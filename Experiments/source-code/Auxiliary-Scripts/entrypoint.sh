
#!/bin/bash

export WORKDIR="/opt/experiments"

export BUSYBOX_TYPECHEF_DIR="$WORKDIR/source-code/TypeChef-BusyboxAnalysis"
export BUSYBOX_DIR="$BUSYBOX_TYPECHEF_DIR/gitbusybox"
export TYPECHEF_DIR="$WORKDIR/source-code/TypeChef"
export ARTIFACTS_DIR="$WORKDIR/artifacts"
export ANALYSIS_DIR="$WORKDIR/artifacts"
export BUILDED_ANALYSES_DIR="$WORKDIR/builded_analyses"
export SCRIPTS_DIR="$WORKDIR/source-code/Auxiliary-Scripts"

mkdir -p $ARTIFACTS_DIR

## UNCOMMENT THE FOLLOWING LINES FOR GENERATING THE CFG FILES AND CHANGED FUNCTIONS
## (IT WILL BE NECESSARY TO COMPILE BOTH ORIGINAL AND MODIFIED TYPECHEF VERSIONS)
## THE REPRODUCIBILITY PACKAGE COMES WITH THE CFGS AND CHANGED_FUNCTIONS ALREADY COMPUTED
# while IFS= read -r revision; do
#     cd $SCRIPTS_DIR
#     ./build_typechef.sh "full-cfg"

#     cd $SCRIPTS_DIR
#     time ./generate_cfgs.sh $revision

#     cd $SCRIPTS_DIR
#     ./extract_cfg_files.sh $ARTIFACTS_DIR/$revision/cfgs/original

#     cd $SCRIPTS_DIR
#     ./build_typechef.sh "stable-ids"

#     cd $SCRIPTS_DIR
#     time ./generate_cfgs.sh $revision

#     cd $SCRIPTS_DIR
#     ./extract_cfg_files.sh $ARTIFACTS_DIR/$revision/cfgs/stable_ids

# done < revision_list

# cd $SCRIPTS_DIR
# ./compute_changed_functions.sh

for analysis in Return GotosDensity DanglingSwitch CaseTermination ReturnAverage CallDensity; do
    cd $SCRIPTS_DIR
    nohup ./run_analyses.sh $analysis &> $analysis.out &
done
