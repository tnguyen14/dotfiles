#!/bin/bash

# Install command-line tools using Homebrew
# Inspired by https://github.com/paulirish/dotfiles/blob/master/brew.sh

# install brew first if it is not
if ! which brew > /dev/null; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# GNU core utilities (those that come with OS X are outdated)
brew install coreutils
# GNU `find`, `locate`, `updatedb`, and `xargs`
brew install findutils --with-default-names
brew install gnu-sed --with-default-names
brew install grep --with-default-names
brew install diffutils

brew install gcc

# Bash 4
brew install bash
echo /usr/local/bin/bash | sudo tee -a /etc/shells
chsh -s /usr/local/bin/bash

brew install bash-completion2
brew install brew-cask-completion

# Install more recent versions of some OS X tools
brew install macvim --with-override-system-vim
brew install neovim

# Install other useful binaries
brew install git
brew install imagemagick --with-webp
brew install tree
brew install tmux
brew install nginx
brew install nmap
brew install rsync
brew install wget
brew install httpie

# System monitoring tools
# https://www.digitalocean.com/community/tutorials/how-to-use-top-netstat-du-other-tools-to-monitor-server-resources
brew install htop
brew install nethogs
brew install ncdu

brew install jq
brew install mobile-shell
brew install keybase
brew install diff-so-fancy
brew install fzf
brew install ripgrep
brew install tldr

brew install nodejs
brew install docker
brew install python3
pip3 install --upgrade pip setuptools
pip3 install neovim

# generic coloriser https://github.com/garabik/grc
brew install grc

# Remove outdated versions from the cellar
brew cleanup

# Brew Cask
brew cask
brew tap caskroom/versions

brew cask install cerebro
brew cask install appcleaner
brew cask install atom
brew cask install iterm2-beta
brew cask install flux
brew cask install skyfonts
brew cask install postman

# browsers
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install firefoxdeveloperedition
brew cask install docker

brew cask install spotify
brew cask install dropbox
brew cask install google-drive
brew cask install 1password
brew cask install imageoptim
brew cask install slack

# quick look https://github.com/sindresorhus/quick-look-plugins
brew cask install betterzipql
brew cask install qlcolorcode
brew cask install qlimagesize
brew cask install webpquicklook
brew cask install qlmarkdown
brew cask install qlprettypatch
brew cask install qlstephen
brew cask install quicklook-csv
brew cask install quicklook-json
brew cask install suspicious-package

# cask cleanup
brew cask cleanup
