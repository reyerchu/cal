# Google OAuth 设置指南

## 概述
Cal.com 已配置为只允许通过 Google 邮箱登录，新用户注册功能已禁用。

## 获取 Google OAuth 凭据

### 1. 创建 Google Cloud 项目
1. 访问 [Google Cloud Console](https://console.cloud.google.com/)
2. 创建新项目或选择现有项目
3. 启用 Google+ API 和 Google Calendar API

### 2. 配置 OAuth 同意屏幕
1. 在 Google Cloud Console 中，转到 "API 和服务" > "OAuth 同意屏幕"
2. 选择 "内部" 应用类型（推荐用于自托管）
3. 填写应用信息：
   - 应用名称：Cal.com
   - 用户支持电子邮件：你的邮箱
   - 开发者联系信息：你的邮箱
4. 在 "作用域" 页面，添加以下作用域：
   - `https://www.googleapis.com/auth/userinfo.profile`
   - `https://www.googleapis.com/auth/userinfo.email`
   - `https://www.googleapis.com/auth/calendar.readonly`
   - `https://www.googleapis.com/auth/calendar.events`
5. 在 "测试用户" 页面，添加允许登录的 Google 邮箱地址

### 3. 创建 OAuth 2.0 凭据
1. 转到 "API 和服务" > "凭据"
2. 点击 "创建凭据" > "OAuth 客户端 ID"
3. 选择 "Web 应用程序"
4. 添加授权重定向 URI：
   - `https://cal.defintek.io/api/auth/callback/google`
   - `https://cal.defintek.io/api/integrations/googlecalendar/callback`
5. 点击 "创建"

### 4. 下载并配置凭据
1. 下载 JSON 格式的凭据文件
2. 打开 `.env` 文件
3. 将 JSON 内容复制到 `GOOGLE_API_CREDENTIALS` 变量中，例如：
   ```
   GOOGLE_API_CREDENTIALS={"web":{"client_id":"your-actual-client-id.apps.googleusercontent.com","client_secret":"your-actual-client-secret"}}
   ```

## 当前配置状态

### 已启用的功能：
- ✅ Google OAuth 登录已启用
- ✅ 新用户注册已禁用
- ✅ 只允许现有用户通过 Google 登录

### 需要完成的步骤：
1. 获取真实的 Google OAuth 凭据
2. 更新 `.env` 文件中的 `GOOGLE_API_CREDENTIALS`
3. 重启 Docker 容器

## 重启服务
配置完成后，重启 Docker 容器：
```bash
docker-compose down
docker-compose up -d
```

## 测试登录
1. 访问 https://cal.defintek.io
2. 点击 "使用 Google 登录"
3. 只有已存在的用户才能成功登录
4. 新用户尝试登录时会看到错误消息

## 注意事项
- 确保 Google Cloud 项目配置为 "内部" 应用类型
- 只有添加到测试用户列表的邮箱才能登录
- 如果需要在生产环境中使用，需要将应用发布到生产环境 