#!/usr/bin/perl

open FD,"DOSCAR";
($nat,$par)=(<FD>=~/\s*(\d+)\s+\d+\s+(\d+)/);

for($i=0;$i<4;$i++){
    $str=<FD>
}

    ($np,$fermi)=(<FD>=~/\S+\s+\S+\s+(\S+)\s+(\S+)/);

exit if $np==0;

open WD,">","dost.dat";

while(<FD>){
    last if $np--==0;
    ($en,$du,$dd,$idu,$idd)=($_=~/(\S+)\s+(\S+)\s*(\S*)\s*(\S*)/);
    printf WD  "% 2.6f % 2.6e % 2.6e\n",$en-$fermi,$du,$dd;#"  ",$dd,"  ",$idu,"  ",$idd,"\n";
}

close(WD);

if($par==1){
    for($i=1;$i<=$nat;$i++){
	$nm=sprintf("dosp.%03d.dat",$i);
	($np,$fermi)=($_=~/\s*\S+\s+\S+\s+(\S+)\s+(\S+)/);
	exit if $np==0;
	open WD,">",$nm;
	while(<FD>){
	    last if $np--==0;
	    ($en,$oth)=($_=~/\s*(\S+)\s+(.+)/);
	    printf WD "% 2.6f %s\n",$en-$fermi,$oth;
	}
	close (WD);
    }

}

