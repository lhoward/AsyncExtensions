# FindSwiftAtomics.cmake
#
# Locates an installed apple/swift-atomics package built and installed with
# its upstream CMake build. Upstream installs both `libAtomics.so` and the
# swiftmodule under `lib/swift/<os>/`, and does not ship an install-tree-usable
# Config.cmake.

if(CMAKE_SYSTEM_NAME STREQUAL Darwin)
  set(_swift_os macosx)
else()
  string(TOLOWER "${CMAKE_SYSTEM_NAME}" _swift_os)
endif()

find_library(SwiftAtomics_LIBRARY
  NAMES Atomics
  PATH_SUFFIXES lib/swift/${_swift_os} lib)

find_path(SwiftAtomics_MODULE_DIR
  NAMES Atomics.swiftmodule
  PATH_SUFFIXES lib/swift/${_swift_os})

# The _AtomicsShims C module is consumed transitively by `import Atomics`, so
# the consumer compiler needs to find its module.modulemap + headers. Upstream
# swift-atomics' CMake doesn't install these, so the prefix must have been
# populated separately. We look for them under `include/_AtomicsShims/`.
find_path(SwiftAtomics_SHIMS_INCLUDE_DIR
  NAMES _AtomicsShims/module.modulemap
  PATH_SUFFIXES include)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SwiftAtomics
  REQUIRED_VARS
    SwiftAtomics_LIBRARY
    SwiftAtomics_MODULE_DIR
    SwiftAtomics_SHIMS_INCLUDE_DIR)

if(SwiftAtomics_FOUND AND NOT TARGET SwiftAtomics::Atomics)
  add_library(SwiftAtomics::Atomics SHARED IMPORTED)
  set_target_properties(SwiftAtomics::Atomics PROPERTIES
    IMPORTED_LOCATION "${SwiftAtomics_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES
      "${SwiftAtomics_MODULE_DIR};${SwiftAtomics_SHIMS_INCLUDE_DIR}")
endif()

mark_as_advanced(
  SwiftAtomics_LIBRARY
  SwiftAtomics_MODULE_DIR
  SwiftAtomics_SHIMS_INCLUDE_DIR)
