#!/bin/bash

otherArguments=""

nextArgIsToolchain=false
nextArgIsInput=false
nextArgIsSetting=false
nextArgIsCsvDir=false

# make file path absolute
absolutePath () {
  if [[ "$1" = /* ]]; then
    echo "$1"
  else
    echo "$(pwd)/$1"
  fi
}

# Parse arguments
for argument in "$@" 
do
  case "$argument" in
    "-tc")
      echo "Toolchain found"
      nextArgIsToolchain=true
      ;;
    "-i")
      echo "Input file found"
      nextArgIsInput=true
      ;;
    "-s")
      echo "Settings found"
      nextArgIsSetting=true
      ;;
    "--csv-dir")
      echo "CSV directory given"
      nextArgIsCsvDir=true
      ;;
    *)
      if test "$nextArgIsToolchain" = true; then
        toolchainFile=$( absolutePath $argument)
        nextArgIsToolchain=false
      elif test "$nextArgIsInput" = true; then
        sourceFile=$( absolutePath $argument)
        nextArgIsInput=false
      elif test "$nextArgIsSetting" = true; then
        settingFile=$( absolutePath $argument)
        nextArgIsSetting=false
      elif test "$nextArgIsCsvDir" = true; then
        csvDir=$( absolutePath $argument)
        nextArgIsCsvDir=false
      else
        otherArguments+="${argument} "
      fi
  esac
done

# Start Ultimate inside docker container if all arguments are valid
mountArguments="--mount type=bind,source=$(pwd)/logfiles,target=/home/logfiles "

if [[ -f "$settingFile" ]]; then
  mountArguments+="--mount type=bind,source=${settingFile},target=/home/userfiles/$(basename $settingFile) "
else
  echo "No settings found"
fi

if [[ -f $toolchainFile ]]; then
  mountArguments+="--mount type=bind,source=${toolchainFile},target=/home/userfiles/$(basename $toolchainFile) "
else
  echo "No toolchain definition found"
fi

if [[ -f $sourceFile ]]; then
  mountArguments+="--mount type=bind,source=${sourceFile},target=/home/userfiles/$(basename $sourceFile) "
else
  echo "No source for input found"
fi

if [[ -d $csvDir ]]; then
  mountArguments+="--mount type=bind,source=${csvDir},target=/home/csvfiles/ "
else
  echo "No CSV directory to mount"
fi

mkdir -p ./logfiles

# Build and execute container
docker build -f Dockerfile_UAWrapper -t ultimate-wrapper .
docker run $mountArguments --env OTHER_ARGUMENTS="$otherArguments" --rm ultimate-wrapper #/bin/bash
