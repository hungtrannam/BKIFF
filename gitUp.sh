#!/bin/bash

REPO_URL="git@github.com:hungtrannam/BKIFF.git"
BRANCH="main"
DATETIME=$(date '+%Y-%m-%d %H:%M:%S')
MSG="[$DATETIME] Initial commit"

echo "🚀 Khởi tạo Git và đẩy lên $REPO_URL"

git init
git remote add origin "$REPO_URL"
git checkout -b "$BRANCH"
git add -A
git commit -m "$MSG"
git push -u origin "$BRANCH"
