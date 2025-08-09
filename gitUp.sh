#!/bin/bash

# ===== CẤU HÌNH =====
REPO_URL="https://github.com/hungtrannam/BKIFF.git"
BRANCH="main"  # hoặc 'master' tùy repo bạn

# ===== BẮT ĐẦU =====
echo "[1/4] Kiểm tra repo..."
if [ ! -d ".git" ]; then
    echo "Repo chưa khởi tạo. Tiến hành clone..."
    git clone "$REPO_URL" .
fi

echo "[2/4] Thêm file thay đổi..."
git add .

# ===== Commit với thời gian =====
COMMIT_MSG="Update on $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MSG"

echo "[3/4] Push lên GitHub..."
git branch -M $BRANCH
git remote set-url origin "$REPO_URL"
git push -u origin $BRANCH

echo "[4/4] Hoàn tất ✅"
