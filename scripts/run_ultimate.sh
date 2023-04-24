#!/bin/bash

# look for input files
settingFile=$(find userfiles/*.epf)
toolchainFile=$(find userfiles/*.xml)
sourceFile=$(find userfiles/*.c)
csvDir=$(find csvfiles/dockerLocalFile)

fileArguments=""

if [[ -f $settingFile ]]; then
    fileArguments+="-s ${settingFile} "
else
    echo "No settings found"
fi

if [[ -f $toolchainFile ]]; then
    fileArguments+="-tc ${toolchainFile} "
else
    echo "No toolchain definition found"
fi

if [[ -f $sourceFile ]]; then
    fileArguments+="-i ${sourceFile} "
else
    echo "No source for input found"
fi

if [[ -e $csvDir ]]; then
    echo "CSV directory not defined"
else
    fileArguments+="--csv-dir csvfiles/ "
fi

timestamp=$(date +%y%m%d_%H%M%S%Z)
logfileName="logfiles/${timestamp}_ultimate.log"

# Execute Ultimate and save output to logfile
echo "+-------------------+"
echo "| Start ultimate... |"
echo "+-------------------+"
echo "Logfile: ${logfileName}"
echo "./Ultimate $OTHER_ARGUMENTS $fileArguments"
./Ultimate $OTHER_ARGUMENTS $fileArguments | tee $logfileName
