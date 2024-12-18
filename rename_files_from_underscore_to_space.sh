#!/bin/bash

# INPUT: full directory path
#
# Recursively goes through each directory
# and within each directory looks at each file.
# Within a directory, every time there are filenames
# that have an underscore in them, replace the underscores with
# and spaces, but only if it won't become the
# same name as another file in the same directory. 
# Don't overwrite another existing file, when the renaming happens. 
#
# OUTPUT: filenames with `_`s will be replaced with spaces.

# Check if the user provided a directory path
if [ -z "$1" ]; then
  echo "Usage: $0 <directory-path>"
  exit 1
fi

# Assign the provided path to a variable
root_dir="$1"

# Verify that the provided argument is a valid directory
if [ ! -d "$root_dir" ]; then
  echo "Error: '$root_dir' is not a valid directory."
  exit 1
fi

# Recursively find all files within the directory and process them
find "$root_dir" -type f | while read -r file; do
  # Get the directory of the file and the file name
  dir=$(dirname "$file")
  original_name=$(basename "$file")
  
  # Create the new file name by replacing underscores with spaces
  new_name=$(echo "$original_name" | tr '_' ' ')

  # Only attempt renaming if the new name is different from the original
  if [ "$new_name" != "$original_name" ]; then
    # Check if the new file name already exists in the directory
    if [ ! -e "$dir/$new_name" ]; then
      # Perform the rename
      mv "$file" "$dir/$new_name"
      echo "Renamed: '$original_name' to '$new_name'"
    else
      echo "Skipping: '$original_name' -> '$new_name' (target file exists)"
    fi
  fi
done

