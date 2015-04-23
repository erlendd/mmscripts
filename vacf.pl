#! /usr/bin/perl

use Math::Trig;

############################################# 
#                                           #
# VACF (Velocity Auto-Correlation Function) #
#                                           # 
############################################# 
# By J. Carrasco                 27.10.2008 #        
############################################# 
# Utility:                                  # 
#                                           #
# Computing VACF from a given trajectory    #
#                                           #
# Periodic boundary condition correction    #
# pre-applied to the input XYZ trajectory   #
# file. Only valid for a cubic/rectangular  #
# box and system without full diffusion     #
# along the box (see implementation for     #
# details).                                 #                             
#                                           #
# Input:                                    #
# movie.xyz from vaspmd.pl                  # 
#                                           #
# Outputs:                                  #
# <vacf.out> (VACF, units of X in cm)       #
# <velocities.xyz> velocities in xyz format # 
# <input-PBC_corrected> a PBC corrected new #
# XYZ input file                            #
#                                           #
# Use:                                      #
# perl vacf.pl movie.xyz                    #
#                                           #
############################################# 

# !!!!! Constants & conversion factors !!!!!

$fs_to_cm= 2.99792458/100000;

# !!!!! Provisional input parameters !!!!!

$shift=25000;
$cthresh=2.0; # the cell d{x,y,z} correction threshold (less than cell size).
$tstep=0.5; # Time step in fs
@target_atoms=("H", "O", "Pt"); # Label of the atoms considered in the VACF
$cell_x = 5.655440;
$cell_y = 4.897754;
$cell_z = 18.6176475000000003; # Cell parameter along Z 

# Sometimes one atom _starts_ in the PBC place. It is nice to move this.
$indexToMove = 1;
$yMove = $cell_y;
$xMove = tan(deg2rad(30))*$cell_y;

# !!!!! Declaration of subroutines !!!!!

# Will take the dot product of two vectors (a,b,c) and (i,j,k).
sub dot_product {
 my ($a,$b,$c,$i,$j,$k) = @_;
 return $a*$i + $b*$j + $c*$k; 
}

# !!!!! Reading input !!!!!

$i=0;
$j=0;
open (IN, $ARGV[0]);
while (<IN>) {
 if ($.==1) {
  @target=split (' ');
  $nat=$target[0];
 };
 if ($.>1){
  @target=split (' ');
  $line=$target[0];
  if ($line eq frame){
   $i=1;
   $frame=$target[1]-$shift;
   $j++;
  } else {
   $atm[$frame][$i]=$target[0];
   $rx[$frame][$i]=$target[1];
   $ry[$frame][$i]=$target[2];
   $rz[$frame][$i]=$target[3];
   $i++;
  }; 
 };
};

$nframes=$j;
$natoms=$i-1;

$nactiv=0;
for ($k=1; $k<($natoms+1); $k++) {
 $activ[$k]=F;
 foreach $target_atoms (@target_atoms) {
  if ($target_atoms eq $atm[1][$k]) {
   $activ[$k]=T;
   $nactiv++;
  };
 };
};

print "Selected atoms: ";
foreach $target_atoms (@target_atoms) {
print "$target_atoms ";
};
print " (Total: $nactiv)\n";


# !!!!! Computing velocities !!!!!

open (OUT, ">movie-PBC_corrected.xyz");

print OUT "$natoms\n";
print OUT "frame 1\n";
for ($k=1; $k<($natoms+1); $k++) {
 if ($k == $indexToMove) {
  printf OUT "%6s %11.6f %11.6f %11.6f\n",$atm[1][$k], $rx[1][$k]+$xMove, $ry[1][$k]+$yMove, $rz[1][$k];
 } else {
  printf OUT "%6s %11.6f %11.6f %11.6f\n",$atm[1][$k],$rx[1][$k],$ry[1][$k],$rz[1][$k];
 };
};

open (OUT2, ">velocities.xyz");
for ($j=2; $j<($nframes+1); $j++) {
 $fv=$j-1;
 print OUT2 "$natoms\n";
 print OUT2 "frame $fv\n"; 
 print OUT  "$natoms\n";
 print OUT  "frame $j\n"; 
 for ($k=1; $k<($natoms+1); $k++) {

  $dx=abs($rx[$j][$k]-$rx[$j-1][$k]);
  $dy=abs($ry[$j][$k]-$ry[$j-1][$k]);
  $dz=abs($rz[$j][$k]-$rz[$j-1][$k]);

  # if the change in the distance is too large
  if ($dx > $cthresh) {
   $this_cell_x = $cell_x; #+ tan(deg2rad(30))*$ry[$j][$k];
   if ($rx[$j][$k] < $rx[$j-1][$k]) { # off the right
    # if the new position is less than the previous one
    # then we add on the cell size,
    # e.g. if 0.9 -> 0.01 then $dx=0.89
    # however it should be $dx=(0.01+$cell_x)-0.9
    # => $dx=0.11 (fractional).
    $rx[$j][$k] = $rx[$j][$k] + $this_cell_x;
   } else { # off the left
    # similarly, if 0.02 -> 0.9 then $dx=0.88
    # correct this to $dx=(0.9-$cell_x)-0.02
    # => $dx=-0.12 (fractional)
    $rx[$j][$k] = $rx[$j][$k] - $this_cell_x;
   };
  };

  if ($dy > $cthresh) {
   $this_x_cor = tan(deg2rad(30))*$cell_y;
   if ($ry[$j][$k] < $ry[$j-1][$k]) { # off the top
    $ry[$j][$k] = $ry[$j][$k] + $cell_y;
    $rx[$j][$k] = $rx[$j][$k] - $this_x_cor;
   } else { # off the bottom
    $ry[$j][$k] = $ry[$j][$k] - $cell_y;
    $rx[$j][$k] = $rx[$j][$k] + $this_x_cor;
   };
  };

  # z-axis is always orthogonal to the x and y axes.
  if ($dz > $cthresh) {
   if ($rz[$j][$k]<$rz[$j-1][$k]) {
    $rz[$j][$k]=$rz[$j][$k]+$cell_z;
   } else {
    $rz[$j][$k]=$rz[$j][$k]-$cell_z;
   };
  };

  $vx[$j][$k] = ( $rx[$j][$k] - $rx[$j-1][$k] ) / $tstep; # units AA/fs
  $vy[$j][$k] = ( $ry[$j][$k] - $ry[$j-1][$k] ) / $tstep;
  $vz[$j][$k] = ( $rz[$j][$k] - $rz[$j-1][$k] ) / $tstep;

  if ((abs($vx[$j][$k])>2) || 
      (abs($vy[$j][$k])>2) ||
      (abs($vz[$j][$k])>2)){
     ## WHEN A DISCONTINUITY DUE TO PBC IS DETECTED
     ## (criterai 2 AA/fs) NO CONTRIBUTION OF THIS
     ## VELOCITY IS CONSIDERED, BUT THE ONE OF THE
     ## PREVIOUS POINT. 
     #
  print "Warning! - Boundary discontinuity in frame $j.\n";
  print "           Coordinates: 
               $rx[$j][$k] - $rx[$j-1][$k] 
               $ry[$j][$k] - $ry[$j-1][$k] 
               $rz[$j][$k] - $rz[$j-1][$k] "; 
  print "\n           dx: $dx
           dy: $dy
           dz: $dz\n";
  print "           $kk1 $kk2 $kk3\n";
#  print "           Action: velocity of frame $fv considered\n"; 
  print "           Action: none\n"; 
#  
  $vx[$j][$k]=$vx[$j-1][$k];
  $vy[$j][$k]=$vy[$j-1][$k];
  $vz[$j][$k]=$vz[$j-1][$k];
#
  };

  printf OUT2 "%6s %11.6f %11.6f %11.6f\n",$atm[$j][$k], $vx[$j][$k], $vy[$j][$k], $vz[$j][$k];
  if($k == $indexToMove) {
   printf OUT  "%6s %11.6f %11.6f %11.6f\n",
         $atm[$j][$k], $rx[$j][$k]+$xMove, $ry[$j][$k]+$yMove, $rz[$j][$k];
  } else {
   printf OUT  "%6s %11.6f %11.6f %11.6f\n",
         $atm[$j][$k], $rx[$j][$k], $ry[$j][$k], $rz[$j][$k];
  }

 };
};
close(OUT2);
close(OUT);


# !!!!! Computing VACF !!!!!

for ($j=2; $j<($nframes+1); $j++) {
 $vacf[$j]=0;
 for ($k=1; $k<($natoms+1); $k++) {
  if ($activ[$k] eq "T") { 
   $vacf[$j]=$vacf[$j] + &dot_product($vx[2][$k],$vy[2][$k],$vz[2][$k],$vx[$j][$k],$vy[$j][$k],$vz[$j][$k]);
  };
 };
};

open (OUT, ">vacf.out");
for ($j=2; $j<($nframes+1); $j++) {
 $time=$j*$tstep*$fs_to_cm;                      # Change units from [fs] to [cm] 
 $vacf_tot[$j]=$vacf[$j]/$nactiv;
 printf OUT "%14.9f %14.9f\n",$time,$vacf_tot[$j];

};
close(OUT);
