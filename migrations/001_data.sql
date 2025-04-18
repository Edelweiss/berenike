LOAD DATA LOCAL INFILE 'locus.csv' INTO TABLE locus
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 2 LINES
(id, site_id, season_id, trench_id, `number`, description, created, modified);

LOAD DATA LOCAL INFILE 'bucket.csv' INTO TABLE bucket
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 2 LINES
(id, locus_id, `number`, dating, remarks, created, modified);

LOAD DATA LOCAL INFILE 'find.csv' INTO TABLE find
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 2 LINES
(id, bucket_id, trench, `date`, year, month, date_remarks, sca_register, `object`, object_no, category, category_no, weight, quantity, dimensions, preservation, description, material, material_remarks, dating_absolute, typology_reference, publications, remarks, rebuild_changes, created, modified);

LOAD DATA LOCAL INFILE 'specialist.csv' INTO TABLE specialist
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES
(id, name);

LOAD DATA LOCAL INFILE 'find_specialist.csv' INTO TABLE find_specialist
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 2 LINES
(find_id, specialist_id, year, speciality);
