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
my $Bohr=0.5292;
my $m=0;
my $frame=0;
my $dt=0.5*10e-15;

$N=2;

#my $inp="castep.md";
##my $out="GyrationRadius.out";


################################################################
##
##		OUTPUT FILES
##
################################################################

#my  $inp              ="castep.md";
my $inp=$ARGV[$0];
my  $AUTOfilename_out ="AutoCorr.R.dat";
my  $SPfilename_out   ="Spectrum.R.dat";

################################################################










################################################################
##
##		READING THE COORDINATES
##
################################################################

	open(FILE,$inp) or die("Could not open out file.");

	open(FILE1,">Coordinates.xyz") or die("Could not open out.xyz file.");

	$m=$j=0;
	while(<FILE>) 
	{##while						
                        s/^\s*//g;
			s/\s+/ /g;
			s/#.*//;
			
			$j++;
			
			($ind[$j], $hlam1, $x[$j], $y[$j], $z[$j],$hlam2, $hlam3)=split(' ',$_); 			
			##print" -- $z[$j]  $hlam3\n";
			
		        if( $z[$j] eq "E") {
					   $frame++;
					   $m=0;$FLAG=0;
					   printf(FILE1 "$N\n $frame\n" );
					   }	
		
                	if( $hlam3 eq "R")##---------coordinates
			 { 			 			 
			  $FLAG=1;	  
			  $m++; 
			  
			  $XX[$m][$frame]=$x[$j]*$Bohr;
			  $YY[$m][$frame]=$y[$j]*$Bohr;
			  $ZZ[$m][$frame]=$z[$j]*$Bohr;
		  
			  ##----radius vector 
			  $R[$m][$frame]=sqrt($XX[$m][$frame]**2+$YY[$m][$frame]**2+$ZZ[$m][$frame]**2);
			   	 
			  printf(FILE1 " $ind[$j]   %2.5f   %2.5f   %2.5f\n", $XX[$m][$frame],$YY[$m][$frame],$ZZ[$m][$frame]);			  
			  ##print" $ind[$j]   $XX[$m][$frame]  $YY[$m][$frame]  $ZZ[$m][$frame] \n";
			  			 		 
			  }##if 
			  	 
			else{ $FLAG=0;}	


	}##while								
	close(FILE);
	close(FILE1);
	
print"   Read input file..\n Found $m particles; $frame frames.\n";	

	##----number of particles of 1st type--
	$Natoms_1=$m;










print"--------POSITIONS-----------\n\n\n";

##-----POSITIONS-------------------------
##---averaging over configuration
my @RR=AVERAGING($frame, $Natoms_1, @R);
print"--auto=$RR[10]\n";

##---autocorrelation
my @ZR=AUTOCORR($AUTOfilename_out,$frame,@RR );


##----spectrum calculation --
SPECTRUM($SPfilename_out, $frame, @ZR );










##################################################################################
##
## 		AVERAGING routine 
##
##################################################################################


sub AVERAGING{

my($Nframe, $Natoms, @A) = @_;
my $i, $j;
my $A_average_config, @AA;

print"-$A[10]\n";

	##--------averaging per configuration----
	for($i=1;$i<$Nframe;$i++)
	{ 
	
	$A_average_config=0;	
	
	
		for ($j=1;$j<$Natoms;$j++)
		{
		$A_average_config+=$A[$j][$i];
		
		}##j
		
	$AA[$i]=$A_average_config/($Natoms);
	##print"$AA[$i]\n";
	
	}##i


	return @AA;
	
}



##################################################################################
##
## 		AUTOCORRELATION FUNCTION routine 
##
##################################################################################

sub AUTOCORR{

my($AUTOfilename_out, $Nframe, @A) = @_;


my $i, $ii, $j, $jj;
my $A_run, @A_average, $Covariance_run, @Covariance,@AutoCorr, $CV_run, @CV;



	print"Calculating Autocorrelation function \n";
	open(FILE30,">$AUTOfilename_out")  or die("Could not open $AUTOfilename_out file.");
	printf(FILE30 "##-step-----At---------------<A>--------(At-<A>)*(A0-<A>)-----(A0-<A>)**2-------(At-<A>)*(A0-<A>)/(A0-<A>)**2\n");
	
	for($ii=1;$ii<=$Nframe;$ii++)
	{

			
		##--running average <At>
		$A_run+=$A[$ii];
		$A_average[$ii]=$A_run/$ii;
	
	
		##----covariance
		$Covariance_run+=($A[$ii]-$A_average[$ii])**2;
		$Covariance[$ii]=$Covariance_run/$ii;

		
		##----correlation function runing average
		$CV_run+=($A[$ii]-$A_average[$ii])*($A[1]-$A_average[$ii]);
		$CV[$ii]=$CV_run/$ii;
	
		
		if($ii>1)
		{	
		$AutoCorr[$ii]=$CV[$ii]/$Covariance[$ii];
		}
	
	printf(FILE30 "%d       %e       %e        %e        %e\n",$ii, $A[$ii],$A_average[$ii], $CV[$ii], $Covariance[$ii], $AutoCorr[$ii] );  
	##print"$ii, $A_average[$ii], $CV[$ii], $Covariance[$ii], $AutoCorr[$ii]\n";  
       }##for
	
	print" Finished Autocorrelation function...\n";	

	return @AutoCorr;

	close(FILE30);

}





##################################################################################
##
## 		POWER SPECTRUM routine 
##
##################################################################################


sub SPECTRUM{

my($SPfilename_out, $Nframe, @A) = @_;



##----time step--
my $dt=0.5;##*10e-5;


##---frequency step--
my $dw=10000;
my $w_iLim=1;
my $w_fLim=10000000;

##---spectrum variable
my @W, $WW, $w;

##---integer
my $i;

	open(FILE20,">$SPfilename_out")  or die("Could not open $SPfilename_out file.");

	print"Calculating POWER Spectrum f(w) \n";
		

    	 for($w=$w_iLim;$w<=$w_fLim;$w=$w+$dw)
	 {
	  $W=$WW=0;
	 
      		for($i=1;$i<=$Nframe;$i++)
         	{
		   $t=$i*$dt;
		   
       		   $WW+=$A[$i]*cos(2*$PI*$w*$t)*$dt;
		   
         	}
      	  	  
		  
	  $W=($WW/(2*$PI) )*$w/2*(cos(2*$PI*$w/2)/sin(2*$PI*$w/2)+1);
		
	  printf(FILE20 "%f    %e    %e\n",$w,$WW/(2*$PI),$W);
	 }


	close(FILE20);
     
     print" Finished...\n";
     
     print"End of SPECTRUM... \n\n\n\n";
     
}

