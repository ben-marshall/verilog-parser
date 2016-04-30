#!/bin/bash

echo "Setting up project workspace..."

mkdir -p build
cd build
cmake ..
cd ..

echo " "
echo "CMake and project workspace setup complete."
