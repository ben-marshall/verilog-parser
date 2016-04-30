#!/bin/bash

echo "Setting up project workspace..."

# Download tests
cd tests
source ../bin/download-tests.sh
cd ../

# Instance CMake
mkdir -p build
cd build
cmake ..
cd ..

echo " "
echo "CMake and project workspace setup complete."
