
# Load the shell dotfiles, copied from https://github.com/mathiasbynens/dotfiles/blob/master/.bash_profile
for file in ~/.{bash_prompt,bashrc,private_vars}; do
	[ -r "$file" ] && source "$file"
done
unset file