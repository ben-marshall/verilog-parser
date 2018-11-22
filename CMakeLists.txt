cmake_minimum_required(VERSION 3.8)

project(verilog-parser VERSION 1.0 LANGUAGES C)

option(VLOG_PARSER_BUILD_DOCS "Build documents." OFF)
option(VLOG_PARSER_BUILD_TEST "Build test." OFF)

add_subdirectory(./src)

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
