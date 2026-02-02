START TRANSACTION;

-- Add unique constraint on the combination of excavation_id and number
ALTER TABLE locus ADD CONSTRAINT unique_locus_excavation_number UNIQUE (excavation_id, number);

COMMIT;