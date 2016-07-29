cmake_minimum_required(VERSION 2.8)

project(verilog-parser-docs)

find_package(Doxygen)
if(DOXYGEN_FOUND)
    add_custom_target(verilogparser-docs
        ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        COMMENT "Generating API documentation with Doxygen" VERBATIM
    )
endif(DOXYGEN_FOUND)
