cmake_minimum_required(VERSION 2.8)

project(verilog-parser-src)

message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")

set(LIBRARY_NAME    verilogparser)
set(EXECUTABLE_NAME parser)

FIND_PACKAGE(BISON 3.0.4 REQUIRED)
FIND_PACKAGE(FLEX 2.5.35 REQUIRED)

set(SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})

set(FLEX_INPUT  verilog_scanner.l)
set(FLEX_OUTPUT verilog_scanner.c)

set(BISON_INPUT  verilog_parser.y)
set(BISON_OUTPUT verilog_parser.tab.c)

# ------------------------------------------------------------------------


option(WITH_COVERAGE "If YES, build the debug executable with coverage." NO)

SET(COV_FLAGS_C     "-fprofile-arcs -ftest-coverage")
SET(COV_FLAGS_LINK  "-fprofile-arcs -ftest-coverage")

# ------------------------------------------------------------------------
    
SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -Wall -W")
SET(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_C_FLAGS_RELEASE}")

if( ${WITH_COVERAGE} )

message(STATUS "Building with coverage flags set.")
SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${COV_FLAGS_C} -DVERILOG_PARSER_COVERAGE_ON")
SET(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_C_FLAGS_RELEASE} ${COV_FLAGS_LINK}")

else()

message(STATUS "NOT building with coverage.")

endif()


SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}")
SET(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}")

message(STATUS "Parser Build Flags Debug:   ${CMAKE_C_FLAGS_DEBUG}")
message(STATUS "Parser Link Flags Debug:   ${CMAKE_EXE_LINKER_FLAGS_DEBUG}")
message(STATUS "Parser Build Flags Release: ${CMAKE_C_FLAGS_RELEASE}")
message(STATUS "Parser Link Flags Release: ${CMAKE_EXE_LINKER_FLAGS_RELEASE}")

# ------------------------------------------------------------------------

#cmake_policy(SET CMP0050 OLD)

ADD_CUSTOM_COMMAND(
    SOURCE ${SOURCE_DIR}/${BISON_INPUT}
    COMMAND ${BISON_EXECUTABLE} 
    ARGS -y ${SOURCE_DIR}/${BISON_INPUT} -o ${BINARY_DIR}/${BISON_OUTPUT}
    TARGET PARSER_LIB
    OUTPUTS ${BINARY_DIR}/${BISON_OUTPUT}
)

ADD_CUSTOM_COMMAND(
    SOURCE  ${SOURCE_DIR}/${FLEX_INPUT}
    COMMAND ${FLEX_EXECUTABLE} 
    ARGS    -o ${BINARY_DIR}/${FLEX_OUTPUT} ${SOURCE_DIR}/${FLEX_INPUT}
    TARGET  PARSER_LIB
    DEPENDS ${BINARY_DIR}/${BISON_OUTPUT}
    OUTPUTS ${BINARY_DIR}/${FLEX_OUTPUT}
)

#cmake_policy(SET CMP0050 NEW)

SET_SOURCE_FILES_PROPERTIES(${BINARY_DIR}/${FLEX_OUTPUT}  GENERATED)
SET_SOURCE_FILES_PROPERTIES(${BINARY_DIR}/${BISON_OUTPUT} GENERATED)

# ------------------------------------------------------------------------

INCLUDE_DIRECTORIES(${BINARY_DIR})
INCLUDE_DIRECTORIES(${SOURCE_DIR})

set(PARSER_LIB_SRC ${BINARY_DIR}/${FLEX_OUTPUT}
                   ${BINARY_DIR}/${BISON_OUTPUT}
                   ${SOURCE_DIR}/verilog_ast.c
                   ${SOURCE_DIR}/verilog_ast_mem.c
                   ${SOURCE_DIR}/verilog_ast_util.c
                   ${SOURCE_DIR}/verilog_ast_common.c
                   ${SOURCE_DIR}/verilog_parser_wrapper.c
                   ${SOURCE_DIR}/verilog_preprocessor.c
)

add_library(${LIBRARY_NAME} ${PARSER_LIB_SRC})

set(CMAKE_C_OUTPUT_EXTENSION_REPLACE 1)

add_executable(${EXECUTABLE_NAME} main.c)
target_link_libraries(${EXECUTABLE_NAME} ${LIBRARY_NAME})

# ------------------------------------------------------------------------

if( ${DISABLE_VERILOG_PARSER_TESTS} )

else ()
    if( ${WITH_COVERAGE} )

        set(CMAKE_C_OUTPUT_EXTENSION_REPLACE 1)

        file(GLOB TEST_FILE_LIST "../tests/*.[vh]")
            
        add_test(NAME verilog_parser_coverage
                 COMMAND parser ${TEST_FILE_LIST}
                 WORKING_DIRECTORY ../
        )

    else ()

        file(GLOB TEST_FILE_LIST "../tests/*.[vh]")

        foreach ( TESTFILE ${TEST_FILE_LIST} )

            add_test(NAME verilog_parser_${TESTFILE}
                     COMMAND parser ${TESTFILE}
                     WORKING_DIRECTORY ../
            )

        endforeach ( TESTFILE )

    endif()
endif ()
