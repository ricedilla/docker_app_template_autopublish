#!/bin/bash

# Debug script for NPM authentication issues
# This script helps diagnose NPM (Nginx Proxy Manager) connectivity and authentication

echo "🔍 NPM Debug Script"
echo "=================="

# Check if we're on the deployment server
if [ -f "/home/rice/docker/helper_scripts/setup/.env" ]; then
    echo "✅ Found NPM credentials file"
    
    # Load environment variables (without showing them)
    source /home/rice/docker/helper_scripts/setup/.env
    
    # Check if required NPM variables are set
    if [ -z "$NPM_HOST" ] || [ -z "$NPM_EMAIL" ] || [ -z "$NPM_PASSWORD" ]; then
        echo "❌ Missing NPM credentials in .env file"
        echo "   Required: NPM_HOST, NPM_EMAIL, NPM_PASSWORD"
        exit 1
    fi
    
    echo "✅ NPM credentials loaded"
    echo "   Host: $NPM_HOST"
    echo "   Email: $NPM_EMAIL"
    echo "   Password: [HIDDEN]"
    
    # Test NPM connectivity
    echo ""
    echo "🌐 Testing NPM connectivity..."
    
    # Test basic connectivity to NPM host
    if curl -s --connect-timeout 10 "$NPM_HOST" > /dev/null; then
        echo "✅ NPM host is reachable"
    else
        echo "❌ Cannot reach NPM host: $NPM_HOST"
        exit 1
    fi
    
    # Test NPM API authentication
    echo ""
    echo "🔐 Testing NPM authentication..."
    
    # Try to authenticate with NPM API
    AUTH_RESPONSE=$(curl -s -X POST "$NPM_HOST/api/tokens" \
        -H "Content-Type: application/json" \
        -d "{\"identity\":\"$NPM_EMAIL\",\"secret\":\"$NPM_PASSWORD\"}" \
        -w "\n%{http_code}")
    
    HTTP_CODE=$(echo "$AUTH_RESPONSE" | tail -n1)
    RESPONSE_BODY=$(echo "$AUTH_RESPONSE" | head -n -1)
    
    echo "   HTTP Code: $HTTP_CODE"
    
    if [ "$HTTP_CODE" = "200" ]; then
        echo "✅ NPM authentication successful"
        echo "   Token received (length: $(echo "$RESPONSE_BODY" | jq -r '.token' | wc -c))"
    else
        echo "❌ NPM authentication failed"
        echo "   Response: $RESPONSE_BODY"
        
        # Common troubleshooting suggestions
        echo ""
        echo "💡 Troubleshooting suggestions:"
        echo "   1. Check NPM credentials in /home/rice/docker/helper_scripts/setup/.env"
        echo "   2. Verify NPM is running and accessible"
        echo "   3. Check if email/password are correct in NPM admin panel"
        echo "   4. Ensure NPM API is enabled"
    fi
    
else
    echo "❌ This script should be run on the deployment server"
    echo "   Expected file: /home/rice/docker/helper_scripts/setup/.env"
fi

echo ""
echo "🎯 For manual testing, you can also run:"
echo "   cd /home/rice/docker/helper_scripts/core"
echo "   source ../setup/.env"
echo "   python3 npm_api_manager.py --help"
