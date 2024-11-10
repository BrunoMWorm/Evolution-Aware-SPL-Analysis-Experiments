#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <destination_folder>"
    exit 1
fi

cd $BUSYBOX_DIR

# Destination folder
destination_folder="$1"

# Create the destination folder if it doesn't exist
mkdir -p "$destination_folder"

# Read paths from the file
while IFS= read -r path; do
    # Extract the filename
    filename=$path.cfg
    
    # Replace "/" with "."
    new_filename=$(echo "$filename" | sed 's/\//./g')    
    # Copy the file to the destination folder with the new name
    cp "$filename" "$destination_folder/$new_filename"
    
    echo "Copied $path to $destination_folder/$new_filename"
done < filelist

echo "All files copied successfully to $destination_folder"

