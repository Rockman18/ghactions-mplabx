#!/bin/sh

echo "Docker Container Building $1:$2"

set -x -e

prjMakefilesGenerator.sh $1@$2 || exit 1
make -C $1 CONF=$2 build || exit 2

tree /github/workspace/$1/dist
cp -r /github/workspace/$1/dist /github/workspace/output 
