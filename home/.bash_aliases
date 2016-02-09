#!/usr/bin/env bash

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
# Show/hide desktop icons
# By @jvlahos https://gist.github.com/jvlahos/6662210
alias hideicons='defaults write com.apple.finder CreateDesktop -bool false; killall Finder'
alias showicons='defaults write com.apple.finder CreateDesktop -bool true; killall Finder'
# File system usage
alias disk="df -P -kHl"
alias airport=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport
# Networking. IP address, dig, DNS
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias dig="dig +nocmd any +multiline +noall +answer"
# Brew update
alias brew_update="brew -v update; brew -v upgrade --all; brew cleanup; brew cask cleanup; brew prune; brew doctor"
