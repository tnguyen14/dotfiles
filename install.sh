#!/bin/bash
# see https://stackoverflow.com/a/1482133
dir=$(dirname -- "$( readlink -f -- "$0";  )";)

$dir/home/bin/lnk "$dir/home" "$HOME"

# source bashrc once to set up
source "$HOME/.bashrc"

# install tmux
if ! command -v tmux &> /dev/null; then
  mkdir -p "$HOME/github/tmux"
  git clone https://github.com/tmux/tmux.git "$HOME/github/tmux/tmux"
  cd "$HOME/github/tmux/tmux"
  sh autogen.sh
  ./configure
  make && sudo make install
fi
