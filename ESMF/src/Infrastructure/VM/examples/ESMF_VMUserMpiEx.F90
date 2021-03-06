! $Id: ESMF_VMUserMpiEx.F90,v 1.1.5.1 2013-01-11 20:23:44 mathomp4 Exp $
!
! Earth System Modeling Framework
! Copyright 2002-2012, University Corporation for Atmospheric Research,
! Massachusetts Institute of Technology, Geophysical Fluid Dynamics
! Laboratory, University of Michigan, National Centers for Environmental
! Prediction, Los Alamos National Laboratory, Argonne National Laboratory,
! NASA Goddard Space Flight Center.
! Licensed under the University of Illinois-NCSA License.
!
!==============================================================================

!==============================================================================
!ESMF_EXAMPLE        String used by test script to count examples.
!==============================================================================

!------------------------------------------------------------------------------
!BOE
!
! \subsubsection{Nesting ESMF inside a user MPI application}
!
! \begin{sloppypar}
! It is possible to nest an ESMF application inside a user application that 
! explicitly calls {\tt MPI\_Init()} and {\tt MPI\_Finalize()}. The
! {\tt ESMF\_Initialize()} call automatically checks whether MPI has already
! been initialized, and if so does not call {\tt MPI\_Init()} internally. 
! On the finalize side, {\tt ESMF\_Finalize()} can be instructed to {\em not}
! call {\tt MPI\_Finalize()}, making it the responsibility of the outer code
! to finalize MPI.
! \end{sloppypar}
!
!EOE
!------------------------------------------------------------------------------

program ESMF_VMUserMpiEx

  use ESMF
  
  implicit none
#ifndef ESMF_MPIUNI     
  include 'mpif.h'
#endif
  
  ! local variables
  integer:: rc
#ifndef ESMF_MPIUNI     
  integer:: ierr
#endif
  ! result code
  integer :: finalrc
  finalrc = ESMF_SUCCESS
#ifndef ESMF_MPIUNI     
!BOC
  call MPI_Init(ierr)
  ! User code initializes MPI.
!EOC
  if (ierr/=0) finalrc = ESMF_FAILURE
#endif
!BOC
  call ESMF_Initialize(defaultlogfilename="VMUserMpiEx.Log", &
                    logkindflag=ESMF_LOGKIND_MULTI, rc=rc)
  ! ESMF_Initialize() does not call MPI_Init() if it finds MPI initialized.
!EOC
  if (rc/=ESMF_SUCCESS) finalrc = ESMF_FAILURE
!BOC
  call ESMF_Finalize(endflag=ESMF_END_KEEPMPI, rc=rc)
  ! Calling with endflag=ESMF_END_KEEPMPI instructs ESMF_Finalize() to keep
  ! MPI active.
!EOC
  if (rc/=ESMF_SUCCESS) finalrc = ESMF_FAILURE
#ifndef ESMF_MPIUNI     
!BOC
  call MPI_Finalize(ierr)
  ! It is the responsibility of the outer user code to finalize MPI.
!EOC
  if (ierr/=0) finalrc = ESMF_FAILURE
#endif
  ! print result
  if (finalrc==ESMF_SUCCESS) then
    print *, "PASS: ESMF_VMUserMpiEx.F90"
  else
    print *, "FAIL: ESMF_VMUserMpiEx.F90"
  endif
end program
