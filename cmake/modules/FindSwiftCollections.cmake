#[[
This source file is part of the AsyncExtensions open source project

Copyright (c) 2024 The AsyncExtensions project authors
Licensed under MIT License

See https://github.com/sideeffect-io/AsyncExtensions/blob/main/LICENSE for license information
#]]

# FindSwiftCollections.cmake
#
# Locates an installed apple/swift-collections package built and installed with
# its upstream CMake build.

if(CMAKE_SYSTEM_NAME STREQUAL Darwin)
  set(_swift_os macosx)
else()
  string(TOLOWER "${CMAKE_SYSTEM_NAME}" _swift_os)
endif()

find_library(SwiftCollections_LIBRARY
  NAMES Collections
  PATH_SUFFIXES lib/swift/${_swift_os} lib)

find_path(SwiftCollections_MODULE_DIR
  NAMES Collections.swiftmodule
  PATH_SUFFIXES lib/swift/${_swift_os})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SwiftCollections
  REQUIRED_VARS
    SwiftCollections_LIBRARY
    SwiftCollections_MODULE_DIR)

if(SwiftCollections_FOUND AND NOT TARGET SwiftCollections::Collections)
  add_library(SwiftCollections::Collections SHARED IMPORTED)
  set_target_properties(SwiftCollections::Collections PROPERTIES
    IMPORTED_LOCATION "${SwiftCollections_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${SwiftCollections_MODULE_DIR}")

  foreach(_mod DequeModule BitCollections HashTreeCollections HeapModule
               OrderedCollections InternalCollectionsUtilities)
    find_library(SwiftCollections_${_mod}_LIBRARY
      NAMES ${_mod}
      PATH_SUFFIXES lib/swift/${_swift_os} lib)
    if(SwiftCollections_${_mod}_LIBRARY)
      add_library(SwiftCollections::${_mod} SHARED IMPORTED)
      set_target_properties(SwiftCollections::${_mod} PROPERTIES
        IMPORTED_LOCATION "${SwiftCollections_${_mod}_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${SwiftCollections_MODULE_DIR}")
      mark_as_advanced(SwiftCollections_${_mod}_LIBRARY)
    endif()
  endforeach()
endif()

mark_as_advanced(SwiftCollections_LIBRARY SwiftCollections_MODULE_DIR)
