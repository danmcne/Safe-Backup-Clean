#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 <older_versions_directory> <main_directory>"
    echo
    echo "Compares files in the older_versions directory with their counterparts in the main directory."
    echo "If the files are identical, the files in older_versions are deleted."
    echo
    echo "Arguments:"
    echo "  older_versions_directory    Path to the directory containing older versions of files."
    echo "  main_directory              Path to the main directory to compare against."
    exit 1
}

# Check if the correct number of arguments is provided
if [[ "$#" -ne 2 ]]; then
    usage
fi

# Assign command-line arguments to variables
OLDER_VERSIONS_DIR="$(realpath "$1")"
MAIN_DIR="$(realpath "$2")"

# Validate the directories
if [[ ! -d "$OLDER_VERSIONS_DIR" ]]; then
    echo "Error: older_versions directory '$OLDER_VERSIONS_DIR' does not exist."
    exit 1
fi

if [[ ! -d "$MAIN_DIR" ]]; then
    echo "Error: main directory '$MAIN_DIR' does not exist."
    exit 1
fi

# Check if the directories are the same
if [[ "$OLDER_VERSIONS_DIR" == "$MAIN_DIR" ]]; then
    echo "Warning: The older_versions directory and main directory are the same!"
    echo "This could result in unintended file deletions."
    read -p "Are you sure you want to proceed? (yes/no): " confirmation
    confirmation="${confirmation,,}" # Convert to lowercase for consistency
    if [[ "$confirmation" != "yes" ]]; then
        echo "Operation canceled. No changes were made."
        exit 1
    fi
fi

# Traverse through all files in the older_versions directory
find "$OLDER_VERSIONS_DIR" -type f | while read -r backup_file; do
    # Extract the relative path and file name
    relative_path="${backup_file#$OLDER_VERSIONS_DIR/}"
    original_name=$(basename "$relative_path")
    dir_name=$(dirname "$relative_path")

    # Split the file name at '~' to get the original file name
    original_base_name="${original_name%%~*}"

    # Construct the path to the corresponding file in the main directory
    main_file="$MAIN_DIR/$dir_name/$original_base_name"

    # Check if the corresponding file exists in the main directory
    if [[ -f "$main_file" ]]; then
        # Check that the files being compared have different paths
        if [[ "$backup_file" != "$main_file" ]]; then
            # Compare the backup file with the main file
            if diff -q "$backup_file" "$main_file" > /dev/null; then
                # Files are identical, delete the backup file
                echo "Deleting identical backup file: $backup_file"
                rm "$backup_file"
            fi
        else
            echo "Skipping comparison for identical paths: $backup_file"
        fi
    else
        echo "Main file not found for: $backup_file"
    fi
done

