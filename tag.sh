#!/bin/bash
# Version Tagging and Release Logic:
# 1. Increments the patch version (3rd digit) in the 'version' file.
# 2. Saves the new version string back to the 'version' file.
# 3. Stages the updated 'version' file for git.
# 4. Commits the change with an "incrementing version" message.
# 5. Pushes the commit to the remote repository.


set -e
trap 'echo "[ERROR] Error in line $LINENO when executing: $BASH_COMMAND"' ERR

VERSION="3.14.$(( $(cat version | cut -d'.' -f3) + 1 ))"
echo "$VERSION" > version
git add version

git commit -m "incrementing version: $VERSION"
git push
