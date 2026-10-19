#!/bin/bash
# Enable detailed logging for Berenike to debug the 500 error

set -e

cd /var/www/berenike

echo "=== Enabling Detailed Logging for Production ==="
echo ""

# Create a backup of the original config
cp config/packages/prod/monolog.yaml config/packages/prod/monolog.yaml.backup

echo "Creating enhanced monolog.yaml with detailed error logging..."

cat > config/packages/prod/monolog.yaml << 'YAMLEOF'
monolog:
    handlers:
        # Immediate error logging - no filtering
        critical:
            type: stream
            path: "%kernel.logs_dir%/%kernel.environment%.log"
            level: critical
        
        error:
            type: stream
            path: "%kernel.logs_dir%/%kernel.environment%.log"
            level: error
        
        # All errors to separate file for debugging
        debug_all:
            type: stream
            path: "%kernel.logs_dir%/all-errors.log"
            level: debug
        
        # Fingers crossed for buffering
        main:
            type: fingers_crossed
            action_level: error
            handler: nested
            excluded_http_codes: [404, 405]
            buffer_size: 50
        
        nested:
            type: stream
            path: "%kernel.logs_dir%/%kernel.environment%.log"
            level: debug
        
        console:
            type: console
            process_psr_3_messages: false
            channels: ["!event", "!doctrine"]
        
        # Log PHP errors
        php_errors:
            type: stream
            path: "%kernel.logs_dir%/php-errors.log"
            level: notice
            channels: ["php"]
YAMLEOF

echo "✓ monolog.yaml updated"
echo ""

# Create a custom global error handler
echo "Creating custom error handler in public/index.php..."

# Create a wrapper script
cat > public/index-enhanced.php << 'PHPEOF'
<?php
// Enhanced error handling for debugging

// Set up error logging before anything else
ini_set('log_errors', 1);
error_log('[BERENIKE] PHP Script Started', 3, '/var/log/berenike-php-errors.log');

// Custom error handler to log all errors/warnings/notices
set_error_handler(function($errno, $errstr, $errfile, $errline) {
    $error_msg = sprintf(
        "[%s] %s in %s:%d",
        strtoupper(gettype($errno)), 
        $errstr, 
        $errfile, 
        $errline
    );
    error_log($error_msg, 3, '/var/log/berenike-php-errors.log');
    // Don't suppress PHP's normal handling
    return false;
});

// Custom exception handler
set_exception_handler(function($exception) {
    $error_msg = sprintf(
        "[EXCEPTION] %s: %s in %s:%d\nTrace:\n%s",
        get_class($exception),
        $exception->getMessage(),
        $exception->getFile(),
        $exception->getLine(),
        $exception->getTraceAsString()
    );
    error_log($error_msg, 3, '/var/log/berenike-php-errors.log');
    
    // Re-throw to let Symfony handle it
    throw $exception;
});

// Original index.php logic
if (is_file(dirname(__FILE__).'/recovery.php')) {
    include dirname(__FILE__).'/recovery.php';
}

$trustedProxies = $_SERVER['TRUSTED_PROXIES'] ?? $_ENV['TRUSTED_PROXIES'] ?? false;
$trustedHosts = $_SERVER['TRUSTED_HOSTS'] ?? $_ENV['TRUSTED_HOSTS'] ?? false;

require_once dirname(__FILE__).'/../vendor/autoload_runtime.php';

error_log('[BERENIKE] Autoloader loaded', 3, '/var/log/berenike-php-errors.log');

return function(array $context) {
    error_log('[BERENIKE] Kernel creation starting', 3, '/var/log/berenike-php-errors.log');
    
    try {
        $kernel = new App\Kernel($context['APP_ENV'], (bool) $context['APP_DEBUG']);
        error_log('[BERENIKE] Kernel created successfully', 3, '/var/log/berenike-php-errors.log');
    } catch (Throwable $e) {
        error_log('[BERENIKE] Kernel creation failed: ' . $e->getMessage(), 3, '/var/log/berenike-php-errors.log');
        throw $e;
    }
    
    return $kernel;
};
PHPEOF

echo "✓ Custom error handler wrapper created at public/index-enhanced.php"
echo ""

# Clear cache
echo "Clearing Symfony cache..."
sudo php bin/console cache:clear --env=prod --no-debug 2>&1 | grep -E "Clearing|OK|error"

echo ""
echo "Setting up logrotate for new log files..."

sudo tee /etc/logrotate.d/berenike > /dev/null << 'LOGEOF'
/var/www/berenike/var/log/*.log
/var/log/berenike-php-errors.log
{
    daily
    rotate 14
    compress
    delaycompress
    missingok
    notifempty
    create 0644 www-data www-data
    sharedscripts
    postrotate
        systemctl reload apache2 > /dev/null 2>&1 || true
    endscript
}
LOGEOF

echo "✓ Logrotate config created"
echo ""

echo "=== Log Files Setup ==="
echo ""
echo "Production log:     /var/www/berenike/var/log/prod.log"
echo "Debug log:          /var/www/berenike/var/log/all-errors.log"
echo "PHP errors:         /var/log/berenike-php-errors.log"
echo ""

echo "=== To Monitor Errors ==="
echo ""
echo "Watch all logs in real-time:"
echo "  tail -f /var/www/berenike/var/log/prod.log &"
echo "  tail -f /var/log/berenike-php-errors.log &"
echo ""
echo "Or use this command:"
echo "  watch -n 1 'tail -20 /var/www/berenike/var/log/prod.log; echo \"---\"; tail -20 /var/log/berenike-php-errors.log'"
echo ""

echo "=== Testing ==="
echo ""
echo "Run this and watch the logs:"
echo "  sudo tail -f /var/www/berenike/var/log/prod.log &"
echo "  sudo tail -f /var/log/berenike-php-errors.log &"
echo "  curl -k https://berenike.zaw.uni-heidelberg.de/asset/4652/edit"
echo ""

echo "✅ Logging enabled. Configuration backed up in monolog.yaml.backup"
PHPEOF
