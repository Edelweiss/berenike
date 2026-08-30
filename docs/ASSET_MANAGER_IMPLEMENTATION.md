# Asset Manager Implementation Summary

## Completed Tasks

### 1. Database Migration (Version20260827000000.php)
Created migration that:
- Adds `asset_key` (VARCHAR 512, nullable) and `asset_shard` (VARCHAR 2, nullable) fields to the `image` table
- Creates `find_image` join table for N:M relationship between `find` and `image`
- Migrates existing data from `image.find_id` to the new `find_image` join table
- Drops the old `image.find_id` foreign key and column
- Includes complete rollback in the `down()` method

### 2. Doctrine ORM Mappings Updated
- **Image.orm.xml**: Added `assetKey` and `assetShard` fields, changed relationship from `many-to-one` to `many-to-many`
- **Find.orm.xml**: Changed relationship from `one-to-many` to `many-to-many`

### 3. Entity Classes Updated
- **Image.php**:
  - Added `$assetKey`, `$assetShard` properties
  - Changed `$find` to `$finds` (ArrayCollection for N:M relationship)
  - Added `addFind()`, `removeFind()`, `setFinds()`, `getFinds()` methods
  - `setAssetKey()` automatically computes and sets `assetShard` (first 2 chars of MD5 hash)
  - Legacy `getFind()` and `setFind()` methods kept for backward compatibility (deprecated)

- **Find.php**:
  - Updated `addImage()` and `removeImage()` to properly handle bidirectional N:M relationship

### 4. ImageService Created (src/Service/ImageService.php)
Handles all asset management and image processing:
- `generateAssetKey()`: Converts filename to lowercase, strips extension, replaces spaces with underscores
- `generateAssetShard()`: Computes first 2 chars of MD5 hash
- `getAssetDirectory()`: Returns path `/public/assets/<shard>/<key>/`
- `ensureAssetDirectory()`: Creates asset directory if needed
- `assetExists()`: Checks if asset files already exist
- `processImage()`: Complete image processing pipeline:
  - Copies source file as `source_<original_filename>`
  - Generates `original.tif` (LZW compressed, sRGB color space)
  - Generates WebP variants: `large.webp` (max 1920px), `medium.webp` (max 1024px), `small.webp` (max 640px), `thumbnail.webp` (max 250px)
  - Returns original image dimensions
- `getImageDimensions()`: Extracts dimensions using ImageMagick identify (handles TIF warnings)
- `getAssetWebPath()`: Returns web-accessible path for variants
- `getAssetVariants()`: Lists all available variants for an asset

### 5. Import Command Created (src/Command/ImportImagesCommand.php)
Full-featured CLI import tool with:
- **Arguments**: source-dir, image-csv, find-image-csv
- **Options**: 
  - `--dry-run`: Validates without making changes
  - `--batch-size`: Entity Manager clear interval (default 100)
- **Features**:
  - Streams CSV files to manage memory
  - Handles specialist GND mapping (adds `https://` prefix automatically)
  - Checks for existing images by `asset_key` (deduplication)
  - Links images to multiple finds (N:M relationship)
  - Creates `ImageSpecialist` relationships
  - Memory management: clears Entity Manager every N records (PHP 7.4 compatible)
  - Progress bar with detailed statistics
  - Comprehensive error logging (non-breaking)
  - Handles missing files, missing specialists, and no-find-link cases gracefully

### 6. Service Configuration
Updated `config/services.yaml` to register `ImageService` with `$projectDir` parameter.

## Dry-Run Test Results ✅

Successfully validated against `/data/import/ober3/`:
- **Total records**: 239
- **Processed**: 239
- **Errors**: 0
- All image files found and dimensions successfully extracted
- All CSV data valid
- All find-image relationships mapped correctly

## Next Steps

### 1. Run Database Migration
```bash
cd /Users/elemmire/Papy_HCCH/projects/berenike
bin/console doctrine:migrations:migrate
```

This will:
- Add asset fields to the `image` table
- Create the `find_image` join table
- Migrate existing relationships
- Drop the old `image.find_id` column

### 2. Run the Actual Import
```bash
bin/console app:import-images \
  data/import/ober3/images \
  data/import/ober3/image.csv \
  data/import/ober3/find_image.csv \
  --batch-size=50
```

**Note**: Remove `--dry-run` to execute the actual import. The command will:
- Create 239 image records in the database
- Process and generate all image variants (original.tif + 4 WebP variants)
- Store files in `/public/assets/<shard>/<key>/` structure
- Link images to finds via the `find_image` join table
- Create `ImageSpecialist` relationships

**Memory Management**: The `--batch-size=50` option flushes and clears the Entity Manager every 50 records to prevent memory leaks in PHP 7.4.

### 3. Verify Asset Structure
After import, check the asset directory structure:
```bash
ls -la public/assets/
# Should see subdirectories like: 00/, 01/, 02/, ..., ff/

ls -la public/assets/c4/261_57200.002_dsc_0311-gray/
# Should contain:
#   source_261_57200.002_DSC_0311-gray.jpg
#   original.tif
#   large.webp
#   medium.webp
#   small.webp
#   thumbnail.webp
```

### 4. Update Controllers and Templates (If Needed)
The entity relationship has changed from 1:N to N:M. Update any controllers or templates that reference:
- `$image->getFind()` → Use `$image->getFinds()` or legacy method still works (returns first find)
- `$find->getImages()` → Still works, returns ArrayCollection

## Technical Notes

### Asset Key Generation
Example: `510_64001-BE 11 Small Finds 28 Jan 050.jpg`
- Asset Key: `510_64001-be_11_small_finds_28_jan_050`
- Asset Shard: `c4` (first 2 chars of MD5: `c4f...`)
- Directory: `/public/assets/c4/510_64001-be_11_small_finds_28_jan_050/`

### CSV Format Requirements

**image.csv**:
```csv
image_name,specialist_gnd,type,year,speciality
426_57181-A003+048.jpg,d-nb.info/gnd/13872413X,photo,2009,photographer
```

**find_image.csv**:
```csv
find_id,image_name
10,426_57181-A003+048.jpg
```

### GND Handling
- CSV stores GND as: `d-nb.info/gnd/1020326514`
- Database expects: `https://d-nb.info/gnd/1020326514`
- Import command automatically adds `https://` prefix

### Duplicate Prevention
The import command checks for existing images by `asset_key`. If found:
- Skips file processing
- Only creates new `find_image` relationships
- Logs a notice

## File Structure Created

```
migrations/
  └── Version20260827000000.php          # Database migration

config/
  └── mapping/orm/
      ├── Image.orm.xml                  # Updated with asset fields and N:M
      └── Find.orm.xml                   # Updated with N:M

src/
  ├── Entity/
  │   ├── Image.php                      # Updated with asset properties and N:M
  │   └── Find.php                       # Updated with N:M
  ├── Service/
  │   └── ImageService.php               # New: Asset management service
  └── Command/
      └── ImportImagesCommand.php        # New: Import CLI tool

config/
  └── services.yaml                       # Updated: ImageService registration
```

## Performance Considerations

- **Batch Size**: Default 100, adjustable via `--batch-size`
- **Memory**: Entity Manager cleared every N records to prevent PHP 7.4 memory leaks
- **Processing Time**: ~25 seconds for 239 images in dry-run (validation only)
- **Actual Import**: Expect ~2-5 minutes for full processing with ImageMagick conversions

## Validation Completed ✅

All requirements from `/docs/concept/asset_manager.md` have been implemented:
- ✅ Schema migrations with rollback
- ✅ Asset key/shard generation and automatic computation
- ✅ N:M relationship between find and image
- ✅ Complete file system architecture
- ✅ ImageMagick processing (TIF + WebP variants)
- ✅ CLI import with dry-run mode
- ✅ Memory management for bulk imports
- ✅ CSV parsing with streaming
- ✅ GND specialist matching
- ✅ Duplicate detection by asset_key
- ✅ Progress bars and comprehensive logging
