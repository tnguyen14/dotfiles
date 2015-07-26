#!/usr/bin/env bash

# Load the shell dotfiles, copied from https://github.com/mathiasbynens/dotfiles/blob/master/.bash_profile
if [ ! -f ~/.git-completion.bash ]; then
	curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
fi

for file in ~/.{bash_local,bash_prompt,bash_aliases,private_vars,git-completion.bash,travis/travis.sh}; do
	[ -r "$file" ] && source "$file"
done
unset file

# check for linux
if [[ "$OSTYPE" =~ ^linux ]]; then
	linux=1
elif [[ "$OSTYPE" =~ ^darwin ]]; then
	unix=1
fi

export CLICOLOR=1
# export LSCOLORS=CxFxBxDxCxegedabagacad
export LSCOLORS=CxFxExDxBxegedabagacad

# Base16 Shell
if [ ! -d $HOME/.config/base16-shell ]; then
	git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
fi
BASE16_SHELL="$HOME/.config/base16-shell/base16-default.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# Go
export GOPATH=$HOME/go

# Prepend $PATH without duplicates
function _prepend_path() {
	if ! $( echo "$PATH" | tr ":" "\n" | grep -qx "$1" ) ; then
		PATH="$1:$PATH"
	fi
}
# Construct $PATH
PATH='/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:./bin:./node_modules/.bin:.'
[ -d $HOME/go ] && _prepend_path "$HOME/go"
[ -d $HOMEwordpress ] && _prepend_path "$HOME/wordpress"
[ -d /usr/local/heroku/bin ] && _prepend_path "/usr/local/heroku/bin"
[ -d /usr/local/opt/ruby/bin ] && _prepend_path "/usr/local/opt/ruby/bin"
command -v rbenv >/dev/null 2>&1 && _prepend_path "$HOME/.rbenv/shims"
[ -d /usr/local/share/npm/bin ] && _prepend_path "/usr/local/share/npm/bin"
[ -d $HOMEdotfiles/bin ] && _prepend_path "$HOME/dotfiles/bin"
[ -d $HOME/bin ] && _prepend_path "$HOME/bin"
export PATH

# support for z.sh
if [ $unix ]; then
	. `brew --prefix`/etc/profile.d/z.sh
elif [ $linux ]; then
	[ -f ~.z.sh ] && . ~/z.sh
fi

# extend git with hub tools https://github.com/defunkt/hub
if [[ "$(type -P hub)" ]]; then
	alias git=hub
fi

function wptheme() {
	cd wp-content/themes
	if [ $1 ]; then
		if [ -d $1 ]; then
			cd $1
		fi
	fi
}

# Set up env vars for docker-machine
# accept an argument as the machine name
function dm() {
	if [ -z "$1" ]; then
		machine="dev"
	else
		machine=$1
	fi
	eval "$(docker-machine env $machine)"
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
# gulp completion
command -v gulp >/dev/null 2>&1 && eval "$(gulp --completion=bash)"

# Bash completion (installed via Homebrew; source after `brew` is added to PATH)
command -v brew >/dev/null 2>&1 && [ -r "$(brew --prefix)/etc/bash_completion" ] && source "$(brew --prefix)/etc/bash_completion"
