#!/usr/bin/env bash
#
# Delete local branches that are either:
#   1. Merged into HEAD  (git branch --merged; run this from your base branch).
#   2. Tracking a remote branch that no longer exists (': gone]').
#
# Squash-merged branches are only caught once their remote is deleted and
# pruned, so run `git fetch --prune` first.
#
# Usage: clean-local-branches   (run from main/master)

CURRENT=$(git symbolic-ref --quiet --short HEAD);

# Branches merged into HEAD (excluding the base branch itself).
merged=$(git branch --merged | sed 's/^[*+ ]*//' | grep -vxE 'main|master');

# Branches whose upstream is gone.
gone=$(git branch -vv | grep ': gone]' | sed 's/^[*+ ]*//' | awk '{print $1}');

# Combined set, blank lines and the current branch removed.
TO_REMOVE=$(printf '%s\n%s\n' "$merged" "$gone" \
  | sed '/^$/d' | grep -vxF "$CURRENT" | sort -u);

if [[ -z "$TO_REMOVE" ]]; then
  echo "You have nothing to clean";
  exit 0;
fi;

echo "The following branches are merged or have a gone upstream:";
printf "\n%s\n\n" "$TO_REMOVE";
echo "Proceed?";

select result in Yes No; do
  if [[ "$result" == "Yes" ]]; then
    echo "Removing in progress...";
    # -D (force): 'gone' branches are often squash-merged and not ancestors,
    # so -d would refuse them. The set above is already vetted as merged/gone.
    echo "$TO_REMOVE" | xargs git branch -D;
    if [[ "$?" -ne "0" ]]; then
      echo "";
      echo "Some branches were not removed, you have to do it manually!";
    else
      echo "All branches removed!";
    fi
  fi

  break;
done;
