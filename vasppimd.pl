#! /usr/bin/perl

#-------------------------------------------------------------------
# PROGRAM vaspmd TO DEAL WITH MOLECULAR DYNAMIC CALCS. FROM VASP
#                          OUTPUT OSZICAR
#
# UTILITIES:
# 1) To generate compact files with the energy evolution during the
#    simulation allowing the post-processing analysis. Data coming
#    from different running outputs could be treated togheter.
# 2) Auto-generation of input files for GNUPLOT from the date 
#    processed in point 1). 
#
#    

# $ARGV[0] lista con los ficheros (y path si no esta en el directorio
# de trabajo) de los diferentes OSZICAR y OUTCAR separados por al menos
# un espacio y en la misma linea los dos ficheros de cada simulacion,
# en el orden de la simulacion. Primera linea, timestep ( en fs) 

#
# media y desviacion standard implementadas 

# PARAMETERS START

$time=0.0;         # Initial simulation time 
$dfstep=0.01;     #  Time step for distribution functions
$dfmax=4.0;        # Maximum distance for distribution functions
                   # ($dfmax / $dfstep) should be an integer!!!

# PARAMETERS END

print "\n";
print "vaspmd.pl is processing your data... \n"; print "\n";

### Developing this part ###

open (IN, $ARGV[0]);
$i=0;
$l=0;
$nfiles=0;
while (<IN>) {
 if ($.==1) {
  @target=split (' ');
  $tstep=$target[0];
  $tpoint=$target[1];
 };
 for ($l=0; $l<$tpoint; $l++){
   if ($.==($l+2)) {
   @target=split (' ');
   $pointini[$l]=$target[0];
   $pointfin[$l]=$target[1];
   };
 };
 if ($.>($tpoint+1)) {
  @target=split (' ');
  $oszicar[$i]=$target[0];$outcar[$i]=$target[1];
  $nfiles=$nfiles+1;
  $i++;
 };
};
close (IN);

system ("rm -f tmpfile1"); 
system ("grep POTCAR $outcar[0] > tmpfile2");
open (TMP2, tmpfile2);
$i=1;
while (<TMP2>){
@field=split (' ');
$at[$i]=$field[2];
$i++;
}
close (TMP2);
$nat=($i-1)/2;
$i=1;
$s=0;
$nions=0;
for ($i=1; $i<=$nat; $i++){
system ("grep 'ions per type' $outcar[0] > tmpfile2");
open (TMP2, tmpfile2);
while (<TMP2>){
@field=split(' ');
$atn[$i]=$field[$i+3];
for ($t=1; $t<=$atn[$i]; $t++){
$s++;
$atnl[$s]=$at[$i];
}
$nions=$nions+$atn[$i];
}
}
close (TMP2);
$matches=$nions+1;
system ("rm -f tmpfile2"); 

$i=0;
for ($i=0; $i<$nfiles;$i++){
system ("grep T $oszicar[$i] >> tmpfile1");
system ("grep -A $matches POSITION $outcar[$i] | grep -v '\\-\\-' | grep -v POSITION >> tmpfile2");
system ("grep 'total spring (eV)' $outcar[$i] >> tmpfile3");

};
open (TMP2, tmpfile2);
$p=1;
while (<TMP2>){
$p++;
}
close(TMP2);
$ptotal=($p-1)/$nions;
$p=1;
open (TMP2, tmpfile2);
$i=0;
while (<TMP2>){
@field=split(' ');
$x[$i]=$field[0];
$y[$i]=$field[1];
$z[$i]=$field[2];
$i++;
}
close (TMP2);
# added by erlend to read the spring energies
open (TMP3, tmpfile3);
$i=0;
while (<TMP3>){
@field=split(' ');
$ebead[$i]=$field[3];
#print $ebead[$i];
$i++;
}
close (TMP2);


print "Simulation timestep: $tstep¬fs\n";
print "Input files has been read successfully! ¬\n";
for ($i=0; $i<$nfiles;$i++){
 print "  $oszicar[$i]\n";
};
print "   ---\n";
for ($i=0; $i<$nfiles;$i++){
 print "  $outcar[$i]\n";
};
print "\n";
print "Outputs generation can take some time. Please wait.\n";

### End new developing part ###

open (TMP1, tmpfile1);
$i=0;
while (<TMP1>) {
 if ($.>0){
  @target=split (' ');
  $t[$i]=$target[2];
  $e[$i]=$target[4];
  $f[$i]=$target[6];
  $e0[$i]=$target[8];
  $ek[$i]=$target[10];
  $sp[$i]=$target[12];
  $sk[$i]=$target[14];
  $i++;
 };
};
$nstep=$i;
close (TMP1);

open (OUT, ">vaspmd.E.out");
for ($i=0; $i<$nstep; $i++){
# (time wrote in ps)
$time=$time+$tstep/1000;
# print [time] [E] [F] [Ek] [T]:
printf OUT "%3.4f  $e[$i]  $f[$i]  $ek[$i]  $t[$i]  $ebead[$i]\n", $time;
}; 
close (OUT);

# GNUPLOT OUTPUT ENERGY AND TEMPERATURE PLOTS

open (OUT2, ">vaspmd.E.gpt");
printf OUT2 "set title \"%2.3f ps simulation\"\n",$time;
print OUT2 "set xlabel \"time (ps)\"\n";
print OUT2 "set ylabel \"energy (eV)\"\n";
print OUT2 "set format y \"%5.3f\"\n";
print OUT2 "plot \"vaspmd.E.out\" u 1:(\$2+(\$6)/2) t \"Total energy (Edft + Ek)\" with lines, \\\n";
print OUT2 "\"vaspmd.E.out\" u 1:((\$2+(\$6)/2-\$6)) t \"PIMD Energy (Et-Ebead)\" with lines, \\\n";
print OUT2 "\"vaspmd.E.out\" u 1:((\$2+(\$6)/2-\$6-\$4)) t \"PIMD Energy sans Ek\" with lines \n";

close (OUT2);
open (OUT3, ">vaspmd.T.gpt");
printf OUT3 "set title \"%2.3f ps simulation\"\n",$time;
print OUT3 "set xlabel \"time (ps)\"\n";
print OUT3 "set ylabel \"Temperature (K)\"\n";
print OUT3 "set format y \"%5.3f\"\n";
print OUT3 "plot \"vaspmd.E.out\" u 1:5 with lines \n";
close (OUT3);

print "\n";
print "  File name     Status    Description          Format\n";
print "--------------  ------  ----------------  ----------------\n";
print "<vaspmd.E.out>   Done   E and T summary   Standard output\n";
print "<vaspmd.E.gpt>   Done   E vs. t           Gnuplot script\n";
print "<vaspmd.T.gpt>   Done   T vs. t           Gnuplot script\n";

# movie.xyz OUTPUT & distances calculation 

$time=0;
open (OUT4, ">movie.xyz");
open (OUT5, ">vaspmd.G.out");
print OUT5 "#t/ps ";
for ($k=0; $k<$tpoint; $k++){
print OUT5 "#d($pointini[$k]-$pointfin[$k])";
};
print OUT5 "#<d>#std.-dev.#\n";
$i=0;
for ($p=1; $p<=$ptotal; $p++){
# Ad in input $tpoint: total puntos a calcular distancia y
# susodichos $pointini[$tpoint] $pointfin[$tpoint]
   print OUT4 "$nions\n";
   print OUT4 "frame $p\n";
   for ($j=1; $j<=$nions; $j++){
      print OUT4 "$atnl[$j] $x[$i] $y[$i] $z[$i]\n";
      $xd[$j]=$x[$i];
      $yd[$j]=$y[$i];
      $zd[$j]=$z[$i];
   $i++;
   } 
   printf OUT5 "%3.4f ",$time;
   $dmedia=0.0;
   $dmedia2=0.0;
   for ($k=0; $k<$tpoint; $k++){
      $d[$p][$k]=sqrt(($xd[$pointini[$k]]-$xd[$pointfin[$k]])**2+($yd[$pointini[$k]]-$yd[$pointfin[$k]])**2+($zd[$pointini[$k]]-$zd[$pointfin[$k]])**2);
      $dmedia=$dmedia+$d[$p][$k]/$tpoint; 
      $dmedia2=$dmedia2+$d[$p][$k]*$d[$p][$k]/$tpoint;
      printf OUT5 "%3.5f ", $d[$p][$k];
   };
   $ds=sqrt($dmedia2-$dmedia*$dmedia);
   printf OUT5 "%3.5f %3.5f", $dmedia, $ds;
   print OUT5 "\n";
   $time=$time+$tstep/1000;
}
close (OUT4);
close (OUT5);

open (OUT6, ">vaspmd.G.gpt");
printf OUT6 "set title \"%2.3f ps simulation\"\n",$time;
print OUT6 "set xlabel \"time (ps)\"\n";
print OUT6 "set ylabel \"distance (Angs.)\"\n";
print OUT6 "set format y \"%5.3f\"\n";
print OUT6 "plot ";
for ($k=0; $k<($tpoint-1); $k++){
$kk=$k+2;
print OUT6 "\"vaspmd.G.out\" u 1:$kk t \"d($pointini[$k]-$pointfin[$k])\" with lines, \\\n";
};
$ttpoint=$tpoint+1;
print OUT6 "\"vaspmd.G.out\" u 1:$ttpoint t \"d($pointini[$tpoint-1]-$pointfin[$tpoint-1])\" with lines\n";
close (OUT6);

print "<vaspmd.G.out>   Done   Geometric stuff   Standard output\n";
print "<vaspmd.G.gpt>   Done   dist. vs. t       Gnuplot script\n";
print "<movie.xyz>      Done   Simulation movie  XYZ format \n";

# Distribution geometry functions (DEVEL)

for ($k=0; $k<$tpoint; $k++){
for ($dfi=1; $dfi<=($dfmax/$dfstep); $dfi++){
$df[$k][$dfi]=0;
$dft[$k]=0;
};
open (IN, "vaspmd.G.out");
while (<IN>) {
 if ($.>1) {
  @target=split (' ');
  $vdf=$target[$k+1];
   $dfi=1;
   for ($dstep=0.0; $dstep<$dfmax; ($dstep=$dstep+$dfstep)) {
    if (($vdf>$dstep)&&($vdf<=($dstep+$dfstep))) { 
     $df[$k][$dfi]=$df[$k][$dfi]+1;
    };
    $dfi++;
   };
 };
};
close(IN);
};
open (OUT7, ">vaspmd.D.out");
print OUT7 "#d/ps ";
for ($k=0; $k<$tpoint; $k++){
print OUT7 "#df($pointini[$k]-$pointfin[$k])";
};
print OUT7 "#\n";
$dfval=0;
$dft[$k]=0;
for ($dfi=1; $dfi<=($dfmax/$dfstep); $dfi++){
 $dfval1=$dfval1+$dfstep;
 $dfval2=$dfval1-($dfstep/2);
 printf OUT7 "%2.4f", $dfval2;
 for ($k=0; $k<$tpoint; $k++){
  $dfscaled=$df[$k][$dfi]/$ptotal*100;
  printf OUT7 " %2.6f", $dfscaled; 
 };
 print OUT7 "\n";
};
close(OUT7);

# GNUPLOT output for distribution functions

open (OUT8, ">vaspmd.D.gpt");
printf OUT8 "set title \"%2.3f ps simulation\"\n",$time;
print OUT8 "set xlabel \"r (Angs.)\"\n";
print OUT8 "set ylabel \"P(r) (%)\"\n";
print OUT8 "set xrange [0:$dfmax] \n";
print OUT8 "set format y \"%3.1f\"\n";
print OUT8 "plot ";
for ($k=0; $k<($tpoint-1); $k++){
$kk=$k+2;
print OUT8 "\"vaspmd.D.out\" u 1:$kk t \"P($pointini[$k]-$pointfin[$k])\" with imp, \\\n";
};
$ttpoint=$tpoint+1;
print OUT8 "\"vaspmd.D.out\" u 1:$ttpoint t \"P($pointini[$tpoint-1]-$pointfin[$tpoint-1])\" with imp\n";
close (OUT8);

print "<vaspmd.D.out>   Done   Distr. func. (P)  Standard output\n";
print "<vaspmd.D.gpt>   Done   P(r) vs. r        Gnuplot script\n";

print "\n";
print "Normal vaspmd.pl termination\n";
print "Type <gnuplot -persist file.gpt> to visualize outputs with Gnuplot\n";
print "\n";
print "                               J.C.R\n"; print "\n";

# MAIN CODE ENDED, DELETING LEFTOVERS: 
system ("rm -f tmpfile1"); 
system ("rm -f tmpfile2"); 
system ("rm -f tmpfile3"); 





