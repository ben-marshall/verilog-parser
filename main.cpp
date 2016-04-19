
#include <iostream>
#include <cstdlib>

#include "verilog_driver.hpp"

using namespace std;

int main(const int argc, const char ** argv)
{
    if(argc!=2){
        cout<<"Need single file name as argument."<<endl;
        return 1;
    }

    VL::VerilogDriver driver;

    driver.parse(argv[1]);
    return 0;
}
