#!/bin/bash

echo "------------------------- Running Test Script -------------------------"

EXE=build/bin/verilog-app
TEST_FILES=`ls tests/ | sort`

FAILED_TESTS=" "
PASSED_TESTS=" "

for FILE in $TEST_FILES
do
    # run the program and store the result.
    $EXE tests/$FILE
    RESULT=$?

    if [ "0" -eq "$RESULT" ]; then
        PASSED_TESTS="$PASSED_TESTS $FILE"
    else
        FAILED_TESTS="$FAILED_TESTS $FILE"
    fi


done

echo " "
echo " "
echo "Passing Tests:"
printf "%30s  %30s  %30s  %30s\n" $PASSED_TESTS

echo " "
echo "Failing Tests:"
printf "%30s  %30s  %30s  %30s\n" $FAILED_TESTS

echo "------------------------- Finished Test Script ------------------------"
