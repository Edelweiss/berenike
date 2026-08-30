<?php

namespace App\Service;

/**
 * Service for managing image assets, file processing, and variant generation
 */
class ImageService
{
    private string $publicDir;
    private string $assetsDir;
    private string $identifyPath = '/usr/local/bin/identify';
    private string $convertPath = '/usr/local/bin/convert';

    public function __construct(string $projectDir)
    {
        $this->publicDir = $projectDir . '/public';
        $assetsPath = $this->publicDir . '/assets';
        
        // Resolve symlink to actual directory
        $realPath = realpath($assetsPath);
        if ($realPath === false) {
            throw new \RuntimeException(sprintf('Assets directory does not exist: %s', $assetsPath));
        }
        
        $this->assetsDir = $realPath;
    }

    /**
     * Generate asset_key from filename
     * Rule: Convert to lowercase, strip extension, replace spaces with underscores
     */
    public function generateAssetKey(string $filename): string
    {
        // Remove file extension
        $nameWithoutExt = pathinfo($filename, PATHINFO_FILENAME);
        
        // Convert to lowercase and replace spaces with underscores
        $assetKey = strtolower(str_replace(' ', '_', $nameWithoutExt));
        
        return $assetKey;
    }

    /**
     * Generate asset_shard from asset_key (first 2 chars of MD5 hash)
     */
    public function generateAssetShard(string $assetKey): string
    {
        return substr(md5($assetKey), 0, 2);
    }

    /**
     * Get the full directory path for an asset
     */
    public function getAssetDirectory(string $assetKey): string
    {
        $assetShard = $this->generateAssetShard($assetKey);
        return $this->assetsDir . '/' . $assetShard . '/' . $assetKey;
    }

    /**
     * Ensure asset directory exists
     */
    public function ensureAssetDirectory(string $assetKey): string
    {
        $dir = $this->getAssetDirectory($assetKey);
        
        // Check if directory already exists
        if (is_dir($dir)) {
            return $dir;
        }
        
        // Log debug info
        error_log(sprintf(
            'Creating asset directory: %s (user: %s, umask: %03o, parent exists: %s, parent writable: %s)',
            $dir,
            get_current_user(),
            umask(),
            is_dir(dirname($dir)) ? 'yes' : 'no',
            is_writable(dirname($dir)) ? 'yes' : 'no'
        ));
        
        // Ensure parent directory exists first
        $parentDir = dirname($dir);
        if (!is_dir($parentDir)) {
            $oldUmask = umask(0);
            $result = @mkdir($parentDir, 0777, true);
            umask($oldUmask);
            if (!$result && !is_dir($parentDir)) {
                throw new \RuntimeException(sprintf('Failed to create parent directory: %s', $parentDir));
            }
        }
        
        // Try to create directory
        $oldUmask = umask(0);
        $result = @mkdir($dir, 0777, false);
        umask($oldUmask);
        
        if (!$result && !is_dir($dir)) {
            $error = error_get_last();
            throw new \RuntimeException(sprintf(
                'Failed to create directory "%s": %s',
                $dir,
                $error['message'] ?? 'Unknown error'
            ));
        }
        
        return $dir;
    }

    /**
     * Check if asset already exists (directory and files present)
     */
    public function assetExists(string $assetKey): bool
    {
        $dir = $this->getAssetDirectory($assetKey);
        return is_dir($dir) && file_exists($dir . '/original.tif');
    }

    /**
     * Process and save image file with all variants
     * 
     * @param string $sourceFile Path to source image file
     * @param string $assetKey Asset key for the image
     * @return array{width: int, height: int} Original image dimensions
     */
    public function processImage(string $sourceFile, string $assetKey): array
    {
        if (!file_exists($sourceFile)) {
            throw new \RuntimeException(sprintf('Source file not found: %s', $sourceFile));
        }

        $assetDir = $this->ensureAssetDirectory($assetKey);
        $originalFilename = basename($sourceFile);
        
        // Copy source file as archive
        $sourceDestination = $assetDir . '/source_' . $originalFilename;
        if (!copy($sourceFile, $sourceDestination)) {
            throw new \RuntimeException(sprintf('Failed to copy source file to: %s', $sourceDestination));
        }

        // Get original dimensions
        $dimensions = $this->getImageDimensions($sourceFile);
        
        // Generate original.tif (uncompressed/LZW TIF, sRGB color space)
        $originalTif = $assetDir . '/original.tif';
        $this->convertToTif($sourceFile, $originalTif);
        
        // Generate WebP variants
        $this->generateWebPVariant($sourceFile, $assetDir . '/large.webp', 1920);
        $this->generateWebPVariant($sourceFile, $assetDir . '/medium.webp', 1024);
        $this->generateWebPVariant($sourceFile, $assetDir . '/small.webp', 640);
        $this->generateWebPVariant($sourceFile, $assetDir . '/thumbnail.webp', 250);
        
        return $dimensions;
    }

    /**
     * Get image dimensions (width, height)
     */
    public function getImageDimensions(string $imageFile): array
    {
        $output = [];
        $returnVar = 0;
        // Use -quiet to suppress warnings and [0] to only read first frame/page
        // Redirect stderr to /dev/null to filter out warnings
        exec(sprintf(
            '%s -quiet -format "%%w,%%h" %s 2>/dev/null',
            escapeshellcmd($this->identifyPath),
            escapeshellarg($imageFile . '[0]')
        ), $output, $returnVar);
        
        // If quiet failed, try again without -quiet but take only the first line
        if (empty($output[0])) {
            $output = [];
            exec(sprintf(
                '%s -format "%%w,%%h" %s 2>&1',
                escapeshellcmd($this->identifyPath),
                escapeshellarg($imageFile . '[0]')
            ), $output, $returnVar);
            
            // Take only the first line (dimensions)
            if (!empty($output)) {
                $output = [trim($output[0])];
            }
        }
        
        if (empty($output[0])) {
            throw new \RuntimeException(sprintf('Failed to get image dimensions for: %s', $imageFile));
        }
        
        $parts = explode(',', trim($output[0]));
        if (count($parts) !== 2) {
            throw new \RuntimeException(sprintf(
                'Unexpected dimension format for %s: %s',
                $imageFile,
                $output[0]
            ));
        }
        
        list($width, $height) = $parts;
        return ['width' => (int)$width, 'height' => (int)$height];
    }

    /**
     * Convert image to TIF format (uncompressed/LZW, sRGB)
     */
    private function convertToTif(string $sourceFile, string $destFile): void
    {
        $output = [];
        $returnVar = 0;
        exec(sprintf(
            '%s %s -colorspace sRGB -compress LZW %s 2>&1',
            escapeshellcmd($this->convertPath),
            escapeshellarg($sourceFile),
            escapeshellarg($destFile)
        ), $output, $returnVar);
        
        if ($returnVar !== 0) {
            throw new \RuntimeException(sprintf(
                'Failed to convert to TIF: %s (Error: %s)',
                $sourceFile,
                implode("\n", $output)
            ));
        }
    }

    /**
     * Generate WebP variant with max dimension
     * Maintains aspect ratio
     */
    private function generateWebPVariant(string $sourceFile, string $destFile, int $maxDimension): void
    {
        $output = [];
        $returnVar = 0;
        
        // Use ImageMagick to resize maintaining aspect ratio
        // -resize will scale to fit within maxDimension x maxDimension box
        exec(sprintf(
            '%s %s -resize %dx%d\> -quality 85 %s 2>&1',
            escapeshellcmd($this->convertPath),
            escapeshellarg($sourceFile),
            $maxDimension,
            $maxDimension,
            escapeshellarg($destFile)
        ), $output, $returnVar);
        
        if ($returnVar !== 0) {
            throw new \RuntimeException(sprintf(
                'Failed to generate WebP variant %s: %s',
                $destFile,
                implode("\n", $output)
            ));
        }
    }

    /**
     * Get web-accessible path for an asset variant
     */
    public function getAssetWebPath(string $assetKey, string $variant = 'medium'): string
    {
        $assetShard = $this->generateAssetShard($assetKey);
        return sprintf('/assets/%s/%s/%s.webp', $assetShard, $assetKey, $variant);
    }

    /**
     * Get all available variants for an asset
     */
    public function getAssetVariants(string $assetKey): array
    {
        $assetDir = $this->getAssetDirectory($assetKey);
        $variants = [];
        
        $variantFiles = [
            'source' => glob($assetDir . '/source_*')[0] ?? null,
            'original' => $assetDir . '/original.tif',
            'large' => $assetDir . '/large.webp',
            'medium' => $assetDir . '/medium.webp',
            'small' => $assetDir . '/small.webp',
            'thumbnail' => $assetDir . '/thumbnail.webp',
        ];
        
        foreach ($variantFiles as $name => $path) {
            if ($path && file_exists($path)) {
                $variants[$name] = $path;
            }
        }
        
        return $variants;
    }
}
