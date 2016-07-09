#!/bin/bash

echo "Setting up project workspace..."

# Download tests
cd tests
source ../bin/setup-tests.sh
cd ../

# Create build directory structure.
mkdir -p build
mkdir -p build/obj
mkdir -p build/gen
mkdir -p build/lib
mkdir -p build/bin

echo " "
echo "Project workspace setup complete."
