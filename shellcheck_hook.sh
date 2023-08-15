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

# Iterate through staged files and collect .sh filenames
while IFS= read -r file; do
    if [[ "$file" == *.sh ]]; then
        SH_FILES+=("$file")
    fi
done < <(git diff --cached --name-only --diff-filter=ACMRT)

# Initialize the SHELLCHECK_ERROR counter
SHELLCHECK_ERROR=0

# Iterate through the array of shell script filenames
for file in "${SH_FILES[@]}"; do
    echo "Checking $file with shellcheck..."
    
    if ! shellcheck "$file"; then
        echo "Shellcheck found issues in $file."
        ((SHELLCHECK_ERROR++))
    fi
done

# Check if any errors were found
if [[ $SHELLCHECK_ERROR -ne 0 ]]; then
    echo "Commit aborted due to shellcheck errors."
    exit 1
fi

echo "Pre-commit hook completed successfully."
exit 0

