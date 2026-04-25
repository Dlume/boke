# 🚀 快速部署指南

## 1️⃣ 推送代码到 GitHub

```bash
# 替换为你的 GitHub 用户名
export GH_USER="your-username"
export GH_REPO="boke"

# 添加远程仓库并推送
git remote add origin https://github.com/$GH_USER/$GH_REPO.git
git branch -M main
git push -u origin main
```

## 2️⃣ Render 一键部署

1. 登录 [Render.com](https://render.com)
2. 点击 `New +` → `Web Service`
3. 选择你刚推送的 GitHub 仓库
4. Render 会自动读取 `render.yaml` 和 `Dockerfile`
5. 点击 `Create Web Service`

## 3️⃣ 配置自动部署

1. 在 Render 服务页面 → `Settings` → `Deploy Hooks` → 复制 URL
2. 到 GitHub 仓库 → `Settings` → `Secrets and variables` → `Actions`
3. 新增 Secret:
   - **Name**: `RENDER_DEPLOY_HOOK`
   - **Value**: 粘贴刚才复制的 URL

之后每次 `git push` 到 `main`，都会自动触发部署。

## 4️⃣ 绑定自定义域名 & HTTPS

1. Render 服务 → `Settings` → `Custom Domains` → 添加域名（如 `flora.yourdomain.com`）
2. 去你的 DNS 提供商（阿里云/Cloudflare/腾讯云）添加 CNAME 记录：
   ```
   类型: CNAME
   主机记录: flora
   记录值: <your-service>.onrender.com
   TTL: 300
   ```
3. 等待 5-10 分钟，Render 会自动签发 Let's Encrypt 证书

## 5️⃣ 上线验收

访问以下路径确认服务正常：
- `/` - 首页
- `/species` - 物种列表
- `/api/species?page_size=1` - API 测试
- `/submit` - 提交表单
- `/admin` - 管理后台

运行健康检查：
```bash
./deploy/scripts/healthcheck.sh
# 预期返回: [OK] healthcheck status=200
```

## 6️⃣ 长期托管方案（可选）

如需自管服务器，参考：
- `deploy/systemd/begonia-web.service` - systemd 服务
- `deploy/supervisor/begonia-web.conf` - supervisor 配置
- `deploy/nginx/begonia.conf` - nginx + TLS 模板

完整步骤见 `DEPLOYMENT_GUIDE.md`

## ⚠️ 注意事项

- 确保 `DATABASE_URL` 等环境变量在 Render 中配置正确
- RLS 策略已包含在 `db/rls_policies.sql`，部署后需在 Supabase 执行
- Telegram Bot Token 需单独配置

## 🆘 故障排查

- **构建失败**: 检查 `requirements.txt` 和 Python 版本
- **数据库连接**: 验证 `DATABASE_URL` 格式
- **域名不解析**: 检查 DNS 传播（使用 `dig flora.yourdomain.com`）
- **SSL 未生效**: 等待 10 分钟，确认证书状态

---
📖 详细文档: `DEPLOYMENT_GUIDE.md` | `API_DESIGN.md`
🐛 问题反馈: https://github.com/dashuai136/boke/issues
