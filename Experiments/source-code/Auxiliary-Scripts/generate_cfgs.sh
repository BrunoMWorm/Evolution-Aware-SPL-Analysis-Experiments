#!/bin/bash

source "$HOME/.sdkman/bin/sdkman-init.sh"

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <revision>"
    exit 1
fi

# Destination folder
revision="$1"

sdk use java 8.0.412-zulu

cd $BUSYBOX_TYPECHEF_DIR
./cleanBusyboxGit.sh

cd $BUSYBOX_DIR
git reset --hard $revision
git clean -f

cd $BUSYBOX_TYPECHEF_DIR
./prepareGit.sh
./prepareGit.sh
./analyzeBusyboxGit.sh
