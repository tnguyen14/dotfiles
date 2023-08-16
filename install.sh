#!/bin/bash
# see https://stackoverflow.com/a/1482133
dir=$(dirname -- "$( readlink -f -- "$0";  )";)

$dir/home/bin/lnk "$dir/home" "$HOME"

# execute bash to source bashrc once
bash
