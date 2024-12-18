#!/bin/bash

# INPUT: full directory path
#
# Recursively goes through each directory
# and within each directory looks at each file.
# Within a directory, every time there are files
# that have the same name (ignoring case),
# print the directory and the same name files in it.
#
# OUTPUT: Renames the duplicate file by appending a "2"
# to the end of the filename. Prints the duplicate files.

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

# Function to append '2' before the extension of a file
rename_file() {
  local file_path="$1"
  local base_name=$(basename "$file_path")
  local dir_name=$(dirname "$file_path")
  
  # Extract filename without extension and extension
  local filename="${base_name%.*}"
  local extension="${base_name##*.}"

  # Create a new name by appending '2' before the extension
  if [ "$filename" == "$base_name" ]; then
    # If there's no extension
    new_name="${filename}2"
  else
    new_name="${filename}2.${extension}"
  fi

  # Full path of the new file
  new_file_path="$dir_name/$new_name"

  # Ensure the new filename doesn't overwrite an existing file
  if [ ! -e "$new_file_path" ]; then
    mv "$file_path" "$new_file_path"
    echo "Renamed '$file_path' to '$new_file_path'"
  else
    echo "File '$new_file_path' already exists, skipping rename."
  fi
}

# Recursively go through each directory
find "$DIR_PATH" -type d | while read -r dir; do
  # Get all files in the directory, ignoring case
  files=$(find "$dir" -maxdepth 1 -type f | sed 's:.*/::' | tr '[:upper:]' '[:lower:]')
  
  # Sort and find duplicate file names
  duplicates=$(echo "$files" | sort | uniq -d)
  
  # If duplicates are found, handle them
  if [ -n "$duplicates" ]; then
    echo "Directory: $dir"
    echo "Duplicate files:"
    
    # Print the actual filenames that match the duplicates and rename one of them
    for duplicate in $duplicates; do
      matching_files=$(find "$dir" -maxdepth 1 -type f -iname "$duplicate")
      
      count=0
      for file in $matching_files; do
        echo "$file"
        
        # Rename one of the duplicates
        if [ $count -eq 1 ]; then
          rename_file "$file"
        fi
        count=$((count + 1))
      done
    done
    echo
  fi
done

