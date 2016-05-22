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

BISON_TARGET(VerilogParserCPP
             verilog_parser.yy
             ${CMAKE_CURRENT_BINARY_DIR}/verilog_parser.tab.cc
             COMPILE_FLAGS "-d --graph"
)

FLEX_TARGET (VerilogScannerCPP
             verilog_scanner.ll
             ${CMAKE_CURRENT_BINARY_DIR}/verilog_lexer.yy.cc
)


include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
add_executable(verilog-parser-cpp
               verilog_parser.tab.cc 
               verilog_lexer.yy.cc
               verilog_driver.cpp 
               main-parse.cpp
)

add_executable(verilog-lexer-cpp
               verilog_parser.tab.cc 
               verilog_lexer.yy.cc
               verilog_driver.cpp 
               main-lex.cpp
)

add_library(verilogparserc
            verilog_parser.tab.c
            verilog_lexer.y.c
) 

add_library(verilogparsercpp
            verilog_parser.tab.cc 
            verilog_lexer.yy.cc
            verilog_driver.cpp 
) 

add_executable(verilog-parser-c
               verilog_parser.tab.c
               verilog_lexer.y.c
               main.c
)
