-- check the maximum length of all string fields in the marina_3 and iwona_3 tables, and also checks the distribution of lengths for the object_no field, which is the only one that has a length close to 255. The results show that all fields are well below 255 characters, so we can safely set the length to 255 for all string fields in the next migration.
SELECT
    MAX(LENGTH(f.category)) as max_category_length,
    MAX(LENGTH(f.category_no)) as max_category_no_length,
    MAX(LENGTH(f.dating_absolute)) as max_dating_absolute_length,
    MAX(LENGTH(f.description)) as max_description_length,
    MAX(LENGTH(f.dimensions)) as max_dimensions_length,
    MAX(LENGTH(f.material)) as max_material_length,
    MAX(LENGTH(f.material_remarks)) as max_material_remarks_length,
    MAX(LENGTH(f.object_id)) as max_object_id_length,
    MAX(LENGTH(f.object_no)) as max_object_no_length,
    MAX(LENGTH(f.preservation)) as max_preservation_length,
    MAX(LENGTH(f.quantity)) as max_quantity_length,
    MAX(LENGTH(f.rebuild_changes)) as max_rebuild_changes_length,
    MAX(LENGTH(f.sca_register)) as max_sca_register_length,
    MAX(LENGTH(f.trench2)) as max_trench2_length,
    MAX(LENGTH(f.typology_reference)) as max_typology_reference_length,
    MAX(LENGTH(f.weight)) as max_weight_length
FROM
(SELECT f.id, f.category, f.category_no, f.dating_absolute, f.description, f.dimensions, f.material, f.material_remarks, f.object_id, f.object_no, f.preservation, f.quantity, f.rebuild_changes, f.sca_register, f.trench2, f.typology_reference, f.weight FROM marina_3 f JOIN import ON f.id = import.id WHERE import.authority LIKE 'marina_3%'
UNION
SELECT f.id, f.category, f.category_no, f.dating_absolute, f.description, f.dimensions, f.material, f.material_remarks, f.object_id, f.object_no, f.preservation, f.quantity, f.rebuild_changes, f.sca_register, f.trench2, f.typology_reference, f.weight FROM iwona_3 f JOIN import ON f.id = import.id WHERE import.authority = 'iwona_3') f;

--

SELECT
length(object_no) object_no_length, count(*) as number_of_finds, GROUP_CONCAT(id) find_ids
FROM
(SELECT f.id, f.category, f.category_no, f.dating_absolute, f.description, f.dimensions, f.material, f.material_remarks, f.object_id, f.object_no, f.preservation, f.quantity, f.rebuild_changes, f.sca_register, f.trench2, f.typology_reference, f.weight FROM marina_3 f JOIN import ON f.id = import.id WHERE import.authority LIKE 'marina_3%'
UNION
SELECT f.id, f.category, f.category_no, f.dating_absolute, f.description, f.dimensions, f.material, f.material_remarks, f.object_id, f.object_no, f.preservation, f.quantity, f.rebuild_changes, f.sca_register, f.trench2, f.typology_reference, f.weight FROM iwona_3 f JOIN import ON f.id = import.id WHERE import.authority = 'iwona_3') f
GROUP BY length(object_no) ORDER BY length(object_no) desc;

-- check category_no field 

SELECT id, category_no, LENGTH(category_no) FROM
(SELECT f.id, category_no, object_id, weight FROM marina_3 f JOIN import on import.id = f.id and authority LIKE 'marina_3%' WHERE f.loci_site_id = 'BE' AND f.loci_season_id is not null AND f.loci_trench_id is not null AND f.loci_locusno is not null AND f.pb_pb_no is not null
UNION
SELECT f.id, category_no, object_id, weight FROM iwona_3 f JOIN import on import.id = f.id and authority = 'iwona_3' WHERE f.loci_site_id = 'BE' AND f.loci_season_id is not null AND f.loci_trench_id is not null AND f.loci_locusno is not null AND f.pb_pb_no is not null
) f
WHERE LENGTH(category_no) > 64;

