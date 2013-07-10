# Load the shell dotfiles, copied from https://github.com/mathiasbynens/dotfiles/blob/master/.bash_profile
for file in ~/.{bash_prompt,private_vars}; do
	[ -r "$file" ] && source "$file"
done
unset file

export CLICOLOR=1
export LSCOLORS=CxFxBxDxCxegedabagacad
export PATH=$HOME/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/git/bin:/Applications/MAMP/Library/bin:.

alias ll='ls -al'
alias desktop='cd ~/Desktop'
# Sublime shortcut
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

# extend git with hub tools https://github.com/defunkt/hub
alias git=hub

# rbenv
eval "$(rbenv init -)"

# navigate to development directory
function dev() {
	local DEV_DIR=~/Dropbox/Development/vhosts
	cd $DEV_DIR
	# if there is argument passed in, try to find that directory
	# if child directory exists, cd into that dir
	if [ $1 ]; then
		if [ $1 == 'ups' ]; then
			cd upstatement
		fi
		if [ -d $1 ]; then
			cd $1
		fi
	fi
}

function theme() {
	cd wp-content/themes
	if [ $1 ]; then
		if [ -d $1 ]; then
			cd $1
		fi
	fi
}

# From http://stackoverflow.com/questions/370047/#370255
function path_remove() {
	IFS=:
	# convert it to an array
	t=($PATH)
	unset IFS
	# perform any array operations to remove elements from the array
	t=(${t[@]%%$1})
	IFS=:
	# output the new array
	echo "${t[*]}"
}