c  Reads VASP OUTCAR file 
       integer, parameter:: natom = 27 
       character(len=70) :: label, num, fname 
       character(len=2)  :: symb(natom) 
  
       real*8            :: vec(3), cell(3,3), sh(3) 
  
 c----------------------------------------------------------------------- 
  
       symb(:)(:) = ' ' 
       do ia = 1, 6 
        symb(ia)= 'C' 
       enddo 
       do ia = 7, 11 
        symb(ia)= 'H' 
       enddo 
       symb(12)= 'S' 
       do ia = 13, natom 
        symb(ia)= 'Ag' 
       enddo 
  
       nargs = iargc() 
       if ( nargs.lt.1 ) stop 'Usage: file_names XV2MD shfit(1:3) fac' 
       call getarg(1,fname) 
  
       ncel1= 0; ncel2=0; ncel3=0; fac=1.0 
       if ( nargs.gt.1 ) then 
        call getarg(2,num); read(num,*) ncel1 
       endif 
       if ( nargs.gt.2 ) then 
        call getarg(3,num); read(num,*) ncel2 
       endif 
       if ( nargs.gt.3 ) then 
        call getarg(4,num); read(num,*) ncel3 
       endif 
       write(6,*) 'ncel=',ncel1,ncel2,ncel3 
       if ( nargs.gt.4 ) then 
        call getarg(5,num); read(num,*) fac 
       endif 
       write(6,*) 'fac=',fac 
       open(1,file='OUTCAR',status='old',err=3) 
       open(2,file=trim(fname)//'_MD.xyz',status='unknown') 
       lcell = .false. 
       do 
        read(1,'(a)',end=10) label 
  
 c      read cell  
        if ( .not. lcell ) then 
         if ( index(label,'direct lattice vectors').ne.0 ) then 
          do i = 1 , 3 
           read(1,*) cell(:,i) 
          enddo 
          lcell = .true. 
         endif 
        endif 
  
 c      read positions  
        if ( index(label,'POSITION').ne.0 ) then 
         read(1,*) 
         natoms = (2*ncel1+1)*(2*ncel2+1)*(2*ncel3+1)*natom 
         write(2,'(i6/)') natoms 
         do ia = 1, natom 
          read(1,*) vec 
          if ( ia.gt.12 ) vec = vec - cell(:,3) 
          do icel3= -ncel3, ncel3 
           do icel2= -ncel2, ncel2 
            do icel1= -ncel1, ncel1 
             sh = icel1*cell(:,1)  + icel2*cell(:,2) + icel3*cell(:,3) 
             write(2,'(1x,a,3f10.5)') symb(ia),vec(:)+sh 
            enddo 
           enddo 
          enddo 
         enddo 
        endif 
       enddo 
 10    close(1) 
       close(2) 
  
       stop 
 3     stop 'could not open OUTCAR file' 
       end
