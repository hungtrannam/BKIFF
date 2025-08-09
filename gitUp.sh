#!/usr/bin/env bash
set -e
BRANCH="main"

# Kiểm tra remote, nếu chưa có thì thêm
if ! git remote | grep -q origin; then
    git remote add origin git@github.com:hungtrannam/BKIFF.git
fi

# Add, commit, push
git add -A
git commit -m "[${BRANCH}] $(date '+%F %T')" || echo "⚠️ Không có thay đổi để commit"
git push -u origin "$BRANCH"
