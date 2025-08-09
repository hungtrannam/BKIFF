#!/bin/bash
set -e

echo "[1/4] Kiểm tra repo..."
if [ ! -d .git ]; then
    echo "Repo chưa khởi tạo. Tiến hành init..."
    git init
    git branch -M main
    git remote add origin git@github.com:hungtrannam/BKIFF.git
fi

echo "[2/4] Thêm file thay đổi..."
git add .
git commit -m "Update $(date '+%Y-%m-%d %H:%M:%S')" || echo "Không có gì để commit"

echo "[3/4] Push lên GitHub qua SSH..."
git push -u origin main

echo "[4/4] Hoàn tất ✅"
