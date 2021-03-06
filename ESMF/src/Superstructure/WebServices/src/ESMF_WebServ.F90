! $Id$
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
#define ESMF_FILENAME "ESMF_WebServ.F90"
!==============================================================================
!
! ESMF Component module
module ESMF_WebServMod
!
!==============================================================================
! A blank line to keep protex happy because there are no public entry
! points in this file, only internal ones.
!BOP

!EOP
!
! This file contains the Component class definition and all Component
! class methods.
!
!------------------------------------------------------------------------------
! INCLUDES

#include "ESMF.h"

!------------------------------------------------------------------------------
!BOPI
! !MODULE: ESMF_GridCompMod - Gridded Component class.
!
! !DESCRIPTION:
!
! The code in this file implements the Fortran interfaces to the
! ESMF Web Services.
!
!
! !USES:
  use ESMF_CompMod
  use ESMF_GridCompMod
  use ESMF_StateTypesMod
  use ESMF_StateMod
  use ESMF_ClockMod
  use ESMF_UtilTypesMod
  use ESMF_VMMod
  use ESMF_LogErrMod
    
  implicit none

  private

  public ESMF_WebServProcessRequest, ESMF_WebServWaitForRequest
  public ESMF_WebServicesLoop

contains

!------------------------------------------------------------------------------
#undef  ESMF_METHOD
#define ESMF_METHOD "ESMF_WebServProcessRequest()"
!BOPI
! !IROUTINE: ESMF_WebServProcessRequest 
!
! !INTERFACE:
  subroutine ESMF_WebServProcessRequest(comp, importState, exportState, &
                                        clock, phase, procType, rc)

!
! !ARGUMENTS:
    type(ESMF_GridComp)  :: comp
    type(ESMF_State)     :: importState
    type(ESMF_State)     :: exportState
    type(ESMF_Clock)     :: clock
    integer              :: phase
    character            :: procType
    integer, intent(out) :: rc

!
!
! !DESCRIPTION:
!   If this is the root process, send messages to all of the other processes
!   to run the specified routine.
!
! The arguments are:
! \begin{description}
! \item[{[comp]}]
!   {\tt ESMF\_GridComp} object that represents the Grid Component for which
!   the service is created.
! \item[{[impstate]}]
!   {\tt ESMF\_State} containing import data for coupling. 
! \item[{[expstate]}]
!   {\tt ESMF\_State} containing export data for coupling. 
! \item[{[clock]}]
!   External {\tt ESMF\_Clock} for passing in time information.
! \item[{[phase]}]
!   Indicates whether routines are {\em single-phase} or {\em multi-phase}.
! \item[{[procType]}]
!   Specifies which routine to run: 'I' for initialization, 'R' for run, and
!   'F' for finalization.
! \item[{[rc]}]
!   Return code; equals {\tt ESMF\_SUCCESS} if there are no errors.
! \end{description}
!
!EOPI
!------------------------------------------------------------------------------

    ! Local variables
    integer        :: localrc
    type(ESMF_VM)  :: vm
    integer        :: localPet, petCount
    integer        :: thread_cntr
    character      :: outmsg(2)

    ! Initialize return code
    rc = ESMF_SUCCESS
    localrc = ESMF_SUCCESS

    print *, "Processing request"

    call ESMF_GridCompGet(comp, vm=vm)
    call ESMF_VMGet(vm, localPet=localPet, petCount=petCount)

    if (localPet == 0) then

       outmsg(1) = procType

       ! Loop through the other, non-root processes, sending each of them 
       ! the message to process the request
       do thread_cntr = 1, petCount - 1, 1

          print *, "In do loop: ", thread_cntr
          print *, "Before MPI Send: ", procType
          call ESMF_VMSend(vm, sendData=outmsg, count=1, dstPet=thread_cntr, &
                           rc=localrc)

          ! Check return code to make sure send went out ok
          if (localrc /= ESMF_SUCCESS) then
              call ESMF_LogSetError( &
                      rcToCheck=ESMF_RC_NOT_VALID, &
                      msg="Error while sending message to non-root pet", &
                      ESMF_CONTEXT, &
                      rcToReturn=localrc)
          endif

       enddo

    endif

    rc = localrc

  end subroutine
!-------------------------------------------------------------------------


!------------------------------------------------------------------------------
#undef  ESMF_METHOD
#define ESMF_METHOD "ESMF_WebServWaitForRequest()"
!BOPI
! !IROUTINE: ESMF_WebServWaitForRequest 
!
! !INTERFACE:
!  subroutine ESMF_WebServWaitForRequest(comp, exportState, rc)
  subroutine ESMF_WebServWaitForRequest(comp, importState, exportState, clock, syncflag, phase, rc)

!
! !ARGUMENTS:
    type(ESMF_GridComp)  :: comp
!    type(ESMF_State)     :: exportState
    type(ESMF_State),        intent(inout), optional :: importState
    type(ESMF_State),        intent(inout), optional :: exportState
    type(ESMF_Clock),        intent(inout), optional :: clock
    type(ESMF_Sync_Flag), intent(in),    optional :: syncflag
    integer,                 intent(in),    optional :: phase
    integer,                 intent(out),   optional :: rc
!
!
! !DESCRIPTION:
!   If this is not the root process, waits for a message from the root 
!   process and executes the appropriate routine when the message is received.
!
! The arguments are:
! \begin{description}
! \item[{[comp]}]
!   {\tt ESMF\_GridComp} object that represents the Grid Component for which
!   routine is run.
! \item[{[expstate]}]
!   {\tt ESMF\_State} containing export data for coupling. 
! \item[{[rc]}]
!   Return code; equals {\tt ESMF\_SUCCESS} if there are no errors.
! \end{description}
!
!EOPI
!------------------------------------------------------------------------------

    integer       :: localrc
    type(ESMF_VM) :: vm
    integer       :: localPet, petCount
    character     :: inmsg(2)
    integer       :: count

    ! Initialize return code
    rc = ESMF_SUCCESS
    localrc = ESMF_SUCCESS

    ! Get the current PET info
    call ESMF_GridCompGet(comp, vm=vm)
    call ESMF_VMGet(vm, localPet=localPet, petCount=petCount)

    ! Loop forever... need to provide clean exit 
    do

       ! Wait for the request to be sent, and once it's received, process
       ! the request based on the incoming message
       print *, "Waiting for request: ", localPet
       inmsg(1) = 'A'

       call ESMF_VMRecv(vm, recvData=inmsg, count=count, srcPet=0, &
                        syncflag=ESMF_SYNC_BLOCKING, rc=localrc)
       if (localrc /= ESMF_SUCCESS) then
           call ESMF_LogSetError( &
                   rcToCheck=ESMF_RC_NOT_VALID, &
                   msg="Error while receiving message from root pet", &
                   ESMF_CONTEXT, &
                   rcToReturn=localrc)

           rc = localrc
           return
       endif

       print *, "    Buffer value: ", inmsg(1), " - ", localPet
       print *, "Leaving MPI_Recv: ", localPet

       ! 'I' = init
       if (inmsg(1) == 'I') then

          print *, "Execute GridCompInitialize: ", localPet
          call ESMF_GridCompInitialize(comp, rc=localrc)
          if (localrc /= ESMF_SUCCESS) then
              call ESMF_LogSetError( &
                      rcToCheck=ESMF_RC_NOT_VALID, &
                      msg="Error while calling ESMF Initialize.", &
                      ESMF_CONTEXT, &
                      rcToReturn=localrc)

              rc = localrc
              return
          endif
          print *, "Done Execute GridCompInitialize: ", localPet

       ! 'R' = run
       else if (inmsg(1) == 'R') then

          print *, "Execute GridCompRun: ", localPet
          call ESMF_GridCompRun(comp, rc=localrc)
          if (localrc /= ESMF_SUCCESS) then
              call ESMF_LogSetError( &
                      rcToCheck=ESMF_RC_NOT_VALID, &
                      msg="Error while calling ESMF Run.", &
                      ESMF_CONTEXT, &
                      rcToReturn=localrc)

              rc = localrc
              return
          endif
          print *, "Done Execute GridCompRun: ", localPet

       ! 'F' = final
       else if (inmsg(1) == 'F') then

          print *, "Execute GridCompFinalize: ", localPet
          call ESMF_GridCompFinalize(comp, rc=localrc)
          if (localrc /= ESMF_SUCCESS) then
              call ESMF_LogSetError( &
                      rcToCheck=ESMF_RC_NOT_VALID, &
                      msg="Error while calling ESMF Finalize.", &
                      ESMF_CONTEXT, &
                      rcToReturn=localrc)

              rc = localrc
              return
          endif
          print *, "Done Execute GridCompFinalize: ", localPet

       ! 'E' = exit
       else if (inmsg(1) == 'E') then

          print *, "Exit Component Service: ", localPet
          rc = ESMF_SUCCESS
          return

       ! Anything else... it's an error
       else 

           localrc = ESMF_FAILURE

           call ESMF_LogSetError( &
                   rcToCheck=ESMF_RC_ARG_BAD, &
                   msg="Error while processing request.", &
                   ESMF_CONTEXT, &
                   rcToReturn=localrc)

           rc = localrc
           return

       endif

    end do

    rc = localrc

  end subroutine
!------------------------------------------------------------------------------


!------------------------------------------------------------------------------
#undef  ESMF_METHOD
#define ESMF_METHOD "ESMF_WebServRegisterSvc()"
!BOPI
! !IROUTINE: ESMF_WebServRegisterSvc 
!
! !INTERFACE:
  subroutine ESMF_WebServRegisterSvc(comp, portNum, clientId, rc)

!
! !ARGUMENTS:
    type(ESMF_GridComp)        :: comp
    integer                    :: portNum
    character(len=ESMF_MAXSTR) :: clientId
    integer, intent(out)       :: rc
!
!
! !DESCRIPTION:
!   Registers this component as a service with the Registrar so that clients
!   can discover that it is available.
!
! The arguments are:
! \begin{description}
! \item[{[comp]}]
!   {\tt ESMF\_GridComp} object that represents the Grid Component for which
!   routine is run.
! \item[{[portNum]}]
!   Number of the port on which the component service is listening.
! \item[{[rc]}]
!   Return code; equals {\tt ESMF\_SUCCESS} if there are no errors.
! \end{description}
!
!EOPI
!------------------------------------------------------------------------------

    integer                     :: localrc
    character(len=ESMF_MAXSTR)  :: compName
    character(len=ESMF_MAXSTR)  :: compDesc
!    character(len=ESMF_MAXSTR)  :: hostName

    ! Initialize return code
    rc = ESMF_SUCCESS
    localrc = ESMF_SUCCESS

    call ESMF_GridCompGet(comp, name=compName, rc=localrc)

    compDesc = ""
!    hostName = "localhost"

    call c_ESMC_RegisterComponent(compName, compDesc, clientId, portNum, &
                                  localrc)

    rc = localrc

  end subroutine
!------------------------------------------------------------------------------


!------------------------------------------------------------------------------
#undef  ESMF_METHOD
#define ESMF_METHOD "ESMF_WebServUnregisterSvc()"
!BOPI
! !IROUTINE: ESMF_WebServUnregisterSvc 
!
! !INTERFACE:
  subroutine ESMF_WebServUnregisterSvc(clientId, rc)

!
! !ARGUMENTS:
    character(len=ESMF_MAXSTR) :: clientId
    integer, intent(out)       :: rc
!
!
! !DESCRIPTION:
!   Un-registers this component from the Registrar so that it is no longer
!   discoverable as an available service.
!
! The arguments are:
! \begin{description}
! \item[{[comp]}]
!   {\tt ESMF\_GridComp} object that represents the Grid Component for which
!   routine is run.
! \item[{[portNum]}]
!   Number of the port on which the component service is listening.
! \item[{[rc]}]
!   Return code; equals {\tt ESMF\_SUCCESS} if there are no errors.
! \end{description}
!
!EOPI
!------------------------------------------------------------------------------

    integer                     :: localrc

    ! Initialize return code
    rc = ESMF_SUCCESS
    localrc = ESMF_SUCCESS

    call c_ESMC_UnregisterComponent(clientId, localrc)

    rc = localrc

  end subroutine
!------------------------------------------------------------------------------


!------------------------------------------------------------------------------
#undef  ESMF_METHOD
#define ESMF_METHOD "ESMF_WebServSvcLoop()"
!BOPI
! !IROUTINE: ESMF_WebServSvcLoop 
!
! !INTERFACE:
  subroutine ESMF_WebServSvcLoop(comp, portNum, importState, exportState, &
                                 clock, syncflag, phase, rc)

!
! !ARGUMENTS:
    type(ESMF_GridComp)                              :: comp
    integer                                          :: portNum
    type(ESMF_State),        intent(inout), optional :: importState
    type(ESMF_State),        intent(inout), optional :: exportState
    type(ESMF_Clock),        intent(inout), optional :: clock
    type(ESMF_Sync_Flag), intent(in),    optional :: syncflag
    integer,                 intent(in),    optional :: phase
    integer,                 intent(out),   optional :: rc
!
!
! !DESCRIPTION:
!   Enters the service into a process loop that waits for requests from
!   clients using a socket service.
!
! The arguments are:
! \begin{description}
! \item[{[comp]}]
!   {\tt ESMF\_GridComp} object that represents the Grid Component for which
!   routine is run.
! \item[{[portNum]}]
!   Number of the port on which the component service is listening.
! \item[{[rc]}]
!   Return code; equals {\tt ESMF\_SUCCESS} if there are no errors.
! \end{description}
!
!EOPI
!------------------------------------------------------------------------------

    integer       :: localrc

    ! Initialize return code
    rc = ESMF_SUCCESS
    localrc = ESMF_SUCCESS

    call c_ESMC_ComponentSvcLoop(comp, importState, exportState, clock, &
                                 syncflag, phase, portNum, localrc)

    rc = localrc

  end subroutine
!------------------------------------------------------------------------------


!------------------------------------------------------------------------------
#undef  ESMF_METHOD
#define ESMF_METHOD "ESMF_WebServGetPortNum()"
!BOPI
! !IROUTINE: ESMF_WebServSvcLoop 
!
! !INTERFACE:
  subroutine ESMF_WebServGetPortNum(portNum, rc)

!
! !ARGUMENTS:
    integer,                 intent(out)             :: portNum
    integer,                 intent(out),   optional :: rc
!
!
! !DESCRIPTION:
!   Finds a suitable port number for the service.
!
! The arguments are:
! \begin{description}
! \item[{[portNum]}]
!   Number of the port on which the component service is listening.
! \item[{[rc]}]
!   Return code; equals {\tt ESMF\_SUCCESS} if there are no errors.
! \end{description}
!
!EOPI
!------------------------------------------------------------------------------

    integer       :: localrc

    ! Initialize return code
    rc = ESMF_SUCCESS
    localrc = ESMF_SUCCESS

    call c_ESMC_GetPortNum(portNum, localrc)

    rc = localrc

  end subroutine
!------------------------------------------------------------------------------


!------------------------------------------------------------------------------
#undef  ESMF_METHOD
#define ESMF_METHOD "ESMF_WebServicesLoop()"
!BOP
! !IROUTINE: ESMF_WebServicesLoop 
!
! !INTERFACE:
  subroutine ESMF_WebServicesLoop(comp, portNum, clientId, rc)

!
! !ARGUMENTS:
    type(ESMF_GridComp)                                 :: comp
    integer,                    intent(inout), optional :: portNum
    character(len=ESMF_MAXSTR), intent(in),    optional :: clientId
    integer,                    intent(out),   optional :: rc
!
!
! !DESCRIPTION:
!   Encapsulates all of the functionality necessary to setup a component as
!   a component service.  If this is the root PET, it registers the 
!   component service and then enters into a loop that waits for requests on 
!   a socket.  The loop continues until an "exit" request is received, at 
!   which point it exits the loop and unregisters the service.  If this is
!   any PET other than the root PET, it sets up a process block that waits
!   for instructions from the root PET.  Instructions will come as requests
!   are received from the socket.
!
! The arguments are:
! \begin{description}
! \item[{[comp]}]
!   {\tt ESMF\_GridComp} object that represents the Grid Component for which
!   routine is run.
! \item[{[portNum]}]
!   Number of the port on which the component service is listening.
! \item[{[clientId]}]
!   Identifer of the client responsible for this component service.  If a
!   Process Controller application manages this component service, then the
!   clientId is provided to the component service application in the command
!   line.  Otherwise, the clientId is not necessary.
! \item[{[rc]}]
!   Return code; equals {\tt ESMF\_SUCCESS} if there are no errors.
! \end{description}
!
!EOP
!------------------------------------------------------------------------------

    integer                    :: localrc
    integer                    :: registrarrc
    integer                    :: localPet, petCount
    type(ESMF_VM)              :: vm
    type(ESMF_State)           :: importState
    type(ESMF_State)           :: exportState
    type(ESMF_Clock)           :: clock
    type(ESMF_Sync_Flag)       :: syncflag
    integer                    :: phase
    character(len=ESMF_MAXSTR) :: clientIdVal


    ! Initialize return code
    rc = ESMF_SUCCESS
    localrc = ESMF_SUCCESS

    if (present(clientId)) then
      clientIdVal = clientId
    else
      clientIdVal = ""
    end if

    call ESMF_VMGetGlobal(vm=vm, rc=localrc)
    if (ESMF_LogFoundError(localrc, ESMF_ERR_PASSTHRU, &
      ESMF_CONTEXT, &
      rcToReturn=rc)) return

    call ESMF_VMGet(vm, petCount=petCount, localPet=localPet, rc=localrc)
    if (ESMF_LogFoundError(localrc, ESMF_ERR_PASSTHRU, &
      ESMF_CONTEXT, &
      rcToReturn=rc)) return

    if (localPet == 0)  then

       ! create and initialize data members 
       importState = ESMF_StateCreate(name="Import", &
                                      stateintent=ESMF_STATEINTENT_IMPORT, &
                                      rc=localrc)
       if (ESMF_LogFoundError(localrc, ESMF_ERR_PASSTHRU, &
         ESMF_CONTEXT, &
         rcToReturn=rc)) &
          return

       exportState = ESMF_StateCreate(name="Export", &
                                      stateintent=ESMF_STATEINTENT_EXPORT, &
                                      rc=localrc)
       if (ESMF_LogFoundError(localrc, ESMF_ERR_PASSTHRU, &
         ESMF_CONTEXT, &
         rcToReturn=rc)) &
         return

       ! Initialize clock in the ComponentInitialize function??  
       ! Will creating the object be sufficient or do I need to initialize 
       ! it with some values using ClockCreate?
       !clock = ESMF_ClockCreate("App Clock", rc=localrc)

       syncflag = ESMF_SYNC_BLOCKING
       phase = 1

       if (portNum <= 0) then
          call ESMF_WebServGetPortNum(portNum=portNum, rc=localrc)
       if (ESMF_LogFoundError(localrc, &
             ESMF_ERR_PASSTHRU, &
             ESMF_CONTEXT, &
             rcToReturn=rc)) return
       endif

       call ESMF_WebServRegisterSvc(comp, portNum=portNum, &
             clientId=clientIdVal, rc=registrarrc)
       if (ESMF_LogFoundError(registrarrc, &
             ESMF_ERR_PASSTHRU, &
             ESMF_CONTEXT, &
             rcToReturn=rc)) &
             print *, "Unable to Register Service... continuing"

       print *, "KDS: Starting Service Loop"

       call ESMF_WebServSvcLoop(comp, portNum=portNum, &
             importState=importState, exportState=exportState, clock=clock, &
             syncflag=syncflag, phase=phase, rc=localrc)
       if (ESMF_LogFoundError(localrc, &
             ESMF_ERR_PASSTHRU, &
             ESMF_CONTEXT, &
             rcToReturn=rc)) return

       print *, "KDS: Exited Service Loop"

       call ESMF_WebServProcessRequest(comp, &
             importState=importState, exportState=exportState, &
             clock=clock, phase=phase, procType="E", rc=localrc)

       call ESMF_WebServUnregisterSvc(clientId=clientIdVal, rc=registrarrc)
       if (ESMF_LogFoundError(registrarrc, &
             ESMF_ERR_PASSTHRU, &
             ESMF_CONTEXT, &
             rcToReturn=rc)) &
             print *, "Unable to Unregister Service... continuing"

    else

       call ESMF_WebServWaitForRequest(comp, importState=importState, &
             exportState=exportState, clock=clock, syncflag=syncflag, &
             phase=phase, rc=localrc)
       if (ESMF_LogFoundError(localrc, &
             ESMF_ERR_PASSTHRU, &
             ESMF_CONTEXT, &
             rcToReturn=rc)) return

    end if

    rc = localrc

  end subroutine
!------------------------------------------------------------------------------


!------------------------------------------------------------------------------
#undef  ESMF_METHOD
#define ESMF_METHOD "ESMF_WebServAddOutputFilename()"
!BOPI
! !IROUTINE: ESMF_WebServAddOutputFilename 
!
! !INTERFACE:
  subroutine ESMF_WebServAddOutputFilename(filename, rc)

!
! !ARGUMENTS:
    character(len=ESMF_MAXSTR), intent(in)              :: filename
    integer,                    intent(out),   optional :: rc
!
!
! !DESCRIPTION:
!   Adds a filename to the list of output filenames.
!
! The arguments are:
! \begin{description}
! \item[{[filename]}]
!   The name of the file to add to the list of output filenames.
! \item[{[rc]}]
!   Return code; equals {\tt ESMF\_SUCCESS} if there are no errors.
! \end{description}
!
!EOPI
!------------------------------------------------------------------------------

    integer       :: localrc

    ! Initialize return code
    rc = ESMF_SUCCESS
    localrc = ESMF_SUCCESS

    call c_ESMC_AddOutputFilename(filename, localrc)

    rc = localrc

  end subroutine
!------------------------------------------------------------------------------


end module ESMF_WebServMod
