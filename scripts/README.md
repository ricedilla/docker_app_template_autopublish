# Scripts Directory

## setup-secrets.sh

Automatically configures GitHub repository secrets for deployment using GitHub CLI.

### Usage

1. **Create configuration file:**
   ```bash
   cp deploy-secrets.conf.example deploy-secrets.conf
   ```

2. **Edit the configuration file:**
   ```bash
   nano deploy-secrets.conf
   ```
   
   Fill in your deployment details:
   - `DEPLOY_HOST`: Deployment server hostname/IP (e.g., `subdomain.roca.tools`)
   - `DEPLOY_USER`: SSH username (typically 'rice')
   - `SSH_PRIVATE_KEY_FILE`: Path to your SSH private key file
   - OR `SSH_PRIVATE_KEY`: Direct private key content

3. **Run the setup script:**
   ```bash
   ./setup-secrets.sh
   ```

The script will:
- ✅ Check GitHub CLI installation and authentication
- ✅ Read configuration from `deploy-secrets.conf`
- ✅ Set GitHub repository secrets automatically
- ✅ No interactive prompts - fully automated!

### Required GitHub Secrets

The script sets these secrets for deployment:
- `DEPLOY_HOST` - Deployment server hostname/IP (where to SSH for deployment)
- `DEPLOY_USER` - SSH username for server access  
- `SSH_PRIVATE_KEY` - SSH private key for server authentication

**Note:** `DEPLOY_HOST` is the server you SSH into for deployment, while `HOST` in `deploy/host.config` is the public domain where your app will be accessible (e.g., `my-app.roca.tools`).

### Security Notes

- `deploy-secrets.conf` is automatically ignored by git
- Never commit your private key or configuration file
- Keep your SSH private key secure and accessible only to you
