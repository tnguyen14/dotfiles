# upgrade system
pacman -Syu --noconfirm

# system
pacman -S --noconfirm git nginx

pacman -S --noconfirm nodejs npm
npm i -g n

# Note: https://wiki.archlinux.org/index.php/Docker
# Docker needs the loop module on first usage. The following steps may be required before starting docker:
# tee /etc/modules-load.d/loop.conf <<< "loop"
# modprobe loop 
# You may need to reboot before the module is available.
pacman -S --noconfirm docker docker-compose

# dev
pacman -S --noconfirm tmux neovim diff-so-fancy ripgrep
pacman -S certbot-nginx
