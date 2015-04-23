#!/usr/bin/perl 

##------------------------
##
## script for "CLASS" MD
##
##------------------------
my $PI=3.1416;

my $timestep=1;
my $i,$j,$N,@x,@y,@z,@ind;
my @XX, @YY, @ZZ, @R;



my $Nbeads=8;
my $Natoms=12;

################################################################
##
##		OUTPUT FILES
##
################################################################

my $inp=$ARGV[$0];
my $out="ET.out";

################################################################





	open(FILE,$inp) or die("Could not open out file.");


	$m=$j=0;
	while(<FILE>) 
	{##while						
                        s/^\s*//g;
			s/\s+/ /g;
			s/#.*//;
			
			
			(@z)=split(' ',$_); 			

			


		        if( $z[1] eq "Total" ) 
			{
			  $j++;
			  $ET[$j]=$z[3];
			}	


		        if( $z[1] eq "Temperature:" ) 
			{
			  $j++;
			  $T[$j]=$z[2];
			}	

	##print"$j--$EP[$j]--$EK[$j]--$ET[$j]--$ES[$j]--$T[$j]\n";


	}##while								
	close(FILE);

	$Nframes=$j;
	print"found $Nframes frames\n";


##################################################################################
##
## 		write out file
##
##################################################################################



	open(FILE,">out")  or die("Could not open $out file.");

	$i=0;	
	for($j=1;$j<=$Nframes;$j++)
        {  
	
	 ## $i++;
	  ##-----------step---EP---EK----ET----ES----T-------
	  printf(FILE "%d    %f    %f    %f    %f    %f \n",$j,$EP[$j],$EK[$j],$ET[$j],$ES[$j],$T[$j]);

	 ## if($i==$Nbeads){$i=0;}  
	 }


	close(FILE);
     
     print" Finished...\n";
     
     
    

