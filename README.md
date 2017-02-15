# Tri's dotfiles
> dotfiles all the things!

## Usage

```shell
# macOS
# install XCode
:; xcode-select --install
# set defaults
:; ./mac/.macos
# install binaries and applications with Homebrew
:; ./mac/brew.sh

:; git clone git@github.com:tnguyen14/dotfiles.git ~/
:; cd ~/dotfiles

# link dotfiles
:; link.sh

# install npm modules
:; npm install

# install vim-plug plugins
:; nvim -E -c "PlugInstall" -c qa
```

### npm packages
Instead of installing global npm packages, "global" npm packages are just packages of the dotfiles folder, as the dotfiles's `node_modules/.bin` path is in `PATH` variable.
