#!/bin/bash

source "$HOME/.sdkman/bin/sdkman-init.sh"

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <typechef_tag>"
    exit 1
fi

cd $TYPECHEF_DIR

typechef_tag="$1"

git checkout $typechef_tag

sdk use java 8.0.412-zulu

sbt mkrun
sbt publishLocal