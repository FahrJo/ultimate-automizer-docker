#!/bin/bash

lastOptWasT=false;

# Parse arguments
while getopts 's:tc:i:h' opt; do
  if [[ "$OPTARG" = /* ]]; then
    path=$OPTARG
  else
    path="$(pwd)"/"$OPTARG"
  fi

  case "$opt" in
    s)
      settingFile="$path"
      echo "settings:   $settingFile"
      lastOptWasT=false
      ;;

    t)
      lastOptWasT=true
      ;;

    c)
      if $lastOptWasT; then
        toolchainFile="$path"
        echo "toolchain:  $toolchainFile"
        lastOptWasT=false
      else
        echo "Invalid option c"
        exit 1
      fi
      ;;

    i)
      sourceFile="$path"
      echo "source:     $sourceFile"
      lastOptWasT=false
      ;;
   
    ?|h)
      echo "Usage: $(basename $0) [-tc toolchainFile] [-s settingFile] [-i sourceFile]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

# Start Ultimate inside docker container if all arguments are valid
if [[ ! -f "$settingFile" ]]; then
    echo "no settings found"
    exit 1
elif [[ ! -f $toolchainFile ]]; then
    echo "no toolchain definition found"
    exit 1
elif [[ ! -f $sourceFile ]]; then
    echo "no source for input found"
    exit 1
else
    mkdir ./logfiles

    docker build -f Dockerfile_UAWrapper -t ultimate-wrapper .
    docker run \
        --mount type=bind,source="$settingFile",target=/home/userfiles/"$(basename $settingFile)" \
        --mount type=bind,source="$toolchainFile",target=/home/userfiles/"$(basename $toolchainFile)" \
        --mount type=bind,source="$sourceFile",target=/home/userfiles/"$(basename $sourceFile)" \
        --mount type=bind,source="$(pwd)"/logfiles,target=/home/logfiles \
        --rm \
        ultimate-wrapper #/bin/bash
fi
