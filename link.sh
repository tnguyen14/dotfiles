#!/bin/bash

echo "Linking files..."
for file in link/{.,}*; do
	if [[ -f $file ]]; then
		base="$(basename $file)"
		# check if it already exists
		if [[ $file -ef ~/"$base" ]]; then
			echo "Skipping $base"
			continue
		fi
		ln -sfv `pwd`/$file ~/
	fi
done
