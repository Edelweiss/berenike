-- Make tm field unsigned (positive integers only)
ALTER TABLE find MODIFY COLUMN tm INT UNSIGNED NULL;