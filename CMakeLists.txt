cmake_minimum_required(VERSION 3.8)

project(verilogparser VERSION 1.0 LANGUAGES C)

option(VLOG_PARSER_BUILD_DOCS "Build documents." OFF)
option(VLOG_PARSER_BUILD_TEST "Build test." OFF)

# ------------------------------------------------------------------------
set(VLOG_PARSER_TARGET_NAME                 ${PROJECT_NAME})
set(VLOG_PARSER_CONFIG_INSTALL_DIR          "lib/cmake/${PROJECT_NAME}" CACHE INTERNAL "")
set(VLOG_PARSER_INCLUDE_INSTALL_DIR         "include")
set(VLOG_PARSER_INCLUDE_BUILD_DIR           "${PROJECT_SOURCE_DIR}/include")
set(VLOG_PARSER_TARGETS_EXPORT_NAME         "${PROJECT_NAME}Targets")
set(VLOG_PARSER_CMAKE_CONFIG_TEMPLATE       "cmake/config.cmake.in")
set(VLOG_PARSER_CMAKE_CONFIG_DIR            "${CMAKE_CURRENT_BINARY_DIR}")
set(VLOG_PARSER_CMAKE_VERSION_CONFIG_FILE   "${VLOG_PARSER_CMAKE_CONFIG_DIR}/${PROJECT_NAME}ConfigVersion.camke")
set(VLOG_PARSER_CMAKE_PROJECT_CONFIG_FILE   "${VLOG_PARSER_CMAKE_CONFIG_DIR}/${PROJECT_NAME}Config.cmake")
set(VLOG_PARSER_CMAKE_PROJECT_TARGETS_FILE  "${PROJECT_NAME}Targets.cmake")


# ------------------------------------------------------------------------

set(LIBRARY_NAME ${PROJECT_NAME}) 

add_subdirectory(./src)

# ------------------------------------------------------------------------
# install

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  ${VLOG_PARSER_CMAKE_VERSION_CONFIG_FILE}
  COMPATIBILITY AnyNewerVersion
)

configure_file(
  ${VLOG_PARSER_CMAKE_CONFIG_TEMPLATE}
  ${VLOG_PARSER_CMAKE_PROJECT_CONFIG_FILE}
  @ONLY
)

install(
  FILES ${VLOG_PARSER_CMAKE_PROJECT_CONFIG_FILE} ${VLOG_PARSER_CMAKE_VERSION_CONFIG_FILE}
  DESTINATION ${VLOG_PARSER_CONFIG_INSTALL_DIR}
)

install(
  EXPORT ${VLOG_PARSER_TARGETS_EXPORT_NAME}
  DESTINATION ${VLOG_PARSER_CONFIG_INSTALL_DIR}
  NAMESPACE ${PROJECT_NAME}::
  FILE ${VLOG_PARSER_PROJECT_TARGETS_FILE}
)

export(
  TARGETS ${LIBRARY_NAME}
  NAMESPACE ${PROJECT_NAME}::
  FILE ${VLOG_PARSER_CMAKE_PROJECT_TARGETS_FILE}
)

export(PACKAGE ${PROJECT_NAME})


# ------------------------------------------------------------------------

if(${VLOG_PARSER_BUILD_DOCS})
  add_subdirectory(./docs)
endif()

if(${VLOG_PARSER_BUILD_TEST}) 
  enable_testing()

  add_custom_target(verilogparser-test
    COMMAND ./bin/run-tests.sh
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    DEPENDS ${EXECUTABLE_NAME}
    COMMENT "Running Test Suite"
    VERBATIM
  )

endif()
