#!/usr/bin/env bash

if [ "$TRAVIS_BRANCH" != "master" ] || [ "$BUILD_DOCS" != "yes" ] ; then
    exit
fi

DOCS_REPO_NAME="travis-test-target"
DOCS_REPO_URL="git@github.com:sbstp/travis-test-target.git"

openssl aes-256-cbc -K $encrypted_7d232113fa70_key -iv $encrypted_7d232113fa70_iv -in key.enc -out key -d
ssh-add key
rm key

git clone "$DOCS_REPO_URL" "$DOCS_REPO_NAME"
bash script/makedocs.sh "$DOCS_REPO_NAME"

cd "$DOCS_REPO_NAME"
git add --all
# Check if anythhing changed, and if it's the case, push to origin/master.
if git commit --author="Automated Update <>" -m 'update docs' ; then
    git push origin master
fi
