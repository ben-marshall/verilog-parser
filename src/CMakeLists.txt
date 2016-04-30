cmake_minimum_required (VERSION 2.6)
project (Verilog-Parser-Src)

find_package(BISON)
find_package(FLEX)


include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
add_executable(verilog-parser
               verilog_parser.tab.cc 
               verilog_lexer.yy.c 
               verilog_driver.cpp 
               main.cpp
)

