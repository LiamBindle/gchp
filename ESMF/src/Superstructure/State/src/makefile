# $Id: makefile,v 1.1.5.1 2013-01-11 20:23:44 mathomp4 Exp $

ALL: build_here 

AUTOGEN   = ESMF_StateInternals.F90 ESMF_StateRemRep.F90 ESMF_StateAPI.F90
# ESMF_StateGet.F90
#TODO:FIELDINTEGRATION Restore StateGet

SOURCEC	  = 
SOURCEF	  = ESMF_StateItem.F90 ESMF_StateContainer.F90 ESMF_StateTypes.F90 \
	    ESMF_StateVa.F90 ESMF_State.F90 \
	    ESMF_StateReconcile.F90 ESMF_StateWr.F90 $(AUTOGEN)
SOURCEH	  = 
STOREH    = ESMCI_StateItem.h ESMC_State.h
TEXFILES  = $(addsuffix _fapi.tex, $(basename $(AUTOGEN)))

OBJSC     = $(addsuffix .o, $(basename $(SOURCEC)))
OBJSF     = $(addsuffix .o, $(basename $(SOURCEF)))

LIBBASE	  = libesmf
LOCDIR	  = src/Superstructure/State/src

CLEANDIRS   =
CLEANFILES  = $(AUTOGEN) $(addprefix ../doc/, $(TEXFILES) ) ESMF_LogFile
CLOBBERDIRS =

include $(ESMF_DIR)/makefile

DIRS	  = 

