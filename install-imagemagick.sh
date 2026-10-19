#!/bin/bash
# Install ImageMagick and PHP ImageMagick extension
# Run on Ubuntu 20.04 LTS as: sudo bash install-imagemagick.sh

set -e

echo "=== Installing ImageMagick for Ubuntu 20.04 LTS ==="
echo ""

# Update package list
echo "Step 1: Updating package list..."
sudo apt-get update

# Install ImageMagick
echo "Step 2: Installing ImageMagick..."
sudo apt-get install -y imagemagick

# Install PHP ImageMagick extension (Imagick)
echo "Step 3: Installing PHP ImageMagick extension (imagick)..."
sudo apt-get install -y php-imagick

# Restart web server
echo "Step 4: Restarting web server..."
if command -v apache2ctl &> /dev/null; then
  echo "Detected Apache - restarting..."
  sudo systemctl restart apache2
elif command -v nginx &> /dev/null; then
  echo "Detected Nginx - restarting..."
  sudo systemctl restart nginx
  # Also restart PHP-FPM if using Nginx
  sudo systemctl restart php7.4-fpm
else
  echo "Could not detect web server"
fi

# Verify installation
echo ""
echo "Step 5: Verifying installation..."
echo ""
echo "ImageMagick version:"
convert --version | head -3
echo ""
echo "PHP ImageMagick extension:"
php -m | grep -i imagick || echo "⚠️ Warning: imagick not found in php -m output"

# Additional check with PHP script
echo ""
echo "Detailed PHP extension check:"
php -r "echo extension_loaded('imagick') ? '✅ Imagick is loaded' : '❌ Imagick is NOT loaded';" || true
php -i 2>/dev/null | grep -A5 'imagick' || echo "No imagick details found in php -i"

echo ""
echo "✅ ImageMagick installation complete!"
echo ""
echo "Useful ImageMagick commands:"
echo "  convert image.jpg image.png  # Convert format"
echo "  convert image.jpg -resize 100x100 thumb.jpg  # Resize"
echo "  convert image.jpg -quality 85 -strip optimized.jpg  # Optimize"
echo ""
echo "PHP usage example:"
echo '  $img = new Imagick("input.jpg");'
echo '  $img->thumbnailImage(100, 100);'
echo '  $img->writeImage("thumb.jpg");'
