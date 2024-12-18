# bash-useful-scripts
created 20241022

### find_duplicate_files.sh
only prints duplicate filename

### rename_duplicate_files_by_appending2.sh
Similar to `find_duplicate_files.sh`, except it actually renames the duplicate files by appending a `2` to the end of the duplicate filename.

### rename_files_from_underscore_to_space.sh
Filenames with `_`s will be replaced with spaces.
Doesn't skip any directories.

### rename_files_from_spaces_to_underscores.sh
Filenames with spaces will be replaced with `_`s
Will skip looking in the `resources` directory.
This script is useful for renaming Obsidian files,
so that they don't have any spaces in them.

### rename_directories.sh
Replaces spaces with underscores for all subdirectories.