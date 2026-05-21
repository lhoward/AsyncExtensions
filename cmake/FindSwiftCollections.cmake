# FindSwiftCollections.cmake
#
# Locates an installed apple/swift-collections package built and installed with
# its upstream CMake build. swift-collections installs both its shared
# libraries and swiftmodules under `lib/swift/<os>/` and does not ship an
# install-tree-usable Config.cmake.
#
# Components: Collections (the umbrella module). DequeModule, BitCollections,
# HashTreeCollections, HeapModule, OrderedCollections, _RopeModule,
# InternalCollectionsUtilities are exposed via INTERFACE_LINK_LIBRARIES of
# Collections, but only Collections has a SwiftCollections::<name> alias here.

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

  # Also locate the sibling modules Collections re-exports so they can be
  # linked individually if a consumer needs them.
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
