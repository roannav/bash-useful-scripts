#!/bin/bash

# INPUT: full directory path
#
# Recursively goes through each directory
# and within each directory looks at each file.
# Within a directory, every time there are files
# that have the same name (ignoring case),
# print the directory and the same name files in it.

# Check if a directory path is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <full-directory-path>"
  exit 1
fi

# Assign the provided path to a variable
DIR_PATH="$1"

# Check if the provided path is a valid directory
if [ ! -d "$DIR_PATH" ]; then
  echo "Error: $DIR_PATH is not a valid directory"
  exit 1
fi

# Recursively go through each directory
find "$DIR_PATH" -type d | while read -r dir; do
  # Get all files in the directory, ignoring case
  files=$(find "$dir" -maxdepth 1 -type f | sed 's:.*/::' | tr '[:upper:]' '[:lower:]')

  # Sort and find duplicate file names
  duplicates=$(echo "$files" | sort | uniq -d)

  # If duplicates are found, print the directory and matching files
  if [ -n "$duplicates" ]; then
    echo "Directory: $dir"
    echo "Duplicate files:"

    # Print the actual filenames that match the duplicates
    for duplicate in $duplicates; do
      find "$dir" -maxdepth 1 -type f -iname "$duplicate"
    done
    echo
  fi
done
