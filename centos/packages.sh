
sudo yum update -y

curl https://setup.ius.io/ | sudo bash
sudo yum install -y git2u # git 2.x 

# install tmux
sudo yum install -y libtool automake gcc make kernel-devel ncurses-devel
mkdir -p ~/lib && cd ~/lib

if [ ! -d libevent ]; then
	git clone https://github.com/libevent/libevent.git
fi
cd libevent
git checkout release-2.1.8-stable
./autogen.sh
./configure
make
sudo make install

cd ~/lib
if [ ! -d tmux ]; then
	git clone https://github.com/tmux/tmux.git
fi
cd tmux
git checkout 2.3
./autogen.sh
# configuration taken from https://gist.github.com/rschuman/6168833
LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure
make
sudo make install

# install node
curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -
yum install -y nodejs

# install latest npm
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
npm install -g npm@latest
echo 'WARN: please add "~/.npm-global/bin" to the front of your $PATH.'

npm install -g diff-so-fancy tldr


# install ripgrep
# sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlgeorge/ripgrep/repo/epel-7/carlgeorge-ripgrep-epel-7.repo
# sudo yum install ripgrep

# or install from source
cd ~/lib
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env
git clone https://github.com/BurntSushi/ripgrep
cd ripgrep
cargo build --release
sudo ln -sv $PWD/target/release/rg /usr/local/bin/

# install docker
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo systemctl start docker
sudo usermod -aG docker $USER
echo  "Log out and log back in to use docker without sudo"
