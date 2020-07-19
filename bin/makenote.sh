#!/usr/bin/env bash

noteDirectory="$HOME/Dropbox/Documents/Notes/src/"
noteFilename="$noteDirectory/dailynote-$(date +%Y-%m-%d).md"

mkdir -p $noteDirectory

if [ ! -f $noteFilename ]; then
  echo "# Notes for $(date +%Y-%m-%d)" > $noteFilename
fi

vim -c "norm Go" \
  -c "norm Go## $(date +%H:%M)" \
  -c "norm G2o" \
  -c "norm zz" \
  -c "startinsert" $noteFilename
