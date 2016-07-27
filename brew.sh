#!/bin/bash

# Install command-line tools using Homebrew
# Inspired by https://github.com/paulirish/dotfiles/blob/master/brew.sh

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# GNU core utilities (those that come with OS X are outdated)
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils --with-default-names
# GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils
brew install gnu-sed

# Bash 4
brew install bash
echo /usr/local/bin/bash|sudo tee -a /etc/shells
chsh -s /usr/local/bin/bash
# regular bash-completion package is held back to an older release, so we get latest from versions.
#   github.com/Homebrew/homebrew/blob/master/Library/Formula/bash-completion.rb#L3-L4
brew tap homebrew/versions
brew install bash-completion2

brew install homebrew/completions/brew-cask-completion

# generic coloriser http://kassiopeia.juls.savba.sk/~garabik/software/grc.html
brew install grc

# Install wget with IRI support
brew install wget --enable-iri

# Install more recent versions of some OS X tools
brew install macvim --with-override-system-vim
brew tap neovim/neovim
brew install neovim
brew install homebrew/dupes/grep
brew install homebrew/dupes/screen

# Install other useful binaries
brew install git
brew install imagemagick --with-webp
brew install tree
brew install tmux
brew install nginx
brew install nmap
brew install rsync
brew install httpie

brew install pianobar
brew install cadaver
brew install jq
brew install mobile-shell
brew install keybase
brew install diff-so-fancy
brew install ag
brew install fzf

brew install nodejs
brew install docker
brew install python3
pip3 install --upgrade pip setuptools
pip3 install neovim

# Remove outdated versions from the cellar
brew cleanup

# Brew Cask
brew tap caskroom/cask

brew cask install alfred
brew cask alfred link
brew cask install appcleaner
brew cask install atom
brew cask install iterm2
brew cask install flux
brew cask install skyfonts
brew cask install postman

# browsers
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install firefoxdeveloperedition

brew cask install spotify
brew cask install dropbox
brew cask install google-drive
brew cask install 1password
brew cask install evernote
brew cask install imageoptim

# quick look https://github.com/sindresorhus/quick-look-plugins
brew cask install betterzipql
brew cask install qlcolorcode
brew cask install qlimagesize
brew cask install webpquicklook
brew cask install qlmarkdown
brew cask install qlprettypatch
brew cask install qlstephen
brew cask isntall quicklook-csv
brew cask install quicklook-json
brew cask install suspicious-package

# cask cleanup
brew cask cleanup
