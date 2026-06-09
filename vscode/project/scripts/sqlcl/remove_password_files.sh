#!/bin/bash

# Find all password (*.pwd) files and remove them from the projects local filesystem
echo "Remove password files from projects local filesystem:"
find . -name "*.pwd" -printf "%p\n" -type f -delete -o -name "passwords" -printf "%p\n" -type d -exec rmdir {} \;
echo ""
echo "Succesfully removed all plain-text password files"
