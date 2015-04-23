#! /usr/bin/perl


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

# we only care about the z movements
# as the dipole moment is perpendicular
# to the surface
$z_movement = 0;

for($i=1; $i<=$nat; $i++) {
    $z_movement = $z_movement + abs($dz[$i]);
};

print $z_movement;

