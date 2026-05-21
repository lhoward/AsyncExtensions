cmake_minimum_required(VERSION 3.26)
project(AsyncExtensions LANGUAGES Swift)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Resolve the Swift module triple (used in installed swiftmodule paths).
if(NOT Swift_MODULE_TRIPLE)
  execute_process(
    COMMAND ${CMAKE_Swift_COMPILER} -print-target-info
    OUTPUT_VARIABLE _swift_target_info_json)
  string(JSON Swift_MODULE_TRIPLE GET "${_swift_target_info_json}" "target" "moduleTriple")
  set(Swift_MODULE_TRIPLE "${Swift_MODULE_TRIPLE}"
    CACHE STRING "swift module triple used for installed swiftmodule/swiftinterface files")
endif()

if(CMAKE_SYSTEM_NAME STREQUAL Darwin)
  set(SWIFT_OS_DIR macosx)
else()
  string(TOLOWER "${CMAKE_SYSTEM_NAME}" SWIFT_OS_DIR)
endif()

set(CMAKE_Swift_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/swift")

find_package(SwiftCollections REQUIRED)
find_package(SwiftAtomics REQUIRED)

file(GLOB_RECURSE ASYNC_EXTENSIONS_SOURCES CONFIGURE_DEPENDS
  Sources/*.swift)

add_library(AsyncExtensions SHARED ${ASYNC_EXTENSIONS_SOURCES})
target_link_libraries(AsyncExtensions
  PUBLIC
    SwiftCollections::Collections
    SwiftAtomics::Atomics)
set_target_properties(AsyncExtensions PROPERTIES
  SOVERSION 0
  INTERFACE_INCLUDE_DIRECTORIES
    "$<BUILD_INTERFACE:${CMAKE_Swift_MODULE_DIRECTORY}>;$<INSTALL_INTERFACE:${CMAKE_INSTALL_LIBDIR}/swift/${SWIFT_OS_DIR}>")

install(TARGETS AsyncExtensions
  EXPORT AsyncExtensionsTargets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

install(FILES "${CMAKE_Swift_MODULE_DIRECTORY}/AsyncExtensions.swiftmodule"
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/swift/${SWIFT_OS_DIR}/AsyncExtensions.swiftmodule
  RENAME ${Swift_MODULE_TRIPLE}.swiftmodule)
install(FILES "${CMAKE_Swift_MODULE_DIRECTORY}/AsyncExtensions.swiftdoc"
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/swift/${SWIFT_OS_DIR}/AsyncExtensions.swiftmodule
  RENAME ${Swift_MODULE_TRIPLE}.swiftdoc)

install(EXPORT AsyncExtensionsTargets
  FILE AsyncExtensionsTargets.cmake
  NAMESPACE AsyncExtensions::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/AsyncExtensions)

configure_package_config_file(
  cmake/AsyncExtensionsConfig.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/AsyncExtensionsConfig.cmake"
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/AsyncExtensions)

install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/AsyncExtensionsConfig.cmake"
  cmake/FindSwiftCollections.cmake
  cmake/FindSwiftAtomics.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/AsyncExtensions)
