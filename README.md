# Example Project: Node.js Docker Template

🚀 **Ultra-simple template** for deploying Node.js apps with GitHub Actions.

## ⚡ How It Works

1. **Fork this template** → Create your project
2. **Add GitHub Secrets** → Get server access (see [USER_GUIDE.md](USER_GUIDE.md))
3. **Edit your app** in `src/server.js` 
4. **Set your hostname** in `deploy/host.config`
5. **Push to `production` branch** → **App goes live automatically!** 🎉

📖 **Complete setup guide:** [USER_GUIDE.md](USER_GUIDE.md)

---

## 📁 What's Included

```
example_project/
├── src/
│   ├── server.js          # 👈 Edit this (your app code)
│   ├── package.json       
│   └── Dockerfile         
├── deploy/
│   ├── host.config        # 👈 Edit this (your hostname)
│   └── docker-compose.yml 
└── .github/workflows/
    └── deploy.yml         # 👈 Handles everything automatically
```

---

## 🔧 Quick Start

### 1. Customize Your App
```javascript
// src/server.js - Replace this with your app
const http = require('http');
const PORT = 3000;
http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello, world!\n');  // 👈 Change this!
}).listen(PORT);
```

### 2. Set Your Hostname
```bash
# deploy/host.config
HOST=my-awesome-app.roca.tools  # 👈 Change this!
PORT=3000
```

### 3. Deploy
```bash
git add .
git commit -m "My awesome app"
git push origin production  # 👈 This triggers deployment!
```

**Result:** Your app is live at `https://my-awesome-app.roca.tools` 🎉

---

## 🏷️ Auto-Generated Names

Your container will be named: **`{your-github-username}_{repo-name}`**

Examples:
- `alice/my-blog` → Container: `alice_my_blog`
- `bob/api-service` → Container: `bob_api_service`

No conflicts, no configuration needed!

---

## � That's It!

- ✅ **No local Docker commands**
- ✅ **No deployment scripts** 
- ✅ **No complex setup**
- ✅ **Just push and deploy**

**Perfect for teams who want to focus on code, not deployment! 🎯**
