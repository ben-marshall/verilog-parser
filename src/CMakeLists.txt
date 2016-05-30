cmake_minimum_required (VERSION 2.6)
project (Verilog-Parser-Src)

find_package(BISON)
find_package(FLEX)

BISON_TARGET(VerilogParserC
             verilog_parser.y
             ${CMAKE_CURRENT_BINARY_DIR}/verilog_parser.tab.c
             COMPILE_FLAGS "-d --graph"
)

FLEX_TARGET (VerilogScannerC
             verilog_scanner.l
             ${CMAKE_CURRENT_BINARY_DIR}/verilog_lexer.y.c
)

include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

## ----------------------------------------------------------

set(PARSER_LIB_SRCS verilog_parser.tab.c
                    verilog_lexer.y.c
                    verilog_parser.c
                    verilog_ast.c
                    verilog_ast_common.c
)


set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fprofile-arcs -ftest-coverage")
set(CMAKE_EXE_LINKER_FLAGS
    "${CMAKE_EXE_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")

# C library
add_library(verilogparserc ${PARSER_LIB_SRCS})

# C library test exectuable
add_executable(verilog-parser-c
               main.c
)

target_link_libraries(verilog-parser-c gcov verilogparserc)

