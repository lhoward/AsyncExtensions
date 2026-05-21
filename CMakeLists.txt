#[[
This source file is part of the AsyncExtensions open source project

Copyright (c) 2024 The AsyncExtensions project authors
Licensed under MIT License

See https://github.com/sideeffect-io/AsyncExtensions/blob/main/LICENSE for license information
#]]

cmake_minimum_required(VERSION 3.16)
project(AsyncExtensions
  LANGUAGES Swift)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_Swift_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/swift)

if(CMAKE_SYSTEM_NAME STREQUAL Windows OR CMAKE_SYSTEM_NAME STREQUAL Darwin)
  option(BUILD_SHARED_LIBS "Build shared libraries by default" YES)
endif()

include(GNUInstallDirs)
include(SwiftSupport)

find_package(SwiftCollections REQUIRED)
find_package(SwiftAtomics REQUIRED)

add_subdirectory(Sources)
add_subdirectory(cmake/modules)
