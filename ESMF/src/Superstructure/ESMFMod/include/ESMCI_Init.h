// $Id: ESMCI_Init.h,v 1.1.5.1 2013-01-11 20:23:44 mathomp4 Exp $
//
// Earth System Modeling Framework
// Copyright 2002-2012, University Corporation for Atmospheric Research, 
// Massachusetts Institute of Technology, Geophysical Fluid Dynamics 
// Laboratory, University of Michigan, National Centers for Environmental 
// Prediction, Los Alamos National Laboratory, Argonne National Laboratory, 
// NASA Goddard Space Flight Center.
// Licensed under the University of Illinois-NCSA License.

// ESMC Init include file for C++

// these lines prevent this file from being read more than once if it
// ends up being included multiple times

#ifndef ESMCI_Init_H
#define ESMCI_Init_H

//-----------------------------------------------------------------------------
//
// !DESCRIPTION:
//
// The code in this file implements constants and macros for the Init Code.
//
// 
//

// !USES:
#include "ESMCI_Macros.h"
#include "ESMCI_Calendar.h"

// public globals, filled in by ESMC_Initialize()
//  and used by MPI_Init().   set once, treat as read-only!

extern int globalargc;
extern char **globalargv;


// keep in sync with Fortran
enum ESMCI_MainLanguage { ESMF_MAIN_C=1, ESMF_MAIN_F90 };


// prototypes for C routines
int ESMCI_Initialize(char *defaultConfigFilename,
  ESMC_CalKind_Flag defaultCalendar=ESMC_CALKIND_NOCALENDAR,
  char *defaultLogFilename=NULL, ESMC_LogType defaultLogType=ESMC_LOG_MULTI);

int ESMCI_Initialize(ESMC_CalKind_Flag defaultCalendar=ESMC_CALKIND_NOCALENDAR);

int ESMCI_Initialize(int argc, char **argv, 
  ESMC_CalKind_Flag defaultCalendar=ESMC_CALKIND_NOCALENDAR);

int ESMCI_Finalize(void);


// prototypes for fortran interface routines
extern "C" {
   void FTN(f_esmf_frameworkinitialize)(int *language, 
                                        char *defaultConfigFileName,
                                        ESMC_CalKind_Flag *defaultCalendar,
                                        char *defaultLogFileName,
                                        ESMC_LogType *defaultLogType,
                                        int *rc, ESMCI_FortranStrLenArg count1,
					ESMCI_FortranStrLenArg count2);
   void FTN(f_esmf_frameworkfinalize)(int *rc);
};


#endif  // ESMCI_Init_H
