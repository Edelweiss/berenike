<?php

namespace App\Service;

use App\Entity\Image;
use App\Repository\ImageRepository;

/**
 * Service for managing image assets, file processing, and variant generation
 */
class ImageService
{
    private string $publicDir;
    private string $assetsDir;
    private string $identifyPath = '/usr/local/bin/identify';
    private string $convertPath = '/usr/local/bin/convert';
    private ?ImageRepository $imageRepository = null;

    public function __construct(string $projectDir, ?ImageRepository $imageRepository = null)
    {
        $this->publicDir = $projectDir . '/public';
        $assetsPath = $this->publicDir . '/assets';
        
        // Resolve symlink to actual directory
        $realPath = realpath($assetsPath);
        if ($realPath === false) {
            throw new \RuntimeException(sprintf('Assets directory does not exist: %s', $assetsPath));
        }
        
        $this->assetsDir = $realPath;
        $this->imageRepository = $imageRepository;
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
        // error_log(sprintf(
        //     'Creating asset directory: %s (user: %s, umask: %03o, parent exists: %s, parent writable: %s)',
        //     $dir,
        //     get_current_user(),
        //     umask(),
        //     is_dir(dirname($dir)) ? 'yes' : 'no',
        //     is_writable(dirname($dir)) ? 'yes' : 'no'
        // ));
        
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
        exec(sprintf(
            '%s -quiet -format "%%w,%%h" %s 2>/dev/null',
            escapeshellcmd($this->identifyPath),
            escapeshellarg($imageFile . '[0]')
        ), $output, $returnVar);

        if ($returnVar !== 0 || empty($output[0])) {
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

        return ['width' => (int)$parts[0], 'height' => (int)$parts[1]];
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

    /**
     * Provision an Image entity from an uploaded source file.
     * If an Image with the derived asset_key already exists, returns it untouched.
     * Otherwise creates variants on disk, populates assetKey/type/file/size, and returns the new (not yet persisted) entity.
     *
     * @return array{image: Image, isNew: bool}
     */
    public function provisionAssetFromUpload(string $sourceFile, string $originalFilename, string $type = 'photo'): array
    {
        if ($this->imageRepository === null) {
            throw new \LogicException('ImageService needs an ImageRepository for provisioning.');
        }

        $assetKey = $this->generateAssetKey($originalFilename);
        $existing = $this->imageRepository->findOneBy(['assetKey' => $assetKey]);
        if ($existing !== null) {
            return ['image' => $existing, 'isNew' => false];
        }

        $dimensions = $this->processImage($sourceFile, $assetKey);

        $image = new Image();
        $image->setAssetKey($assetKey);
        $image->setType($type);
        $image->setFile($originalFilename);
        $image->setSize(sprintf('%d,%d', $dimensions['width'], $dimensions['height']));

        return ['image' => $image, 'isNew' => true];
    }

    /**
     * Regenerate variants transactionally: stage into a temp key, only touch the real dir on success.
     * The archival source_* file is preserved.
     *
     * @return array{width:int,height:int}
     */
    public function overwriteAsset(string $sourceFile, string $assetKey): array
    {
        $assetDir = $this->getAssetDirectory($assetKey);
        if (!is_dir($assetDir)) {
            throw new \RuntimeException(sprintf('Asset directory does not exist: %s', $assetDir));
        }

        $stageKey = $assetKey . '__stage_' . uniqid();
        try {
            $dimensions = $this->processImage($sourceFile, $stageKey);
        } catch (\Throwable $e) {
            $this->purgeAssetDirectory($stageKey);
            throw $e;
        }

        $stageDir = $this->getAssetDirectory($stageKey);
        try {
            // Delete only regenerated variants in real dir; keep source_* archive
            foreach ((array) glob($assetDir . '/*') as $file) {
                if (!is_file($file)) {
                    continue;
                }
                if (strpos(basename($file), 'source_') === 0) {
                    continue;
                }
                @unlink($file);
            }

            // Move staged files into place; discard staged source_* (real archive kept)
            foreach ((array) glob($stageDir . '/*') as $file) {
                $name = basename($file);
                if (strpos($name, 'source_') === 0) {
                    @unlink($file);
                    continue;
                }
                rename($file, $assetDir . '/' . $name);
            }
        } finally {
            $this->purgeAssetDirectory($stageKey);
        }

        // Stale edit_source cache from previous session
        @unlink($assetDir . '/edit_source.png');

        return $dimensions;
    }

    /**
     * Ensure an editable PNG (derived from original.tif) exists and return its asset-relative path.
     * Falls back to large.webp if original.tif is missing. Caller should pipe the return value
     * through Twig's asset() helper so the app base path gets prepended.
     */
    public function ensureEditSource(string $assetKey, int $maxDimension = 3000): string
    {
        $assetDir = $this->getAssetDirectory($assetKey);
        $editPng = $assetDir . '/edit_source.png';
        $originalTif = $assetDir . '/original.tif';

        if (!file_exists($editPng) || (file_exists($originalTif) && filemtime($originalTif) > filemtime($editPng))) {
            if (file_exists($originalTif)) {
                $this->renderPng($originalTif, $editPng, $maxDimension);
            }
        }

        $shard = $this->generateAssetShard($assetKey);
        $variant = file_exists($editPng) ? 'edit_source.png' : 'large.webp';
        return sprintf('assets/%s/%s/%s', $shard, $assetKey, $variant);
    }

    /**
     * Suggest the next versioned asset key (base, base_v2, base_v3, …).
     * Existing "_vN" suffix on $baseKey is stripped before search.
     */
    public function nextVersionedKey(string $baseKey): string
    {
        if ($this->imageRepository === null) {
            throw new \LogicException('ImageService needs an ImageRepository for versioning.');
        }

        $rootKey = preg_replace('/_v\d+$/', '', $baseKey);
        $qb = $this->imageRepository->createQueryBuilder('i')
            ->where('i.assetKey = :root OR i.assetKey LIKE :pattern')
            ->setParameter('root', $rootKey)
            ->setParameter('pattern', $rootKey . '_v%');
        $existing = $qb->getQuery()->getResult();

        $maxV = 1;
        foreach ($existing as $img) {
            $key = $img->getAssetKey();
            if ($key === $rootKey) {
                continue;
            }
            if (preg_match('/^' . preg_quote($rootKey, '/') . '_v(\d+)$/', $key, $m)) {
                $maxV = max($maxV, (int) $m[1]);
            }
        }
        return $rootKey . '_v' . ($maxV + 1);
    }

    private function renderPng(string $sourceFile, string $destFile, int $maxDimension): void
    {
        $output = [];
        $returnVar = 0;
        exec(sprintf(
            '%s %s[0] -resize %dx%d\> -colorspace sRGB %s 2>&1',
            escapeshellcmd($this->convertPath),
            escapeshellarg($sourceFile),
            $maxDimension,
            $maxDimension,
            escapeshellarg($destFile)
        ), $output, $returnVar);
        if ($returnVar !== 0) {
            throw new \RuntimeException(sprintf(
                'Failed to render editable PNG %s: %s',
                $destFile,
                implode("\n", $output)
            ));
        }
    }

    private function purgeAssetDirectory(string $assetKey): void
    {
        $dir = $this->getAssetDirectory($assetKey);
        if (!is_dir($dir)) {
            return;
        }
        foreach ((array) glob($dir . '/*') as $file) {
            if (is_file($file)) {
                @unlink($file);
            }
        }
        @rmdir($dir);
        @rmdir(dirname($dir)); // remove shard dir if now empty
    }
}
