# Distributed under the OSI-approved BSD 3-Clause License.
#
# Copyright (C) 2025  DFTB+ developers group
#

#[=======================================================================[.rst:
FindCustomMimic
---------------

Finds the MIMIC library (mclf and mcl components)


Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported target, if found:

``Mimic::Mimic``
  The MIMIC library


Result Variables
^^^^^^^^^^^^^^^^

This module will define the following variable:

``MIMIC_FOUND``
  True if the system has the MIMIC library


Cache variables
^^^^^^^^^^^^^^^

The following cache variables may be set to influence the library detection:

``MIMIC_DETECTION``
  Whether MIMIC libraries should be detected (default: True). If set to False,
  the settings in ``MIMIC_LIBRARY`` and ``MIMIC_INCLUDE_DIR`` will be used 
  without any further checks.

``MIMIC_LIBRARY``
  Customized MIMIC library/libraries to use (instead of autodetected one). 
  MIMIC consists of two libraries: mclf and mcl. They should be specified as 
  a list, e.g. "-DMIMIC_LIBRARY=/path/to/libmclf.so;/path/to/libmcl.so"

``MIMIC_INCLUDE_DIR``
  Directory containing the MIMIC Fortran module files (especially mcl.mod)

``MIMIC_LIBRARY_DIR``
  Directories which should be looked up in order to find the customized libraries.
#]=======================================================================]

include(FindPackageHandleStandardArgs)
include(CustomLibraryFinder)

if(TARGET Mimic::Mimic)

  set(CUSTOMMIMIC_FOUND True)
  set(CustomMimic_FOUND True)
  set(MIMIC_FOUND True)
  set(Mimic_FOUND True)

else()

  option(MIMIC_DETECTION "Whether MIMIC library should be detected" TRUE)

  if(MIMIC_DETECTION)

    # Try to find MIMIC via pkg-config first
    find_package(PkgConfig)
    # MiMiC may provide pkg-config files for mclf and/or mcl
    pkg_check_modules(_mimic QUIET mclf mcl)

    # Overwrite PkgConfig values by user defined input if present.
    if(NOT "${MIMIC_LIBRARY}" STREQUAL "")
      set(_mimic_LIBRARIES ${MIMIC_LIBRARY})
      set(_mimic_LIBRARY_DIRS ${MIMIC_LIBRARY_DIR})
    endif()


    ### This block is added regarding to Plumed structure

    # Find the libraries using CustomLibraryFinder
    # Note: MIMIC typically has two libraries: mclf and mcl
    if(NOT _mimic_LIBRARIES)
      set(_mimic_LIBRARIES "mclf;mcl")
    endif()

    ### 


    find_custom_libraries("${_mimic_LIBRARIES}" "${_mimic_LIBRARY_DIRS}"
      "${CustomMimic_FIND_QUIETLY}" _libs)
    set(MIMIC_LIBRARY "${_libs}" CACHE STRING "List of MIMIC libraries to link (mclf and mcl)" FORCE)    
    


    ### This block is added regarding to Plumed structure
    
    # Find include directory for Fortran modules (critical for MIMIC)
    if(NOT MIMIC_INCLUDE_DIR)
      # Try to find from pkg-config first
      if(_mimic_INCLUDE_DIRS)
        set(_mimic_INCLUDE_HINTS ${_mimic_INCLUDE_DIRS})
      else()
        set(_mimic_INCLUDE_HINTS ${_mimic_LIBRARY_DIRS})
      endif()
      
      find_path(MIMIC_INCLUDE_DIR
        NAMES mcl.mod
        HINTS ${_mimic_INCLUDE_HINTS} ${MIMIC_LIBRARY_DIR}
        PATH_SUFFIXES include include/MiMiC MiMiC ../include ../include/MiMiC
      )
      mark_as_advanced(MIMIC_INCLUDE_DIR)
    endif()
    ### 
    
    
    unset(_libs)
    unset(_mimic_LIBRARIES)
    unset(_mimic_LIBRARY_DIRS)
    unset(_mimic_INCLUDE_DIRS)
    unset(_mimic_INCLUDE_HINTS)

    set(MIMIC_DETECTION False CACHE BOOL "Whether MIMIC libraries should be detected" FORCE)
  
  endif()


  # Standard argument handling - but now with both LIBRARY and INCLUDE_DIR
  find_package_handle_standard_args(CustomMimic REQUIRED_VARS MIMIC_LIBRARY MIMIC_INCLUDE_DIR)
  
  set(MIMIC_FOUND ${CUSTOMMIMIC_FOUND})
  set(Mimic_FOUND ${CUSTOMMIMIC_FOUND})

  if(MIMIC_FOUND AND NOT TARGET Mimic::Mimic)
    add_library(Mimic::Mimic INTERFACE IMPORTED)
    target_link_libraries(Mimic::Mimic INTERFACE "${MIMIC_LIBRARY}")
    target_include_directories(Mimic::Mimic INTERFACE "${MIMIC_INCLUDE_DIR}")
  endif()

endif()
