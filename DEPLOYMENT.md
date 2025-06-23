# Cal.defintek.io Deployment Guide

This repository contains a self-hosted Cal.com instance configured for cal.defintek.io with Google OAuth integration.

## Prerequisites

- Docker and Docker Compose installed
- Google Cloud Console project with OAuth 2.0 credentials
- Domain configured (cal.defintek.io)

## Setup Instructions

### 1. Google OAuth Configuration

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing project
3. Enable the Google+ API and Google Calendar API
4. Create OAuth 2.0 credentials:
   - Application type: Web application
   - Authorized redirect URIs:
     - `https://cal.defintek.io/api/auth/callback/google`
     - `https://cal.defintek.io/api/integrations/googlecalendar/callback`
5. Download the credentials JSON file

### 2. Environment Configuration

Before running the application, you need to update the `docker-compose.yml` file with your actual credentials:

1. Replace `YOUR_GOOGLE_CLIENT_ID` with your actual Google Client ID
2. Replace `YOUR_GOOGLE_PROJECT_ID` with your actual Google Project ID  
3. Replace `YOUR_GOOGLE_CLIENT_SECRET` with your actual Google Client Secret
4. Update `CALENDSO_ENCRYPTION_KEY` with a secure 32-character random string
5. Update `NEXTAUTH_SECRET` with a secure random string

### 3. Deployment

```bash
# Clone the repository
git clone https://github.com/reyerchu/cal.git
cd cal

# Update docker-compose.yml with your credentials
# (Edit the file and replace placeholder values)

# Start the services
docker-compose up -d

# Check service status
docker-compose ps
```

### 4. Apache Reverse Proxy Configuration

The repository includes Apache configuration files in the `~/` directory:
- `cal.defintek.io.conf` - Main site configuration
- `calcom-apache.conf` - Additional Apache settings

Copy these files to your Apache configuration directory and restart Apache.

### 5. Verification

1. Visit `https://cal.defintek.io`
2. Click "Sign in with Google"
3. Complete the OAuth flow
4. Verify calendar integration works

## Security Notes

- Never commit actual OAuth credentials to version control
- Use environment variables or secure secret management in production
- Regularly rotate encryption keys and secrets
- Keep Docker images updated

## Troubleshooting

- Check container logs: `docker-compose logs calcom`
- Verify database connection: `docker-compose logs db`
- Ensure Apache proxy is correctly configured
- Check Google OAuth app settings in Google Cloud Console

## Support

For issues related to this deployment, check the logs and verify all configuration steps have been completed correctly. 