#!/usr/bin/env bash

# if not running interactively, don't do anything
[[ -z $PS1 ]] && return

# check for linux
if [[ "$OSTYPE" =~ ^linux ]]; then
	linux=1
elif [[ "$OSTYPE" =~ ^darwin ]]; then
	unix=1
fi

export CLICOLOR=1
# export LSCOLORS=CxFxBxDxCxegedabagacad
export LSCOLORS=CxFxExDxBxegedabagacad

# vim as default
export EDITOR="nvim"

# highlighting inside manpages and elsewhere
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# find hidden files with fzf, and ignore .gitignore
export FZF_DEFAULT_COMMAND='ag --hidden -U --ignore .git -g ""'

# Base16 Shell
if [ ! -d $HOME/.config/base16-shell ]; then
	git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
fi
BASE16_SHELL="$HOME/.config/base16-shell/base16-default.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# Go
export GOPATH=$HOME/go

# Construct $PATH
PATH='/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:./bin:./node_modules/.bin:.'
[ -d $GOPATH ] && PATH="$GOPATH:$PATH"
[ -d /usr/local/share/npm/bin ] && PATH="/usr/local/share/npm/bin:$PATH"
[ -d $HOME/dotfiles/node_modules/.bin ] && PATH="$HOME/dotfiles/node_modules/.bin:$PATH"
[ -d $HOME/bin ] && PATH="$HOME/bin:$PATH"
export PATH

if [ $unix ]; then
	if which brew > /dev/null; then
		# support for z.sh
		zFile="$(brew --prefix)/etc/profile.d/z.sh"
		grc="$(brew --prefix)/etc/grc.bashrc"
		bashCompletion="$(brew --prefix)/share/bash-completion/bash_completion"
	fi
elif [ $linux ]; then
	zFile="~/z.sh"
	bashCompletion="/etc/bash_completion"
fi

if [ -f $zFile ]; then
	source "$zFile"
fi
if [ -f $grc ]; then
	source "$grc"
fi
if [ -f $bashCompletion ]; then
	source "$bashCompletion"
fi

# Bash history
# timestamps for later analysis. www.debian-administration.org/users/rossen/weblog/1
export HISTTIMEFORMAT='%F %T '

# keep history up to date, across sessions, in realtime
#  http://unix.stackexchange.com/a/48113

# no duplicate entries
export HISTCONTROL=ignoredups:erasedups
# big big history (default is 500)
export HISTSIZE=100000
# big big history
export HISTFILESIZE=$HISTSIZE
# Don't record some commands
export HISTIGNORE="&:[  ]*:exit:ls:bg:fg:history:clear"
# append to history, don't overwrite it
shopt -s histappend
# Save multi-line commands as one command
shopt -s cmdhist

# Save and reload the history after each command finishes
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Instead of reload the history right away, only save it so that new session
# will have access to recent commands, but arrow-up still works in existing shell
# http://unix.stackexchange.com/q/1288#comment67052_48116
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

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

# https://github.com/herrbischoff/awesome-osx-command-line#show-current-ssid
function ssid() {
	airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'
}
# https://github.com/herrbischoff/awesome-osx-command-line#show-wi-fi-network-passwords
function wifipw() {
	security find-generic-password -D "AirPort network password" -a "$1" -gw
}

# whois a domain or a URL
function whois() {
	local domain=$(echo "$1" | awk -F/ '{print $3}') # get domain from URL
	if [ -z $domain ] ; then
		domain=$1
	fi
	echo "Getting whois record for: $domain …"

	# avoid recursion
					# this is the best whois server
													# strip extra fluff
	/usr/bin/whois -h whois.internic.net $domain | sed '/NOTICE:/q'
}

function localip(){
	local if=$(netstat -rn | awk '/^0.0.0.0/ {thif=substr($0,74,10); print thif;} /^default.*UG/ {thif=substr($0,65,10); print thif;}')
	local ip=$(ifconfig ${if} | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
	echo $ip
}

# Better directory navigation
# Prepend cd to directory names automatically
shopt -s autocd
# Correct spelling errors during tab-completion
shopt -s dirspell
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell
# defines where cd looks for targets
CDPATH="."

# Create a new directory and enter it
function md() {
	mkdir -p "$@" && cd "$@"
}

# find shorthand
function f() {
	find . -name "$1" 2>&1 | grep -v 'Permission denied'
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
	local port="${1:-8000}"
	open "http://localhost:${port}/"
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# Copy w/ progress
cpp () {
  rsync -WavP --human-readable --progress $1 $2
}

# Create a new tmux session with the current dir as the session name
function tmuxn() {
	# only do something if there's no argument, otherwise, pass it along 
	# to the regular tmux command
	if [ $# -eq 0 ]; then
		# get dirname without full path
		local dirname=${PWD##*/}
		# replace dot in dirname with -
		tmux new-session \; run-shell "tmux rename-session ${dirname/./-}"
	else
		tmux "$@"
	fi
}

# Grunt completion
command -v grunt >/dev/null 2>&1 && eval "$(grunt --completion=bash)"
# gulp completion
command -v gulp >/dev/null 2>&1 && eval "$(gulp --completion=bash)"

if [ ! -f ~/.git-completion.bash ]; then
	curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
fi

# Load the shell dotfiles, copied from https://github.com/mathiasbynens/dotfiles/blob/master/.bash_profile
for file in ~/.{bash_local,bash_prompt,bash_aliases,private_vars,git-completion.bash,travis/travis.sh}; do
	[ -r "$file" ] && source "$file"
done
unset file
