#!/bin/bash

# This script checks shell scripts for syntax errors using shellcheck.

echo "Running pre-commit hook..."

# Check if shellcheck is available
if ! command -v shellcheck &> /dev/null; then
    echo "Error: shellcheck is not installed. Please install shellcheck to use this pre-commit hook."
    exit 1
fi

# Initialize an empty array to hold shell script filenames
SH_FILES=()

# Iterate through staged files
while IFS= read -r file; do
    if [[ "$file" == *.sh ]]; then
        SH_FILES+=("$file")
    fi
done < <(git diff --cached --name-only --diff-filter=ACMRT)

# Check if there are any .sh files to process
if [[ ${#SH_FILES[@]} -eq 0 ]]; then
    echo "No shell script files found for checking. Pre-commit hook completed successfully."
    exit 0
fi

# Iterate through the array of shell script filenames
for file in "${SH_FILES[@]}"; do
    echo "Checking $file with shellcheck..."
    
    if  ! shellcheck "$file"; then
        echo "Shellcheck found issues in $file. Commit aborted."
        exit 1
    fi
done

echo "Pre-commit hook completed successfully."
exit 0

