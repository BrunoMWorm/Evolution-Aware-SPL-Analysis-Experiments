#!/bin/bash

# Function to compare files in two folders
compare_files_between_folders() {
    folder1="$ARTIFACTS_DIR/$1/cfgs/stable_ids"
    folder2="$ARTIFACTS_DIR/$2/cfgs/stable_ids"

    changed_functions_dir="$ARTIFACTS_DIR/$1/changed_functions"
    mkdir -p "$changed_functions_dir"

    # Iterate over files in the first folder
    for file1 in "$folder1"/*; do
        file2="$folder2/$(basename "$file1")"
        if [ -s "$file1" ]; then
            if [ -s "$file2" ]; then
                time python3 analyze_cfg_diff.py $file1 $file2 > "$changed_functions_dir/$(basename "$file1")"
            else
                echo "File '$file2' does not exist or is empty in $folder2"
            fi
        else
            echo "File '$file1' does not exist or is empty in $folder1"
        fi
    done
}

prev_folder=""
while IFS= read -r folder; do
    if [ -z "$prev_folder" ]; then
        prev_folder="$folder"
    else
        compare_files_between_folders "$folder" "$prev_folder"
        prev_folder="$folder"
    fi
done < revision_list
