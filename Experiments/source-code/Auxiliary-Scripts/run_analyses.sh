#!/bin/bash

cd $WORKDIR

mkdir -p results

export LD_LIBRARY_PATH=/usr/local/lib

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <analysis>"
    exit 1
fi

analysis="$1"

mkdir -p results/$analysis
prev_revision="None"

while IFS= read -r revision; do
    mkdir -p results/$analysis/$revision
    for fileDir in "$ARTIFACTS_DIR/$revision/cfgs/original"/*; do
        file=$(basename $fileDir)
        echo "Running $analysis on $file for revision $revision (previous revision: $prev_revision)."
        timeout 120m $BUILDED_ANALYSES_DIR/$analysis --filename="$file" --fileversion="$revision" --previousversion="$prev_revision" --csv="results/$analysis/stats.csv" --output="results/$analysis/$revision/$file.json" --template=json --time-limit=0.2 &> results/$analysis/$revision/$file.output;
        cat results/$analysis/$revision/$file.output;
        echo "Done."
    done   
    prev_revision=$revision
done < $SCRIPTS_DIR/revision_list
