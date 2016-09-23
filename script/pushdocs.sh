#!/usr/bin/env bash

if [ "$TRAVIS_BRANCH" != "master" ] || [ "$BUILD_DOCS" != "yes" ] ; then
    exit 0
fi

DOCS_REPO_NAME="travis-test-target"
DOCS_REPO_URL="git@github.com:sbstp/travis-test-target.git"

# deal with private key
openssl aes-256-cbc -K $encrypted_7d232113fa70_key -iv $encrypted_7d232113fa70_iv -in key.enc -out key -d
chmod 600 key
eval `ssh-agent -s`
ssh-add key

# clone the repo
git clone "$DOCS_REPO_URL" "$DOCS_REPO_NAME"
bash script/makedocs.sh "$DOCS_REPO_NAME"

# gti stuff
cd "$DOCS_REPO_NAME"
git config user.name "Travis CI"
git config user.email "<>"
git add --all
# Check if anythhing changed, and if it's the case, push to origin/master.
if git commit -m "update docs to commit=$TRAVIS_COMMIT" ; then
    git push origin master
fi
