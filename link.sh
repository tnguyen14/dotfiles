#!/usr/bin/env bash

# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }

# $1: file
# $2: directory path to link to
function do_link() {
	base=$(basename "$1")
	if [ "$1" -ef "$2/$base" ]; then
		e_arrow "Skipping $base"
	else
		ln -sfv "$1" "$2/$base"
		if [ $? == 0 ]; then
			e_success "Linked $base"
		else
			e_error "Failed to link $base to $2"
		fi
	fi
}
# link file
# $1: file
# $2: directory path to link to
function link_file() {
	if [ -f "$1" ]; then
		case "$1" in
			# ignore .swp files
			*.swp) 
				continue
				;;
			*) 
				do_link "$1" "$2"
				;;
		esac
	elif [ -d "$1" ]; then
		base=$(basename "$1")
		case "$base" in
			# skip current or prev directory
			.|..)
				continue
				;;
			# recursively call link_dir
			*)
				link_dir "$1" "$2/$base"
				;;
		esac
	fi
}

# link dir
# $1: directory to link
# $2: directory to link to
function link_dir() {
	for file in $1/{.,}*; do
		link_file "$file" "$2"
	done
}
e_header "Setting up \$HOME dotfiles..."
link_dir "$(pwd)/home" "$HOME"

sublimePath=~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
if [ -d "$sublimePath" ]; then
	e_header "Setting up Sublime Text settings..."
	link_dir "$(pwd)/sublime" "$sublimePath"
fi

atomPath=~/.atom
if [ -d "$atomPath" ]; then
	e_header "Setting up Atom settings..."
	link_dir "$(pwd)/atom" "$atomPath"
fi
