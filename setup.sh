#!/bin/bash
# ================================================================
# OpenClaw Model Switcher — 一键服务器部署脚本
# 适用：Ubuntu / Debian
# 使用：sudo bash setup.sh
# ================================================================

set -euo pipefail

REPO="https://github.com/MacleChen/exchange_openclaw_models.git"
WEBROOT="/var/www/openclaw-switcher"
NGINX_CONF="/etc/nginx/sites-available/openclaw-switcher"
NGINX_LINK="/etc/nginx/sites-enabled/openclaw-switcher"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'; BOLD='\033[1m'
log()   { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERR]${NC}   $*"; exit 1; }

# ── Root check ─────────────────────────────────────────────────
[[ $EUID -ne 0 ]] && error "请使用 sudo 运行此脚本"

echo ""
echo -e "${BOLD}================================================${NC}"
echo -e "${BOLD}   OpenClaw Model Switcher — 自动部署${NC}"
echo -e "${BOLD}================================================${NC}"
echo ""

# ── 1. 系统更新 & 安装依赖 ────────────────────────────────────
log "更新系统包列表..."
apt-get update -qq

log "安装 Nginx 和 Git..."
apt-get install -y -qq nginx git curl

# ── 2. 拉取代码 ────────────────────────────────────────────────
log "部署网站文件到 ${WEBROOT}..."
if [[ -d "$WEBROOT/.git" ]]; then
  cd "$WEBROOT"
  git pull --ff-only origin main
  ok "代码已更新"
else
  rm -rf "$WEBROOT"
  git clone "$REPO" "$WEBROOT"
  ok "代码已克隆"
fi

# ── 3. 设置权限 ────────────────────────────────────────────────
chown -R www-data:www-data "$WEBROOT"
chmod -R 755 "$WEBROOT"
ok "文件权限设置完成"

# ── 4. 配置 Nginx ──────────────────────────────────────────────
log "写入 Nginx 配置..."
cp "${WEBROOT}/nginx.conf" "$NGINX_CONF"

# 启用站点
[[ -L "$NGINX_LINK" ]] && rm "$NGINX_LINK"
ln -s "$NGINX_CONF" "$NGINX_LINK"

# 删除 default 站点（避免端口冲突）
[[ -L "/etc/nginx/sites-enabled/default" ]] && rm /etc/nginx/sites-enabled/default && warn "已禁用 Nginx default 站点"

# 测试配置
nginx -t || error "Nginx 配置测试失败，请检查 ${NGINX_CONF}"
ok "Nginx 配置验证通过"

# ── 5. 启动/重载 Nginx ─────────────────────────────────────────
log "启动 Nginx 服务..."
systemctl enable nginx --quiet
systemctl restart nginx
ok "Nginx 已启动"

# ── 6. 防火墙（如果有 ufw）─────────────────────────────────────
if command -v ufw &>/dev/null && ufw status | grep -q "Status: active"; then
  ufw allow 80/tcp >/dev/null 2>&1 && ok "防火墙已放行 80 端口"
fi

# ── 7. 获取服务器 IP ───────────────────────────────────────────
SERVER_IP=$(curl -s --max-time 5 https://ipv4.icanhazip.com 2>/dev/null || hostname -I | awk '{print $1}')

# ── 完成 ───────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}================================================${NC}"
echo -e "${GREEN}${BOLD}   部署完成！${NC}"
echo -e "${GREEN}${BOLD}================================================${NC}"
echo ""
echo -e "  访问地址：${BOLD}http://${SERVER_IP}${NC}"
echo ""
echo -e "  后续更新只需在服务器执行："
echo -e "  ${CYAN}cd ${WEBROOT} && git pull && systemctl reload nginx${NC}"
echo ""
