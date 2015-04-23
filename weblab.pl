#! /usr/bin/perl

#----------------------------------------------------------------
# PROGRAMA Weblab PARA GENERAR INPUTS DE WebLab Viewer Pro A  
# PARTIR DE FICHEROS EN FORMATO poscar/contcar DE VASP 
#
# UTILIDADES: Permite ademas reposicionar todas las coordenadas 
#             centrnadolas respecto un punto de referencia que 
#             pasa a ser el (0,0,0)
#
# UTILIZACION:
# perl weblab.pl ficero_poscar/contcar
#
# By Javier Carrasco (carrasco@qf.ub.es)
#----------------------------------------------------------------
##------------------------------------------------- ---------------
## WebLab PROGRAM TO GENERATE INPUTS OF A WebLab Viewer Pro
## FROM FILE FORMAT Posco / contcar OF VASP
##
## UTILITIES: Allows also reset all coordinates
## Centrnadolas regarding a point of reference
## Becomes (0,0,0)
##
## USES:
## Perl weblab.pl ficero_poscar / contcar
##
## By Javier Carrasco (carrasco@qf.ub.es)
##------------------------------------------------- --------------- 

#LECTURA DEL FICHERO POSCAR O CONTCAR DE PARTIDA 
## READING OF FILE

open (IN, $ARGV[0]);
$i=0;
while (<IN>) {
  if ($. ==1){ $name=$_;chomp($name);};
  if ($. ==2) { $escala=$_;chomp($escala);};
  if ($. ==3) {
      @fields=split(' ');
      $ax=$fields[0];
       $ay=$fields[1];
      $az=$fields[2];
  };
   if ($.==4){
      @fields=split(' ');
      $bx=$fields[0];
       $by=$fields[1];
      $bz=$fields[2];
  };
   if ($.==5){
      @fields=split(' ');
      $cx=$fields[0];
       $cy=$fields[1];
      $cz=$fields[2];
  };
  if ($.==6){
      @at=split(' ');
       $suma=0;
       $sum=0;
       for ($j=0;$j<@at;$j++){
          $at[$j]=$at[$j];
          $sum=$sum+1;
          $NAT=$NAT+$at[$j];
       };
  };
  if (($.>8)&&($.<$NAT+9)){
      @fields=split (' ');
      $x[$i]=$fields[0];$y[$i]=$fields[1];$z[$i]=$fields[2];
      $optx[$i]=$fields[3];$opty[$i]=$fields[4];$optz[$i]=$fields[5];
      $i++;
  };
};
close (IN);

#LECTURA DE LOS PARAMETROS PARA GENERAR EL OUTPUT DESEADO 
##READING OF THE PARAMETERS FOR GENERATING THE OUTPUT DESIRED

print "\n";
print "##############################################################################\n";
print "\n";
print "Indicar etiqueta para cada atomo en el orden que aparecen en el fichero\n";
print "(Write the label for each atom in the order they appear in the file)\n";
print "POSCAR/CONTCAR \n";
for ($p=0;$p<@at;$p++){
   $k=$p+1;
   print "Etiqueta $k, $at[$p] atomo/s de: ";
   print "Label $k, $at[$p] for atom: "; 
   $label[$p]=<STDIN>;chomp($label[$p]);
};
print "\n";
while (1) {
   print "Redefinir origen (y/N)?: ";
   print "(Redefine origin (y/N))?: ";
   $resp1=<STDIN>; chomp($resp1);
   if ($resp1 eq "y") {
      print "Indicar en coordenadas directas el nuevo origen (0,0,0):\n";
      print "(Ads in the new coordinates direct origin (0,0,0)):\n";
      print "x: ";
      $xr=<STDIN>; chomp($xr);
      print "y: ";
      $yr=<STDIN>; chomp($yr);
      print "z: ";
      $zr=<STDIN>; chomp($zr);
      $xcr=($escala)*($xr*$ax+$yr*$bx+$zr*$cx);
      $ycr=($escala)*($xr*$ay+$yr*$by+$zr*$cy);
      $zcr=($escala)*($xr*$az+$yr*$bz+$zr*$cz);
      last;
   };
   if ($resp1 eq "n" || $resp1 eq "") {
      $xcr=0; $ycr=0; $zcr=0;
      last;
   };
   print "Orden incorrecta. Escriba \"y\" o \"n\"\n";
};

while (1) {
   print "Activar marcacion de coordenadas \"relajadas\" (con T en POS/CONTCAR)\n";
   print "-EL FORMATO .xyz DEJARA DE SER VALIDO SI SE ACTIVA LA MARCACION- (y/n)?: ";
   $resp2=<STDIN>; chomp($resp2);
   if ($resp2 eq "y") {
      last;
   };  
   if ($resp2 eq "n") {
      last;
   };  
   print "Orden incorrecta. Escriba \"y\" o \"n\"\n";
   print "(Order incorrect.  Type \"y\" or \"n\")\n";
};

if ($resp1 eq "y") {
while (1) {
   print "Activar reajuste de coordenadas para permitir comparativa entre\n";
   print "distintos sistemas -esto reubica las coordenadas que por condiciones\n";
   print "periodicas estan a una distancia ficticia de la referencia escogida\n";
   print "(Activating readjusting coordinates to allow comparison\n\
          different systems-that relocates the coordinates for conditions\n\
          Journalists are at a distance from the fictitious reference chosen)\n";
   print "(y/n)?:";
   $resp3=<STDIN>; chomp($resp3);
   if ($resp3 eq "y") {
      last;
   };
   if ($resp3 eq "n") {
      last;
   };
   print "Orden incorrecta. Escriba \"y\" o \"n\"\n";
   print "(Order incorrect.  Type \"y\" or \"n\")\n";
};
};
# Hasta aqui tenemos todos los datos de entrada de datos 
#----------------------------------------------------------------
#
# TRATAMIENTO DE LOS DATOS
#
# 0. Reposicionado de todas las coordenadas fraccionarias a 
#    valores positivos (para evitar posibles conflictos).
#    Y reajuste de coordenadas de "periodicas a cluster"
## So here we have all the data input
##------------------------------------------------- ---------------
##
## TREATMENT OF DATA
##
## 0. Repositioned all the coordinates of a divisional
## Positive values (to avoid potential conflicts).
## And readjustment of coordinates of "regular cluster"

for ($p=0;$p<$NAT;$p++){
   if ($x[$p]<0.0) {
      $x[$p]=$x[$p]+1;
   };
   if ($y[$p]<0.0) {
      $y[$p]=$y[$p]+1;
   };
   if ($z[$p]<0.0) {
      $z[$p]=$z[$p]+1;
   };
};

if ($resp3 eq "y") {
   for ($p=0;$p<$NAT;$p++){
      $difx=$x[$p]-$xr;
      if ($difx>0.50000000) {
         $x[$p]=$x[$p]-1;
      };
      if ($difx<-0.5000000) {
         $x[$p]=$x[$p]+1;
      };
      $dify=$y[$p]-$yr;
      if ($dify>0.500000000) {
         $y[$p]=$y[$p]-1;
      };
      if ($dify<-0.50000000) {
         $y[$p]=$y[$p]+1;
      };
      $difz=$z[$p]-$zr;
      if ($difz>0.500000000) {
         $z[$p]=$z[$p]-1;
      };
      if ($difz<-0.50000000) {
         $z[$p]=$z[$p]+1;
      };
   };
};

# 1. Transformacion a coordenadas cartesianas 

for ($i=0;$i<$NAT;$i++){
   $xc[$i]=($escala)*($x[$i]*$ax+$y[$i]*$bx+$z[$i]*$cx);
   $xc[$i]=$xc[$i]-$xcr;
   $yc[$i]=($escala)*($x[$i]*$ay+$y[$i]*$by+$z[$i]*$cy);
   $yc[$i]=$yc[$i]-$ycr;
   $zc[$i]=($escala)*($x[$i]*$az+$y[$i]*$bz+$z[$i]*$cz);
   $zc[$i]=$zc[$i]-$zcr;
};

# 2. Escritura de los resultados en fichero con formato .xyz para WebLab

print "\n";
print "Indicar nombre para el fichero de salida en formato XYZ:\n";
print "(Indicate name for the output file format XYZ):\n";
$output=<STDIN>; chomp($output);

open (OUT1, ">$output"); 
print OUT1 "$NAT\n";
print OUT1 "$name\n";

$index=0;
if ($resp2 eq "y") {
   for ($p=0;$p<@at;$p++){
      for ($i=$index;$i<$index+$at[$p];$i++){
         printf OUT1 "%4s %14.8f($optx[$i]) %14.8f($opty[$i]) %14.8f($optz[$i])\n",$label[$p],$xc[$i],$yc[$i],$zc[$i];
      };
      $index=$index+$at[$p];
   };
};

if ($resp2 eq "n") {
   for ($p=0;$p<@at;$p++){
      for ($i=$index;$i<$index+$at[$p];$i++){
         printf OUT1 "%4s %14.8f %14.8f %14.8f\n",$label[$p],$xc[$i],$yc[$i],$zc[$i];
      };
      $index=$index+$at[$p];
   };
};

print "\n";
print "Resultado en $output\n";
print "\n";
print "##############################################################################\n";
print "\n";
print "                                      J.C.R\n";

#############   #####      ####   ######
#############   ######     ####   ##########
####            #######    ####   ####    ####
####            ########   ####   ####      #### 
#############   #### ####  ####   ####       ####
#############   ####  #### ####   ####       ####
####            ####   ########   ####      ####
####            ####    #######   ####    ####
#############   ####     ######   ##########
#############   ####      #####   #######
