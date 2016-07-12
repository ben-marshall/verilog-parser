cmake_minimum_required(VERSION 2.8)

project(verilog-parser-src)


FIND_PACKAGE(BISON REQUIRED)
FIND_PACKAGE(FLEX REQUIRED)

ADD_CUSTOM_COMMAND(
    SOURCE  ${Foo_SOURCE_DIR}/src/verilog_scanner.l
    COMMAND ${FLEX_EXECUTABLE} 
    ARGS    -o${Foo_BINARY_DIR}/src/verilog_scanner.c 
        ${Foo_SOURCE_DIR}/src/verilog_scanner.l
    TARGET  PARSER_LIB
    OUTPUTS ${Foo_BINARY_DIR}/src/verilog_scanner.c
)

