# Docker App Template with Auto-Publish

🚀 **Production-ready template** for deploying Dockerized Node.js apps with fully automated GitHub Actions pipeline.

## ✨ Key Features

- 🤖 **Fully Automated Deployment** - Push to `production` branch, app goes live
- 🏗️ **Multi-Architecture Support** - ARM64 and AMD64 compatible
- 🔒 **Secure Secret Management** - Automated GitHub secrets setup
- 🌐 **SSL/HTTPS Ready** - Automatic reverse proxy with Nginx Proxy Manager
- 📋 **Zero Configuration** - Smart defaults with optional customization
- 🔧 **Debug Tools** - Built-in debugging and monitoring scripts

## ⚡ Quick Start

1. **Fork this template** → Create your project
2. **Run setup script** → `./scripts/setup-secrets.sh` (see [USER_GUIDE.md](USER_GUIDE.md))
3. **Edit your app** in `src/server.js` 
4. **Set your hostname** in `deploy/host.config`
5. **Push to `production` branch** → **App goes live automatically!** 🎉

📖 **Complete setup guide:** [USER_GUIDE.md](USER_GUIDE.md)

---

## 📁 What's Included

```
docker-app-template/
├── src/
│   ├── server.js          # 👈 Your application code
│   ├── package.json       # Dependencies and scripts
│   └── Dockerfile         # Multi-stage Docker build
├── deploy/
│   ├── host.config        # 👈 Deployment configuration
│   └── docker-compose.yml # Container orchestration
├── scripts/
│   ├── setup-secrets.sh   # 🔑 Automated secret setup
│   ├── debug-npm.sh       # 🐛 NPM troubleshooting
│   └── README.md          # Scripts documentation
└── .github/workflows/
    └── deploy.yml         # � Automated CI/CD pipeline
```

---

## 🔧 Quick Start

### 1. Customize Your App
```javascript
// src/server.js - Your application code
const http = require('http');
const PORT = 3000;
http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain; charset=utf-8'});
  const timestamp = new Date().toISOString();
  res.end(`Hello, www! 🚀\nDeployed: ${timestamp}\nPlatform: ${process.platform}/${process.arch}\n`);
}).listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}/`);
  console.log(`Platform: ${process.platform}/${process.arch}`);
});
```

### 2. Configure Secrets (One-time setup)
```bash
# Copy and customize the secrets configuration
cp scripts/deploy-secrets.conf.example scripts/deploy-secrets.conf
# Edit the file with your deployment server details
nano scripts/deploy-secrets.conf

# Run the automated setup script
./scripts/setup-secrets.sh
```

### 3. Set Your Hostname
```bash
# deploy/host.config
HOST=my-awesome-app.roca.tools  # 👈 Your app's domain
PORT=3000                       # Port your app listens on
CONTAINER_NAME=my_custom_name   # Optional: override auto-generated name
```

### 4. Deploy
```bash
git add .
git commit -m "Deploy my awesome app"

# Create and push to production branch (first time only)
git checkout -b production
git push -u origin production

# For subsequent deployments:
# git push origin production
```

**Result:** Your app is live at `https://my-awesome-app.roca.tools` 🎉

---

## 🔧 Advanced Features

### Automated Secret Management
- 🔑 **GitHub Secrets**: Automatically configured via `setup-secrets.sh`
- 🔒 **SSH Keys**: Secure server access
- 🌐 **NPM Integration**: Reverse proxy configuration
- 📁 **Config Templates**: Example configurations provided

### Multi-Architecture Support
- 🏗️ **ARM64/AMD64**: Builds for target server architecture
- 🐳 **Docker Buildx**: Advanced multi-platform builds
- ✅ **Platform Detection**: Runtime platform information

### Debugging & Monitoring
- 🐛 **NPM Debug Script**: `./scripts/debug-npm.sh`
- 📊 **Deployment Logs**: Detailed GitHub Actions logs
- 🔍 **Container Status**: Runtime diagnostics
- 📋 **Health Checks**: Automated service validation

---

## 🏷️ Smart Container Naming

Your container will be auto-named: **`{github-username}_{repo-name}`**

Examples:
- `alice/my-blog` → Container: `alice_my_blog`
- `bob/api-service` → Container: `bob_api_service`

**Override:** Set `CONTAINER_NAME` in `deploy/host.config` for custom names.

---

## 🎯 What Makes This Special

- ✅ **Zero Local Docker** - Build and deploy entirely in the cloud
- ✅ **Fork & Deploy** - Works immediately on forks with minimal setup
- ✅ **Production Ready** - SSL, reverse proxy, monitoring included
- ✅ **Multi-Architecture** - ARM64 and AMD64 server support
- ✅ **Automated Secrets** - No manual GitHub configuration needed
- ✅ **Debug Tools** - Built-in troubleshooting and monitoring
- ✅ **Extensible** - Easy to customize for complex applications

**Perfect for teams who want enterprise-grade deployment with zero DevOps overhead! 🎯**

---

## 📚 Documentation

- **[USER_GUIDE.md](USER_GUIDE.md)** - Complete setup and usage guide
- **[scripts/README.md](scripts/README.md)** - Script documentation and troubleshooting
- **[deploy/README.md](deploy/README.md)** - Deployment configuration details

## 🐛 Troubleshooting

Having issues? Check the debug tools:

```bash
# NPM/Reverse proxy issues
./scripts/debug-npm.sh

# View deployment logs
# Check GitHub Actions tab in your repository
```

## 🤝 Contributing

This template is designed to be forked and customized. If you've made improvements that would benefit everyone, please consider creating a pull request!
