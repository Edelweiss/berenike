#!/bin/bash
# Fix Symfony logging permissions for berenike project
# Run on the production server as: sudo bash fix-berenike-logging.sh

set -e

echo "=== Fixing Symfony Logging Permissions for berenike ==="
echo ""

# Navigate to project root
cd /var/www/berenike || { echo "Error: /var/www/berenike not found"; exit 1; }

# Detect web server user
HTTPDUSER=$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)
DEPLOY_USER=$(stat -c '%U' . 2>/dev/null || stat -f '%Su' .)

echo "Web server user: $HTTPDUSER"
echo "Deployment user: $DEPLOY_USER"
echo ""

# Check if directories exist
if [ ! -d var/cache ]; then
  echo "Creating var/cache directory..."
  mkdir -p var/cache
fi

if [ ! -d var/log ]; then
  echo "Creating var/log directory..."
  mkdir -p var/log
fi

echo "Setting ownership for var/cache and var/log to www-data:www-data..."
sudo chown -R www-data:www-data var/cache var/log

echo "Setting permissions on var/cache and var/log (755)..."
sudo chmod -R 755 var/cache var/log

echo "Setting write permissions for www-data on var/cache and var/log (775)..."
sudo chmod -R 775 var/cache var/log

# Try to use ACL if available
if command -v setfacl &> /dev/null; then
  echo "Using ACL for better permission handling..."
  
  # Set default ACL for future files/directories
  sudo setfacl -dR -m u:www-data:rwX -m u:$DEPLOY_USER:rwX var/cache var/log 2>/dev/null || true
  
  # Apply ACL to existing files/directories
  sudo setfacl -R -m u:www-data:rwX -m u:$DEPLOY_USER:rwX var/cache var/log 2>/dev/null || true
  
  echo "ACL applied successfully"
else
  echo "ACL not available, using chmod only"
fi

echo ""
echo "Clearing PHP OPcache and application cache..."
sudo php bin/console cache:clear --env=prod --no-debug || true

echo ""
echo "Final verification of permissions:"
echo "------------------------------------"
ls -ld var/cache var/log
echo ""
ls -la var/log/ | head -5

echo ""
echo "✅ Done! Logging permissions have been fixed."
echo ""
echo "If logging still doesn't work, check:"
echo "1. Web server error log: tail -f /var/log/apache2/error.log (Apache) or /var/log/nginx/error.log (Nginx)"
echo "2. Check if www-data can write: sudo -u www-data touch var/log/test.log"
echo "3. Run: sudo php bin/console monolog:test --env=prod"
