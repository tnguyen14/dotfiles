#!/bin/bash

# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }

# link file
# $1: directory path to link to
# $2: file
function link_file() {
	if [[ -f "$2" ]]; then
		base=$(basename "$2")
		if [[ "$2" -ef "$1"/"$base" ]]; then
			e_arrow "Skipping $base"
		else
			e_success "Linking $base"
			ln -sfv $(pwd)/"$2" "$1"/"$base"
		fi
	fi
}

e_header "Linking files..."
for file in home/{.,}*; do
	link_file ~ "$file"
done

sublimePath=~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
if [[ -d $sublimePath ]]; then
	e_header "Setting up Sublime Text settings..."
	for file in sublime/*.sublime-settings; do
		link_file "$sublimePath" "$file"
	done;
fi
