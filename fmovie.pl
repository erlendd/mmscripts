#! /usr/bin/perl

# Make movies of vibrational freqeucny modes

# Use: perl fmovi.pl datafile

# datafile: X Y Z dx dy dz 

$j=1;
open (IN, $ARGV[0]);
while (<IN>) {
 if ($.>0) {
  @tar=split (' ');
  $x[$j]=$tar[0];$y[$j]=$tar[1];$z[$j]=$tar[2];
  $dx[$j]=$tar[3];$dy[$j]=$tar[4];$dz[$j]=$tar[5];
#  $xf[$j]=$x[$j]+$dx[$j];
#  $yf[$j]=$y[$j]+$dy[$j];
#  $zf[$j]=$z[$j]+$dz[$j];
 
  $j++;
 };
};
close(IN);
$nat=$j-1;

$j=1;
for ($j=1;$j<=$nat;$j++){
for ($i=1;$i<=5;$i++){
$xm[$j][$i]=$x[$j]+$dx[$j]*($i/5);
$ym[$j][$i]=$y[$j]+$dy[$j]*($i/5);
$zm[$j][$i]=$z[$j]+$dz[$j]*($i/5);
};
};

open (OUT, ">$ARGV[0].xyz");
for ($i=1;$i<=5;$i++){
print OUT "$nat\n";
print OUT "frame $i\n";
for ($j=1;$j<=$nat;$j++){
print OUT "H $xm[$j][$i] $ym[$j][$i] $zm[$j][$i]\n";
};
};
close(OUT);
