cmake_minimum_required (VERSION 2.6)
project (Verilog-Parser-Docs)


find_package(Doxygen)

if(DOXYGEN_FOUND)
    add_custom_target(docs
        ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        COMMENT "Generating API documentation with Doxygen" VERBATIM
    )
    add_custom_target(clean-docs
        rm -rf ${CMAKE_CURRENT_SOURCE_DIR}/html
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        COMMENT "Cleaning API documentation" VERBATIM
    )
endif(DOXYGEN_FOUND)


