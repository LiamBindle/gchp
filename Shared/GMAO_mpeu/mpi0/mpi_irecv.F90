!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!       NASA/GSFC, Data Assimilation Office, Code 910.3, GEOS/DAS      !
!BOP -------------------------------------------------------------------
!
! !ROUTINE: mpi_irecv -
!
! !DESCRIPTION:
!
! !INTERFACE:

    subroutine mpi_irecv( buf, count, type, pe, tag, comm, request, ierror)

      use m_mpi0,only : mpi0_initialized, MPI_STATUS_SIZE
      implicit none
      integer,dimension(*),intent(in) :: buf
      integer,		   intent(in) :: count
      integer,		   intent(in) :: type

      integer,             intent(in) :: pe
      integer,             intent(in) :: tag
      integer,		   intent(in) :: comm
      integer,             intent(out):: request
      integer,		   intent(inout):: ierror

! !REVISION HISTORY:
! 	04Jun02	- Tom Clune <Thomas.L.Clune.1@gsfc.nasa.gov>
!		- initial prototype/prolog/code
!EOP ___________________________________________________________________

  character(len=*),parameter :: myname='mpi_isendallgather'

  if(.not.mpi0_initialized) call mpi_init(ierror)

  ! need to set up a buffer
  ! for now - never call this routine
  call mpi_abort(comm, -1, ierror)

end subroutine mpi_irecv
