#!/bin/bash

echo "Setting up project workspace..."

# Remove any remnant of the old work environment
rm -rf ./build

# Create build directory structure.
mkdir -p build/release
mkdir -p build/debug
mkdir -p build/coverage
mkdir -p build/docs

echo "Setup debug build environment..."

cd ./build/debug
cmake -DCMAKE_BUILD_TYPE=Debug ../../
cd -

echo "Setup release build environment..."

cd ./build/release
cmake -DCMAKE_BUILD_TYPE=Release ../../
cd -

echo "Setup coverage build environment..."

cd ./build/coverage
cmake -DCMAKE_BUILD_TYPE=Debug -DWITH_COVERAGE=YES ../../
cd -

# Download tests
cd tests
source ../bin/setup-tests.sh
cd ../


echo " "
echo "Project workspace setup complete."
