# Tri's dotfiles
> dotfiles all the things!

## Boostrap

### macOS

```shell
# macOS
# install XCode
:; xcode-select --install
# set defaults
:; ./macos/.macos
# install binaries and applications with Homebrew
:; ./macos/brew.sh
```

### Arch Linux VM

Make sure the directory `~/Dropbox/dev/arch/etc` exists before starting the VM.

```shell
# Arch Linux
:; cd ~/dotfiles/arch
:; vagrant up
:; vagrant reload  # reboot is needed after first start/ provisioning
:; vagrant ssh
```

## Linking

```shell
# link everything in `home` to `~`
:; cd ~/dotfiles
:; link

```

## npm packages

```shell
:; cd ~/dotfiles
:; npm install
```

Instead of installing global npm packages, "global" npm packages are just packages of the dotfiles folder, as the dotfiles's `node_modules/.bin` path is in `PATH` variable. This allows for these "global" npm packages to be version controlled.
