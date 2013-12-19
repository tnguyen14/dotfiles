# Load the shell dotfiles, copied from https://github.com/mathiasbynens/dotfiles/blob/master/.bash_profile
for file in ~/.{bash_prompt,private_vars}; do
	[ -r "$file" ] && source "$file"
done
unset file

export CLICOLOR=1
export LSCOLORS=CxFxBxDxCxegedabagacad
export PATH=./bin:/usr/local/heroku/bin:/usr/local/share/npm/bin:$HOME/.rbenv/bin:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/git/bin:.

alias ll='ls -al'
alias desktop='cd ~/Desktop'
alias ..='cd ..'
alias ~='cd ~'
# Sublime shortcut
alias subl='~/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
# Add spacer to Dock
alias spacer="defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type=\"spacer-tile\";}' && killall Dock"
# Show/hide desktop icons
# By @jvlahos https://gist.github.com/jvlahos/6662210
alias hideicons='defaults write com.apple.finder CreateDesktop -bool false; killall Finder'
alias showicons='defaults write com.apple.finder CreateDesktop -bool true; killall Finder'

# extend git with hub tools https://github.com/defunkt/hub
if [[ "$(type -P rbenv)" ]]; then
	alias git=hub
fi

# rbenv
if [[ "$(type -P rbenv)" ]]; then
	eval "$(rbenv init -)"
fi

# navigate to development directory
function dev() {
	local DEV_DIR=~/Dropbox/Development
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
