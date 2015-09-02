#!/usr/bin/env bash

# inspired by https://github.com/aredridel/git-create-deploy-branch v1.0.1

set -e

CDUP="`git rev-parse --show-cdup`"

if [ -n "$CDUP" ]; then
    cd "$CDUP"
fi

GIT_DIR=`git rev-parse --git-dir`

NEW_INDEX_FILE="$GIT_DIR/deploy-index"

CURRENT_BRANCH=`git symbolic-ref --short HEAD`
CURRENT_COMMIT=`git rev-parse HEAD`

DEPLOY_BRANCH=deploy/$CURRENT_BRANCH
DEPLOY_BRANCH_EXISTS=`git branch --list $DEPLOY_BRANCH`

if [ -z "$DEPLOY_BRANCH_EXISTS" ]; then
    git branch $DEPLOY_BRANCH $CURRENT_BRANCH
fi

git read-tree $DEPLOY_BRANCH --index-output="$NEW_INDEX_FILE"

GIT_INDEX_FILE="$NEW_INDEX_FILE"
export GIT_INDEX_FILE

if [ -n "$1" ]; then
    git add -f "$@"
elif [ -e .gitdeploy ]; then
    while IFS= read -r ENT; do
        git add -f "$ENT"
    done < .gitdeploy
else
    git add -f .
fi

CHANGES="`git diff-index $DEPLOY_BRANCH: --cached`"

if [ -z "$CHANGES" ] && [ -z "$DEPLOY_BRANCH_EXISTS" -o -n "`git branch --contains HEAD $DEPLOY_BRANCH`" ] ; then
    echo "Nothing to do" 1>&2
    exit 1
fi

CURRENT_DEPLOY_COMMIT=`git rev-parse $DEPLOY_BRANCH`

PARENT="-p $CURRENT_COMMIT"
if [ $CURRENT_DEPLOY_COMMIT != $CURRENT_COMMIT ]; then
    PARENT="$PARENT -p $CURRENT_DEPLOY_COMMIT"
fi

TREE=`git write-tree`
COMMIT=`git commit-tree $TREE -m "deploy $CURRENT_BRANCH" $PARENT`

git update-ref refs/heads/$DEPLOY_BRANCH $COMMIT

if [ $CURRENT_DEPLOY_COMMIT != $CURRENT_COMMIT ]; then
    echo `git rev-parse --short $CURRENT_DEPLOY_COMMIT`..`git rev-parse --short $COMMIT`    $DEPLOY_BRANCH
else
    echo '[new branch]' `git rev-parse --short $COMMIT`    $DEPLOY_BRANCH
fi

exit
