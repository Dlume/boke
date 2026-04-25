#!/bin/bash
# 🚀 Begonia Illustrated - One-Click Deploy Script
# Usage: chmod +x deploy.sh && ./deploy.sh

set -e

# =========================
# Configuration (Replace these!)
# =========================
GH_USER="YOUR_GITHUB_USERNAME"        # 替换为你的 GitHub 用户名
GH_REPO="boke"                        # 仓库名
RENDER_SERVICE_NAME="begonia-illustrated"
CUSTOM_DOMAIN="flora.yourdomain.com"  # 你的自定义域名

# =========================
# Step 1: Push to GitHub
# =========================
echo "📦 Step 1: Pushing to GitHub..."
if ! git remote get-url origin > /dev/null 2>&1; then
    git remote add origin "https://github.com/$GH_USER/$GH_REPO.git"
fi

git branch -M main
git push -u origin main
echo "✅ Code pushed to GitHub: https://github.com/$GH_USER/$GH_REPO"

# =========================
# Step 2: Render Deployment (Manual)
# =========================
echo ""
echo "🌐 Step 2: Deploy to Render"
echo "1. Go to: https://render.com"
echo "2. Click 'New +' → 'Web Service'"
echo "3. Connect your GitHub repo: $GH_USER/$GH_REPO"
echo "4. Render will auto-detect render.yaml"
echo "5. Click 'Create Web Service'"
echo ""
read -p "Press Enter after creating the service on Render..."

# =========================
# Step 3: Setup Auto-Deploy
# =========================
echo ""
echo "🔄 Step 3: Setup Auto-Deploy"
echo "1. In Render Service → Settings → Deploy Hooks → Copy URL"
echo "2. Go to GitHub Repo → Settings → Secrets → Actions"
echo "3. Add secret: RENDER_DEPLOY_HOOK = <paste-url>"
echo ""
read -p "Press Enter after adding the secret..."

# =========================
# Step 4: Custom Domain & HTTPS
# =========================
echo ""
echo "🔒 Step 4: Bind Custom Domain"
echo "1. Render Service → Settings → Custom Domains → Add: $CUSTOM_DOMAIN"
echo "2. Add CNAME record in your DNS provider:"
echo "   Type: CNAME"
echo "   Name: flora (or @)"
echo "   Value: <your-render-service>.onrender.com"
echo "3. Wait 5-10 mins for SSL certificate"
echo ""
read -p "Press Enter after configuring DNS..."

# =========================
# Step 5: Verification
# =========================
echo ""
echo "✅ Step 5: Verification"
echo "Visit these endpoints:"
echo "  - https://$CUSTOM_DOMAIN/"
echo "  - https://$CUSTOM_DOMAIN/species"
echo "  - https://$CUSTOM_DOMAIN/api/species?page_size=1"
echo "  - https://$CUSTOM_DOMAIN/submit"
echo "  - https://$CUSTOM_DOMAIN/admin"
echo ""
echo "Run health check:"
echo "  ./deploy/scripts/healthcheck.sh"
echo ""
echo "🎉 Deployment complete!"
