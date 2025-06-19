#!/bin/bash

# Setup script to automatically configure GitHub secrets for deployment
# This eliminates the need for manual secret setup in the GitHub web interface
# Reads configuration from deploy-secrets.conf file

set -e

echo "🔧 Setting up GitHub Secrets for deployment..."

# Define config file path
CONFIG_FILE="deploy-secrets.conf"

# Check if config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "❌ Configuration file '$CONFIG_FILE' not found!"
    echo ""
    echo "📝 Please create '$CONFIG_FILE' with the following format:"
    echo "----------------------------------------"
    echo "DEPLOY_HOST=subdomain.roca.tools"
    echo "DEPLOY_USER=rice"
    echo "SSH_PRIVATE_KEY_FILE=/path/to/private/key"
    echo "# OR"
    echo "# SSH_PRIVATE_KEY=-----BEGIN RSA PRIVATE KEY-----"
    echo "# (paste full private key content here...)"
    echo "# -----END RSA PRIVATE KEY-----"
    echo "----------------------------------------"
    echo ""
    echo "💡 You can also specify SSH_PRIVATE_KEY_FILE to read from a file"
    exit 1
fi

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed. Please install it first:"
    echo "   macOS: brew install gh"
    echo "   Linux: https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
    echo "   Windows: https://github.com/cli/cli/releases"
    exit 1
fi

# Check if user is authenticated with GitHub CLI
if ! gh auth status &> /dev/null; then
    echo "🔐 Please authenticate with GitHub CLI:"
    gh auth login
fi

echo ""
echo "📋 Reading configuration from '$CONFIG_FILE'..."

# Source the config file
source "$CONFIG_FILE"

# Get repository information
echo "🔍 Detecting repository..."
REPO_URL=$(git remote get-url origin 2>/dev/null)
if [[ -z "$REPO_URL" ]]; then
    echo "❌ No 'origin' remote found. Please run this script from a git repository."
    exit 1
fi

# Extract repo owner/name from URL
if [[ "$REPO_URL" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
    REPO_OWNER="${BASH_REMATCH[1]}"
    REPO_NAME="${BASH_REMATCH[2]}"
    REPO_FULL="${REPO_OWNER}/${REPO_NAME}"
    echo "✅ Repository detected: $REPO_FULL"
else
    echo "❌ Could not parse GitHub repository from URL: $REPO_URL"
    exit 1
fi

# Validate required variables
if [[ -z "$DEPLOY_HOST" ]]; then
    echo "❌ DEPLOY_HOST not set in config file"
    exit 1
fi

if [[ -z "$DEPLOY_USER" ]]; then
    echo "❌ DEPLOY_USER not set in config file"
    exit 1
fi

# Handle SSH private key - either from file or direct content
if [[ -n "$SSH_PRIVATE_KEY_FILE" ]]; then
    if [[ ! -f "$SSH_PRIVATE_KEY_FILE" ]]; then
        echo "❌ SSH private key file not found: $SSH_PRIVATE_KEY_FILE"
        exit 1
    fi
    SSH_PRIVATE_KEY=$(cat "$SSH_PRIVATE_KEY_FILE")
    echo "✅ Loaded SSH private key from file: $SSH_PRIVATE_KEY_FILE"
elif [[ -z "$SSH_PRIVATE_KEY" ]]; then
    echo "❌ Neither SSH_PRIVATE_KEY nor SSH_PRIVATE_KEY_FILE is set in config file"
    exit 1
else
    echo "✅ Using SSH private key from config file"
fi

# Set the secrets using GitHub CLI
echo ""
echo "🚀 Setting GitHub repository secrets..."

# Set DEPLOY_HOST
echo "$DEPLOY_HOST" | gh secret set DEPLOY_HOST --repo "$REPO_FULL"
echo "✅ Set DEPLOY_HOST: $DEPLOY_HOST"

# Set DEPLOY_USER  
echo "$DEPLOY_USER" | gh secret set DEPLOY_USER --repo "$REPO_FULL"
echo "✅ Set DEPLOY_USER: $DEPLOY_USER"

# Set SSH_PRIVATE_KEY
echo "$SSH_PRIVATE_KEY" | gh secret set SSH_PRIVATE_KEY --repo "$REPO_FULL"
echo "✅ Set SSH_PRIVATE_KEY: [HIDDEN]"

# Enable GitHub Actions workflows (in case they're disabled on fork)
echo ""
echo "🔄 Enabling GitHub Actions workflows..."
if gh api repos/"$REPO_FULL"/actions/permissions --method PUT --field enabled=true --field allowed_actions=all >/dev/null 2>&1; then
    echo "✅ GitHub Actions enabled successfully"
else
    echo "⚠️  Could not enable GitHub Actions automatically"
    echo "   Please enable them manually in your repository:"
    echo "   https://github.com/$REPO_FULL/actions"
fi

echo ""
echo "🎉 GitHub secrets configured successfully!"
echo ""
echo "📋 Configured secrets:"
echo "   • DEPLOY_HOST: $DEPLOY_HOST"
echo "   • DEPLOY_USER: $DEPLOY_USER" 
echo "   • SSH_PRIVATE_KEY: [HIDDEN]"
echo ""
echo "✅ You can now push to the 'production' branch to deploy!"
echo ""
echo "💡 First time deployment:"
echo "   git checkout -b production"
echo "   git push -u origin production"
echo ""
echo "📋 Subsequent deployments:"
echo "   git push origin production"
