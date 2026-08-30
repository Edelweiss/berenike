# TASK SPECIFICATION: Asset Manager & Image Management Migration for Berenike.project

## Context & Tech Stack
Build a complete Asset Manager for photos/pictures in the Berenike project. 
- Tech Stack: PHP 7.4.3, Symfony, Doctrine ORM (XML mappings), Image Processing (ImageMagick).

---

## 1. Schema Updates & ORM Mapping

### 1a. New Image Asset Fields (`image` Table)
Add two fields to the `image` table:
1. `asset_key` (VARCHAR): Stores the sanitized image filename without file extension. 
   - Rule: Convert string to lowercase, strip file extension, replace spaces with underscores.
   - Example: `510_64001-BE 11 Small Finds 28 Jan 050.jpg` -> `510_64001-be_11_small_finds_28_jan_050`
2. `asset_shard` (VARCHAR(2)): Stores the first **2 characters** of the MD5 hash of `asset_key`.
   - Rule: Automatically computed whenever `asset_key` is set. Non-editable by users.

Write a SQL migration snippet to:
- Add `asset_key` and `asset_shard` columns to `image`. Make it nullable, so it works with legacy data.
- Update Doctrine XML/Attribute Mappings, `Image` Entity, Controllers, Forms, and Templates.

### 1b. Relationship Migration: `find` <-> `image` (1:N to N:M)
The relationship between `find` and `image` changes from 1:N to N:M.
1. Create a join table `find_image`:
   - `find_id` (INT, FK -> find.id, NOT NULL)
   - `image_id` (INT, FK -> image.id, NOT NULL)
   - Primary Key: (`find_id`, `image_id`)
2. Write a migration snippet to:
   - Populate `find_image` using existing `image.find_id` data.
   - Drop the foreign key constraint and column `image.find_id`.
3. Update Doctrine Mappings, Entities (`Find`, `Image`), Forms, Controllers, and UI templates to support `ManyToMany` / `ManyToMany` with join table.

---

## 2. File System Architecture & Asset Processing

All assets must be stored in `/public/assets/<asset_shard>/<asset_key>/`.

### Directory Tree Example:
For file `261_57200.002_DSC_0311-gray.jpg`
- `asset_key`: `261_57200.002_dsc_0311-gray`
- `asset_shard`: `c4` (MD5 first 2 chars)

```text
/public/assets/c4/261_57200.002_dsc_0311-gray/
├── source_261_57200.002_DSC_0311-gray.jpg  <-- Untouched original upload
├── original.tif                             <-- Standard Web/IIIF TIF conversion
├── large.webp                               <-- Web variant (Max 1920px width/height)
├── medium.webp                              <-- Web variant (Max 1024px width/height)
├── small.webp                               <-- Web variant (Max 640px width/height)
└── thumbnail.webp                           <-- Grid/Thumb variant (Max 250px width/height)
```

### Backend CRUD & Image Upload Pipeline

Create a full CRUD for Image. Validation rule: An image must be linked to at least one Find (via find_image) and at least one Specialist (via image_specialist).

When an image is uploaded via Admin UI:

1.    Generate `asset_key` and compute `asset_shard`.

2.    Ensure directory `/public/assets/<asset_shard>/<asset_key>/` exists.

3.    Save raw uploaded file as `source_<original_filename>.<ext>` (untouched RAW archive).

4.    Generate processing variants:

      -  `original.tif`: Convert source image to baseline uncompressed/LZW TIF (sRGB).

      -  `large.webp`, `medium.webp`, `small.webp`, `thumbnail.webp`: Downscale proportionally retaining aspect ratio using WebP format.

5.    Extract physical pixel dimensions (width, height) of the original file and store in legacy field `image.size` as string "width,height" (e.g., "4000,3000").

### 3.  CLI Import Command (app:import-images)

Write a Symfony Console Command to batch import legacy images.

Command Inputs:

1.    Source directory containing images.

2.    CSV 1: **image.csv** (Columns: `image_name`, `type`, `number`, `heidICON_id`, `heidICON_uuid`, `heidICON_system_object_id`, `specialist_gnd`, `year`, `speciality`)

3.    CSV 2: **find_image.csv** (Columns: `find_id`, `image_name`)

Command Processing Logic:

1.    Parse CSV files with streaming/chunking to manage RAM.

2.    Match specialist_gnd to specialist database record. Note: In the CSV, GND is formatted like 'd-nb.info/gnd/1020326514', while in the database it is stored with HTTPS prefix: 'https://d-nb.info/gnd/1020326514'. Handle this mapping.

3.    Match `image_name` to files in the provided image folder and to records in CSV 2.

4. Defaults handling: If not specified in CSV 1, `type` defaults to 'photo', and `number`, `heidICON_id`, `heidICON_uuid`, `heidICON_system_object_id`, `year` and `speciality` default to NULL. These columns can be completely absent.

5. Check for duplicates: Search DB by computed `asset_key`. If the `image` record and files already exist, skip file generation/saving, attach the existing `image` to the `find` via `find_image`, and output a notice.

6.    Execution: Execute directory creation, ImageMagick processing (WebP/TIF), and DB insertion within Doctrine transactions (clear Entity Manager every 100 items to avoid RAM leaks).

7.    Check if an image with the generated asset_key already exists in the database. If yes, skip file operations and only create the entry in find_image.

8.    Output progress bar and log missing files or unresolvable GND IDs without breaking execution.

9.    Add a `--dry-run` option to validate files, CSV data, and GND references without writing DB records or files.
