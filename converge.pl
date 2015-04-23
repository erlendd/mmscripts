eval '(exit $?0)' && eval 'exec perl -S $0 ${1+"$@"}' && eval 'exec perl -S $0 $argv:q' if 0;
#;-*- Perl -*-

# we are going to get rid of this script

  use FindBin qw($Bin) ;
  use lib "$Bin" ;
  use Vasp ;
  use Cwd ;

  $dir = cwd ;

  @args=@ARGV ;
  if (@args==0) {
    opendir(DIR,".") or die "couldn't open . ($!)\n" ;
    @list=readdir(DIR) ;
    closedir(DIR) ;
  }

    $energy=`grep 'energy  w' OUTCAR` ;
    $forces=`grep 'FORCES: m' OUTCAR` ;
    @forces = split /\n/ , $forces ;
    @energy = split /\n/ , $energy ;
    $n = @forces ;

    open OUT , ">fe.dat" ;

    for($j=0; $j<$n; $j++){
      $f = $forces[$j] ; chomp($f) ; $f=~s/^\s+//g ; @f=split /\s+/,$f ;
      $e = $energy[$j] ; chomp($e) ; $e=~s/^\s+//g ; @e=split /\s+/,$e ;

      if(!$j) {$e0 = $e[6] ;}
      printf OUT "%5i %20.8f %20.6f %20.6g \n",$j,$f[5],$e[6],$e[6]-$e0 ;
    }
    close OUT ;

    system "gnuplot $Bin/vef.gnu" ;

  

