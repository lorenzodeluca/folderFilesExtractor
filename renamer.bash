#!/bin/bash

# Directory configuration
source="L:/source"
dest="L:/dest"

# Convert possible Windows paths to Unix format if needed
source="${source//\\//}"
dest="${dest//\\//}"

# Create destination directory if it does not exist
mkdir -p "$dest"

# Initialize file counter
counter=1

# Function to get modification year and month
get_mod_date() {
    local file="$1"
    # Get file modification date; works for Linux/macOS
    # Linux:
    mod_time=$(stat -c "%y" "$file" 2>/dev/null)
    if [ -z "$mod_time" ]; then
        # macOS fallback
        mod_time=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$file")
    fi
    # Extract year and month
    year=$(echo "$mod_time" | awk -F'[- ]' '{print $1}')
    month=$(echo "$mod_time" | awk -F'[- ]' '{print $2}')
    echo "$year" "$month"
}

# Recursively find all files in source directory
find "$source" -type f | while read -r file; do
    # Get modification year and month
    read modYear modMonth < <(get_mod_date "$file")

    # Get filename (without extension) and extension
    base=$(basename "$file")
    filename="${base%.*}"          # Name without extension
    extension="${base##*.}"        # File extension

    # Construct new filename
    newname="${modYear}-${modMonth}-${filename}-${counter}.${extension}"

    # Copy file to destination with new name
    cp "$file" "$dest/$newname"

    echo "Copied: $file -> $dest/$newname"

    counter=$((counter + 1))
done

echo ""
echo "Operation completed. Total files processed: $((counter-1))"
