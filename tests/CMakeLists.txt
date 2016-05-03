cmake_minimum_required (VERSION 2.6)
project (Verilog-Parser-Tests)

file(GLOB TESTS_SRC
    "*.v"
)

foreach(TEST_PATH ${TESTS_SRC})

    get_filename_component(TEST_NAME ${TEST_PATH} NAME_WE)
    
    add_test(NAME parse_${TEST_NAME} 
             COMMAND verilog-parser ${TEST_PATH})
    
    add_test(NAME lex_${TEST_NAME} 
             COMMAND verilog-lexer ${TEST_PATH})
    
    message("Added test: ${TEST_NAME}")

endforeach(TEST_PATH)
