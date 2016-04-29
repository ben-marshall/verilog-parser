
#include <stdio.h>
#include <iostream>
#include <cstdlib>

#include "verilog_driver.hpp"

using namespace std;

int main(const int argc, const char ** argv)
{
    cout << "Program Start" << endl; fflush(stdout);

    if(argc!=2){
        cout<<"Need single file name as argument."<<endl;
        return 1;
    }
    
    cout << "Instance Driver" << endl; fflush(stdout);
    VL::VerilogDriver driver;
    
    cout << "Starting parse" << endl; fflush(stdout);
    driver.parse(argv[1]);
    cout << "Finished parse" << endl;
    return 0;
}
