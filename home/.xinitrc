[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
[[ -f ~/.local.Xresources ]] && xrdb -merge ~/.local.Xresources
