#[[
This source file is part of the AsyncExtensions open source project

Copyright (c) 2024 The AsyncExtensions project authors
Licensed under MIT License

See https://github.com/sideeffect-io/AsyncExtensions/blob/main/LICENSE for license information
#]]

# Package.swift declares the AsyncExtensions target with `path: "Sources"`, so
# unlike a typical SwiftPM layout, this single target's sources span multiple
# subdirectories directly under Sources/.

file(GLOB_RECURSE ASYNC_EXTENSIONS_SOURCES CONFIGURE_DEPENDS
  *.swift)

add_library(AsyncExtensions ${ASYNC_EXTENSIONS_SOURCES})
target_link_libraries(AsyncExtensions
  PUBLIC
    SwiftCollections::Collections
    SwiftAtomics::Atomics)

get_swift_host_os(_swift_os)
set_target_properties(AsyncExtensions PROPERTIES
  SOVERSION 0
  INTERFACE_INCLUDE_DIRECTORIES
    "$<BUILD_INTERFACE:${CMAKE_Swift_MODULE_DIRECTORY}>;$<INSTALL_INTERFACE:${CMAKE_INSTALL_LIBDIR}/swift/${_swift_os}>")

_install_target(AsyncExtensions)
set_property(GLOBAL APPEND PROPERTY ASYNC_EXTENSIONS_EXPORTS AsyncExtensions)
