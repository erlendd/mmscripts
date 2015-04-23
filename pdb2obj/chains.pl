#!/usr/bin/perl
#  Extract list of chains from .pdb file
#  usage: 'chains.pl xxxx.pdb'
#  tammy@cs.duke.edu

# change to appropriate dirs if necessary
$bindir  = "/home/erlend/scripts/bin/pdb2obj";
$datadir = ".";
$pdbdir  = ".";

for( $k = 0; $k <= $#ARGV; $k++ )
{

  ($file, $ext) = split(/\./, $ARGV[$k]);

  if( length($ext) == 0 )
  {
    $infile="$pdbdir/$file.pdb";
  }
  else
  {
    $infile="$pdbdir/$ARGV[$k]";
  }

  open( PDB, $infile ) or die "Error opening file: '$infile'";

  $chains = "";
  $chid = "";
  $pdbid = "";

  while(<PDB>) 
  {
      /^ATOM/ or next;
   
      my($chid) = ($_ =~ /^.{20}(.{2})/);  # chain is chars 21-22
       
      $chid  =~ s/^\s*//;                  # strip leading spaces
  
      $chains = $chains.$chid;
  }

  $chains =~ tr/A-Za-z//s;
  $chains = join ' ', split //, $chains;

  $pdbid = substr($ARGV[$k],0,4);
 
  if( $chains eq "" ) 
  {
    print("$pdbid: no chains found :-(\n");
  }
  else
  {
    print("$pdbid: $chains\n");
  }
  close(PDB); 
}

