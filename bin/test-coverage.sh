#!/bin/bash


echo "----------------------- Running Coverage Tests ------------------------"

make clean
make app-with-coverage

IWD=`pwd`

EXE=build/bin/verilog-app
TEST_FILES=tests/*.v

echo "$EXE $TEST_FILES"
$EXE $TEST_FILES

echo "---------------------- Coverage Results Summary -----------------------"

cd build/

gcov -o ./obj -s  ./gen/*.c ./gen/*.tab.c ../src/*.c

echo "-----------------------Coverage Tests Complete ------------------------"

cd $IWD # return to initial working directory.
