#!/bin/bash

# Cal.com 自動部署腳本
# 適用於 https://cal.defintek.io

set -e

echo "🚀 開始部署 Cal.com..."

# 檢查 Docker 是否已安裝
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安裝，正在安裝..."
    sudo apt update
    sudo apt install -y docker.io docker-compose
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
    echo "✅ Docker 安裝完成"
else
    echo "✅ Docker 已安裝"
fi

# 檢查 .env 檔案
if [ ! -f .env ]; then
    echo "❌ .env 檔案不存在，請先設定環境變數"
    exit 1
fi

# 停止現有容器
echo "🛑 停止現有容器..."
docker-compose down || true

# 拉取最新映像
echo "📥 拉取最新映像..."
docker-compose pull

# 啟動服務
echo "🚀 啟動 Cal.com 服務..."
docker-compose up -d

# 等待服務啟動
echo "⏳ 等待服務啟動..."
sleep 30

# 檢查服務狀態
echo "🔍 檢查服務狀態..."
docker-compose ps

# 檢查健康狀態
echo "🏥 檢查健康狀態..."
if curl -f http://localhost:5000/api/health > /dev/null 2>&1; then
    echo "✅ Cal.com 服務已成功啟動！"
    echo "🌐 請訪問: https://cal.defintek.io"
    echo ""
    echo "📝 下一步："
    echo "1. 設定 Google OAuth 憑證（編輯 .env 檔案）"
    echo "2. 設定 Apache 反向代理（參考 cal-defintek-io.conf）"
    echo "3. 重新載入 Apache: sudo systemctl reload apache2"
else
    echo "❌ 服務啟動失敗，請檢查日誌："
    docker-compose logs calcom
fi 