# Dotfiles
My very first attempt at version control and bootstrap my dotfiles

A lot of inspiration (and forking) from [Ben Almen's dotfiles](https://github.com/cowboy/dotfiles).

## What to do

### OS X
- Download [XCode Command Line Tools](https://developer.apple.com/downloads/index.action?=command%20line%20tools)
- `bash -c "$(curl -fsSL https://raw.github.com/cowboy/dotfiles/master/bin/dotfiles)" && source ~/.bashrc`

### Ubuntu
- `sudo apt-get -qq update && sudo apt-get -qq upgrade && sudo apt-get -qq install curl && echo &&
bash -c "$(curl -fsSL https://raw.github.com/cowboy/dotfiles/master/bin/dotfiles)" && source ~/.bashrc`

### What this will do
- Install [Homebrew](http://mxcl.github.io/homebrew/) (on Mac OS X)
- Install Git
- Pull from this Github repository the latest version of files
- Create `backup` and `cache` directories in `~/.dotfiles/` directory
- Link all the files in `link` to `~`, saving their old versions in `backup`

It really isn't too crazy right now. This is not a full fork of Ben Almen's dotfiles as I do not need all the programs and functionality that he uses.

## Future
Some TODOs for this project going forward

- [Mac OS X config](https://github.com/mathiasbynens/dotfiles/blob/master/.osx)