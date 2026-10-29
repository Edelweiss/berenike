# Behebung des Logging-Problems und Installation von ImageMagick

## Problem: Symfony schreibt keine Log-Dateien mehr

### Ursache
Das `var/log/` Verzeichnis hat falsche Besitzer- und Berechtigungen:

```bash
# ❌ FALSCH (berenike):
drwxrwxr-x 2 ubuntu   ubuntu       22 Oct  9 11:58 var/log/

# ✅ RICHTIG (beehive):
drwxr-xr-x 2 www-data www-data     37 Feb 13  2022 var/log/
```

Das Problem: Der Webserver läuft als `www-data`, kann aber nicht ins `ubuntu:ubuntu` Verzeichnis schreiben.

---

## Lösung 1: Automatische Reparatur (empfohlen)

Führe das bereitgestellte Skript aus:

```bash
cd /var/www/berenike
sudo bash fix-berenike-logging.sh
```

Das Skript wird:
1. Das Ownership von `var/cache/` und `var/log/` auf `www-data:www-data` setzen
2. Korrekte Berechtigungen (775) setzen
3. ACL konfigurieren für bessere Kompatibilität
4. Cache clearen

---

## Lösung 2: Manuelle Reparatur (falls Skript nicht funktioniert)

### Schritt 1: Ownership ändern
```bash
sudo chown -R www-data:www-data /var/www/berenike/var/cache
sudo chown -R www-data:www-data /var/www/berenike/var/log
```

### Schritt 2: Berechtigungen setzen
```bash
sudo chmod -R 755 /var/www/berenike/var/cache
sudo chmod -R 755 /var/www/berenike/var/log
sudo chmod -R 775 /var/www/berenike/var/cache
sudo chmod -R 775 /var/www/berenike/var/log
```

### Schritt 3: Cache clearen
```bash
cd /var/www/berenike
sudo php bin/console cache:clear --env=prod --no-debug
```

### Schritt 4: Test durchführen
```bash
# Test, ob www-data schreiben kann
sudo -u www-data touch /var/www/berenike/var/log/test.log
ls -la /var/www/berenike/var/log/test.log
rm /var/www/berenike/var/log/test.log
```

---

## Verifikation des Logging

### Test 1: Direkter Schreibtest
```bash
cd /var/www/berenike
sudo php bin/console monolog:test --env=prod
```

### Test 2: Tail der Log-Datei
```bash
tail -f /var/www/berenike/var/log/prod.log
```

### Test 3: Webserver-Fehlerlog prüfen
```bash
# Für Apache:
tail -f /var/log/apache2/error.log

# Für Nginx:
tail -f /var/log/nginx/error.log
```

### Test 4: Permissions verifizieren
```bash
ls -la /var/www/berenike/var/log/
ls -la /var/www/berenike/var/cache/

# Output sollte sein:
# drwxrwxr-x www-data www-data var/log
# drwxrwxr-x www-data www-data var/cache
```

---

## Installation von ImageMagick

### Automatische Installation (empfohlen)

```bash
sudo bash /var/www/berenike/install-imagemagick.sh
```

### Manuelle Installation

#### Schritt 1: ImageMagick installieren
```bash
sudo apt-get update
sudo apt-get install -y imagemagick
```

#### Schritt 2: PHP ImageMagick Extension (Imagick) installieren
```bash
sudo apt-get install -y php-imagick
```

#### Schritt 3: Webserver neustarten
```bash
# Für Apache:
sudo systemctl restart apache2

# Für Nginx + PHP-FPM:
sudo systemctl restart nginx
sudo systemctl restart php7.4-fpm
```

#### Schritt 4: Verifizieren
```bash
# ImageMagick Version prüfen
convert --version

# PHP Extension prüfen
php -m | grep imagick

# Oder detailliert:
php -r "echo extension_loaded('imagick') ? '✅ OK' : '❌ FEHLER';"
```

---

## Verwendung von ImageMagick

### Command-Line Beispiele
```bash
# Bild konvertieren
convert image.jpg image.png

# Größe anpassen
convert image.jpg -resize 800x600 resized.jpg

# Qualität optimieren
convert image.jpg -quality 85 -strip optimized.jpg

# Thumbnail erstellen
convert image.jpg -thumbnail 200x200 thumb.jpg
```

### PHP/Symfony Beispiele

#### Einfache Imagick-Verwendung
```php
<?php
$imagick = new Imagick('input.jpg');
$imagick->thumbnailImage(200, 200, true);
$imagick->writeImage('output.jpg');
$imagick->destroy();
?>
```

#### In Symfony Service
```php
namespace App\Service;
use Imagick;

class ImageProcessor
{
    public function createThumbnail(string $inputPath, string $outputPath, int $size = 200): void
    {
        $imagick = new Imagick($inputPath);
        $imagick->thumbnailImage($size, $size, true);
        $imagick->setImageCompression(Imagick::COMPRESSION_JPEG);
        $imagick->setImageCompressionQuality(85);
        $imagick->writeImage($outputPath);
        $imagick->destroy();
    }
}
```

---

## Sicherheitshinweise

1. **ImageMagick Sicherheit**: 
   - ImageMagick kann mit böswilligen Dateien Sicherheitsrisiken darstellen
   - Immer Eingaben validieren
   - Policy-Datei überprüfen: `/etc/ImageMagick-6/policy.xml`

2. **Dateiberechtigungen**:
   - `var/cache/` und `var/log/` sollten nur für `www-data` schreibbar sein
   - Nicht breiter als 775 setzen
   - Regelmäßig alte Log-Dateien archivieren/löschen

3. **Log-Rotation**:
   - Konfiguriere Logrotate für `/var/www/berenike/var/log/prod.log`
   - Beispiel: `/etc/logrotate.d/berenike`

---

## Troubleshooting

### Problem: Log-Datei wird immer noch nicht geschrieben
**Lösung:**
1. Berechtigungen nochmal mit `ls -la var/log` überprüfen
2. Webserver-Fehlerlog prüfen: `tail -f /var/log/apache2/error.log`
3. PHP Error Log prüfen: `php -r "echo ini_get('error_log');"`
4. SELinux Kontext überprüfen (falls aktiviert): `getenforce`

### Problem: ImageMagick Extension lädt nicht
**Lösung:**
```bash
# Extension aktivieren/überprüfen
php -m | grep imagick

# Wenn nicht vorhanden, neu installieren:
sudo apt-get install --reinstall php-imagick

# PHP-FPM Konfiguration überprüfen:
sudo php-fpm7.4 -t

# Webserver neustarten:
sudo systemctl restart apache2  # oder nginx/php7.4-fpm
```

### Problem: "Unable to load Imagick extension" Fehler
**Lösung:**
```bash
# Überprüfe ob Imagick installiert ist
php -i | grep imagick

# Wenn nicht, installiere es:
sudo apt-get install php7.4-imagick

# Reload PHP:
sudo systemctl restart php7.4-fpm
```

---

## Server-Umgebung
- **OS**: Ubuntu 20.04.6 LTS
- **PHP**: 7.4.3
- **Symfony**: 5.4.53
- **Webserver**: Apache oder Nginx
- **Hostname**: aquila

