program hist
character *100 cmdline ! old the command line args
character *50 infile
real :: min, max
integer :: nbins, nequil, nstop
real :: line ! a line of the data
integer :: n, bin
real :: binwidth, normconst
integer, dimension(:), allocatable :: histogram

nequil = 0
nstop = 0

if ( iargc() < 5 ) then
  write(*,*) "Usage: hist <DATAFILE> <MIN> <MAX> <NBINS> [NEQUIL] [NSTOP]"
  call exit()
endif

call getarg(1,cmdline)
read(cmdline,*) infile
call getarg(2,cmdline)
read(cmdline,*) min
call getarg(3,cmdline)
read(cmdline,*) max
call getarg(4,cmdline)
read(cmdline,*) nbins

if( iargc() > 4 ) then
  call getarg(5,cmdline)
  read(cmdline,*) nequil
  if( iargc() > 5 ) then
    call getarg(6,cmdline)
    read(cmdline,*) nstop
  endif
endif

binwidth = (max-min)/nbins

write(0,*),infile
write(0,*),min
write(0,*),max
write(0,*),nbins
write(0,*),nequil
write(0,*),nstop
write(0,*),binwidth

! open the infile
open(51,FILE=infile,ACCESS="SEQUENTIAL",STATUS="OLD")

allocate( histogram(nbins) )
n = 0
do while ( .true. )
  n = n + 1
  read(51,*,end=20) line
  if ( n < nequil ) then
    continue
  endif
  bin = int( (line - min)/binwidth + 0.5 )
  if ( bin > nbins .or. bin < 0 ) then ! sanity check
    write(0,*) "Oops: gone to far - increase min and/or max"
  else
    histogram(bin) = histogram(bin) + 1
  endif
enddo
20 continue

! normalise the histogram
normconst = 0
do i=0,nbins
  normconst = normconst + binwidth*histogram(i)
enddo

! print out the histogram
do i=0,nbins
  write(*,*) (i*binwidth + min),histogram(i)/normconst
enddo



end program hist
