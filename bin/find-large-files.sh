#!/bin/bash

# Usage: find-large-files.sh <size-in-mb>

if [ -z "$1" ]; then
  echo "Usage: $0 <size-in-mb>"
  exit 1
fi

SIZE_MB=$1
SIZE_BYTES=$((SIZE_MB * 1024 * 1024))

mdfind "kMDItemFSSize > $SIZE_BYTES" | while read -r file; do
  if [ -f "$file" ]; then
    SIZE=$(stat -f%z "$file")
    SIZE_MB_DISPLAY=$(echo "scale=2; $SIZE / 1024 / 1024" | bc)
    echo "$SIZE_MB_DISPLAY MB	$file"
  fi
done | sort -rn
