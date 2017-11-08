# create nginx self-signed cert
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=US/ST=Massachusetts/L=Lynn/O=inspiredev/CN=lab.dev-tridnguyen.com"

openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

systemctl start nginx.service

# docker
echo "loop" | tee /etc/modules-load.d/loop.conf
gpasswd -a vagrant docker

# will need a reboot after in order for docker to work,
# see https://wiki.archlinux.org/index.php/Docker

# vagrant user stuff
su vagrant

# link up dotfiles
cd /home/vagrant/dotfiles && ./link.sh

# install vim plugins
nvim -E -c "PlugInstall" -c qa

