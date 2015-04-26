#!/bin/bash

# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }

e_header "Linking files..."
for file in link/{.,}*; do
	if [[ -f $file ]]; then
		base=$(basename "$file")
		# check if it already exists
		if [[ $file -ef ~/"$base" ]]; then
			e_arrow "Skipping $base"
			continue
		fi
		e_success $(ln -sfv $(pwd)/"$file" ~/"$base")
	fi
done

e_header "Setting up Sublime Text settings..."
for file in sublime/*.sublime-settings; do
	sublimePath=~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
	base=$(basename "$file")
	if [[ $file -ef "$sublimePath"/"$base" ]]; then
		e_arrow "Skipping $base"
		continue
	fi
	e_success $(ln -sfv $(pwd)/"$file" "$sublimePath"/"$base")
done;
