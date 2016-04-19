#include <cctype>
#include <fstream>
#include <cassert>
#include <cstdlib>

#include "verilog_driver.hpp"

VL::VerilogDriver::~VerilogDriver(){ 
   delete(scanner);
   scanner = NULL;
   delete(parser);
   parser = NULL;
}

void VL::VerilogDriver::add_preproc_define(const char * m)
{
    std::cout<<this->scanner->lineno()<<" ";
    std::cout<<"Found preprocessor define: " << m;
}

void VL::VerilogDriver::add_block_comment(const char * m)
{
    std::cout<<this->scanner->lineno()<<" ";
    std::cout<<"Found block comment: " << m<<"\n";
}

void VL::VerilogDriver::add_oneline_comment(const char * m)
{
    std::cout<<this->scanner->lineno()<<" ";
    std::cout<<"Found single line comment: " << m<<"\n";
}

void  VL::VerilogDriver::parse( const char *filename )
{
   assert( filename != NULL);
   std::ifstream in_file( filename );
   if( ! in_file.good() ) exit(1);
   
   delete(scanner);
   try
   {
      scanner = new VL::VerilogScanner( &in_file );
   }
   catch( std::bad_alloc &ba )
   {
      std::cerr << "Failed to allocate scanner: (" <<
         ba.what() << "), exiting!!\n";
      exit(1);
   }
   
   delete(parser); 
   try
   {
      parser = new VL::VerilogParser( (*scanner) /* scanner */, 
                                  (*this) /* driver */ );
   }
   catch( std::bad_alloc &ba )
   {
      std::cerr << "Failed to allocate parser: (" << 
         ba.what() << "), exiting!!\n";
      exit( 1 );
   }
   const int accept( 0 );
   if( parser->parse() != accept )
   {
      std::cerr << "Parse failed!!\n";
   }
}
