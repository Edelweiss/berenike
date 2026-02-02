START TRANSACTION;

-- Add unique constraint on the combination of locus_id and number for bucket table
-- This ensures that the same bucket number cannot exist twice within the same locus
ALTER TABLE `bucket` ADD CONSTRAINT `unique_locus_number` UNIQUE (`locus_id`, `number`);

COMMIT;
