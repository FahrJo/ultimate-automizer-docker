#!/bin/bash

# look for input files
settingFile=$(find -E userfiles -regex ".*\.(epl|epf)")
toolchainFile=$(find userfiles/*.xml)
sourceFile=$(find userfiles/*.c)

if [[ ! -f $settingFile ]]; then
    echo "no settings found"
    exit 1
elif [[ ! -f $toolchainFile ]]; then
    echo "no toolchain definition found"
    exit 1
elif [[ ! -f $sourceFile ]]; then
    echo "no source for input found"
    exit 1
else
    timestamp=$(date +%y%m%d_%H%M%S%Z)
    # Execute Ultimate and save output to logfile
    echo "start ultimate..."
    ./Ultimate -tc $toolchainFile -s $settingFile -i $sourceFile | tee logfiles/"$timestamp"_ultimate.log
fi