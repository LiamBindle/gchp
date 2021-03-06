! $Id: ESMF_GridCompCreateUTest.F90,v 1.1.5.1 2013-01-11 20:23:44 mathomp4 Exp $
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
!
      program ESMF_GridCompCreateUTest

!------------------------------------------------------------------------------

#include "ESMF_Macros.inc"

!==============================================================================
!BOP
! !PROGRAM: ESMF_GridCompCreateUTest - Unit test for Components.
!
! !DESCRIPTION:
! Tests, cursory and exahustive, for Component Create code.
!
!-------------------------------------------------------------------------
!
! !USES:
    use ESMF_TestMod     ! test methods
    use ESMF
    implicit none
    
!   ! Local variables
    integer :: rc
    character(ESMF_MAXSTR) :: cname
    type(ESMF_GridComp) :: comp1, gridcompAlias
    logical:: gridcompBool

    ! individual test failure message
    character(ESMF_MAXSTR) :: failMsg
    character(ESMF_MAXSTR) :: name
    integer :: result = 0

    ! Internal State Variables
    type testData
    sequence
        integer :: testNumber
    end type

    type dataWrapper
    sequence
        type(testData), pointer :: p
    end type


#ifdef ESMF_TESTEXHAUSTIVE
    character(ESMF_MAXSTR) :: bname
    type(dataWrapper) :: wrap1, wrap2, wrap3, wrap4, wrap5, wrap6
    type(ESMF_Grid) :: grid, gridIn
    logical         :: isPresent
#endif

!-------------------------------------------------------------------------------
!   The unit tests are divided into Sanity and Exhaustive. The Sanity tests are
!   always run. When the environment variable, EXHAUSTIVE, is set to ON then
!   the EXHAUSTIVE and sanity tests both run. If the EXHAUSTIVE variable is set
!   to OFF, then only the sanity unit tests.
!   Special strings (Non-exhaustive and exhaustive) have been
!   added to allow a script to count the number and types of unit tests.
!-------------------------------------------------------------------------------
        
    call ESMF_TestStart(ESMF_SRCLINE, rc=rc)

    !------------------------------------------------------------------------
    !NEX_UTest
    cname = "Atmosphere"
    comp1 = ESMF_GridCompCreate(name=cname, configFile="grid.rc", rc=rc)  
    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Creating a Component Test"
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

    !------------------------------------------------------------------------
    !NEX_UTest
    write(name, *) "GridComp equality before assignment Test"
    write(failMsg, *) "Did not return ESMF_SUCCESS"
    gridcompBool = (gridcompAlias.eq.comp1)
    call ESMF_Test(.not.gridcompBool, name, failMsg, result, ESMF_SRCLINE)
    
    !------------------------------------------------------------------------
    !NEX_UTest
    ! Testing ESMF_GridCompAssignment(=)()
    write(name, *) "GridComp assignment and equality Test"
    write(failMsg, *) "Did not return ESMF_SUCCESS"
    gridcompAlias = comp1
    gridcompBool = (gridcompAlias.eq.comp1)
    call ESMF_Test(gridcompBool, name, failMsg, result, ESMF_SRCLINE)
    
    !------------------------------------------------------------------------
    !NEX_UTest
    write(name, *) "GridCompDestroy Test"
    write(failMsg, *) "Did not return ESMF_SUCCESS"
    call ESMF_GridCompDestroy(comp1, rc=rc)
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)
    
    !------------------------------------------------------------------------
    !NEX_UTest
    ! Testing ESMF_GridCompOperator(==)()
    write(name, *) "GridComp equality after destroy Test"
    write(failMsg, *) "Did not return ESMF_SUCCESS"
    gridcompBool = (gridcompAlias==comp1)
    call ESMF_Test(.not.gridcompBool, name, failMsg, result, ESMF_SRCLINE)
    
    !------------------------------------------------------------------------
    !NEX_UTest
    ! Testing ESMF_GridCompOperator(/=)()
    write(name, *) "GridComp non-equality after destroy Test"
    write(failMsg, *) "Did not return ESMF_SUCCESS"
    gridcompBool = (gridcompAlias/=comp1)
    call ESMF_Test(gridcompBool, name, failMsg, result, ESMF_SRCLINE)
    
    !------------------------------------------------------------------------
    !NEX_UTest
    write(name, *) "Double GridCompDestroy through alias Test"
    write(failMsg, *) "Did not return ESMF_SUCCESS"
    call ESMF_GridCompDestroy(gridcompAlias, rc=rc)
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

    !------------------------------------------------------------------------
    !NEX_UTest
    cname = "Atmosphere"
    comp1 = ESMF_GridCompCreate(name=cname, configFile="grid.rc", rc=rc)  
    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Creating a Component Test"
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

    !------------------------------------------------------------------------
    !NEX_UTest
    write(name, *) "GridCompDestroy Test"
    write(failMsg, *) "Did not return ESMF_SUCCESS"
    call ESMF_GridCompDestroy(comp1, rc=rc)
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

#ifdef ESMF_TESTEXHAUSTIVE

!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Test get a Component name from a destroyed component

    call ESMF_GridCompGet(comp1, name=bname, rc=rc)

    write(failMsg, *) "Did return ESMF_SUCCESS"
    write(name, *) "Getting a Component name Test"
    call ESMF_Test((rc.ne.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Test creation of a Component
    comp1 = ESMF_GridCompCreate(rc=rc)  

    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Creating a Component Test"
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Query gridIsPresent

    call ESMF_GridCompGet(comp1, gridIsPresent=isPresent, rc=rc)

    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Query gridIsPresent bit for Grid that was not set Test"
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Verify gridIsPresent

    write(failMsg, *) "Did not verify"
    write(name, *) "Verify gridIsPresent for Grid that was not set Test"
    call ESMF_Test((.not.isPresent), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Test get a Grid that was not set

    call ESMF_GridCompGet(comp1, grid=grid, rc=rc)

    write(failMsg, *) "Did return ESMF_SUCCESS"
    write(name, *) "Getting a Grid that was not set Test"
    call ESMF_Test((rc.ne.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------

    gridIn = ESMF_GridEmptyCreate(rc=rc)
    if (rc/=ESMF_SUCCESS) call ESMF_Finalize(endflag=ESMF_END_ABORT)
    
!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Set a Grid

    call ESMF_GridCompSet(comp1, grid=gridIn, rc=rc)

    write(failMsg, *) "Did return ESMF_SUCCESS"
    write(name, *) "Setting a Grid that was not set Test"
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Query gridIsPresent

    call ESMF_GridCompGet(comp1, gridIsPresent=isPresent, rc=rc)

    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Query gridIsPresent for Grid that was set Test"
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Verify gridIsPresent

    write(failMsg, *) "Did not verify"
    write(name, *) "Verify gridIsPresent for Grid that was not set Test"
    call ESMF_Test((isPresent), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Test get a Grid that was not set

    call ESMF_GridCompGet(comp1, grid=grid, rc=rc)

    write(failMsg, *) "Did return ESMF_SUCCESS"
    write(name, *) "Getting a Grid that was set Test"
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Verify grid

    write(failMsg, *) "Did not verify"
    write(name, *) "Verify Grid that was set Test"
    call ESMF_Test((grid==gridIn), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
    !EX_UTest
    write(name, *) "GridCompDestroy Test"
    write(failMsg, *) "Did not return ESMF_SUCCESS"
    call ESMF_GridCompDestroy(comp1, rc=rc)
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------

    call ESMF_GridDestroy(gridIn, rc=rc)
    if (rc/=ESMF_SUCCESS) call ESMF_Finalize(endflag=ESMF_END_ABORT)
    
!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Test creation of a Component
    cname = "Atmosphere"
    comp1 = ESMF_GridCompCreate(name=cname, configFile="grid.rc", rc=rc)  

    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Creating a Component Test"
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Test validate a component

    call ESMF_GridCompValidate(comp1, rc=rc)

    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Validating a Component Test"
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)
!-------------------------------------------------------------------------
!   !
    !EX_UTest
    ! Wait for a concurrent component to finish executing.

    call ESMF_GridCompWait(comp1, rc=rc)

    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Waiting for a Component Test"
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Test get a Component name

    call ESMF_GridCompGet(comp1, name=bname, rc=rc)

    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Getting a Component name Test"
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Verify the name is correct

    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Verifying the correct Component name was returned Test"
    call ESMF_Test((bname.eq.cname), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Test get a Grid that was not set

    call ESMF_GridCompGet(comp1, grid=grid, rc=rc)

    write(failMsg, *) "Did return ESMF_SUCCESS"
    write(name, *) "Getting a Grid that was not set Test"
    call ESMF_Test((rc.ne.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
!   !  Set Internal State
    !EX_UTest
    allocate(wrap1%p)
    wrap1%p%testnumber=4567

    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Set Internal State Test"
    call ESMF_GridCompSetInternalState(comp1, wrap1, rc)
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
!   !  Get Internal State
    !EX_UTest
    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Get Internal State Test"
    call ESMF_GridCompGetInternalState(comp1, wrap2, rc)
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
!   !  Verify Internal State
    !EX_UTest
    write(failMsg, *) "Did not return correct data"
    write(name, *) "Verify Internal State Test"
    call ESMF_Test((wrap2%p%testnumber.eq.4567), name, failMsg, result, ESMF_SRCLINE)
    print *, "wrap2%p%testnumber = ", wrap2%p%testnumber
    
!-------------------------------------------------------------------------
!   !
!   !  Set Internal State
    !EX_UTest
    allocate(wrap3%p)
    wrap3%p%testnumber=1234

    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Set Internal State 2nd time Test"
    call ESMF_GridCompSetInternalState(comp1, wrap3, rc)
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
!   !  Get Internal State
    !EX_UTest
    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Get Internal State 2nd time Test"
    call ESMF_GridCompGetInternalState(comp1, wrap4, rc)
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
!   !  Verify Internal State
    !EX_UTest
    write(failMsg, *) "Did not return correct data"
    write(name, *) "Verify Internal State 2nd time Test"
    call ESMF_Test((wrap4%p%testnumber.eq.1234), name, failMsg, result, ESMF_SRCLINE)
    print *, "wrap4%p%testnumber = ", wrap4%p%testnumber
    
!-------------------------------------------------------------------------
!   !  Set Internal State
    !EX_UTest
    allocate(wrap5%p)
    wrap3%p%testnumber=9182

    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Set Internal State 3rd time Test"
    call ESMF_GridCompSetInternalState(comp1, wrap5, rc)
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
!   !  Get Internal State
    !EX_UTest
    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Get Internal State 3rd time Test"
    call ESMF_GridCompGetInternalState(comp1, wrap6, rc)
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
!   !  Verify Internal State
    !EX_UTest
    write(failMsg, *) "Did not return correct data"
    write(name, *) "Verify Internal State 3rd time Test"
    call ESMF_Test((wrap4%p%testnumber.eq.9182), name, failMsg, result, ESMF_SRCLINE)
    print *, "wrap4%p%testnumber = ", wrap6%p%testnumber
    
    deallocate(wrap1%p)
    deallocate(wrap3%p)
    deallocate(wrap5%p)

!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Test printing a component

    call ESMF_GridCompPrint(comp1, rc=rc)

    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Printing a Component Test"
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

!-------------------------------------------------------------------------
!   !
    !EX_UTest
!   !  Destroying a component

    call ESMF_GridCompDestroy(comp1, rc=rc)

    write(failMsg, *) "Did not return ESMF_SUCCESS"
    write(name, *) "Destroying a Component Test"
    call ESMF_Test((rc.eq.ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE)

#endif

    call ESMF_TestEnd(result, ESMF_SRCLINE)

    end program ESMF_GridCompCreateUTest
    
