#!/bin/bash

echo "----------------- Setup Project Workspace ---------------------------"

# Remove any remnant of the old work environment
rm -rf ./build

# Create build directory structure.
mkdir -p build/release
mkdir -p build/debug
mkdir -p build/coverage
mkdir -p build/docs

# Download tests - must happen before CMake is run.
cd tests
source ../bin/setup-tests.sh
cd ../

echo "----------------- Setup Debug Build Environment ---------------------"

cd ./build/debug
cmake -DCMAKE_BUILD_TYPE=Debug ../../
cd -

echo "----------------- Setup Release Build Environment -------------------"

cd ./build/release
cmake -DCMAKE_BUILD_TYPE=Release ../../
cd -

echo "----------------- Setup Coverage Build Environment ------------------"

cd ./build/coverage
cmake -DCMAKE_BUILD_TYPE=Debug -DWITH_COVERAGE=YES ../../
cd -


echo " "
echo "----------------- Setup Coverage Build Environment ------------------"
