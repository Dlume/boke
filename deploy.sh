#!/bin/bash
# 🚀 一键推送与部署脚本
# 使用前请替换 YOUR_GITHUB_USERNAME 和 YOUR_GITHUB_TOKEN

set -e

# =========================
# 配置区 (请替换!)
# =========================
GH_USER="YOUR_GITHUB_USERNAME"
GH_TOKEN="YOUR_GITHUB_TOKEN"
GH_REPO="boke"

# =========================
# 1. 配置 Git 并推送
# =========================
echo "📦 配置 Git 远程仓库..."
cd D:\QwenPawOut001\boke-repo

# 使用 Token 认证推送
git remote set-url origin "https://${GH_USER}:${GH_TOKEN}@github.com/${GH_USER}/${GH_REPO}.git"

echo "🚀 推送代码到 GitHub..."
git branch -M main
git push -u origin main --force

echo "✅ 代码已推送: https://github.com/${GH_USER}/${GH_REPO}"

# =========================
# 2. 本地验证 (可选)
# =========================
echo ""
echo "🔍 本地验证..."
python webapp/init_db.py
python webapp/app.py &
APP_PID=$!
sleep 3

curl -s http://127.0.0.1:8080/ > /dev/null && echo "✅ 首页正常"
curl -s http://127.0.0.1:8080/species > /dev/null && echo "✅ 物种列表正常"
curl -s http://127.0.0.1:8080/api/species?page_size=1 > /dev/null && echo "✅ API 正常"

kill $APP_PID 2>/dev/null
echo "🎉 本地验证完成！"

# =========================
# 3. Render 部署提示
# =========================
echo ""
echo "🌐 下一步：Render 部署"
echo "1. 登录 https://render.com"
echo "2. New + → Web Service → 选择仓库: ${GH_USER}/${GH_REPO}"
echo "3. 自动识别 render.yaml，点击 Create"
echo "4. 获取公网地址: https://<your-service>.onrender.com"

# =========================
# 4. 域名绑定提示
# =========================
echo ""
echo "🔒 绑定自定义域名"
echo "1. Render 服务 → Settings → Custom Domains → 添加域名"
echo "2. DNS 添加 CNAME 记录指向 <your-service>.onrender.com"
echo "3. 等待 SSL 证书签发 (5-10 分钟)"

echo ""
echo "🎉 全部完成！"
