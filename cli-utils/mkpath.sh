#!/bin/bash

# Function to print usage
print_usage() {
    echo "Usage: mkpath [-c|--cd] path"
    echo "Creates directories and/or files, then optionally changes to that directory"
    echo "  -c, --cd    Change to the created directory after creation"
    exit 1
}

# Check if no arguments provided
if [ $# -eq 0 ]; then
    print_usage
fi

# Parse arguments
cd_after=false
path=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--cd)
            cd_after=true
            shift
            ;;
        *)
            path="$1"
            shift
            ;;
    esac
done

# Check if path is provided
if [ -z "$path" ]; then
    print_usage
fi

# Convert to absolute path
if [[ "$path" = /* ]]; then
    abs_path="$path"
else
    abs_path="$(pwd)/$path"
fi

# Remove trailing slash if exists
abs_path="${abs_path%/}"

# Determine if the path is a file or directory
if [[ "$abs_path" =~ \. ]]; then
    # It's likely a file
    dir_path=$(dirname "$abs_path")
    mkdir -p "$dir_path"
    touch "$abs_path"
else
    # It's a directory
    mkdir -p "$abs_path"
fi

# Change directory if --cd flag is set
if [ "$cd_after" = true ]; then
    if [[ "$abs_path" =~ \. ]]; then
        cd "$dir_path"
    else
        cd "$abs_path"
    fi
else
    echo "$abs_path"
fi
