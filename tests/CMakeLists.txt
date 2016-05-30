cmake_minimum_required (VERSION 2.6)
project (Verilog-Parser-Tests)

file(GLOB TESTS_SRC
    "*.v"
)

foreach(TEST_PATH ${TESTS_SRC})

    get_filename_component(TEST_NAME ${TEST_PATH} NAME_WE)
    
    add_test(NAME c_parse_${TEST_NAME} 
             COMMAND verilog-parser-c ${TEST_PATH})

endforeach(TEST_PATH)
