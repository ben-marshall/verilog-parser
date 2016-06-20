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

rm -rf coverage/*
mkdir -p coverage/

gcov -f -b -c -o ./obj -s ./gen/*.c ./gen/*.tab.c ../src/*.c

mv ./obj/*.gcno ./coverage/.
mv ./obj/*.gcda ./coverage/.
mv ./*.gcov ./coverage/.
touch "<stdout>"

cd coverage

lcov  --directory . -c -o coverage.info -t "Verilog Parser"
genhtml -o ../cov-report -t "Verilog Parser Test Coverage" --num-spaces 4 coverage.info


cd $IWD # return to initial working directory.
rm -f "build/<stdout>"

echo " "
echo "Coverage Report Written To:"
echo "    ./build/cov-report/index.html"
echo " "

echo "-----------------------Coverage Tests Complete ------------------------"
