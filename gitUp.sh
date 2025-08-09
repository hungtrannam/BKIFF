#!/usr/bin/env bash
set -euo pipefail

REPO_URL="git@github.com:hungtrannam/BKIFF.git"
BRANCH="main"
DATETIME=$(date '+%Y-%m-%d %H:%M:%S')
MSG="[${DATETIME}] Initial commit"

echo "🚀 Khởi tạo Git và đẩy lên $REPO_URL"

# Chỉ init nếu chưa là repo
if [ ! -d .git ]; then
  git init
fi

# Thêm remote nếu chưa có
if ! git remote get-url origin >/dev/null 2>&1; then
  git remote add origin "$REPO_URL"
fi

# Tạo/checkout nhánh
git rev-parse --verify "$BRANCH" >/dev/null 2>&1 || git checkout -b "$BRANCH"
git checkout "$BRANCH"

# Nếu đang rebase dở thì hủy (tránh kẹt)
if [ -d .git/rebase-merge ] || [ -d .git/rebase-apply ]; then
  echo "⚠️  Đang rebase dở, hủy rebase."
  git rebase --abort || true
fi

# ĐẢM BẢO đã có .gitignore trước khi add
if [ ! -f .gitignore ]; then
  echo "⚠️  Chưa có .gitignore — tạo file trống tạm thời."
  touch .gitignore
fi

# Nếu đã từng add các file cần ignore, untrack chúng
git rm -r --cached . >/dev/null 2>&1 || true

# Add theo rule ignore hiện tại
git add -A
git commit -m "$MSG" || echo "ℹ️  Không có gì để commit."

# Thử đồng bộ nhánh từ remote (nếu có)
if git fetch origin "$BRANCH" >/dev/null 2>&1; then
  # Rebase nhẹ nhàng, tránh merge commit
  git pull --rebase origin "$BRANCH" || true
fi

# Push lên remote
git push -u origin "$BRANCH"
