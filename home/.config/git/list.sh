#!/usr/bin/env bash

# inspired by http://stackoverflow.com/questions/17359370/git-show-last-commit-date-and-message-for-each-file-in-directory-like-github

# look in current working directory by default
DIR="$PWD/"
if [ -n "$1" ]; then
	DIR=$1
fi
FILES=$(git ls-tree --name-only HEAD $DIR)
MAXLEN=0
IFS=$(echo -en "\n\b")
for f in $FILES; do
    if [ ${#f} -gt $MAXLEN ]; then
        MAXLEN=${#f}
    fi
done
for f in $FILES; do
	str=$(git log -1 --pretty=format:"%C(green)%cr%Creset %x09 %C(cyan)%h%Creset %C(dim)%s%Creset %C(yellow)(%cn)%Creset" $f)
	printf "%-${MAXLEN}s -- %s\n" "$f" "$str"
done
