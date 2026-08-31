-- Add supervisor (specialist_id) to excavation table
-- Date: 2026-08-31

ALTER TABLE excavation 
    ADD COLUMN specialist_id INT DEFAULT NULL,
    ADD KEY IDX_excavation_specialist_id (specialist_id),
    ADD CONSTRAINT FK_excavation_specialist_id FOREIGN KEY (specialist_id) REFERENCES specialist (id) ON DELETE SET NULL;

-- Note: specialist_id can be null, allowing trenches without an assigned supervisor
