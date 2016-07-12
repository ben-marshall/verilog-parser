#!/bin/bash

black='\E[30m'
red='\E[31m'
green='\E[32m'
yellow='\E[33m'
blue='\E[34m'
magenta='\E[35m'
cyan='\E[36m'
white='\E[37m'
clrc='\E[0m'

echo "------------------------- Running Test Script -------------------------"

rm -rf build/tests.log

EXE=./build/debug/src/parser
TEST_FILES=`find tests/ -name *.v | sort`

FAILED_TESTS=" "
PASSED_TESTS=" "

for FILE in $TEST_FILES
do
    # run the program and store the result.
    $EXE $FILE 2>> build/tests.log 1>> build/tests.log
    RESULT=$?

    if [ "0" -eq "$RESULT" ]; then
        PASSED_TESTS="$PASSED_TESTS $FILE"
        echo -n -e "$green $FILE $clrc"
    else
        FAILED_TESTS="$FAILED_TESTS $FILE"
        echo -n -e "$red $FILE $clrc"
    fi


done

echo " "
echo " "
echo "--------------------------- Testing Complete --------------------------"

echo " "
echo " "
echo -e "$green Passing Tests: $clrc"
printf "%30s  %30s  %30s  %30s\n" $PASSED_TESTS

echo " "
echo -e "$red Failing Tests: $clrc"
printf "%30s  %30s  %30s  %30s\n" $FAILED_TESTS

echo " "
echo "------------------------- Finished Test Script ------------------------"
echo " "
echo "Passing: `echo $PASSED_TESTS | wc -w` \t Failing: "`echo $FAILED_TESTS | wc -w`
echo " "

exit `echo "$FAILED_TESTS" | wc -w`
