#!/usr/bin/env bash

# if not running interactively, don't do anything
# [[ -z $PS1 ]] && export PATH="$PATH:/usr/local/bin" && return
# $- is current shell options

case $- in
	*i*) ;;
	*) export PATH="$PATH:/usr/local/bin" && return;;
esac

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

export VISUAL="vim"
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

# so-fancy
mkdir -p ~/github/so-fancy
git clone https://github.com/so-fancy/diff-so-fancy.git ~/github/so-fancy/diff-so-fancy

# Construct $PATH
pathmunge () {
	if [ ! -e "$1" ]; then return; fi
	if ! echo "$PATH" | grep -qE "(^|:)$1($|:)" ; then
		if [ "$2" = "after" ] ; then
			PATH=$PATH:$1
		else
			PATH=$1:$PATH
		fi
	fi
}

pathmunge /usr/sbin "after"
pathmunge /usr/bin "after"
pathmunge /sbin "after"
pathmunge /bin "after"
pathmunge /usr/local/sbin
pathmunge /usr/local/bin

pathmunge "$HOME/.cargo/bin"
pathmunge "$HOME/github/tnguyen14/dotfiles/node_modules/.bin"
pathmunge "$HOME/bin"
pathmunge "$HOME/.local/bin"
pathmunge "$HOME/github/tnguyen14/dotfiles/bin"
pathmunge "$HOME/github/so-fancy/diff-so-fancy"
# allow local bins to override
pathmunge ./node_modules/.bin
pathmunge ./bin

if command -v brew > /dev/null 2>&1; then
	pathmunge "$(brew --prefix coreutils)/libexec/gnubin"
	pathmunge "$(brew --prefix findutils)/libexec/gnubin"
	pathmunge "$(brew --prefix python)/libexec/bin"
fi

# linuxbrew
if [ $linux ]; then
	pathmunge "/home/linuxbrew/.linuxbrew/bin"
	export LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/lib
fi

pathmunge "$GOPATH"
pathmunge "$HOME/.cargo/bin"
pathmunge "/usr/local/share/npm/bin"
pathmunge "$HOME/.local/bin" # pip install location

export PATH

# Base16 Shell
if [ ! -d "$HOME/.config/base16-shell" ]; then
	git clone https://github.com/chriskempson/base16-shell.git "$HOME/.config/base16-shell"
fi
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s "$BASE16_SHELL/profile_helper.sh" ] && source "$BASE16_SHELL/profile_helper.sh"
base16_default-dark

# Bash history
# timestamps for later analysis. www.debian-administration.org/users/rossen/weblog/1
export HISTTIMEFORMAT='%F %T '

# keep history up to date, across sessions, in realtime
# http://unix.stackexchange.com/a/48113

# no duplicate entries
export HISTCONTROL=ignoredups:erasedups
# big big history (default is 500)
export HISTSIZE=100000
# big big history
export HISTFILESIZE=$HISTSIZE
# Don't record some commands
export HISTIGNORE="&:[  ]*:exit:ls:bg:fg:history:clear:reset:_reset"
# append to history, don't overwrite it
shopt -s histappend
# Save multi-line commands as one command
shopt -s cmdhist

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Better directory navigation
# Prepend cd to directory names automatically
shopt -s autocd
# Correct spelling errors during tab-completion
shopt -s dirspell
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell
# defines where cd looks for targets
CDPATH="."

# whois a domain or a URL
whois() {
	local domain
	domain=$(echo "$1" | awk -F/ '{print $3}') # get domain from URL
	if [ -z "$domain" ] ; then
		domain=$1
	fi
	echo "Getting whois record for: $domain …"

	# avoid recursion
	# this is the best whois server
	# strip extra fluff
	/usr/bin/whois -h whois.internic.net "$domain" | sed '/NOTICE:/q'
}

# Create a new directory and enter it
md() {
	mkdir -p "$@" && cd "$@" || return
}

# find shorthand
f() {
	find . -name "$1" 2>&1 | grep -v 'Permission denied'
}

# clean up docker
docker_cleanup () {
	docker container prune -f --filter "until=24h"
	docker volume prune -f
	docker image prune -af --filter "until=24h"
}

# Copy w/ progress
cpp () {
	rsync -WavP --human-readable --progress "$1" "$2"
}

# override the reset function to also restore color
_reset () {
	reset
	eval "$($BASE16_SHELL/profile_helper.sh)"
}

# view tls info, pass in domain as first argument
view_tls () {
	local DOMAIN=$1
	openssl s_client -showcerts -servername $DOMAIN -connect $DOMAIN:443
}

# apply config changes
apply_config() {
	if [ -z "$CONFIG_MACHINE_NAME" ]; then
		echo "\$CONFIG_MACHINE_NAME variable is not set. Bailing."
		return 1
	fi
	if [ -z "$CONFIG_PATH" ]; then
		echo "\$CONFIG_PATH variable is not set. Bailing."
		return 1
	fi
	lnk "$CONFIG_PATH/$CONFIG_MACHINE_NAME" /
}

# check if tmux.conf exist, and if tpm is being used
if [ -f "$HOME/.tmux.conf" ]; then
	# find the string within .tmux.conf file
	grep -Fxq "set -g @plugin 'tmux-plugins/tpm'" "$HOME/.tmux.conf"
	# returns 0 if found, 1 if not
	tpm=$?
	if [ "$tpm" == 0 ] && [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
		mkdir -p "$HOME/.tmux/plugins"
		git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
	fi
	unset tpm
fi

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

# download base16-default-dark Xresources file from
# https://github.com/chriskempson/base16-xresources
if [ ! -f ~/.config/base16-default-dark-256.Xresources ]; then
	curl -Lo ~/.config/base16-default-dark-256.Xresources \
		https://raw.githubusercontent.com/chriskempson/base16-xresources/master/xresources/base16-default-dark-256.Xresources
fi

if [ ! -f ~/z.sh ]; then
	curl -Lo ~/z.sh \
		https://raw.githubusercontent.com/rupa/z/master/z.sh
fi

# Aliases
alias grep='grep --color=auto'
alias ll='ls --color -alhF'
alias la='ls -A'
alias l='ls -CF'
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
alias digg="dig +nocmd any +multiline +noall +answer"
# refresh bash
alias refresh='source ~/.bashrc'
# ripgrep search case-insensitive by default
alias rg='rg -i'

if command -v sensible-editor > /dev/null 2>&1; then
	alias e='sensible-editor'
fi

if [ $unix ]; then
	# Add spacer to Dock
	alias spacer="defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type=\"spacer-tile\";}' && killall Dock"
	# Brew update
	alias brew_update="brew -v update; brew -v upgrade --all; brew cleanup; brew cask cleanup; brew prune; brew doctor"

fi

# Add an "alert" alias for long running commands.
# Use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# notify-send is only available on ubuntu; notify is cross platform
# see https://github.com/mikaelbr/node-notifier
alias notify='notify -i "$([ $? = 0 ] && echo terminal || echo error)" -t "Terminal Notification" -m "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Sourcing files
filesToSource=()

if [ $unix ]; then
	if command -v brew > /dev/null 2>&1; then
		# shellcheck disable=SC2207
		filesToSource+=($(brew --prefix)/etc/grc.bashrc)
		# shellcheck disable=SC2207
		filesToSource+=($(brew --prefix)/share/bash-completion/bash_completion)
		# shellcheck disable=SC2207
		filesToSource+=($(brew --prefix)/etc/grc.bashrc)
	fi
elif [ $linux ]; then
	filesToSource+=(/etc/bash_completion)
fi

filesToSource+=(~/.bash_local)
filesToSource+=(~/.git-prompt.sh)
filesToSource+=(~/.bash_prompt)
filesToSource+=(~/.git-completion.bash)
filesToSource+=(~/.fzf.bash)
filesToSource+=(~/.fzf.sh) # custom fzf commands
filesToSource+=(~/.travis/travis.sh)
filesToSource+=(~/z.sh)
filesToSource+=(~/.cargo/env)

for file in "${filesToSource[@]}"; do
	# https://github.com/koalaman/shellcheck/wiki/SC1090
	# shellcheck source=/dev/null
	[ -r "$file" ] && source "$file"
done
unset file

# vim: set tabstop=4:
