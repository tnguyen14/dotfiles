#!/usr/bin/env bash

# if not running interactively, don't do anything
[[ -z $PS1 ]] && export PATH="$PATH:/usr/local/bin" && return

# check for linux
if [[ "$OSTYPE" =~ ^linux ]]; then
	linux=1
elif [[ "$OSTYPE" =~ ^darwin ]]; then
	unix=1
fi

export CLICOLOR=1
# export LSCOLORS=CxFxBxDxCxegedabagacad
export LSCOLORS="CxFxExDxBxegedabagacad"
# for Linux
# use http://geoff.greer.fm/lscolors/ for translation and preview
export LS_COLORS="di=1;32:ln=1;35:so=1;34:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

export VISUAL="nvim"
export EDITOR="$VISUAL"

# highlighting inside manpages and elsewhere
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# find hidden files with fzf, and ignore .gitignore
# export FZF_DEFAULT_COMMAND='ag --hidden -U --ignore .git -g ""'
export FZF_DEFAULT_COMMAND='rg -uu --files -g !.git -g !node_modules'

# Go
export GOPATH=$HOME/go

# Construct $PATH
PATH="${PATH:-/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin}"
_prepend_path() {
	[ -d $1 ] && PATH="$1:$PATH"
}
_append_path() {
	[ -d $1 ] && PATH="$PATH:$1"
}

PATH="$PATH:$HOME/dotfiles/node_modules/.bin:$HOME/bin:./bin:./node_modules/.bin:."

if which brew > /dev/null 2>&1; then
	_prepend_path "$(brew --prefix coreutils)/libexec/gnubin"
	_prepend_path "$(brew --prefix findutils)/libexec/gnubin"
fi

# linuxbrew
if [ $linux ]; then
	_prepend_path "/home/linuxbrew/.linuxbrew/bin"
fi

_prepend_path $GOPATH
_prepend_path "/usr/local/share/npm/bin"
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

# Better directory navigation
# Prepend cd to directory names automatically
shopt -s autocd
# Correct spelling errors during tab-completion
shopt -s dirspell
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell
# defines where cd looks for targets
CDPATH="."

# https://github.com/herrbischoff/awesome-osx-command-line#show-current-ssid
ssid() {
	if [ $unix ]; then
		airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'
	fi
}
# https://github.com/herrbischoff/awesome-osx-command-line#show-wi-fi-network-passwords
wifipw() {
	if [ $unix ]; then
		security find-generic-password -D "AirPort network password" -a "$1" -gw
	fi
}

# whois a domain or a URL
whois() {
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

# Create a new directory and enter it
md() {
	mkdir -p "$@" && cd "$@"
}

# find shorthand
f() {
	find . -name "$1" 2>&1 | grep -v 'Permission denied'
}

# Start an HTTP server from a directory, optionally specifying the port
serve() {
	local port="${1:-8000}"
	open "http://localhost:${port}/"
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# clean up docker
docker_cleanup() {
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

# check if tmux.conf exist, and if tpm is being used
if [ -f $HOME/.tmux.conf ]; then
	# find the string within .tmux.conf file
	grep -Fxq "set -g @plugin 'tmux-plugins/tpm'" $HOME/.tmux.conf
	# returns 0 if found, 1 if not
	tpm=$?
	if [ "$tpm" == 0 ] && [ ! -d $HOME/.tmux/plugins/tpm ]; then
			mkdir -p $HOME/.tmux/plugins
			git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
	fi
	unset tpm
fi

# Create a new tmux session with the current dir as the session name
tmuxn() {
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

if [ ! -f ~/.git-completion.bash ]; then
	curl -Lo ~/.git-completion.bash \
		https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
fi

# install vim-plug if it is not there
if [ ! -f ~/.vim/autoload/plug.vim ]; then
	curl -Lo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [ ! -f ~/.config/nvim/autoload/plug.vim ]; then
	curl -Lo ~/.config/nvim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Aliases
alias ls='ls --color'
alias ll='ls -alF'
alias la='ls -A'
alias dt='cd ~/Desktop'
# Make basic commands verbose
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v -i' # remove interactively
alias ln='ln -v'
# Always show line numbers for less
alias less='less -N'
# File system usage
alias disk="df -P -kHl"
# Networking. IP address, dig, DNS
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias dig="dig +nocmd any +multiline +noall +answer"
# refresh bash
alias refresh='source ~/.bashrc'
# ripgrep search case-insensitive by default
alias rg='rg -i'
# vim lite
alias viml='vim -u ~/.lite.vim'

if [ $unix ]; then
	# Add spacer to Dock
	alias spacer="defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type=\"spacer-tile\";}' && killall Dock"
	# Brew update
	alias brew_update="brew -v update; brew -v upgrade --all; brew cleanup; brew cask cleanup; brew prune; brew doctor"

fi

# Sourcing files
filesToSource=()

if [ $unix ]; then
	if which brew > /dev/null 2>&1; then
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
filesToSource+=(~/.fzf.bash)
filesToSource+=(~/.fzf.sh) # custom fzf commands

for file in "${filesToSource[@]}"; do
	[ -r "$file" ] && source "$file"
done
unset file
