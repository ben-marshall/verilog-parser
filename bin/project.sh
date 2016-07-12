#!/bin/bash

echo "Setting up project workspace..."

# Download tests
cd tests
source ../bin/setup-tests.sh
cd ../

# Create build directory structure.
mkdir -p build
mkdir -p build/docs

cd ./build
cmake ..
cd ..

echo " "
echo "Project workspace setup complete."
