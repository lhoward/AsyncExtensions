#[[
This source file is part of the AsyncExtensions open source project

Copyright (c) 2024 The AsyncExtensions project authors
Licensed under MIT License

See https://github.com/sideeffect-io/AsyncExtensions/blob/main/LICENSE for license information
#]]

include(CMakePackageConfigHelpers)

set(ASYNC_EXTENSIONS_EXPORTS_FILE
  ${CMAKE_CURRENT_BINARY_DIR}/AsyncExtensionsExports.cmake)

configure_file(AsyncExtensionsConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/AsyncExtensionsConfig.cmake)

get_property(ASYNC_EXTENSIONS_EXPORTS GLOBAL PROPERTY ASYNC_EXTENSIONS_EXPORTS)
export(TARGETS ${ASYNC_EXTENSIONS_EXPORTS}
  NAMESPACE AsyncExtensions::
  FILE ${ASYNC_EXTENSIONS_EXPORTS_FILE}
  EXPORT_LINK_INTERFACE_LIBRARIES)

install(EXPORT AsyncExtensionsTargets
  FILE AsyncExtensionsTargets.cmake
  NAMESPACE AsyncExtensions::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/AsyncExtensions)

configure_package_config_file(
  AsyncExtensionsConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/install/AsyncExtensionsConfig.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/AsyncExtensions)

install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/install/AsyncExtensionsConfig.cmake
  FindSwiftCollections.cmake
  FindSwiftAtomics.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/AsyncExtensions)
