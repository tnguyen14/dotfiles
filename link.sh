#!/usr/bin/env bash

# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }
function e_reset()    { echo -e "\033[0m"; }

function usage() {
	cat << EOF
Usage: link.sh [options]

Options:
    -h, --help      Show help options
    --nobackup      Skip backup
EOF
}

backup=1

# http://stackoverflow.com/questions/402377/using-getopts-in-bash-shell-script-to-get-long-and-short-command-line-options/7680682#7680682
optspec=":h-:"
while getopts "$optspec" optchar; do
	case "${optchar}" in
		-)
			case "${OPTARG}" in
				nobackup)
					backup=0
					;;
				help)
					usage
					exit
					;;
			esac;;
		h)
			usage
			exit
			;;
	esac
done

# Create a .backup directory in the destination folder
# move the existing file there if it's not a symlink
# skip if $backup is set to 0
function do_backup() {
	if [ $backup -eq 0 ]; then
		return
	fi
	mkdir -p "$1"/.backup
	if [ -f "$1/$base" ] && [ ! -L "$1/$base" ]; then
		mv "$1/$2" "$1"/.backup/
		if [ $? -eq 0 ]; then
			e_success "Backed up $2 to $1/.backup/"
		else
			e_error "Failed to back up $2"
			return 1
		fi
	fi
}

# $1: full path of file to be linked to
# $2: directory path to link to
function do_link() {
	base=$(basename "$1")
	# if the file already hard links to the same file, skip it
	if [ "$1" -ef "$2/$base" ]; then
		e_arrow "Skipping $2/$base"
		return
	fi
	# try to backup first, and if unsuccessful, skip
	do_backup "$2" "$base"
	if [ $? -ne 0 ]; then
		e_arrow "Skipping $base"
		return 1
	fi
	ln -sfv "$1" "$2/$base"
	if [ $? -eq 0 ]; then
		e_success "Linked $base"
	else
		e_error "Failed to link $base to $2"
	fi
}
# link file
# $1: file to be linked to
# $2: directory path to link to
function link_file() {
	if [ -f "$1" ]; then
		case "$1" in
			# ignore .swp or .DS_Store files
			*.swp|*.DS_Store) 
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
	# if destination dir does not exist
	if [ ! -d "$2" ]; then
		mkdir -p "$2"
	fi
	if [ -d "$1" ] && [ -d "$2" ]; then
		for file in "$1"/{.,}*; do
			link_file "$file" "$2"
		done
	fi
}
e_header "Setting up \$HOME dotfiles..."
link_dir "$(pwd)/home" "$HOME"

# macos specific stuff
if [[ "$OSTYPE" =~ ^darwin ]]; then
	link_dir "$(pwd)/macos/home" "$HOME"
fi

e_reset
