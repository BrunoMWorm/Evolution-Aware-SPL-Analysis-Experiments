#!/bin/bash

# Define arrays for the hashes and analyses
hashes=("5ab20641d687bfe4d86d255f8c369af54b6026e7" \
        "1c31e9e82b12bdceeec4f8e07955984e20ee6b7e" \
        "3f2477e8a89ddadd1dfdd9d990ac8c6fdb8ad4b3" \
        "31905f94777ae6e7181e9fbcc0cc7c4cf70abfaf" \
        "0d6a4ecb30f596570585bbde29f7c9b42a60b623" \
        "2f7d9e8903029b1b5e51a15f9cb0dcb6ca17c3ac" \
        "6088e138e1c6d0b73f8004fc4b4e9ec40430e18e" \
        "0cd4f3039b5a6518eb322f26ed8430529befc3ae" \
        "642e71a789156a96bcb18e6c5a0f52416c49d3b5" \
        "df1689138e71fa3648209db28146a595c4e63c26")

analyses=("call-density" "case-termination" "dangling-switch" "gotos-density" "return" "return-average")

# Loop over each hash and analysis combination
for analysis in "${analyses[@]}"; do
    for hash in "${hashes[@]}"; do
        # Execute the find command with du -k for kilobytes and use awk to format the output with commas
        # find "$analysis/artifacts/$hash" -type d -name "memoization" -exec du -c --block-size="'1M" {} + | grep total | awk '{print $1}'
        find "$analysis/artifacts/$hash" -type d -name "memoization" -exec du -ch --block-size="'1k" {} + | grep total
    done
done

