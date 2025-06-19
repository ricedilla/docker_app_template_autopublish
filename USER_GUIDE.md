# 🚀 User Deployment Guide

How to fork the template and deploy to the shared server.

## 👥 For Team Admin (One-Time Setup)

### 1. Generate Shared Deployment Key **ON THE SERVER**
```bash
# SSH into your deployment server first
ssh rice@subdomain.roca.tools

# Then on the server, generate the key:
ssh-keygen -t rsa -b 4096 -f ~/.ssh/team_deploy -N ""

# Add to authorized_keys (on the server)
cat ~/.ssh/team_deploy.pub >> ~/.ssh/authorized_keys

# Show the private key to copy/share with team (on the server)
cat ~/.ssh/team_deploy
```

### 2. Share Server Access Details
Your team needs these details to add as GitHub Secrets:
- **Server IP/hostname**: `subdomain.roca.tools` (or IP address)
- **SSH username**: `rice` (or whatever user runs Docker)
- **SSH private key**: Contents of `~/.ssh/team_deploy` (from the server)

---

## 👤 For Each User/Coworker

### 1. Fork the Template
```bash
# On GitHub: Fork the example_project repo
# Or clone and create new repo:
git clone <template-repo> my-awesome-app
cd my-awesome-app
git remote set-url origin <your-new-repo-url>
```

### 2. Add GitHub Secrets
In your forked repo: **Settings** → **Secrets and variables** → **Actions**

Add these **Repository Secrets**:

| Secret Name | Value | Example |
|-------------|-------|---------|
| `DEPLOY_HOST` | Server IP/hostname | `subdomain.roca.tools` |
| `DEPLOY_USER` | SSH username | `rice` |
| `SSH_PRIVATE_KEY` | Private key from admin | `-----BEGIN RSA PRIVATE KEY-----...` |

**🚀 Automated Setup**: Use the included script to set up secrets automatically:
```bash
cd scripts
cp deploy-secrets.conf.example deploy-secrets.conf
# Edit deploy-secrets.conf with your values
./setup-secrets.sh
```

**📋 Enable Workflows**: For forked repositories, you may need to manually enable GitHub Actions:
1. Go to your repository's **Actions** tab
2. Click **"I understand my workflows, go ahead and enable them"**

### 3. Customize Your App
```javascript
// src/server.js - Your app code
const http = require('http');
const PORT = 3000;
http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('My awesome app!\n');  // 👈 Edit this
}).listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}/`);
});
```

```bash
# deploy/host.config - Your hostname
HOST=my-awesome-app.roca.tools  # 👈 Edit this
PORT=3000
```

### 4. Deploy
```bash
git add .
git commit -m "My awesome app ready for deployment"

# Create and push to production branch (first time only)
git checkout -b production
git push -u origin production

# For subsequent deployments, just push to production:
# git push origin production
```

### 5. Done! 🎉
Your app is now live at: `https://my-awesome-app.roca.tools`

---

## 🔐 Security Notes

- The shared SSH key gives access to deploy to the server
- Keep the private key secure (don't commit to repos)
- Admin can revoke access by removing the public key from server
- For better security, use individual SSH keys per user

---

## 🆘 Troubleshooting

### "Permission denied (publickey)"
- Check that GitHub Secrets are set correctly
- Verify SSH private key format (should start with `-----BEGIN`)

### "Host key verification failed"
- Add server to known_hosts or disable host key checking in workflow

### Deployment fails
- Check GitHub Actions logs in your repo
- Verify server is accessible and npm_api_manager is working
