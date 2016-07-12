#!/bin/bash

echo "Setting up project workspace..."

# Download tests
cd tests
source ../bin/setup-tests.sh
cd ../

# Create build directory structure.
mkdir -p build/release
mkdir -p build/debug
mkdir -p build/docs

echo "Setup debug build environment..."

cd ./build/debug
cmake -DCMAKE_BUILD_TYPE=Debug ../../
cd -

echo "Setup release build environment..."

cd ./build/release
cmake -DCMAKE_BUILD_TYPE=Release ../../
cd -

echo " "
echo "Project workspace setup complete."
