#!/bin/bash

################################################################################
# This script creates a directory structure for a device driver project using
# the provided project name. It sets up include, src, and tests directories,
# along with CMakeLists.txt files for each directory. Source files and CMake
# configurations are named based on the provided project name.
# Usage: ./create_project.sh <project_name>
################################################################################

if [ $# -eq 0 ]; then
    echo "Usage: $0 <project_name>"
    exit 1
fi

project_name="$1"

# Create the project directory
mkdir -p "$project_name"
cd "$project_name" || exit 1

# Create subdirectories
mkdir include
mkdir src
mkdir tests

# Create include directory contents
touch include/"$project_name".h

# Create src directory contents
touch src/"$project_name".c
touch src/CMakeLists.txt

# Create tests directory contents
touch tests/test_"$project_name".c
touch tests/CMakeLists.txt

# Create top-level CMakeLists.txt
cat <<EOT > CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
project($project_name)

# Include subdirectories
add_subdirectory(src)
add_subdirectory(tests)
EOT

# Create src/CMakeLists.txt
cat <<EOT > src/CMakeLists.txt
add_library($project_name $project_name.c)
target_include_directories($project_name PUBLIC \${CMAKE_CURRENT_SOURCE_DIR}/../include)
EOT

# Create tests/CMakeLists.txt
cat <<EOT > tests/CMakeLists.txt
add_executable(test_$project_name test_$project_name.c)
target_link_libraries(test_$project_name PRIVATE $project_name)
EOT

echo "Device driver project '$project_name' directory structure created successfully!"
