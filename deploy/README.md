# Deployment Configuration

This directory contains the deployment configuration files that control how your application is deployed and served.

## 📁 Configuration Files

### 🌐 `host.config`
**Purpose**: Configure your application's public domain and container settings

**Required Settings:**
```bash
HOST=my-app.roca.tools    # Your app's public domain (where users access it)
PORT=3000                # Port your app listens on inside the container
```

**Optional Settings:**
```bash
CONTAINER_NAME=my_custom_name  # Override auto-generated container name
```

**Important Notes:**
- `HOST` is the **public domain** where your app will be accessible
- This is different from `DEPLOY_HOST` in secrets (which is the server you deploy to)
- The domain should be configured in your DNS to point to the deployment server

### 🐳 `docker-compose.yml`
**Purpose**: Container orchestration and networking configuration

**Key Features:**
- ✅ **Environment Variable Support** - Uses `${DOCKER_IMAGE}`, `${CONTAINER_NAME}`, `${PORT}`
- ✅ **Network Integration** - Connects to `proxy-network` for reverse proxy
- ✅ **Auto-restart** - Container restarts automatically if it crashes
- ✅ **Port Mapping** - Maps container port to host port dynamically

**Structure:**
```yaml
services:
  app:
    image: ${DOCKER_IMAGE:-example-app:latest}
    container_name: ${CONTAINER_NAME:-example-app}
    ports:
      - "${PORT:-3000}:${PORT:-3000}"
    networks:
      - proxy-network
    restart: unless-stopped

networks:
  proxy-network:
    external: true
```

**Environment Variables (set automatically by CI/CD):**
- `DOCKER_IMAGE` - The Docker image name (e.g., `username_repo:latest`)
- `CONTAINER_NAME` - Container name (auto-generated or from `host.config`)
- `PORT` - Application port (from `host.config`)

---

## 🚀 Deployment Process

### 1. **Configuration**
- Set your domain in `host.config`
- Optionally customize container name

### 2. **Push to Production**
```bash
git push origin production
```

### 3. **Automated Steps** (handled by GitHub Actions)
1. **Build**: Creates Docker image for target architecture (ARM64/AMD64)
2. **Deploy**: Copies files to deployment server
3. **Load**: Loads Docker image on server
4. **Start**: Starts container with `docker compose up -d`
5. **Proxy**: Configures reverse proxy with SSL

### 4. **Result**
Your app is live at `https://your-domain.roca.tools` 🎉

---

## 🔧 Advanced Configuration

### Custom Docker Image
If you need a different base image or build process, modify `../src/Dockerfile`:

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

### Multiple Ports
To expose multiple ports, modify `docker-compose.yml`:

```yaml
ports:
  - "${PORT:-3000}:${PORT:-3000}"
  - "8080:8080"  # Additional port
```

### Health Checks
Add health checks to monitor container status:

```yaml
services:
  app:
    # ...existing config...
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

### Environment Variables
Pass environment variables to your application:

```yaml
services:
  app:
    # ...existing config...
    environment:
      - NODE_ENV=production
      - API_KEY=${API_KEY}  # From host.config or GitHub secrets
```

---

## 🐛 Troubleshooting

### Container Won't Start
```bash
# Check container logs
docker logs CONTAINER_NAME

# Check if port is in use
sudo netstat -tlnp | grep :3000

# Verify image exists
docker images | grep your-image-name
```

### Port Conflicts
```bash
# Find what's using the port
sudo lsof -i :3000

# Use a different port in host.config
PORT=3001
```

### Network Issues
```bash
# Check if proxy-network exists
docker network ls | grep proxy-network

# Create network if missing
docker network create proxy-network
```

### Domain Not Accessible
1. **Check DNS**: Ensure domain points to deployment server
2. **Check reverse proxy**: Verify NPM configuration
3. **Check SSL**: Ensure certificate is valid and installed
4. **Check container**: Verify app is running and responding

---

## 📚 Related Documentation

- **[../README.md](../README.md)** - Main project documentation
- **[../USER_GUIDE.md](../USER_GUIDE.md)** - Complete setup guide
- **[../scripts/README.md](../scripts/README.md)** - Scripts and troubleshooting
