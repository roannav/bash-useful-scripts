#!/bin/bash

# INPUT: full directory path
#
# Recursively goes through each directory
# and within each directory looks at each file.
# Within a directory, every time there are filenames
# that have a space in them, replace the spaces with
# and underscore, but only if it won't become the
# same name as another file in the same directory. 
# Don't overwrite another existing file, when the renaming happens. 
#
# Will skip looking in the `resources` directory.
# This script is useful for renaming Obsidian files,
# so that they don't have any spaces in them.
#
# OUTPUT: filenames with spaces will be replaced with `_`s

# Check if the user provided a directory path
if [ -z "$1" ]; then
    echo "Usage: $0 <directory-path>"
    exit 1
fi

# Ensure the given path is a valid directory
if [ ! -d "$1" ]; then
    echo "Error: '$1' is not a directory."
    exit 1
fi

# Function to replace spaces with underscores in filenames, while skipping `_resources` directories
rename_files() {
    local dir="$1"

    # Loop through all files and directories in the current directory
    for file in "$dir"/*; do
        if [ -d "$file" ]; then
            # Skip directories named '_resources'
            if [[ "$(basename "$file")" == "_resources" ]]; then
                echo "Skipping directory '$file'"
                continue
            fi
            # If it's another directory, recursively call the function
            rename_files "$file"
        elif [ -f "$file" ]; then
            # If it's a file, check if it contains spaces
            if [[ "$file" == *" "* ]]; then
                # Create the new filename by replacing spaces with underscores
                new_file="${file// /_}"

                # Only rename if a file with the new name doesn't already exist
                if [ ! -e "$new_file" ]; then
                    echo "Renaming '$file' to '$new_file'"
                    mv "$file" "$new_file"
                else
                    echo "Skipping '$file' (rename would cause a conflict with an existing file)"
                fi
            fi
        fi
    done
}

# Call the rename function on the provided directory
rename_files "$1"

echo "Done."
