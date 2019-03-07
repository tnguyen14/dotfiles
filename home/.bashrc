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

# Construct $PATH
pathmunge () {
	if [ ! -e $1 ]; then return; fi
	if ! echo $PATH | egrep -q "(^|:)$1($|:)" ; then
		if [ "$2" = "after" ] ; then
			PATH=$PATH:$1
		else
			PATH=$1:$PATH
		fi
	fi
}

pathmunge /sbin
pathmunge /usr/sbin
pathmunge /usr/local/sbin
pathmunge /bin
pathmunge /usr/bin
pathmunge /usr/local/bin

pathmunge "$HOME/github/tnguyen14/dotfiles/node_modules/.bin"
pathmunge "$HOME/bin"
pathmunge "$HOME/github/tnguyen14/dotfiles/bin"
pathmunge ./bin "after"
pathmunge ./node_modules/.bin "after"

if which brew > /dev/null 2>&1; then
	pathmunge "$(brew --prefix coreutils)/libexec/gnubin"
	pathmunge "$(brew --prefix findutils)/libexec/gnubin"
	pathmunge "$(brew --prefix python)/libexec/bin"
fi

# linuxbrew
if [ $linux ]; then
	pathmunge "/home/linuxbrew/.linuxbrew/bin"
	export LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/lib
fi

pathmunge $GOPATH
pathmunge "$HOME/.cargo/bin"
pathmunge "/usr/local/share/npm/bin"

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
# http://unix.stackexchange.com/a/48113

# no duplicate entries
export HISTCONTROL=ignoredups:erasedups
# big big history (default is 500)
export HISTSIZE=100000
# big big history
export HISTFILESIZE=$HISTSIZE
# Don't record some commands
export HISTIGNORE="&:[  ]*:exit:ls:bg:fg:history:clear:reset"
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
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
	if [ $unix ]; then
		open "http://localhost:${port}/"
	fi
}

# clean up docker
function docker_cleanup {
	# docker-gc
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc \
		-e FORCE_IMAGE_REMOVAL=1 -e REMOVE_VOLUMES=1 spotify/docker-gc
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
alias ll='ls -alF'
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
alias dig="dig +nocmd any +multiline +noall +answer"
# refresh bash
alias refresh='source ~/.bashrc'
# ripgrep search case-insensitive by default
alias rg='rg -i'

if which sensible-editor > /dev/null 2>&1; then
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
	if which brew > /dev/null 2>&1; then
		# support for z.sh
		filesToSource+=($(brew --prefix)/etc/grc.bashrc)
		filesToSource+=($(brew --prefix)/share/bash-completion/bash_completion)
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

for file in "${filesToSource[@]}"; do
	[ -r "$file" ] && source "$file"
done
unset file

# vim: set tabstop=4:
