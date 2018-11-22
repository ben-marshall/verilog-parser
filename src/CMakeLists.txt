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

if(${WITH_COVERAGE})

  message(STATUS "Building with coverage flags set.")
  SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${COV_FLAGS_C} -DVERILOG_PARSER_COVERAGE_ON")
  SET(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_C_FLAGS_RELEASE} ${COV_FLAGS_LINK}")

else()

  message(STATUS "NOT building with coverage.")

endif()

message(STATUS "Parser Build Flags Debug:   ${CMAKE_C_FLAGS_DEBUG}")
message(STATUS "Parser Link Flags Debug:   ${CMAKE_EXE_LINKER_FLAGS_DEBUG}")
message(STATUS "Parser Build Flags Release: ${CMAKE_C_FLAGS_RELEASE}")
message(STATUS "Parser Link Flags Release: ${CMAKE_EXE_LINKER_FLAGS_RELEASE}")

# ------------------------------------------------------------------------

add_custom_command(
  COMMAND ${BISON_EXECUTABLE}
  ARGS -y ${SOURCE_DIR}/${BISON_INPUT} -o ${BINARY_DIR}/${BISON_OUTPUT}
  OUTPUT ${BINARY_DIR}/${BISON_OUTPUT}
  WORKING_DIRECTORY ${SOURCE_DIR} #/${BISON_INPUT}
)

add_custom_command(
  COMMAND ${FLEX_EXECUTABLE}
  ARGS -o ${BINARY_DIR}/${FLEX_OUTPUT} ${SOURCE_DIR}/${FLEX_INPUT}
  OUTPUT ${BINARY_DIR}/${FLEX_OUTPUT}
  WORKING_DIRECTORY ${SOURCE_DIR} #/${FLEX_INPUT}
  DEPENDS ${BINARY_DIR}/${BISON_OUTPUT}
)

SET_SOURCE_FILES_PROPERTIES(${BINARY_DIR}/${FLEX_OUTPUT}  GENERATED)
SET_SOURCE_FILES_PROPERTIES(${BINARY_DIR}/${BISON_OUTPUT} GENERATED)

# ------------------------------------------------------------------------

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
add_library(${PROJECT_NAME}::${LIBRARY_NAME} ALIAS ${LIBRARY_NAME})

target_compile_options(${LIBRARY_NAME} PRIVATE -Wall)
target_compile_options(${LIBRARY_NAME} PRIVATE -W)

set_target_properties(${LIBRARY_NAME} PROPERTIES C_EXTENSIONS OFF)

target_include_directories(${LIBRARY_NAME}
  PUBLIC
    $<INSTALL_INTERFACE:include>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
)

# ------------------------------------------------------------------------

add_executable(${EXECUTABLE_NAME} main.c)

target_compile_options(${EXECUTABLE_NAME} PRIVATE -Wall)
target_compile_options(${EXECUTABLE_NAME} PRIVATE -W)

target_link_libraries(${EXECUTABLE_NAME} ${LIBRARY_NAME})

target_include_directories(${EXECUTABLE_NAME} 
    PRIVATE ${PROJECT_SOURCE_DIR}/include
)

# ------------------------------------------------------------------------

install(TARGETS ${LIBRARY_NAME} ${EXECUTABLE_NAME}
  EXPORT ${LIBRARY_NAME}Targets
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  RUNTIME DESTINATION bin
  INCLUDES DESTINATION include
)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  ${LIBRARY_NAME}ConfigVersion.cmake
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY AnyNewerVersion
)

install(EXPORT ${LIBRARY_NAME}Targets
  FILE ${LIBRARY_NAME}Targets.cmake
  NAMESPACE ${LIBRARY_NAME}::
  DESTINATION lib/cmake/${LIBRARY_NAME}
)

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
