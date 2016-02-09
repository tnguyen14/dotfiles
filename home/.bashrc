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

export EDITOR=/usr/local/bin/vim

[ -n "$TMUX"  ] && export TERM=screen-256color

# LESS colors
export LESS_TERMCAP_mb=$(printf "\e[1;31m") \
export LESS_TERMCAP_md=$(printf "\e[1;31m") \
export LESS_TERMCAP_me=$(printf "\e[0m") \
export LESS_TERMCAP_se=$(printf "\e[0m") \
export LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
export LESS_TERMCAP_ue=$(printf "\e[0m") \
export LESS_TERMCAP_us=$(printf "\e[1;32m") \

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
PATH='/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:./bin:./node_modules/.bin:.'
[ -d $GOPATH ] && _prepend_path "$GOPATH"
[ -d /usr/local/opt/ruby/bin ] && _prepend_path "/usr/local/opt/ruby/bin"
command -v rbenv >/dev/null 2>&1 && _prepend_path "$HOME/.rbenv/shims"
[ -d /usr/local/share/npm/bin ] && _prepend_path "/usr/local/share/npm/bin"
[ -d $HOME/.dotfiles/node_modules/.bin ] && _prepend_path "$HOME/.dotfiles/node_modules/.bin"
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

# If possible, add bash completion for many commands (Linux)
[ -f /etc/bash_completion ] && source /etc/bash_completion

# Grunt completion
command -v grunt >/dev/null 2>&1 && eval "$(grunt --completion=bash)"
# gulp completion
command -v gulp >/dev/null 2>&1 && eval "$(gulp --completion=bash)"

# Bash completion (installed via Homebrew; source after `brew` is added to PATH)
command -v brew >/dev/null 2>&1 && [ -r "$(brew --prefix)/etc/bash_completion" ] && source "$(brew --prefix)/etc/bash_completion"
