#! /usr/bin/perl

#-------------
# VASPIR code
#-------------
#
# Beta 0.1 (Jun 2008)
#
# By Javier Carrasco 
#
# Comments:
# -- Tested for VASP 4.6.28
# 
# 
# How to use:
#-------------
# perl vaspir.pl OUTCAR.file
#
# Outputs:
# -- IRCAR: full output
# -- IRSPECTRA: spectra (XY format)  
#
# Requirements:
#---------------
# -- Previous frequency calculation with VASP (OUTCAR file needed)
# -- In the VASP input (INCAR), DIPOL correction required (LDIPOL=TRUE, IDIPOL=3)
#
# Uses:
#-------
# (1) Calculate IR intensities
#
# Implementation details
#------------------------
#
# Based on: A. Valcarcel et al., J. Phys. Chem. B 108, 18297 (2004)
#           &
#           A. Varcarcel PhD Thesis (Chapter 2)
#
# The VASP code already computes the dipole moment components at each
# nuclear configuration used for the construction of the Hessian
# matrix. The VASPIR code computes a numerical estimate of the
# dipole moment derivatives, Ddipol(z)/Dz, on the basis of the atomic
# Cartesian displacements. Note that, because only those vibrational
# modes that give rise an oscillating dipolar moment
# perpendicular to the surface are active, we have considered only
# the z component of the dipole moment. The calculated Ddipol(z)/Dz
# values are then projected onto the basis of normal modes to
# obtain the dynamic dipole moments of the vibrational normal
# modes, Ddipol(z)/DQ_k. The square of the latter is directly related to
# the IR intensities of fundamental bands. It is important to point
# out that vibrational frequencies for the normal modes are mass
# sensitive and, consequently, the intensities of IR bands may also
# change when substituted isotopic species spectra are examined.
#
#        /         \ 2   /                                        \ 2 
#       | Ddipol(z) |   |                    P_ki                  |
# I_k = |-----------| = | Sum_{i=1}^{3N} ----------- Ddipol(z)/Dz_i| 
#       |    DQ_k   |   |                 sqrt(m_i)                |
#        \         /     \                                        /
#
# P_ki / sqrt(m_i) : mass weighted coordinate matrix of the normal
# mode k 
#
# In the current implementation only derivatives of the z-component of
# the dipolmoment with respect to Z coordinate (X,Y neglected) are 
# considered, estimating such value from  the slope of a linear 
# regression employing the displacements around the considered 
# atom along Z     

#
# PARAMETERS DEFINED BY THE USER:
#
$frmin=0;      # Spectrum scale MIN
$frmax=4000;     # Spectrum scale MAX
$specint=0.01;   # Spacing between calculated spectrum (in cm-1) 
$smear=0.005;     # Smearing for gaussian smoothing (1/f --> 100 cm-1 --> 0.01)

# -------------------------------------------
#   sqr()  -  Return the square of a number.
# -------------------------------------------

sub sqr {
$_[0] * $_[0];
}

open (OUT, ">IRCAR");
print OUT "\n";
print OUT "********************************************************************\n";
print OUT "*                              VASPIR                              *\n";
print OUT "********************************************************************\n";
print OUT "\n";
print OUT "   Input file:     $ARGV[0]\n";
print OUT "   Initical date:  ";
close (OUT);
system ("date >> IRCAR");

print "\n";
print " (1/3) Extracting data from $ARGV[0]\n";


# Reading data from OUTCAR files:
# (0) considered displacement ($step) and number of them ($nstep)
# (1) dipolmoment ($dm[$k]) for each configuration: (#mnv) * (nstep) + 1 
#      -- $dm[1]: reference (opt geometry)
#      -- $dm[2]: for atom 1, x + ($step) 
#      -- $dm[3]: for atom 1, x - ($step) 
#      -- $dm[4]: for atom 1, y + ($step) 
#      -- ...
#      -- $dm[7]: for atom 1, z - ($step) 
#      -- $dm[8]: for atom 2, x + ($step) 
#      -- ...
# (2) corrdinates of each displacement 
# (3) mass weighted coordinate matrix elements of each mnv 
#
#
# (0)
#
system("grep NFREE $ARGV[0] > tmpcore1"); 
open (IN, tmpcore1);
while (<IN>) {
 if ($.>0) {
  @target=split (' ');
  $nstep=$target[2];
#  print "$nstep\n";
  $k++;
 };
};
close(IN);
system("rm -f tmpcore1"); 
system("grep 'POTIM =' $ARGV[0] > tmpcore1"); 
open (IN, tmpcore1);
while (<IN>) {
 if ($.>0) {
  @target=split (' ');
  $step=$target[3];
#  print "$step\n";
  $k++;
 };
};
close(IN);
system("rm -f tmpcore1"); 

#
# (1)
#
system("grep -B 29 'potential at core' $ARGV[0] > tmpcore1"); 
system("grep 'dipolmoment' tmpcore1 > tmpcore2"); 
system("rm -f tmpcore1"); 
$k=1;
open (IN, tmpcore2);
while (<IN>) {
 if ($.>0) {
  @target=split (' ');
  $dm[$k]=$target[3];
#  print "$k -- $dm[$k]\n";
  $k++;
 };
};
$configs=$k-1;   # TOTAL NUMBER OF CONFIGURATIONS INCLUDING (x0, y0, z0)
close(IN);
system("rm -f tmpcore2"); 
$actat=($configs-1)/(3*$nstep); # ACTIVE ATOMS ALLOWED TO RELAX     
system("grep NIONS $ARGV[0] > tmpcore1");
open (IN, tmpcore1);
while (<IN>) {
 if ($.>0) {
  @target=split (' ');
  $nions=$target[11];
 };
};
close(IN);
system("rm -f tmpcore1");
#
# General output info
#
open (OUT, ">>IRCAR");
print OUT "\n";
print OUT "**************************** Parameters ****************************\n";
print OUT "\n";
printf OUT "   Total number of atoms:            %6.0f (NIONS)\n",$nions;
printf OUT "   Active atoms displaced:           %6.0f \n",$actat;
printf OUT "   Number of displacements / corrd:  %6.0f (NFREE)\n",$nstep;
printf OUT "   Total number of configurations:   %6.0f (NFREE*NIONS*3+1)\n",$configs; 
printf OUT "   Magnitude of the displacements:   %6.4f (POTIM)\n",$step;
close (OUT);
#
# (2)
#
$matches=$nions+1;
system ("grep -A $matches POSITION $ARGV[0] | grep -v '\\-\\-' | grep -v POSITION >> tmpcore1");
$i=1;
$j=1; # $j=1 configuration (x0, y0, z0). x+ (j=2), x- (j=3), y+(j=4)... 
open (IN, tmpcore1);
while (<IN>) {
 if ($.>0) {
  @target=split (' ');
  $xdisp[$j][$i]=$target[0];
  $ydisp[$j][$i]=$target[1];
  $zdisp[$j][$i]=$target[2];
  if ($i>=$nions){
   $i=0;
   $j++; 
  }; 
 };
 $i++;
};
close(IN);
system("rm -f tmpcore1");

open (OUT, ">>IRCAR");
print OUT "\n";
print OUT "********************** Minimum configuration ***********************\n";
print OUT "\n";
$w=1;
for ($w=1;$w<=$nions;$w++){
printf OUT "   %11.7f %11.7f %11.7f\n",$xdisp[1][$w],$ydisp[1][$w],$zdisp[1][$w];
};
close (OUT);

print " (2/3) Computing Intensities\n";

#
# (3)
#

$matches=$nions+1;
system ("grep -A $matches THz $ARGV[0] | grep -v '\\-\\-' | grep -v 'dx'> tmpcore1");
$line=($nions+1)*($actat*3);
$i=1;
open (IN, tmpcore1);
while (<IN>) {
 if ($.> ($line)) {
  @target=split (' ');
  if ($target[4] eq "THz"){
   $fcm[$i]=$target[7];
   $fmev[$i]=$target[9];
   $i++;
   $j=1;
  } else {
  if (($target[3] != 0)||($target[4] != 0)||($target[5] != 0)){
  $dx[$i-1][$j]=$target[3];
  $dy[$i-1][$j]=$target[4];
  $dz[$i-1][$j]=$target[5];
  $j++;
  };
  };
 };
};
close(IN);

system("rm -f tmpcore1"); 

open (OUT1, ">tmpdipol");
$j=1;
$i=1;
$kx=1;$kxx=1;
$ky=1;$kyy=1;
$kz=1;$kzz=1;
$tag1=1;
$atag[1]=f; # cebador
for ($j=2;$j<=$configs; $j++){
 if ((($tag1)/$nstep) > 3){
  $kxx=1;
  $kyy=1;
  $kzz=1;
  $tag1=1;
 }; 
 $tag1++;
 for ($i=1;$i<=$nions; $i++){
  if (($xdisp[$j][$i])==($xdisp[1][$i])&&($ydisp[$j][$i])==($ydisp[1][$i])&&($zdisp[$j][$i])==($zdisp[1][$i])){
   if ($atag[$i] eq t){
   } else {
    $atag[$i]=f; # $atag defines if the atom is relaxed (t) or not (f) 
   };
  } else {
   if (($xdisp[$j][$i] < ($xdisp[1][$i]-$step+0.00001))&&($xdisp[$j][$i] > ($xdisp[1][$i]-$step-0.00001))){  
#   if ($xdisp[$j][$i] == ($xdisp[1][$i]-$step)){  
   printf OUT1 "%3.0f %3.0f 1 : (x0)  :  $xdisp[1][$i]  $dm[1]\n",$kx,$kxx;
   $kxx++;
   printf OUT1 "%3.0f %3.0f 1 : (x0-) :  $xdisp[$j][$i]  $dm[$j]\n",$kx,$kxx;
   $kx++;
   $kxx++;
   } else {
   if ($xdisp[$j][$i] > $xdisp[1][$i]){
   printf OUT1 "%3.0f %3.0f 1 : (x0+) :  $xdisp[$j][$i]  $dm[$j]\n",$kx,$kxx; 
   $kxx++;
   };
   if ($xdisp[$j][$i] < $xdisp[1][$i]){
   printf OUT1 "%3.0f %3.0f 1 : (x0-) :  $xdisp[$j][$i]  $dm[$j]\n",$kx,$kxx; 
   $kxx++;
   };
   };

   if (($ydisp[$j][$i] < ($ydisp[1][$i]-$step+0.00001))&&($ydisp[$j][$i] > ($ydisp[1][$i]-$step-0.00001))){  
#   if ($ydisp[$j][$i] == ($ydisp[1][$i]-$step)){  
   printf OUT1 "%3.0f %3.0f 2 : (y0)  :  $ydisp[1][$i]  $dm[1]\n",$ky,$kyy;
   $kyy++;
   printf OUT1 "%3.0f %3.0f 2 : (y0-) :  $ydisp[$j][$i]  $dm[$j]\n",$ky,$kyy;
   $ky++;
   $kyy++;
   } else {
   if ($ydisp[$j][$i] > $ydisp[1][$i]){
   printf OUT1 "%3.0f %3.0f 2 : (y0+) :  $ydisp[$j][$i]  $dm[$j]\n",$ky,$kyy; 
   $kyy++;
   };
   if ($ydisp[$j][$i] < $ydisp[1][$i]){
   printf OUT1 "%3.0f %3.0f 2 : (y0-) :  $ydisp[$j][$i]  $dm[$j]\n",$ky,$kyy; 
   $kyy++;
   };
   };

   if (($zdisp[$j][$i] < ($zdisp[1][$i]-$step+0.00001))&&($zdisp[$j][$i] > ($zdisp[1][$i]-$step-0.00001))){  
#   if ($zdisp[$j][$i] == ($zdisp[1][$i]-$step)){  
   printf OUT1 "%3.0f %3.0f 3 : (z0)  :  $zdisp[1][$i]  $dm[1]\n",$kz,$kzz;
   $kzz++;
   printf OUT1 "%3.0f %3.0f 3 : (z0-) :  $zdisp[$j][$i]  $dm[$j]\n",$kz,$kzz;
   $kz++;
   $kzz++;
   } else {
   if ($zdisp[$j][$i] > $zdisp[1][$i]){
   printf OUT1 "%3.0f %3.0f 3 : (z0+) :  $zdisp[$j][$i]  $dm[$j]\n",$kz,$kzz; 
   $kzz++;
   };
   if ($zdisp[$j][$i] < $zdisp[1][$i]){
   printf OUT1 "%3.0f %3.0f 3 : (z0-):  $zdisp[$j][$i]  $dm[$j]\n",$kz,$kzz; 
   $kzz++;
   };
   };

   $atag[$i]=t; 
  };
 };
};
close(OUT1);


open (OUT, ">>IRCAR");
print OUT "\n";
print OUT "*********************** Displacements summary **********************\n";
print OUT "\n";
print OUT "< atom | displac. tag | 1-X, 2-Y, 3-Z | . |  coord | z-dipolmoment >\n";
print OUT "\n";
close (OUT);
system ("cat tmpdipol >> IRCAR");


open (IN, tmpdipol);
while (<IN>) {
 if ($. > 0) {
  @target=split (' ');
  $a=$target[0];
  $b=$target[1];
  $c=$target[2];
  $r[$a][$b][$c]=$target[6];
  $dipol[$a][$b][$c]=$target[7]; 
 };
};
close(IN);
system ("rm -f tmpdipol");

open (OUT2, ">>IRCAR");
print OUT2 "\n";
print OUT2 "******************* Ddipol/Dz (linear regression) ******************\n";
$i=1;
$j=1;
$k=1;
$n=$nstep+1;
for ($j=1;$j<=($actat);$j++){
 print OUT2 "\n";
 printf OUT2 " Atom %4.0f\n",$j; 
 print OUT2 "--------------------------------------------------------------------\n";
 for ($i=1;$i<=3;$i++){
  if ($i == 1){
  print OUT2 " Displacement along X:\n";  
  };
  if ($i == 2){
  print OUT2 " Displacement along Y:\n";  
  };
  if ($i == 3){
  print OUT2 " Displacement along Z:\n";  
  };
  $sumx=0; $sumx2=0; $sumxy=0; $sumy=0; $sumy2=0; 
  for ($k=1;$k<=$n;$k++){
    printf OUT2 " %10.6f %10.6f\n",$r[$j][$k][$i],$dipol[$j][$k][$i]; 
    $sumx = $sumx + $r[$j][$k][$i];             
    $sumx2 = $sumx2 + $r[$j][$k][$i] * $r[$j][$k][$i];      
    $sumxy = $sumxy + $r[$j][$k][$i] * $dipol[$j][$k][$i];    
    $sumy  = $sumy + $dipol[$j][$k][$i];       
    $sumy2 = $sumy2 + $dipol[$j][$k][$i] * $dipol[$j][$k][$i]; 
  };
  $m[$j][$i]=($n * $sumxy  -  $sumx * $sumy) / ($n * $sumx2 - sqr($sumx));
  $coef[$j][$i]= ($sumy * $sumx2  -  $sumx * $sumxy) / ($n * $sumx2  -  sqr($sumx));
  $rfac[$j][$i]= ($sumxy - $sumx * $sumy / $n) / sqrt(($sumx2 - sqr($sumx)/$n) * ($sumy2 - sqr($sumy)/$n));             
  $rfac2[$j][$i]=$rfac[$j][$i] * $rfac[$j][$i];
 printf OUT2 " Fit: Ddipol/Dr = %9.6f  (B = %9.6f; R^2 = %8.6f)\n",$m[$j][$i],$coef[$j][$i],$rfac2[$j][$i];  
 print OUT2 "--------------------------------------------------------------------\n";
 };
 
};
close(OUT2); 

$i=1;
for ($i=1;$i<=($actat*3);$i++){
$int[$i]=0;
 for ($j=1;$j<=$nions;$j++){ 
  $int[$i] = $int[$i] + $dz[$i][$j]*$m[$j][3];
 };
 $int2[$i] = sqr($int[$i]);
};

  $int2max=$int2[1];
  foreach (@int2) {
    if ($_ > $int2max){
    $int2max = $_;
    };
  };

open (OUT, ">>IRCAR");
print OUT "\n";
print OUT "***************** IR intensities for each frequency ****************\n";
print OUT "    (Normalized with respect to the most intense signal and *100)\n"; 
print OUT "\n";
print OUT " mnv     f (cm-1)      f (meV)   Int (a.u.)\n"; 
print OUT "--------------------------------------------------------------------\n";

for ($i=1;$i<=($actat*3);$i++){
$int2s[$i]=$int2[$i]/$int2max*100; 
printf OUT "%4.0f  %11.4f  %11.4f    %9.4f\n",$i,$fcm[$i],$fmev[$i],$int2s[$i];
};
close (OUT);

print " (3/3) Generating spectra\n";

open (OUT, ">IRSPECTRA");
for ($fr=$frmin;$fr<=$frmax;($fr=$fr+$specint)){
#for ($fr=$frmin;$fr<=$frmax;$fr++){
$spec=0;
for ($i=1;$i<=($actat*3);$i++){
$spec = $spec + $int2s[$i]*exp(-$smear*($fcm[$i]-$fr)**2); 
$k1=$fcm[$i]*$fr;
$k2=($fcm[$i]*$fr)**2;
$k3=-$smear*($fcm[$i]*$fr)**2;
$k4 =exp(-$smear*($fcm[$i]*$fr)**2);
#print OUT "$k1 $k2 $k3 $k4\n";
};
print OUT "$fr   $spec\n";
};

close (OUT);


open (OUT, ">>IRCAR");
print OUT "\n";
print OUT "********************************************************************\n";
print OUT "\n";
print OUT " Final date: ";
system ("date >> IRCAR");
print OUT "\n";
print OUT "Beendet.\n";
print OUT "\n";
close (OUT);

print "\n";
print "Done.\n";
