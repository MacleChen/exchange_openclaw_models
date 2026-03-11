# OpenClaw Model Switcher

> 可视化切换 OpenClaw 默认大模型的 Web 工具

**在线访问：[http://47.93.247.205](http://47.93.247.205)**

![Static Badge](https://img.shields.io/badge/license-MIT-blue)
![Static Badge](https://img.shields.io/badge/nginx-static-green)
![Static Badge](https://img.shields.io/badge/no_backend-pure_frontend-purple)

---

## 功能

- 📂 **上传配置** — 点击或拖拽上传 `~/.openclaw/openclaw.json`
- 🤖 **选择模型** — 可视化展示所有 Provider 下的模型，含推理能力、上下文窗口、价格信息
- ✏️ **设置别名** — 自定义模型显示名称（alias）
- 🔍 **变更预览** — Diff 视图 + 完整 JSON 语法高亮预览
- ⬇️ **一键下载** — 下载修改后的 `openclaw.json`，覆盖原文件即生效
- 🔒 **隐私安全** — 所有操作在浏览器本地完成，文件不会上传到任何服务器

## 使用步骤

**1. 上传配置文件**

```bash
# 配置文件路径
~/.openclaw/openclaw.json
```

**2. 在网页上选择目标模型，确认变更预览**

**3. 下载并覆盖原配置**

```bash
mv ~/Downloads/openclaw.json ~/.openclaw/openclaw.json
```

**4. 重启 OpenClaw 生效**

```bash
openclaw restart
```

---

## 修改的字段

| 字段 | 说明 |
|------|------|
| `agents.defaults.model.primary` | 默认模型，格式为 `provider/modelId` |
| `agents.defaults.models` | 模型别名映射表 |

---

## 本地开发

无需任何构建工具，直接用浏览器打开即可：

```bash
git clone https://github.com/MacleChen/exchange_openclaw_models.git
cd exchange_openclaw_models
open index.html   # macOS
```

---

## 服务器部署

适用于 Ubuntu / Debian，一条命令完成部署：

```bash
curl -fsSL https://raw.githubusercontent.com/MacleChen/exchange_openclaw_models/main/setup.sh | sudo bash
```

脚本执行内容：
- 安装 Nginx、Git
- 克隆代码到 `/var/www/openclaw-switcher`
- 配置 Nginx 站点（含安全响应头、Gzip 压缩）
- 启动服务并放行防火墙 80 端口

**更新部署：**

```bash
sudo bash /var/www/openclaw-switcher/update.sh
```

---

## 项目结构

```
.
├── index.html      # 单文件前端应用（HTML + CSS + JS）
├── nginx.conf      # Nginx 站点配置
├── setup.sh        # 一键初始化部署脚本
├── update.sh       # 快速更新脚本
└── README.md
```

---

## License

MIT
