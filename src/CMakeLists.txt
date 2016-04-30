cmake_minimum_required (VERSION 2.6)
project (Verilog-Parser-Src)

find_package(BISON)
find_package(FLEX)

FLEX_TARGET(
    verilog_scanner
    verilog_scanner.l 
    ${CMAKE_CURRENT_BINARY_DIR}/verilog_lexer.cpp
)

BISON_TARGET(
    verilog_parser 
    verilog_parser.yy
    ${CMAKE_CURRENT_BINARY_DIR}/verilog_parser.cpp
)

ADD_FLEX_BISON_DEPENDENCY(verilog_scanner verilog_parser)

include_directories(${CMAKE_CURRENT_BINARY_DIR})
add_executable(verilog-parser
               main.cpp
               ${BISON_verilog_parser_OUTPUTS}
               ${FLEX_verilog_scanner_OUTPUTS}
 )

