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

echo "Setting up Sublime Text settings..."
for file in sublime/*.sublime-settings; do
	sublimePath=~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
	base=$(basename "$file")
	echo $base
	if [[ -f "$sublimePath"/"$base" ]]; then
		echo "Skipping $base"
		continue
	fi
	ln -sv $(pwd)/"$file" "$sublimePath"/"$base"
done;
