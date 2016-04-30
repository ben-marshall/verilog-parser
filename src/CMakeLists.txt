cmake_minimum_required (VERSION 2.6)
project (Verilog-Parser-Src)

find_package(BISON)
find_package(FLEX)

BISON_TARGET(VerilogParser 
             verilog_parser.yy
             ${CMAKE_CURRENT_BINARY_DIR}/verilog_parser.tab.cc
             COMPILE_FLAGS "-d"
)

FLEX_TARGET (VerilogScanner
             verilog_scanner.l
             ${CMAKE_CURRENT_BINARY_DIR}/verilog_lexer.yy.cc
)


include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
add_executable(verilog-parser
               verilog_parser.tab.cc 
               verilog_lexer.yy.cc
               verilog_driver.cpp 
               main.cpp
)

