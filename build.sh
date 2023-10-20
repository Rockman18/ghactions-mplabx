#!/bin/sh

set -x -e

for conf in $(echo $2 | sed "s/,/ /g"); do
  echo "Building project $1 with configuration $conf"
  prjMakefilesGenerator.sh $1@$conf || exit 1
  make -C $1 CONF=$conf build || exit 2
done
