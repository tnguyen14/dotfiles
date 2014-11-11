#!/usr/bin/env bash

# Load the shell dotfiles, copied from https://github.com/mathiasbynens/dotfiles/blob/master/.bash_profile
if [ ! -f ~/.git-completion.bash ]; then
	curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
fi

for file in ~/.{bash_local,bash_prompt,private_vars,git-completion.bash,travis/travis.sh}; do
	[ -r "$file" ] && source "$file"
done
unset file

export CLICOLOR=1
export LSCOLORS=CxFxBxDxCxegedabagacad

# Prepend $PATH without duplicates
function _prepend_path() {
	if ! $( echo "$PATH" | tr ":" "\n" | grep -qx "$1" ) ; then
		PATH="$1:$PATH"
	fi
}
# Construct $PATH
PATH='/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:.'
[ -d /usr/local/heroku/bin ] && _prepend_path "/usr/local/heroku/bin"
[ -d /usr/local/opt/ruby/bin ] && _prepend_path "/usr/local/opt/ruby/bin"
command -v rbenv >/dev/null 2>&1 && _prepend_path "$HOME/.rbenv/bin"
[ -d /usr/local/share/npm/bin ] && _prepend_path "/usr/local/share/npm/bin"
command -v brew >/dev/null 2>&1 && _prepend_path "$(brew --prefix coreutils)/libexec/gnubin"
[ -d ~/dotfiles/bin ] && _prepend_path "$HOME/dotfiles/bin"
[ -d ~/bin ] && _prepend_path "$HOME/bin"
[ -d ./bin ] && _prepend_path "./bin"
[ -d ./node_modules/.bin ] && _prepend_path "./node_modules/.bin"
export PATH

# support for z.sh
. `brew --prefix`/etc/profile.d/z.sh

alias ll='ls -al'
alias dt='cd ~/Desktop'
alias ..='cd ..'
alias ~='cd ~'
alias pyserve='python -m SimpleHTTPServer'
# Editor shortcut
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias atom='/Applications/Atom.app/Contents/MacOS/Atom'
# Add spacer to Dock
alias spacer="defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type=\"spacer-tile\";}' && killall Dock"
# Show/hide desktop icons
# By @jvlahos https://gist.github.com/jvlahos/6662210
alias hideicons='defaults write com.apple.finder CreateDesktop -bool false; killall Finder'
alias showicons='defaults write com.apple.finder CreateDesktop -bool true; killall Finder'

# extend git with hub tools https://github.com/defunkt/hub
if [[ "$(type -P hub)" ]]; then
	alias git=hub
fi

# rbenv
if [[ "$(type -P rbenv)" ]]; then
	eval "$(rbenv init -)"
fi

function wptheme() {
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

# If possible, add tab completion for many commands
[ -f /etc/bash_completion ] && source /etc/bash_completion

# Grunt completion
command -v grunt >/dev/null 2>&1 && eval "$(grunt --completion=bash)"

# Bash completion (installed via Homebrew; source after `brew` is added to PATH)
command -v brew >/dev/null 2>&1 && [ -r "$(brew --prefix)/etc/bash_completion" ] && source "$(brew --prefix)/etc/bash_completion"
