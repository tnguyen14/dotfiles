# Tri's dotfiles
> dotfiles all the things!

## Usage

```shell
:; xcode-select --install

:; git clone git@github.com:tnguyen14/dotfiles.git ~/
:; cd ~/dotfiles

# link dotfiles
:; link.sh

# set OS X defaults
:; ./.osx

# install binaries and applications with Homebrew
:; ./brew.sh

# install npm modules
:; npm install
```

### npm packages
Instead of installing global npm packages, "global" npm packages are just packages of the dotfiles folder, as the dotfiles's `node_modules/.bin` path is in `PATH` variable.
