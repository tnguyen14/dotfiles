#!/usr/bin/env bash
set -o errexit
 
# Author: David Underhill
# Script to permanently delete files/folders from your git repository.  To use 
# it, cd to your repository's root and then run the script with a list of paths
# you want to delete, e.g., git-delete-history path1 path2
 
if [ $# -eq 0 ]; then
  exit 0
fi
 
# make sure we're at the root of git repo
if [ ! -d .git ]; then
  echo "Error: must run this script from the root of a git repository"
  exit 1
fi
 
# remove all paths passed as arguments from the history of the repo
files=$@
git filter-branch --force --index-filter "git rm -rf --cached --ignore-unmatch $files" --prune-empty --tag-name-filter cat -- --all
 
# remove the temporary history git-filter-branch otherwise leaves behind for a long time
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now
