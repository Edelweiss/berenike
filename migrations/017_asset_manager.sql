-- Asset Manager Migration: Add asset fields and convert find-image relationship to N:M
-- Date: 2026-08-27

-- Step 1: Add new asset fields to image table
ALTER TABLE image 
    ADD COLUMN asset_key VARCHAR(512) DEFAULT NULL,
    ADD COLUMN asset_shard VARCHAR(2) DEFAULT NULL;

-- Step 2: Create find_image join table for N:M relationship
CREATE TABLE find_image (
    find_id INT NOT NULL,
    image_id INT NOT NULL,
    PRIMARY KEY (find_id, image_id),
    KEY IDX_find_image_find_id (find_id),
    KEY IDX_find_image_image_id (image_id),
    CONSTRAINT FK_find_image_find_id FOREIGN KEY (find_id) REFERENCES find (id) ON DELETE CASCADE,
    CONSTRAINT FK_find_image_image_id FOREIGN KEY (image_id) REFERENCES image (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Step 3: Migrate existing data from image.find_id to find_image join table
INSERT INTO find_image (find_id, image_id)
SELECT find_id, id
FROM image
WHERE find_id IS NOT NULL;

-- Step 4: Drop the old foreign key constraint and column
ALTER TABLE `image` DROP INDEX `find_id`;
ALTER TABLE image DROP FOREIGN KEY find_id;
ALTER TABLE `image` DROP `find_id`;

-- Migration complete
-- Total changes:
--   - Added asset_key and asset_shard columns to image table
--   - Created find_image join table
--   - Migrated existing find-image relationships
--   - Removed old find_id column from image table
