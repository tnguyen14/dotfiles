# Dotfiles
My very first attempt at version control and bootstrap my dotfiles

A lot of inspiration (and forking) from [Ben Almen's dotfiles](https://github.com/cowboy/dotfiles).

## What to do

### OS X
1. Download [XCode Command Line Tools](https://developer.apple.com/downloads/index.action?=command%20line%20tools)
If on Mavericks (10.9) and above, run `xcode-select --install`
2. `bash -c "$(curl -fsSL https://raw.github.com/tnguyen14/dotfiles/master/bin/dotfiles)" && source ~/.bashrc`

### Ubuntu
- `sudo apt-get -qq update && sudo apt-get -qq upgrade && sudo apt-get -qq install curl && echo &&
bash -c "$(curl -fsSL https://raw.github.com/cowboy/dotfiles/master/bin/dotfiles)" && source ~/.bashrc`

### What this will do
- Install [Homebrew](http://mxcl.github.io/homebrew/) (on Mac OS X)
- Install Git
- Pull from this Github repository the latest version of files
- Create `backup` and `cache` directories in `~/.dotfiles/` directory
- Link/ copy all the files in `link` to `~`, saving their old versions in `backup`

It really isn't too crazy right now. This is not a full fork of Ben Almen's dotfiles as I do not need all the programs and functionality that he uses.

### Shell
- This repo currently contains 2 config files for `bash` and `zsh`.
- Both will be updated with `brew` and added to `/etc/shells` to use as standard shells.
- To use either one by default (the updated version), run ``chsh -s `which bash` `` or ``chsh -s `which zsh` ``.

#### Bash
- Bash prompt is configured in `link/.bash_prompt`
- Private environment variables in `link/.private_vars`, which is being ignored by git
- Both of these are then sourced in `.bashrc`, which is in turn sourced by `.bash_profile` for login shells. Differences between `.bashrc` and `.bash_profile` are discussed at length [here](http://stackoverflow.com/questions/415403/whats-the-difference-between-bashrc-bash-profile-and-environment) and [here](http://superuser.com/questions/183870/difference-between-bashrc-and-bash-profile).
- Changes made to any of these files can be made and will take effect immediately without restarting the shell by running `source ~/.bashrc`

#### ZSH
- Z shell is configured by `.zshrc`, which is a fork of [`oh-my-zsh`](https://github.com/robbyrussell/oh-my-zsh).
- A new copy of `oh-my-zsh` is pulled down for each time `bin/dotfiles` is run. If `oh-my-zsh` already exists, it will be updated.
- The `zsh` prompt is forked from [`pure`](https://github.com/sindresorhus/pure).

## Future
Some TODOs for this project going forward

- [Mac OS X config](https://github.com/mathiasbynens/dotfiles/blob/master/.osx)