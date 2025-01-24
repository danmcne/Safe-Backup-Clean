# Safe Cleanup of Backup Files in Older Versions Directory

This script helps clean up backup files stored in an "older_versions" directory by comparing them with their counterparts in the main directory. If the files are identical (which can happen sometimes if rsync looks at modification times), the backup files are deleted to save space. The script includes safety checks to avoid accidental data loss.

## Features
- Compares files in a backup directory (`older_versions`) with their counterparts in a main directory.
- Deletes backup files if they are identical to the originals.
- Ensures the full paths of files being compared are different to avoid unintended deletions.
- Checks if the `older_versions` directory and main directory are the same and prompts for user confirmation before proceeding.
- Provides a usage help message for guidance.

## Prerequisites
- A Unix-like operating system (e.g., Linux, macOS).
- Bash shell.
- The `diff` command for comparing files.

## Notes
File names in the "older versions" directory are assumed to be of the form "filename.ext~anything", where the original file is "filename.ext".

## Usage

### 1. Download the Script
Save the script as `safe_cleanup_older_versions.sh` in your preferred directory.

### 2. Make the Script Executable
Run the following command to make the script executable:
```bash
chmod +x safe_cleanup_older_versions.sh
```

### 3. Run the Script
Use the following syntax to run the script:
```bash
./safe_cleanup_older_versions.sh <older_versions_directory> <main_directory>
```

#### Arguments:
- `<older_versions_directory>`: Path to the directory containing the older versions of files.
- `<main_directory>`: Path to the directory containing the main files to compare against.

#### Example:
```bash
./safe_cleanup_older_versions.sh /path/to/older_versions /path/to/main_tree
```

### 4. Help
To display usage instructions:
```bash
./safe_cleanup_older_versions.sh
```

## Safety Features
1. **Directory Comparison Check**: The script checks if the `older_versions` directory and `main_directory` are the same. If they are, it asks for user confirmation before proceeding. The default action is to cancel the operation unless the user explicitly types `yes`.
2. **File Path Check**: Ensures that the full paths of the files being compared are not identical before performing any operations.
3. **Default "No" Confirmation**: If the user presses Enter or provides invalid input when asked to confirm, the operation is canceled.

## Example Outputs
1. **When directories are the same**:
    ```
    Warning: The older_versions directory and main directory are the same!
    This could result in unintended file deletions.
    Are you sure you want to proceed? (yes/no): 
    ```
    - Pressing Enter or typing anything other than `yes` cancels the operation:
      ```
      Operation canceled. No changes were made.
      ```

2. **When files are identical**:
    ```
    Deleting identical backup file: /path/to/older_versions/file~2025-01-14
    ```

3. **When no match is found**:
    ```
    Main file not found for: /path/to/older_versions/file~2025-01-14
    ```

4. **When file paths are identical**:
    ```
    Skipping comparison for identical paths: /path/to/file
    ```

## Contributing
If you have ideas to improve this script, feel free to open a pull request or submit an issue on GitHub.

## License
This script is open-source and available under the MIT License.
