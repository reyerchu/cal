# Cal.com 子域名遷移總結

## 遷移概述

已成功將 Cal.com 從路徑代理 (`https://defintek.io/cal`) 遷移到子域名 (`https://cal.defintek.io`)。

## 已完成的修改

### 1. 檔案修改
- ✅ **deploy.sh**: 更新註釋和訪問 URL
  - `https://defintek.io/cal` → `https://cal.defintek.io`
  - 更新部署說明（Nginx → Apache）

### 2. Apache 配置
- ✅ **移除舊配置**: 從 `default-ssl.conf` 中移除 `/cal` 代理設定
- ✅ **新增子域名配置**: 創建 `cal-defintek-io.conf`
- ✅ **WordPress 整合**: 從 `.htaccess` 中移除 `/cal` 排除規則

### 3. 清理工作
- ✅ **刪除舊檔案**: 移除 `nginx-calcom.conf`（不再需要）

## 新的訪問方式

### 舊方式（已停用）
```
https://defintek.io/cal
```

### 新方式（已啟用）
```
https://cal.defintek.io
```

## 配置檔案位置

### Apache 子域名配置
- 檔案: `/etc/apache2/sites-available/cal-defintek-io.conf`
- 狀態: 已啟用
- 代理: `http://127.0.0.1:5000/`

### 目錄結構
- 網站根目錄: `/var/www/cal.defintek.io/public_html`
- 日誌檔案: `/var/log/apache2/cal_*.log`

## DNS 設置

需要在 DNS 提供商處添加：
```
cal.defintek.io.    A    [伺服器 IP 地址]
```

## 優勢

1. **避免 Next.js basePath 問題**: 不需要特殊配置
2. **更好的隔離**: 獨立的 VirtualHost
3. **簡化配置**: 直接代理，無複雜重寫規則
4. **更好性能**: 減少路徑處理開銷
5. **易於維護**: 配置更清晰

## 測試步驟

1. 設置 DNS 記錄
2. 等待 DNS 傳播（5-30 分鐘）
3. 測試訪問: `https://cal.defintek.io`
4. 檢查 SSL 證書

## 故障排除

如果遇到問題：
- 檢查 Apache 錯誤日誌: `/var/log/apache2/cal_error.log`
- 檢查 Cal.com 服務狀態: `curl -I http://localhost:5000`
- 檢查 Apache 配置: `sudo apache2ctl configtest`

## 完成時間

遷移完成時間: 2025-06-23 