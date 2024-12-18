#!/bin/bash

# INPUT: full directory path
#
# Recursively goes through each directory and within each directory
# it looks at each subdirectory. Within a directory, every time
# there are subdirectory names that have spaces in them, replace
# the spaces with an underscore, but only if it won't become the
# same name as another subdirectory in the same directory.
# Don't overwrite another existing subdirectory, when the renaming happens.

# Check if the user provided a directory path
if [ -z "$1" ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

# Root directory to start the recursive operation
root_dir="$1"

# Function to rename directories recursively
rename_directories() {
    local dir="$1"

    # Find subdirectories within the current directory
    find "$dir" -mindepth 1 -maxdepth 1 -type d | while read subdir; do
        # Extract the directory name
        dirname=$(basename "$subdir")

        # Check if the directory name contains spaces
        if [[ "$dirname" == *" "* ]]; then
            # Replace spaces with underscores
            new_dirname="${dirname// /_}"
            new_dirpath="$(dirname "$subdir")/$new_dirname"

            # Check if a directory with the new name already exists
            if [ ! -d "$new_dirpath" ]; then
                echo "Renaming: '$subdir' -> '$new_dirpath'"
                mv "$subdir" "$new_dirpath"
            else
                echo "Skipping: '$subdir' -> '$new_dirpath' already exists"
            fi
        fi

        # Call the function recursively to go deeper into the directory structure
        rename_directories "$subdir"
    done
}

# Start the renaming process from the root directory
rename_directories "$root_dir"
