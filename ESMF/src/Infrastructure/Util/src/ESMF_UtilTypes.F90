! $Id: ESMF_UtilTypes.F90,v 1.1.5.1 2013-01-11 20:23:44 mathomp4 Exp $
!
! Earth System Modeling Framework
! Copyright 2002-2012, University Corporation for Atmospheric Research,
! Massachusetts Institute of Technology, Geophysical Fluid Dynamics
! Laboratory, University of Michigan, National Centers for Environmental
! Prediction, Los Alamos National Laboratory, Argonne National Laboratory,
! NASA Goddard Space Flight Center.
! Licensed under the University of Illinois-NCSA License.
!
#define ESMF_FILENAME "ESMF_UtilTypes.F90"

!
! ESMF UtilTypes Module
!
! (all lines between the !BOP and !EOP markers will be included in the
! automated document processing.)
!------------------------------------------------------------------------------
! one blank line for protex processing - in case all routines here are
! marked internal (BOPI/EOPI), the output file will still have contents.
!BOP

!EOP

!------------------------------------------------------------------------------
! module definition

      module ESMF_UtilTypesMod
 
#include "ESMF.h"

!BOPI
! !MODULE: ESMF_UtilTypesMod - General utility/generic derived types and parms
!
! !DESCRIPTION:
!
! Common derived types and parameters which are not specifically associated
! with any one class.  Generally this must be updated strictly in sync with
! the corresponding ESMC_Util.h include file and/or ESMC_Util.C source file.
!
! See the ESMF Developers Guide document for more details.
!
!------------------------------------------------------------------------------

! !USES:
      ! inherit from ESMF base class
!     use ESMF_UtilTypesMod
 !!  use ESMF_InitMacrosMod Commented out to prevent circular dependency
 !!                         this is possible because since all the checks
 !!                         in this module are shallow - Bob 1/9/2007.

      implicit none
!
! !PRIVATE TYPES:
      private

!------------------------------------------------------------------------------
!
!     ! WARNING: 
!     !  constants MUST match corresponding values in ../include/ESMC_Macros.h
!
!EOPI
!BOPI

!    !PUBLIC TYPES:
!    !Global integer parameters

      integer, parameter :: ESMF_SUCCESS = 0, ESMF_FAILURE = -1

! General non-specific string length
      integer, parameter :: ESMF_MAXSTR = 128

! Maximum length of a file name, including its path.
      integer, parameter :: ESMF_MAXPATHLEN = 1024

! TODO:FIELDINTEGRATION Adjust MAXGRIDDIM
      integer, parameter :: ESMF_MAXDIM = 7, &
                            ESMF_MAXIGRIDDIM = 3, &
                            ESMF_MAXGRIDDIM = 3
     
!EOPI

      integer, parameter :: ESMF_VERSION_MAJOR        = 5
      integer, parameter :: ESMF_VERSION_MINOR        = 2
      integer, parameter :: ESMF_VERSION_REVISION     = 0
      integer, parameter :: ESMF_VERSION_PATCHLEVEL   = 2
      logical, parameter :: ESMF_VERSION_PUBLIC       = .true.
      logical, parameter :: ESMF_VERSION_BETASNAPSHOT = .false.

      character(*), parameter :: ESMF_VERSION_STRING  = "5.2.0rp2"

!------------------------------------------------------------------------------
!
!    ! Keyword enforcement type

     type ESMF_KeywordEnforcer
       private
       integer:: quiet
     end type

!------------------------------------------------------------------------------
!
!    ! General object status, useful for any object

!     ! WARNING: 
!     !  constants MUST match corresponding values in ../include/ESMCI_Util.h

      type ESMF_Status
      sequence
      private
          integer :: status
      end type

      type(ESMF_Status), parameter :: ESMF_STATUS_UNINIT = ESMF_Status(1), &
                                      ESMF_STATUS_READY = ESMF_Status(2), &
                                      ESMF_STATUS_UNALLOCATED = ESMF_Status(3), &
                                      ESMF_STATUS_ALLOCATED = ESMF_Status(4), &
                                      ESMF_STATUS_BUSY = ESMF_Status(5), &
                                      ESMF_STATUS_INVALID = ESMF_Status(6), &
                                      ESMF_STATUS_NOT_READY = ESMF_Status(7)
 
!------------------------------------------------------------------------------
!
!    ! Generic pointer, large enough to hold a pointer on any architecture,
!    ! but not useful directly in fortran.  Expected to be used where a
!    ! pointer generated in C++ needs to be stored on the Fortran side.

!     ! WARNING: 
!     !  constants MUST match corresponding values in ../include/ESMC_Util.h

      type ESMF_Pointer
      sequence
      !private
#if (ESMC_POINTER_SIZE == 4)
          integer*4 :: ptr
#else
          integer*8 :: ptr
#endif
      end type

      type(ESMF_Pointer), parameter :: ESMF_NULL_POINTER = ESMF_Pointer(0), &
                                       ESMF_BAD_POINTER = ESMF_Pointer(-1)


!------------------------------------------------------------------------------
!
!    ! Where we can use a derived type, the compiler will help do 
!    ! typechecking.  For those places where the compiler refuses to allow
!    ! anything but an Integer data type, use the second set of constants.

!     ! WARNING: 
!     !  constants MUST match corresponding values in ../include/ESMC_Util.h

      type ESMF_TypeKind_Flag
      sequence
      ! TODO: can this be made private now?
      !!private
        integer :: dkind
      end type

      ! these work well for internal ESMF use, arguments, etc
#ifndef ESMF_NO_INTEGER_1_BYTE 
      type(ESMF_TypeKind_Flag), parameter :: &
                   ESMF_TYPEKIND_I1 = ESMF_TypeKind_Flag(1)
#endif
#ifndef ESMF_NO_INTEGER_2_BYTE 
      type(ESMF_TypeKind_Flag), parameter :: &
                   ESMF_TYPEKIND_I2 = ESMF_TypeKind_Flag(2)
#endif
      type(ESMF_TypeKind_Flag), parameter :: &
                   ESMF_TYPEKIND_I4 = ESMF_TypeKind_Flag(3), &
                   ESMF_TYPEKIND_I8 = ESMF_TypeKind_Flag(4), &
                   ESMF_TYPEKIND_R4 = ESMF_TypeKind_Flag(5), &
                   ESMF_TYPEKIND_R8 = ESMF_TypeKind_Flag(6), &
                   ESMF_TYPEKIND_C8 = ESMF_TypeKind_Flag(7), &
                   ESMF_TYPEKIND_C16 = ESMF_TypeKind_Flag(8), &
                   ESMF_TYPEKIND_LOGICAL = ESMF_TypeKind_Flag(9), &
                   ESMF_TYPEKIND_CHARACTER = ESMF_TypeKind_Flag(10), &
                   ESMF_TYPEKIND_I  = ESMF_TypeKind_Flag(90), &
                   ESMF_TYPEKIND_R  = ESMF_TypeKind_Flag(91), &
                   ESMF_NOKIND = ESMF_TypeKind_Flag(99)

      ! these are the only Fortran kind parameters supported
      ! by ESMF.

#ifndef ESMF_NO_INTEGER_1_BYTE 
      integer, parameter :: &
                   ESMF_KIND_I1 = selected_int_kind(2)
#endif
#ifndef ESMF_NO_INTEGER_2_BYTE 
      integer, parameter :: &
                   ESMF_KIND_I2 = selected_int_kind(4)
#endif
      integer, parameter :: &
                   ESMF_KIND_I4 = selected_int_kind(9)
#ifndef ESMF_NEC_KIND_I8
      integer, parameter :: &
                   ESMF_KIND_I8 = selected_int_kind(18)
#else
      integer, parameter :: &
                   ESMF_KIND_I8 = selected_int_kind(15)
#endif
      integer, parameter :: &
                   ESMF_KIND_R4 = selected_real_kind(3,25), &
                   ESMF_KIND_R8 = selected_real_kind(6,45), &
                   ESMF_KIND_C8 = selected_real_kind(3,25), &
                   ESMF_KIND_C16 = selected_real_kind(6,45)

      integer :: defaultIntegerDummy    ! Needed to define ESMF_KIND_I
      real    :: defaultRealDummy       ! Needed to define ESMF_KIND_R
      integer, parameter :: &
                   ESMF_KIND_I = kind(defaultIntegerDummy), &
                   ESMF_KIND_R = kind(defaultRealDummy)

!------------------------------------------------------------------------------
!
!    ! Dummy structure which must just be big enough to hold the values.
!    ! actual data values will always be accessed on the C++ side.

      type ESMF_DataValue
      sequence
      private
          integer :: pad
      end type

!------------------------------------------------------------------------------
!     ! ESMF_MapPtr - used to provide Fortran access to C++ STL map containers
!     ! for associative lookup name-pointer pairs.

      type ESMF_MapPtr
        sequence
        !private
        type(ESMF_Pointer) :: this
        ! only used internally -> no init macro!
      end type


!------------------------------------------------------------------------------
!
!    ! Integer object type id, one for each ESMF Object type 
!    ! plus a string "official" object name.   Keep this in sync
!    ! with the C++ version!!

      type ESMF_ObjectID
      sequence
      !private
          integer :: objectID
          character (len=32) :: objectName
#if 0 
          ESMF_INIT_DECLARE
#endif
      end type

      ! Note:  any changes made to this Fortran list must also be made to
      !        the corresponding C++ list in ESMCI_Util.C

      ! Caution:  The NAG compiler v5.2 error-exits if there are blank lines in
      !           this list.

      ! these work well for internal ESMF use, arguments, etc
      type(ESMF_ObjectID), parameter :: &
        ESMF_ID_BASE           = ESMF_ObjectID(1,  "ESMF_Base"), &
        ESMF_ID_LOGERR         = ESMF_ObjectID(2,  "ESMF_LogErr"), &
        ESMF_ID_TIME           = ESMF_ObjectID(3,  "ESMF_Time"), &
        ESMF_ID_CALENDAR       = ESMF_ObjectID(4,  "ESMF_Calendar"), &
        ESMF_ID_TIMEINTERVAL   = ESMF_ObjectID(5,  "ESMF_TimeInterval"), &
        ESMF_ID_ALARM          = ESMF_ObjectID(6,  "ESMF_Alarm"), &
        ESMF_ID_CLOCK          = ESMF_ObjectID(7,  "ESMF_Clock"), &
        ESMF_ID_ARRAYSPEC      = ESMF_ObjectID(8,  "ESMF_ArraySpec"), &
        ESMF_ID_LOCALARRAY     = ESMF_ObjectID(9,  "ESMF_LocalArray"), &
        ESMF_ID_ARRAYBUNDLE    = ESMF_ObjectID(10, "ESMF_ArrayBundle"), &
        ESMF_ID_VM             = ESMF_ObjectID(11, "ESMF_VM"), &
        ESMF_ID_DELAYOUT       = ESMF_ObjectID(12, "ESMF_DELayout"), &
        ESMF_ID_CONFIG         = ESMF_ObjectID(13, "ESMF_Config"), &
        ESMF_ID_ARRAY          = ESMF_ObjectID(14, "ESMF_Array"), &
        ESMF_ID_PHYSGRID       = ESMF_ObjectID(15, "ESMF_PhysGrid"), &
        ESMF_ID_IGRID          = ESMF_ObjectID(16, "ESMF_IGrid"), &
        ESMF_ID_EXCHANGEPACKET = ESMF_ObjectID(17, "ESMF_ExchangePacket"), &
        ESMF_ID_COMMTABLE      = ESMF_ObjectID(18, "ESMF_CommTable"), &
        ESMF_ID_ROUTETABLE     = ESMF_ObjectID(19, "ESMF_RouteTable"), &
        ESMF_ID_ROUTE          = ESMF_ObjectID(20, "ESMF_Route"), &
        ESMF_ID_ROUTEHANDLE    = ESMF_ObjectID(21, "ESMF_RouteHandle"), &
        ESMF_ID_FIELDDATAMAP   = ESMF_ObjectID(22, "ESMF_FieldDataMap"), &
        ESMF_ID_FIELD          = ESMF_ObjectID(23, "ESMF_Field"), &
        ESMF_ID_BUNDLEDATAMAP  = ESMF_ObjectID(24, "ESMF_FieldBundleDataMap"), &
        ESMF_ID_FIELDBUNDLE    = ESMF_ObjectID(25, "ESMF_FieldBundle"), &
        ESMF_ID_GEOMBASE       = ESMF_ObjectID(26, "ESMF_GeomBase"), &
        ESMF_ID_REGRID         = ESMF_ObjectID(27, "ESMF_Regrid"), &
        ESMF_ID_LOCSTREAM      = ESMF_ObjectID(28, "ESMF_Locstream"), &
        ESMF_ID_STATE          = ESMF_ObjectID(29, "ESMF_State"), &
        ESMF_ID_GRIDCOMPONENT  = ESMF_ObjectID(30, "ESMF_GridComponent"), &
        ESMF_ID_CPLCOMPONENT   = ESMF_ObjectID(31, "ESMF_CplComponent"), &
        ESMF_ID_COMPONENT      = ESMF_ObjectID(32, "ESMF_Component"), &
        ESMF_ID_XGRID          = ESMF_ObjectID(33, "ESMF_XGrid"), &
        ESMF_ID_NONE           = ESMF_ObjectID(99, "ESMF_None")

!------------------------------------------------------------------------------
!------------------------------------------------------------------------------
!
!     ! Typed true/false values which are not compiler dependent, so that
!     ! when crossing the Fortran/C++ language boundary with logical values we
!     ! have a consistent interpretation.  In C/C++ 0=false, 1=true, but this
!     ! is not defined for Fortran and different compilers use different values
!     ! for booleans.

!     ! WARNING: must match corresponding values in ../include/ESMC_Util.h

      type ESMF_Logical
      sequence
      private
          integer :: value
      end type

      type(ESMF_Logical), parameter :: ESMF_TRUE     = ESMF_Logical(1), &
                                       ESMF_FALSE    = ESMF_Logical(2)

!------------------------------------------------------------------------------
!
!     ! Typed inquire-only flag

!     ! WARNING: must match corresponding values in ../include/ESMC_Util.h

      type ESMF_InquireFlag
      sequence
      private
          type(ESMF_Logical) :: flag
      end type

      type(ESMF_InquireFlag), parameter :: ESMF_INQUIREONLY = ESMF_InquireFlag(ESMF_TRUE), &
                                           ESMF_NOINQUIRE   = ESMF_InquireFlag(ESMF_FALSE)

!------------------------------------------------------------------------------
!
!     ! Typed reduction operations

!     ! WARNING: must match corresponding values in ../include/ESMC_Util.h

      type ESMF_Reduce_Flag
      sequence
      private
          integer :: value
      end type

      type(ESMF_Reduce_Flag), parameter ::  ESMF_REDUCE_SUM   = ESMF_Reduce_Flag(1), &
                                          ESMF_REDUCE_MIN  = ESMF_Reduce_Flag(2), &
                                          ESMF_REDUCE_MAX  = ESMF_Reduce_Flag(3)
                                     
!------------------------------------------------------------------------------
!
!     ! Typed blocking/non-blocking flag

      type ESMF_Sync_Flag
      sequence
      private
          integer :: value
      end type

      type(ESMF_Sync_Flag), parameter:: &
        ESMF_SYNC_BLOCKING     = ESMF_Sync_Flag(1), &
        ESMF_SYNC_VASBLOCKING  = ESMF_Sync_Flag(2), &
        ESMF_SYNC_NONBLOCKING  = ESMF_Sync_Flag(3)

!------------------------------------------------------------------------------
!
!     ! Typed context flag

      type ESMF_Context_Flag
      sequence
      private
          integer :: value
      end type

      type(ESMF_Context_Flag), parameter:: &
        ESMF_CONTEXT_OWN_VM     = ESMF_Context_Flag(1), &
        ESMF_CONTEXT_PARENT_VM  = ESMF_Context_Flag(2)

!------------------------------------------------------------------------------
!
!     ! Typed termination flag

      type ESMF_End_Flag
      sequence
      private
          integer :: value
      end type

      type(ESMF_End_Flag), parameter:: &
        ESMF_END_NORMAL        = ESMF_End_Flag(1), &
        ESMF_END_KEEPMPI      = ESMF_End_Flag(2), &
        ESMF_END_ABORT        = ESMF_End_Flag(3)

!------------------------------------------------------------------------------
!
!     ! Typed DE pinning flag

      type ESMF_Pin_Flag
      sequence
      private
          integer :: value
      end type

      type(ESMF_Pin_Flag), parameter:: &
        ESMF_PIN_DE_TO_PET        = ESMF_Pin_Flag(1), &
        ESMF_PIN_DE_TO_VAS        = ESMF_Pin_Flag(2)

!------------------------------------------------------------------------------
!
!     ! Direction type

      type ESMF_Direction_Flag
      sequence
      private
          integer :: value
      end type

      type(ESMF_Direction_Flag), parameter:: &
        ESMF_DIRECTION_FORWARD = ESMF_Direction_Flag(1), &
        ESMF_DIRECTION_REVERSE = ESMF_Direction_Flag(2)

!------------------------------------------------------------------------------
!
!     ! PIO Format type

      type ESMF_IOFmtFlag
      sequence
      private
          integer :: io_type
      end type

      type(ESMF_IOFmtFlag), parameter ::  &
                           ESMF_IOFMT_BIN      = esmf_IOFmtFlag(0), &
                           ESMF_IOFMT_NETCDF   = ESMF_IOFmtFlag(1), &
                           ESMF_IOFMT_NETCDF4P = ESMF_IOFmtFlag(2), &
                           ESMF_IOFMT_NETCDF4C = ESMF_IOFmtFlag(3)

!------------------------------------------------------------------------------
!     ! ESMF_Index_Flag
!
!     ! Interface flag for setting index bounds

      type ESMF_Index_Flag
      sequence
      private
        integer :: i_type
      end type

      type(ESMF_Index_Flag), parameter ::  &
                               ESMF_INDEX_DELOCAL  = ESMF_Index_Flag(0), &
                               ESMF_INDEX_GLOBAL = ESMF_Index_Flag(1), &
                               ESMF_INDEX_USER = ESMF_Index_Flag(2)

!------------------------------------------------------------------------------
!     ! ESMF_StartRegion_Flag
!
!     ! Interface flag for setting index bounds

      type ESMF_StartRegion_Flag
      sequence
      private
        integer :: i_type
      end type

      type(ESMF_StartRegion_Flag), parameter ::  &
        ESMF_STARTREGION_EXCLUSIVE = ESMF_StartRegion_Flag(0), &
        ESMF_STARTREGION_COMPUTATIONAL = ESMF_StartRegion_Flag(1)

!------------------------------------------------------------------------------
!     ! ESMF_Region_Flag
!
!     ! Interface flag for setting index bounds

      type ESMF_Region_Flag
      sequence
      private
        integer :: i_type
      end type

      type(ESMF_Region_Flag), parameter ::  &
        ESMF_REGION_TOTAL = ESMF_Region_Flag(0), &
        ESMF_REGION_SELECT = ESMF_Region_Flag(1), &
        ESMF_REGION_EMPTY = ESMF_Region_Flag(2)

!------------------------------------------------------------------------------
!     ! ESMF_RouteSync_Flag
!
!     ! Interface flag for setting communication options

      type ESMF_RouteSync_Flag
      sequence
      private
        integer :: i_type
      end type

      type(ESMF_RouteSync_Flag), parameter ::  &
        ESMF_ROUTESYNC_BLOCKING        = ESMF_RouteSync_Flag(0), &
        ESMF_ROUTESYNC_NBSTART         = ESMF_RouteSync_Flag(1), &
        ESMF_ROUTESYNC_NBTESTFINISH    = ESMF_RouteSync_Flag(2), &
        ESMF_ROUTESYNC_NBWAITFINISH    = ESMF_RouteSync_Flag(3), &
        ESMF_ROUTESYNC_CANCEL          = ESMF_RouteSync_Flag(4)

!------------------------------------------------------------------------------
!     ! ESMF_AttWriteFlag
!
!     ! Interface flag for Attribute write methods

      type ESMF_AttWriteFlag
      sequence
      !private
        integer :: value
      end type

      type(ESMF_AttWriteFlag), parameter ::  &
        ESMF_ATTWRITE_TAB = ESMF_AttWriteFlag(0), &
        ESMF_ATTWRITE_XML = ESMF_AttWriteFlag(1)

!------------------------------------------------------------------------------
!     ! ESMF_AttReconcileFlag
!
!     ! Interface flag for Attribute reconcile

      type ESMF_AttReconcileFlag
      sequence
      !private
        integer :: value
      end type

      type(ESMF_AttReconcileFlag), parameter ::  &
        ESMF_ATTRECONCILE_OFF = ESMF_AttReconcileFlag(0), &
        ESMF_ATTRECONCILE_ON = ESMF_AttReconcileFlag(1)

!------------------------------------------------------------------------------
!     ! ESMF_Copy_Flag
!
!     ! Interface flag for Attribute copy

      type ESMF_Copy_Flag
      sequence
      !private
        integer :: value
      end type

      type(ESMF_Copy_Flag), parameter ::  &
        ESMF_COPY_ALIAS = ESMF_Copy_Flag(0), &
        ESMF_COPY_REFERENCE = ESMF_Copy_Flag(1), &
        ESMF_COPY_VALUE = ESMF_Copy_Flag(2)

!------------------------------------------------------------------------------
!     ! ESMF_AttGetCountFlag
!
!     ! Interface flag for Attribute copy

      type ESMF_AttGetCountFlag
      sequence
      !private
        integer :: value
      end type

      type(ESMF_AttGetCountFlag), parameter ::  &
        ESMF_ATTGETCOUNT_ATTRIBUTE = ESMF_AttGetCountFlag(0), &
        ESMF_ATTGETCOUNT_ATTPACK = ESMF_AttGetCountFlag(1), &
        ESMF_ATTGETCOUNT_ATTLINK = ESMF_AttGetCountFlag(2), &
        ESMF_ATTGETCOUNT_TOTAL = ESMF_AttGetCountFlag(3)

!------------------------------------------------------------------------------
!     ! ESMF_AttTreeFlag
!
!     ! Interface flag for Attribute tree

      type ESMF_AttTreeFlag
      sequence
      !private
        integer :: value
      end type

      type(ESMF_AttTreeFlag), parameter ::  &
        ESMF_ATTTREE_OFF = ESMF_AttTreeFlag(0), &
        ESMF_ATTTREE_ON = ESMF_AttTreeFlag(1)


!------------------------------------------------------------------------------
!
!
      ! What to do when a point can't be mapped
      type ESMF_UnmappedAction_Flag
      sequence
!  private
         integer :: unmappedaction
      end type

      type(ESMF_UnmappedAction_Flag), parameter :: &
           ESMF_UNMAPPEDACTION_ERROR    = ESMF_UnmappedAction_Flag(0), &
           ESMF_UNMAPPEDACTION_IGNORE   = ESMF_UnmappedAction_Flag(1)

!------------------------------------------------------------------------------
      type ESMF_RegridMethod_Flag
      sequence
!  private
         integer :: regridmethod
      end type


      type(ESMF_RegridMethod_Flag), parameter :: &
           ESMF_REGRIDMETHOD_BILINEAR    = ESMF_RegridMethod_Flag(0), &
           ESMF_REGRIDMETHOD_PATCH       = ESMF_RegridMethod_Flag(1), &
           ESMF_REGRIDMETHOD_CONSERVE    = ESMF_RegridMethod_Flag(2)

!------------------------------------------------------------------------------

      type ESMF_PoleMethod_Flag
      sequence
!  private
         integer :: polemethod
      end type


      type(ESMF_PoleMethod_Flag), parameter :: &
           ESMF_POLEMETHOD_NONE    =  ESMF_PoleMethod_Flag(0), &
           ESMF_POLEMETHOD_ALLAVG  =  ESMF_PoleMethod_Flag(1), &
           ESMF_POLEMETHOD_NPNTAVG =  ESMF_PoleMethod_Flag(2), &
           ESMF_POLEMETHOD_TEETH   =  ESMF_PoleMethod_Flag(3)

!------------------------------------------------------------------------------
!
!
      type ESMF_RegridConserve
      sequence
!  private
         integer :: regridconserve
      end type


      type(ESMF_RegridConserve), parameter :: &
           ESMF_REGRID_CONSERVE_OFF     = ESMF_RegridConserve(0), &
           ESMF_REGRID_CONSERVE_ON      = ESMF_RegridConserve(1)


!------------------------------------------------------------------------------
!
!
      integer, parameter :: ESMF_REGRID_SCHEME_FULL3D = 0, &
                            ESMF_REGRID_SCHEME_NATIVE = 1, &
                            ESMF_REGRID_SCHEME_REGION3D = 2, &
                            ESMF_REGRID_SCHEME_FULLTOREG3D=3, &
                            ESMF_REGRID_SCHEME_REGTOFULL3D=4, &
                            ESMF_REGRID_SCHEME_DCON3D=5, &
                            ESMF_REGRID_SCHEME_DCON3DWPOLE=6


!------------------------------------------------------------------------------
!BOPI
!
! !PUBLIC TYPES:

      public ESMF_STATUS_UNINIT, ESMF_STATUS_READY, &
             ESMF_STATUS_UNALLOCATED, ESMF_STATUS_ALLOCATED, &
             ESMF_STATUS_BUSY, ESMF_STATUS_INVALID

#ifndef ESMF_NO_INTEGER_1_BYTE 
      public ESMF_TYPEKIND_I1
#endif
#ifndef ESMF_NO_INTEGER_2_BYTE 
      public ESMF_TYPEKIND_I2
#endif

      public ESMF_TYPEKIND_I4, ESMF_TYPEKIND_I8, & 
             ESMF_TYPEKIND_R4, ESMF_TYPEKIND_R8, &
             ESMF_TYPEKIND_C8, ESMF_TYPEKIND_C16, &
             ESMF_TYPEKIND_LOGICAL, ESMF_TYPEKIND_CHARACTER, &
             ESMF_KIND_I, ESMF_KIND_R, &
             ESMF_NOKIND

#ifndef ESMF_NO_INTEGER_1_BYTE 
      public ESMF_KIND_I1
#endif
#ifndef ESMF_NO_INTEGER_2_BYTE 
      public ESMF_KIND_I2
#endif
      public ESMF_KIND_I4, ESMF_KIND_I8, & 
             ESMF_KIND_R4, ESMF_KIND_R8, ESMF_KIND_C8, ESMF_KIND_C16

      public ESMF_NULL_POINTER, ESMF_BAD_POINTER

      public ESMF_Logical, ESMF_TRUE, ESMF_FALSE

      public ESMF_InquireFlag
      public ESMF_INQUIREONLY, ESMF_NOINQUIRE

      public ESMF_Direction_Flag, ESMF_DIRECTION_FORWARD, ESMF_DIRECTION_REVERSE

      public ESMF_IOFmtFlag, ESMF_IOFMT_BIN, ESMF_IOFMT_NETCDF, &
             ESMF_IOFMT_NETCDF4P, ESMF_IOFMT_NETCDF4C

      public ESMF_Index_Flag
      public ESMF_INDEX_DELOCAL, ESMF_INDEX_GLOBAL, ESMF_INDEX_USER
      public ESMF_StartRegion_Flag, &
             ESMF_STARTREGION_EXCLUSIVE, ESMF_STARTREGION_COMPUTATIONAL
      public ESMF_Region_Flag, &
             ESMF_REGION_TOTAL, ESMF_REGION_SELECT, ESMF_REGION_EMPTY
      public ESMF_RouteSync_Flag, &
             ESMF_ROUTESYNC_BLOCKING, ESMF_ROUTESYNC_NBSTART, &
             ESMF_ROUTESYNC_NBTESTFINISH, ESMF_ROUTESYNC_NBWAITFINISH, ESMF_ROUTESYNC_CANCEL

      public ESMF_Reduce_Flag, ESMF_REDUCE_SUM, ESMF_REDUCE_MIN, ESMF_REDUCE_MAX
      public ESMF_Sync_Flag, ESMF_SYNC_BLOCKING, ESMF_SYNC_VASBLOCKING, &
             ESMF_SYNC_NONBLOCKING
      public ESMF_Context_Flag, ESMF_CONTEXT_OWN_VM, ESMF_CONTEXT_PARENT_VM
      public ESMF_End_Flag, ESMF_END_NORMAL, ESMF_END_KEEPMPI, ESMF_END_ABORT
      public ESMF_Pin_Flag, ESMF_PIN_DE_TO_PET, ESMF_PIN_DE_TO_VAS
      public ESMF_Copy_Flag, ESMF_COPY_ALIAS, ESMF_COPY_REFERENCE, &
                               ESMF_COPY_VALUE
      public ESMF_AttGetCountFlag, ESMF_ATTGETCOUNT_ATTRIBUTE, ESMF_ATTGETCOUNT_ATTPACK, &
                                   ESMF_ATTGETCOUNT_ATTLINK, ESMF_ATTGETCOUNT_TOTAL
      public ESMF_AttReconcileFlag, ESMF_ATTRECONCILE_OFF, ESMF_ATTRECONCILE_ON
      public ESMF_AttTreeFlag, ESMF_ATTTREE_OFF, ESMF_ATTTREE_ON
      public ESMF_AttWriteFlag, ESMF_ATTWRITE_TAB, ESMF_ATTWRITE_XML

       public ESMF_RegridMethod_Flag,   ESMF_REGRIDMETHOD_BILINEAR, &
                                   ESMF_REGRIDMETHOD_PATCH, &
                                   ESMF_REGRIDMETHOD_CONSERVE

       public ESMF_PoleMethod_Flag,  ESMF_POLEMETHOD_NONE, &
                                ESMF_POLEMETHOD_ALLAVG, &
                                ESMF_POLEMETHOD_NPNTAVG, &
                                ESMF_POLEMETHOD_TEETH

       public ESMF_RegridConserve, ESMF_REGRID_CONSERVE_OFF, &
                                   ESMF_REGRID_CONSERVE_ON

       public ESMF_REGRID_SCHEME_FULL3D, &
              ESMF_REGRID_SCHEME_NATIVE, &
              ESMF_REGRID_SCHEME_REGION3D, &
              ESMF_REGRID_SCHEME_FULLTOREG3D, &
              ESMF_REGRID_SCHEME_REGTOFULL3D, &
              ESMF_REGRID_SCHEME_DCON3D, &
              ESMF_REGRID_SCHEME_DCON3DWPOLE

      public ESMF_FAILURE, ESMF_SUCCESS
      public ESMF_MAXSTR
      public ESMF_MAXPATHLEN
! TODO:FIELDINTEGRATION Adjust MAXGRIDDIM
      public ESMF_MAXDIM, ESMF_MAXIGRIDDIM, ESMF_MAXGRIDDIM
     
      public ESMF_VERSION_MAJOR, ESMF_VERSION_MINOR
      public ESMF_VERSION_REVISION, ESMF_VERSION_PATCHLEVEL
      public ESMF_VERSION_PUBLIC, ESMF_VERSION_BETASNAPSHOT
      public ESMF_VERSION_STRING 

      public ESMF_ObjectID

#if 0 
      public ESMF_ObjectIDGetInit, ESMF_ObjectIDInit, ESMF_ObjectIDValidate
#endif
      public ESMF_ID_NONE
      public ESMF_ID_BASE, ESMF_ID_LOGERR, ESMF_ID_TIME
      public ESMF_ID_CALENDAR, ESMF_ID_TIMEINTERVAL, ESMF_ID_ALARM
      public ESMF_ID_CLOCK, ESMF_ID_ARRAYSPEC, ESMF_ID_LOCALARRAY
      public ESMF_ID_ARRAYBUNDLE, ESMF_ID_VM, ESMF_ID_DELAYOUT
      public ESMF_ID_CONFIG, ESMF_ID_ARRAY
      public ESMF_ID_COMMTABLE, ESMF_ID_ROUTETABLE, ESMF_ID_ROUTE
      public ESMF_ID_ROUTEHANDLE, ESMF_ID_FIELDDATAMAP, ESMF_ID_FIELD
      public ESMF_ID_FIELDBUNDLE, ESMF_ID_GEOMBASE, ESMF_ID_XGRID
      public ESMF_ID_REGRID, ESMF_ID_LOCSTREAM, ESMF_ID_STATE
      public ESMF_ID_GRIDCOMPONENT, ESMF_ID_CPLCOMPONENT, ESMF_ID_COMPONENT

      public ESMF_KeywordEnforcer

      public ESMF_Status, ESMF_Pointer, ESMF_TypeKind_Flag
      public ESMF_DataValue

      public ESMF_MapPtr

      public ESMF_PointerPrint

       public ESMF_UnmappedAction_Flag, ESMF_UNMAPPEDACTION_ERROR, &
                                   ESMF_UNMAPPEDACTION_IGNORE

      
!  Overloaded = operator functions
      public operator(==), operator(/=), assignment(=)
!

!------------------------------------------------------------------------------

! overload == & /= with additional derived types so you can compare 
!  them as if they were simple integers.
 

interface operator (==)
  module procedure ESMF_sfeq
  module procedure ESMF_dkeq
  module procedure ESMF_pteq
  module procedure ESMF_tfeq
  module procedure ESMF_bfeq
  module procedure ESMF_ctfeq
  module procedure ESMF_tnfeq
  module procedure ESMF_freq
  module procedure ESMF_ifeq
  module procedure ESMF_rfeq
  module procedure ESMF_unmappedactioneq
  module procedure ESMF_ioeq
  module procedure ESMF_RegridPoleEq
end interface

interface operator (/=)
  module procedure ESMF_sfne
  module procedure ESMF_dkne
  module procedure ESMF_ptne
  module procedure ESMF_tfne
  module procedure ESMF_bfne
  module procedure ESMF_ctfne
  module procedure ESMF_tnfne
  module procedure ESMF_frne
  module procedure ESMF_unmappedactionne
  module procedure ESMF_RegridPoleNe
end interface

interface assignment (=)
  module procedure ESMF_bfas
  module procedure ESMF_dkas
  module procedure ESMF_tfas
  module procedure ESMF_tfas_v
  module procedure ESMF_tfas2
  module procedure ESMF_tfas2_v
  module procedure ESMF_ptas
  module procedure ESMF_ptas2
  module procedure ESMF_ioas
end interface  


!------------------------------------------------------------------------------
! ! ESMF_MethodTable

  type ESMF_MethodTable
    sequence
    !private
    type(ESMF_Pointer) :: this
    ! only use internally -> no init macro!
  end type
     
  public ESMF_MethodTable


!------------------------------------------------------------------------------

      contains

#if 0 
!------------------------------------------------------------------------------
#undef  ESMF_METHOD
#define ESMF_METHOD "ESMF_ObjectIDGetInit"
!BOPI
! !IROUTINE:  ESMF_ObjectIDGetInit - Get initialization status.

! !INTERFACE:
    function ESMF_ObjectIDGetInit(s)
!
! !ARGUMENTS:
       type(ESMF_ObjectID), intent(in), optional :: s
       ESMF_INIT_TYPE :: ESMF_ObjectIDGetInit
!
! !DESCRIPTION:
!      Get the initialization status of the shallow class {\tt domain}.
!
!     The arguments are:
!     \begin{description}
!     \item [s]
!           {\tt ESMF\_ObjectID} from which to retreive status.
!     \end{description}
!
!EOPI

       if (present(s)) then
         ESMF_ObjectIDGetInit = ESMF_INIT_GET(s)
       else
         ESMF_ObjectIDGetInit = ESMF_INIT_DEFINED
       endif

    end function ESMF_ObjectIDGetInit

!------------------------------------------------------------------------------
#undef  ESMF_METHOD
#define ESMF_METHOD "ESMF_ObjectIDInit"
!BOPI
! !IROUTINE:  ESMF_ObjectIDInit - Initialize ObjectID

! !INTERFACE:
    subroutine ESMF_ObjectIDInit(s)
!
! !ARGUMENTS:
       type(ESMF_ObjectID) :: s
!
! !DESCRIPTION:
!      Initialize the shallow class {\tt ObjectID}.
!
!     The arguments are:
!     \begin{description}
!     \item [s]
!           {\tt ESMF\_ObjectID} of which being initialized.
!     \end{description}
!
!EOPI
       ESMF_INIT_SET_DEFINED(s)
    end subroutine ESMF_ObjectIDInit

!------------------------------------------------------------------------------
#undef  ESMF_METHOD
#define ESMF_METHOD "ESMF_ObjectIDValidate"
!BOPI
! !IROUTINE:  ESMF_ObjectIDValidate - Check validity of a ObjectID 

! !INTERFACE:
    subroutine ESMF_ObjectIDValidate(s,rc)
!
! !ARGUMENTS:
       type(ESMF_ObjectID), intent(inout) :: s
       integer, intent(out), optional :: rc
!
! !DESCRIPTION:
!      Validates that the {\tt ObjectID} is internally consistent.
!
!     The arguments are:
!     \begin{description}
!     \item [s]
!           {\tt ESMF\_ObjectID} to validate.
!     \item [{[rc]}]
!           Return code; equals {\tt ESMF\_SUCCESS} if the {\tt ObjectID}
!           is valid.
!     \end{description}
!
!EOPI

    ! Initialize return code; assume routine not implemented
    if (present(rc)) rc = ESMF_RC_NOT_IMPL

     ESMF_INIT_CHECK_SET_SHALLOW(ESMF_ObjectIDGetInit,ESMF_ObjectIDInit,s)

     ! return success
     if(present(rc)) then
       rc = ESMF_SUCCESS
     endif
    end subroutine ESMF_ObjectIDValidate

#endif

!------------------------------------------------------------------------------
! function to compare two ESMF_Status flags to see if they're the same or not

function ESMF_sfeq(sf1, sf2)
 logical ESMF_sfeq
 type(ESMF_Status), intent(in) :: sf1, sf2

 ESMF_sfeq = (sf1%status == sf2%status)
end function

function ESMF_sfne(sf1, sf2)
 logical ESMF_sfne
 type(ESMF_Status), intent(in) :: sf1, sf2

 ESMF_sfne = (sf1%status /= sf2%status)
end function

!------------------------------------------------------------------------------
! function to compare two ESMF_TypeKinds to see if they're the same or not

function ESMF_dkeq(dk1, dk2)
 logical ESMF_dkeq
 type(ESMF_TypeKind_Flag), intent(in) :: dk1, dk2

 ESMF_dkeq = (dk1%dkind == dk2%dkind)
end function

function ESMF_dkne(dk1, dk2)
 logical ESMF_dkne
 type(ESMF_TypeKind_Flag), intent(in) :: dk1, dk2

 ESMF_dkne = (dk1%dkind /= dk2%dkind)
end function

subroutine ESMF_dkas(intval, dkval)
 integer, intent(out) :: intval
 type(ESMF_TypeKind_Flag), intent(in) :: dkval

 intval = dkval%dkind
end subroutine


!------------------------------------------------------------------------------
! function to compare two ESMF_Sync_Flags

subroutine ESMF_bfas(bf1, bf2)
 type(ESMF_Sync_Flag), intent(out) :: bf1
 type(ESMF_Sync_Flag), intent(in)  :: bf2

 bf1%value = bf2%value
end subroutine

function ESMF_bfeq(bf1, bf2)
 logical ESMF_bfeq
 type(ESMF_Sync_Flag), intent(in) :: bf1, bf2

 ESMF_bfeq = (bf1%value == bf2%value)
end function

function ESMF_bfne(bf1, bf2)
 logical ESMF_bfne
 type(ESMF_Sync_Flag), intent(in) :: bf1, bf2

 ESMF_bfne = (bf1%value /= bf2%value)
end function

!------------------------------------------------------------------------------
! function to compare two ESMF_Context_Flags

function ESMF_ctfeq(ctf1, ctf2)
 logical ESMF_ctfeq
 type(ESMF_Context_Flag), intent(in) :: ctf1, ctf2

 ESMF_ctfeq = (ctf1%value == ctf2%value)
end function

function ESMF_ctfne(ctf1, ctf2)
 logical ESMF_ctfne
 type(ESMF_Context_Flag), intent(in) :: ctf1, ctf2

 ESMF_ctfne = (ctf1%value /= ctf2%value)
end function

!------------------------------------------------------------------------------
! function to compare two ESMF_End_Flags

function ESMF_tnfeq(tnf1, tnf2)
 logical ESMF_tnfeq
 type(ESMF_End_Flag), intent(in) :: tnf1, tnf2

 ESMF_tnfeq = (tnf1%value == tnf2%value)
end function

function ESMF_tnfne(tnf1, tnf2)
 logical ESMF_tnfne
 type(ESMF_End_Flag), intent(in) :: tnf1, tnf2

 ESMF_tnfne = (tnf1%value /= tnf2%value)
end function

!------------------------------------------------------------------------------
! function to compare two ESMF_Pointers to see if they're the same or not

function ESMF_pteq(pt1, pt2)
 logical ESMF_pteq
 type(ESMF_Pointer), intent(in) :: pt1, pt2

 ESMF_pteq = (pt1%ptr == pt2%ptr)
end function

function ESMF_ptne(pt1, pt2)
 logical ESMF_ptne
 type(ESMF_Pointer), intent(in) :: pt1, pt2

 ESMF_ptne = (pt1%ptr /= pt2%ptr)
end function

subroutine ESMF_ptas(ptval, intval)
 type(ESMF_Pointer), intent(out) :: ptval
 integer, intent(in) :: intval

 ptval%ptr = intval
end subroutine

subroutine ESMF_ptas2(ptval2, ptval)
 type(ESMF_Pointer), intent(out) :: ptval2
 type(ESMF_Pointer), intent(in) :: ptval

 ptval2%ptr = ptval%ptr
end subroutine

!------------------------------------------------------------------------------
! function to compare two ESMF_Logicals to see if they're the same or not
! also assignment to real f90 logical 

function ESMF_tfeq(tf1, tf2)
 logical ESMF_tfeq
 type(ESMF_Logical), intent(in) :: tf1, tf2

 ESMF_tfeq = (tf1%value == tf2%value)
end function

function ESMF_tfne(tf1, tf2)
 logical ESMF_tfne
 type(ESMF_Logical), intent(in) :: tf1, tf2

 ESMF_tfne = (tf1%value /= tf2%value)
end function

subroutine ESMF_tfas(lval, tfval)
 logical, intent(out) :: lval
 type(ESMF_Logical), intent(in) :: tfval

 lval = (tfval%value == 1)    ! this must match initializer
end subroutine

subroutine ESMF_tfas_v(lval, tfval)
 logical, intent(out) :: lval(:)
 type(ESMF_Logical), intent(in) :: tfval(:)

 lval = (tfval%value == 1)    ! this must match initializer
end subroutine

subroutine ESMF_tfas2 (tfval, lval)
 type(ESMF_Logical), intent(out) :: tfval
 logical, intent(in) :: lval

 tfval = merge (ESMF_TRUE, ESMF_FALSE, lval)
end subroutine

subroutine ESMF_tfas2_v (tfval, lval)
 type(ESMF_Logical), intent(out) :: tfval(:)
 logical, intent(in) :: lval(:)

 tfval = merge (ESMF_TRUE, ESMF_FALSE, lval)
end subroutine

!------------------------------------------------------------------------------
! function to compare two ESMF_Direction_Flag types

function ESMF_freq(fr1, fr2)
 logical ESMF_freq
 type(ESMF_Direction_Flag), intent(in) :: fr1, fr2

 ESMF_freq = (fr1%value == fr2%value)
end function

function ESMF_frne(fr1, fr2)
 logical ESMF_frne
 type(ESMF_Direction_Flag), intent(in) :: fr1, fr2

 ESMF_frne = (fr1%value /= fr2%value)
end function

!------------------------------------------------------------------------------
! function to compare two ESMF_IOFmtFlag

subroutine ESMF_ioas(io1, io2)
 type(ESMF_IOFmtFlag), intent(out) :: io1
 type(ESMF_IOFmtFlag), intent(in)  :: io2

 io1%io_type = io2%io_type
end subroutine

function ESMF_ioeq(io1, io2)
  logical ESMF_ioeq
  type(ESMF_IOFmtFlag), intent(in) :: io1, io2

  ESMF_ioeq = (io1%io_type == io2%io_type)
end function

!------------------------------------------------------------------------------
! function to compare two ESMF_Index_Flag types

function ESMF_ifeq(if1, if2)
  logical ESMF_ifeq
  type(ESMF_Index_Flag), intent(in) :: if1, if2

  ESMF_ifeq = (if1%i_type == if2%i_type)
end function

!------------------------------------------------------------------------------
! function to compare two ESMF_Region_Flag types

function ESMF_rfeq(rf1, rf2)
  logical ESMF_rfeq
  type(ESMF_Region_Flag), intent(in) :: rf1, rf2

  ESMF_rfeq = (rf1%i_type == rf2%i_type)
end function


!------------------------------------------------------------------------------
!------------------------------------------------------------------------------
! subroutine to print the corresponding C pointer of ESMF_Pointer object

subroutine ESMF_PointerPrint(ptr)
 type(ESMF_Pointer), intent(in) :: ptr

  call c_pointerprint(ptr)
end subroutine

!------------------------------------------------------------------------------
! function to compare two ESMF_UNMAPPEDACTION types

function ESMF_unmappedactioneq(uma1, uma2)
 logical ESMF_unmappedactioneq
 type(ESMF_UnmappedAction_Flag), intent(in) :: uma1, uma2

 ESMF_unmappedactioneq = (uma1%unmappedaction == uma2%unmappedaction)
end function

function ESMF_unmappedactionne(uma1, uma2)
 logical ESMF_unmappedactionne
 type(ESMF_UnmappedAction_Flag), intent(in) :: uma1, uma2

 ESMF_unmappedactionne = (uma1%unmappedaction /= uma2%unmappedaction)
end function


!------------------------------------------------------------------------------
! function to compare two ESMF_PoleMethod types

function ESMF_RegridPoleEq(rp1, rp2)
 logical ESMF_RegridPoleEq
 type(ESMF_PoleMethod_Flag), intent(in) :: rp1, rp2

 ESMF_RegridPoleEq = (rp1%polemethod == rp2%polemethod)
end function

function ESMF_RegridPoleNe(rp1, rp2)
 logical ESMF_RegridPoleNe
 type(ESMF_PoleMethod_Flag), intent(in) :: rp1, rp2

 ESMF_RegridPoleNe = (rp1%polemethod /= rp2%polemethod)
end function

      end module ESMF_UtilTypesMod
