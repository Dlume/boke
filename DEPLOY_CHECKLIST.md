# 🛠️ 完整部署操作手册

## 📥 第一步：获取 PR #3 代码

### 方式 A：Fork 并 Clone（推荐）
```bash
# 1. 在 GitHub 网页 Fork 仓库
# 访问: https://github.com/dashuai136/boke/pull/3
# 点击 Fork 按钮，选择你的账号

# 2. Clone 你的 Fork 到本地
git clone https://github.com/YOUR_USERNAME/boke.git my-boke
cd my-boke

# 3. 切换到 PR #3 的分支（如果 PR 未合并）
git fetch origin pull/3/head:pr3
git checkout pr3
```

### 方式 B：直接下载 ZIP
1. 访问 https://github.com/dashuai136/boke/pull/3
2. 点击 `Code` → `Download ZIP`
3. 解压到本地目录

## 📦 第二步：合并优化文件

你的本地优化文件位于：`D:\QwenPawOut001\boke-repo\`
需要将以下文件复制到你的项目目录：

```
📁 必须复制的文件：
├── db/rls_policies.sql          # 数据库安全策略
├── scripts/telegram_push.py     # Telegram 推送脚本
├── frontend/package.json        # Next.js 配置
├── Dockerfile                   # 容器化配置
├── render.yaml                  # Render 部署配置
├── requirements.txt             # Python 依赖
├── deploy/                      # 部署脚本和配置
│   ├── scripts/healthcheck.sh
│   ├── systemd/begonia-web.service
│   ├── supervisor/begonia-web.conf
│   └── nginx/begonia.conf
├── DEPLOYMENT_GUIDE.md
└── QUICKSTART.md
```

**合并命令：**
```bash
# 假设你的项目目录为 ./my-boke
cp -r D:/QwenPawOut001/boke-repo/db/rls_policies.sql ./my-boke/db/
cp D:/QwenPawOut001/boke-repo/scripts/telegram_push.py ./my-boke/scripts/
cp D:/QwenPawOut001/boke-repo/frontend/package.json ./my-boke/frontend/
cp D:/QwenPawOut001/boke-repo/Dockerfile ./my-boke/
cp D:/QwenPawOut001/boke-repo/render.yaml ./my-boke/
cp D:/QwenPawOut001/boke-repo/requirements.txt ./my-boke/
cp -r D:/QwenPawOut001/boke-repo/deploy ./my-boke/
```

## 🚀 第三步：推送到 GitHub

```bash
cd my-boke

# 添加你的远程仓库
git remote add origin https://github.com/YOUR_USERNAME/boke.git

# 提交所有文件
git add -A
git commit -m "feat: merge PR3 with deployment optimizations"

# 推送
git branch -M main
git push -u origin main
```

## 🌐 第四步：Render 部署

1. 登录 https://render.com
2. `New +` → `Web Service` → 选择你的仓库
3. 自动识别 `render.yaml`，点击 `Create`
4. 等待构建完成（约 2-3 分钟）

## 🔒 第五步：绑定域名

1. Render 服务 → `Settings` → `Custom Domains` → 添加 `flora.yourdomain.com`
2. DNS 添加 CNAME：
   ```
   Type: CNAME
   Name: flora
   Value: <your-service>.onrender.com
   ```
3. 等待 SSL 证书签发（5-10 分钟）

## ✅ 第六步：验收

```bash
# 健康检查
./deploy/scripts/healthcheck.sh

# 访问测试
curl https://flora.yourdomain.com/
curl https://flora.yourdomain.com/species
curl https://flora.yourdomain.com/api/species?page_size=1
```

## ⚠️ 重要提醒

1. **环境变量**：在 Render 中配置以下 Secrets：
   - `DATABASE_URL`: Supabase/PostgreSQL 连接字符串
   - `SUPABASE_URL`: Supabase 项目 URL
   - `SUPABASE_KEY`: Supabase anon key
   - `TELEGRAM_BOT_TOKEN`: Bot Token（如需推送功能）

2. **数据库初始化**：部署后在 Supabase SQL Editor 执行：
   ```sql
   -- 执行 schema
   \i db/schema_v1_patched.sql
   -- 启用 RLS
   \i db/rls_policies.sql
   ```

3. **GitHub Actions**：已配置 CI 流程，推送后自动运行测试。

## 🆘 常见问题

**Q: gh CLI 认证失败？**
A: 使用 HTTPS 推送，或配置 Personal Access Token：
```bash
git remote set-url origin https://YOUR_TOKEN@github.com/YOUR_USERNAME/boke.git
```

**Q: Render 构建失败？**
A: 检查 `requirements.txt` 版本兼容性，确保 Python 3.11+。

**Q: 域名 SSL 未生效？**
A: 检查 DNS 传播：`dig flora.yourdomain.com CNAME`，等待 10 分钟。

---
📖 详细文档: `DEPLOYMENT_GUIDE.md`
🔧 技术支持: 检查 `QUICKSTART.md`
