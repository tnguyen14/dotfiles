if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

# load bash_local finally to override anything else
if [ -f ~/.bash_local]; then
	source ~/.bash_local
fi