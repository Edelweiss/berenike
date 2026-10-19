#!/bin/bash
# Fix PHP error logging for Apache on production server

set -e

cd /var/www/berenike

echo "=== Fixing PHP Error Logging ==="
echo ""

# Create a PHP error log file specifically for this app
ERROR_LOG="/var/log/berenike-php-errors.log"

echo "Creating dedicated PHP error log at: $ERROR_LOG"
sudo touch "$ERROR_LOG"
sudo chmod 666 "$ERROR_LOG"
sudo chown www-data:www-data "$ERROR_LOG"

# Check which PHP module Apache is using
echo ""
echo "Apache PHP Configuration:"
apache2ctl -M 2>/dev/null | grep -i php || echo "No PHP module found in Apache"

# Find the PHP-FPM or mod_php configuration
echo ""
echo "Checking for PHP-FPM pool config:"
if [ -d "/etc/php/7.4/fpm/pool.d/" ]; then
    ls -la /etc/php/7.4/fpm/pool.d/
    echo ""
    echo "Content of www.conf:"
    grep -E "error_log|catch_workers_output" /etc/php/7.4/fpm/pool.d/www.conf 2>/dev/null || echo "Not found"
fi

echo ""
echo "=== Creating PHP error handler wrapper ==="

# Create a wrapper script that logs errors properly
cat > public/debug-404.php << 'EOF'
<?php
// This is a debug file to capture errors
error_reporting(E_ALL);
ini_set('display_errors', '0');
ini_set('log_errors', '1');
ini_set('error_log', '/var/log/berenike-php-errors.log');

echo "PHP Error Log Location: " . ini_get('error_log') . "\n";
echo "Error Reporting: " . error_reporting() . "\n";

// Try to trigger an error
try {
    throw new Exception("Test exception");
} catch (Exception $e) {
    error_log("Test error logged: " . $e->getMessage());
    echo "Error has been logged.\n";
}
?>
EOF

echo "Test file created: public/debug-404.php"
echo ""

# Create .htaccess to set PHP errors
cat > public/.htaccess << 'EOF'
# Berenike Error Handling
<IfModule mod_php7.c>
    php_value error_log "/var/log/berenike-php-errors.log"
    php_value error_reporting 32767
    php_value log_errors 1
    php_value display_errors 0
</IfModule>

# Fallback for php-fpm
SetEnvIf REQUEST_URI "^" FORCE_LOG_ERRORS="1"
EOF

echo ".htaccess created"
echo ""

# Check if PHP-FPM is being used and update its config
if command -v php-fpm7.4 &> /dev/null; then
    echo "=== Configuring PHP-FPM ==="
    PHP_FPM_CONF="/etc/php/7.4/fpm/pool.d/www.conf"
    
    if [ -f "$PHP_FPM_CONF" ]; then
        echo "Backing up PHP-FPM config..."
        sudo cp "$PHP_FPM_CONF" "$PHP_FPM_CONF.backup"
        
        echo "Updating PHP-FPM error logging..."
        # Add/update error_log if not present
        if ! grep -q "^catch_workers_output" "$PHP_FPM_CONF"; then
            sudo bash -c "echo 'catch_workers_output = yes' >> $PHP_FPM_CONF"
        fi
        
        echo "Restarting PHP-FPM..."
        sudo systemctl restart php7.4-fpm
        sleep 2
    fi
fi

echo ""
echo "=== Restart Apache ==="
sudo systemctl restart apache2
sleep 2

echo ""
echo "=== Verify Error Log ==="
ls -la "$ERROR_LOG"
echo ""

echo "✅ Done! Error logging is now configured."
echo ""
echo "Test with:"
echo "  curl http://berenike.zaw.uni-heidelberg.de/debug-404.php"
echo "  tail -f $ERROR_LOG"
echo ""
echo "Then access: https://berenike.zaw.uni-heidelberg.de/asset/4652/edit"
echo "Errors should now appear in: $ERROR_LOG"
