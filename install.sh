#!/bin/bash
# see https://stackoverflow.com/a/1482133
dir=$(dirname -- "$( readlink -f -- "$0";  )";)

$dir/home/bin/lnk "$dir/home" "$HOME"

# source bashrc once to set up
source "$HOME/.bashrc"

# install vim plugins
nvim +PlugInstall +qall
