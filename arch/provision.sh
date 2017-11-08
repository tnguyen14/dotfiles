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

ln -s ~/config/arch/etc/nginx /etc/nginx

# vagrant user stuff
su vagrant <<EOF

# link up dotfiles
cd ~/dotfiles && ./link.sh

ln -s ~/config/home/.ssh/config ~/.ssh/config
EOF
