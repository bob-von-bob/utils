#!/bin/bash

is_push_final() {
    read -r -p "Is this the final push before opening a PR? (y/n): " response
    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

is_push_final
DO_ALL_CHECKS=$?

if [ $DO_ALL_CHECKS -eq 0 ]; then
    echo "Performing all checks..."
    # Add your checks and validation steps here
else
    echo "Skipping checks..."
fi

