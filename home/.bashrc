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

# Go
export GOPATH=$HOME/go

# Construct $PATH
PATH='/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin'
function _prepend_path() {
	[ -d $1 ] && PATH="$1:$PATH"
}
function _append_path() {
	[ -d $1 ] && PATH="$PATH:$1"
}
if which brew > /dev/null; then
	_prepend_path "$(brew --prefix coreutils)/libexec/gnubin"
	_prepend_path "$(brew --prefix findutils)/libexec/gnubin"
fi
_prepend_path $GOPATH
_prepend_path "/usr/local/share/npm/bin"
PATH="$PATH:$HOME/dotfiles/node_modules/.bin:$HOME/bin:./bin:./node_modules/.bin:."
export PATH

# Base16 Shell
if [ ! -d $HOME/.config/base16-shell ]; then
	git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell
fi
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
base16_default-dark

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
# export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
# see .bash_prompt

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

# clean up docker
function docker_cleanup() {
	# docker-gc
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc spotify/docker-gc

	# https://lebkowski.name/docker-volumes/
	# remove untagged images
	docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs -r docker rmi
	# remove unused volumes
	docker volume ls -qf dangling=true | xargs -r docker volume rm
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

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias dt='cd ~/Desktop'
alias ..='cd ..'
alias ~='cd ~'
alias pyserve='python -m SimpleHTTPServer'
# Make basic commands verbose
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v -i' # remove interactively
# Always show line numbers for less
alias less='less -N'
# Editor shortcut
alias subl='~/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
# Add spacer to Dock
alias spacer="defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type=\"spacer-tile\";}' && killall Dock"
# File system usage
alias disk="df -P -kHl"
alias airport=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport
# Networking. IP address, dig, DNS
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias dig="dig +nocmd any +multiline +noall +answer"
# Brew update
alias brew_update="brew -v update; brew -v upgrade --all; brew cleanup; brew cask cleanup; brew prune; brew doctor"
# refresh bash
alias refresh='source ~/.bashrc'
alias docker-gc="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc spotify/docker-gc"

# Sourcing files
filesToSource=()

if [ $unix ]; then
	if which brew > /dev/null; then
		# support for z.sh
		filesToSource+=($(brew --prefix)/etc/profile.d/z.sh)
		filesToSource+=($(brew --prefix)/etc/grc.bashrc)
		filesToSource+=($(brew --prefix)/share/bash-completion/bash_completion)
	fi
elif [ $linux ]; then
	filesToSource+=(~/z.sh)
	filesToSource+=(/etc/bash_completion)
fi

filesToSource+=(~/.bash_local)
filesToSource+=(~/.git-prompt.sh)
filesToSource+=(~/.bash_prompt)
filesToSource+=(~/.git-completion.bash)

for file in "${filesToSource[@]}"; do
	[ -r "$file" ] && source "$file"
done
unset file
