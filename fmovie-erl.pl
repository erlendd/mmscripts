#! /usr/bin/perl

# Make movies of vibrational freqeucny modes

# Use: perl fmovi.pl datafile

# datafile: X Y Z dx dy dz 

$niter=100;
$xfac=1;
$yfac=1;
$zfac=1;

@ions;

#############
## H2/CuPd(111)
#@ions_quantity = (2,17,1);
@ions_quantity = (2,44,1);
@ions_compressed = ('H','Cu','Pd');
#############
## Water dimer
#@ions_quantity = (4,2,48);
#@ions_compressed = ('H','O','Cu');


for ($i=0; $i<=$#ions_quantity; $i++) {
#    print "i=$i (ions_quantity=$#ions_quantity)\n";
    for ($j=0; $j<@ions_quantity[$i]; $j++) {
#        print "Appending @ions_compressed[$i] onto ions";
#        print " ($j/$#ions_quantity)\n";
        push(ions, @ions_compressed[$i]);
    }
}

$j=1;
open (IN, $ARGV[0]);
while (<IN>) {
    if ($.>0) {
	@tar=split (' ');
	$x[$j]=$tar[0];$y[$j]=$tar[1];$z[$j]=$tar[2];
	$dx[$j]=$tar[3];$dy[$j]=$tar[4];$dz[$j]=$tar[5];
	$j++;
    };
};
close(IN);
$nat=$j-1;

$j=1;
for ($j=1;$j<=$nat;$j++){
    # make the motion symmetric
    $xstartoffset = $xfac*$dx[$j];
    $ystartoffset = $yfac*$dy[$j];
    $zstartoffset = $zfac*$dz[$j];    
    for ($i=1;$i<=$niter;$i++){
	$xm[$j][$i] = $x[$j] - $xstartoffset + 2*$xfac*$dx[$j]*($i/$niter);
	$ym[$j][$i] = $y[$j] - $ystartoffset + 2*$yfac*$dy[$j]*($i/$niter);
	$zm[$j][$i] = $z[$j] - $zstartoffset + 2*$zfac*$dz[$j]*($i/$niter);
    };
};

open (OUT, ">$ARGV[0].xyz");
for ($i=1;$i<=$niter;$i++){
    print OUT "$nat\n";
    print OUT "frame $i\n";
    for ($j=1;$j<=$nat;$j++){
	print OUT "$ions[$j-1] $xm[$j][$i] $ym[$j][$i] $zm[$j][$i]\n";
    };
};

close(OUT);
