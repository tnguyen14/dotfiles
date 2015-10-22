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
# Interactive mode for rm
alias rm='rm -i'
# Editor shortcut
alias subl='~/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
# Add spacer to Dock
alias spacer="defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type=\"spacer-tile\";}' && killall Dock"
# Show/hide desktop icons
# By @jvlahos https://gist.github.com/jvlahos/6662210
alias hideicons='defaults write com.apple.finder CreateDesktop -bool false; killall Finder'
alias showicons='defaults write com.apple.finder CreateDesktop -bool true; killall Finder'
# File system usage
alias dus='df -h'

