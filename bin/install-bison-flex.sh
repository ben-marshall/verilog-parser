#!/bin/bash

echo "Installing flex and bison"
echo " "

echo "Installing Flex..."
apt-get install -qq flex

echo "Installing Bison..."
apt-get install -qq bison

echo "Done"
