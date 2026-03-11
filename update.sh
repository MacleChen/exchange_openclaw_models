#!/bin/bash
# 快速更新脚本 — 在服务器上执行即可拉取最新代码
set -euo pipefail
WEBROOT="/var/www/openclaw-switcher"

cd "$WEBROOT"
git pull --ff-only origin main
chown -R www-data:www-data .
systemctl reload nginx

echo "✅ 更新完成"
