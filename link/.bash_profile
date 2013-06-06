
# Load the shell dotfiles, copied from https://github.com/mathiasbynens/dotfiles/blob/master/.bash_profile
for file in ~/.{bash_prompt,bashrc}; do
	[ -r "$file" ] && source "$file"
done
unset file