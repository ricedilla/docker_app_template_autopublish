# Scripts Documentation

This directory contains utility scripts for deployment automation and troubleshooting.

## 📁 Scripts Overview

### 🔑 `setup-secrets.sh`
**Purpose**: Automate GitHub secrets configuration for deployment

**Features:**
- ✨ **Non-interactive setup** - No prompts, reads from config file
- 🎯 **Auto-repo detection** - Finds GitHub repo automatically  
- 🔒 **Secure secret management** - Pushes secrets to GitHub safely
- 🚀 **Workflow enablement** - Enables GitHub Actions for forks
- 📋 **Validation** - Checks all prerequisites before setup

**Usage:**
```bash
# 1. Copy and customize configuration
cp deploy-secrets.conf.example deploy-secrets.conf
nano deploy-secrets.conf

# 2. Run setup
./setup-secrets.sh
```

**Configuration File**: `deploy-secrets.conf`
```bash
# Server connection details
DEPLOY_HOST=your-server.roca.tools
DEPLOY_USER=rice

# GitHub personal access token (with repo and workflow permissions)
GITHUB_TOKEN=ghp_your_token_here

# SSH private key (base64 encoded)
SSH_PRIVATE_KEY_BASE64=LS0tLS1CR...your_key_here...
```

### 🐛 `debug-npm.sh`
**Purpose**: Diagnose Nginx Proxy Manager (NPM) authentication and connectivity issues

**Features:**
- 🌐 **Connectivity testing** - Verifies NPM host accessibility
- 🔐 **Authentication testing** - Tests NPM API login
- 📊 **Detailed diagnostics** - Shows response codes and errors
- 💡 **Troubleshooting tips** - Provides actionable suggestions

**Usage:**
```bash
# Run on deployment server
./debug-npm.sh
```

### 📋 `deploy-secrets.conf.example`
**Purpose**: Template configuration file for secret setup

---

## 🔧 Troubleshooting Guide

### GitHub Secrets Setup Issues

**Problem**: Authentication or workflow trigger issues
**Solutions:**
1. **Check token permissions**: Token needs `repo` and `workflow` scopes
2. **Enable Actions on forks**: Go to repository Settings → Actions → Enable
3. **Manual trigger**: Use "Run workflow" button in Actions tab

### NPM Authentication Issues

**Problem**: NPM returns 401 authentication error
**Solutions:**
1. **Check credentials**: Verify NPM email/password in server `.env` file
2. **Test manual login**: Log into NPM web interface with same credentials  
3. **Run debug script**: `./debug-npm.sh` for detailed diagnostics

### Deployment Issues

**Problem**: Container fails to start or app not accessible
**Solutions:**
1. **Check logs**: View container logs and GitHub Actions logs
2. **Platform mismatch**: Ensure Docker image matches server architecture (ARM64/AMD64)
3. **NPM proxy**: Ensure reverse proxy is configured correctly
4. **Container status**: Verify container is running and healthy

---

## 📚 Related Documentation

- **[../README.md](../README.md)** - Main project documentation
- **[../USER_GUIDE.md](../USER_GUIDE.md)** - Complete setup guide
- **[../deploy/README.md](../deploy/README.md)** - Deployment configuration
