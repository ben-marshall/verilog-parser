
#include <stdio.h>
#include <iostream>
#include <cstdlib>
#include <cassert>
#include <cctype>
#include <fstream>

#include "verilog_driver.hpp"

using namespace std;

int main(const int argc, const char ** argv)
{
    cout << "Program Start" << endl; fflush(stdout);

    if(argc!=2){
        cout<<"Need single file name as argument."<<endl;
        return 1;
    }
    
    const char * filename = argv[1];
    assert( filename != NULL);
    
    std::ifstream in_file( filename );
    
    if( ! in_file.good() ) exit(1);
    
    VL::VerilogScanner *scanner= new VL::VerilogScanner(&in_file);
    
    cout << "Starting scan" << endl; fflush(stdout);
    VL::VerilogParser::semantic_type *yylval;
    
    int tr = scanner->yylex(yylval);

    while(tr != VL::VerilogParser::token::END)
    {
        tr = scanner -> yylex(yylval);
    }

    cout << "Finished scan" << endl;
    return 0;
}

