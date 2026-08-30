-- ---------------------------- --
-- ---------------------------- --
-- DIFF iwona_3 and find tables

SELECT count(*)
from (SELECT * FROM `iwona_3` i WHERE i.loci_site_id LIKE 'BE' and i.loci_season_id = '25' and loci_trench_id = '171') as i
left join find f on f.id = i.id
WHERE f.id is null;

-- Ids only in iwona_3: 525 (non of those are in marina_3; so iwona is the authoritative source for those)
-- Ids also present in berenike.find: 75


-- ---------------------------- --
-- ---------------------------- --
-- LOCI

SELECT i.loci_site_id, i.loci_season_id, i.loci_trench_id, i.loci_locusno, cast(REGEXP_REPLACE(i.loci_locusno, '[^0-9]', '') as unsigned) as locus, LOWER(REGEXP_SUBSTR(i.loci_locusno, '[A-Za-z]')) as addendum,
GROUP_CONCAT(i.pb_pb_no) as buckets, count(*) as buckets_count, l.id as locus_id, l.number as locus_number, l.addendum as locus_addendum, l.excavation_id as locus_excavation_id

FROM (SELECT * FROM `iwona_3` i WHERE i.loci_site_id LIKE 'BE' and i.loci_season_id = '25' and loci_trench_id = '171') as i
LEFT JOIN find f on f.id = i.id
LEFT JOIN locus l on l.number = cast(REGEXP_REPLACE(i.loci_locusno, '[^0-9]', '') as unsigned) and (i.loci_locusno = '' or l.addendum = LOWER(REGEXP_SUBSTR(i.loci_locusno, '[A-Za-z]'))) and l.excavation_id = 107

WHERE f.id is null

GROUP BY i.loci_site_id, i.loci_season_id, i.loci_trench_id, i.loci_locusno LIMIT 100;

-- insert missing loci
 locus 	addendum 	locus_excavation_id 	

INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '8', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '9', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '10', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '11', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '12', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '13', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '14', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '15', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '16', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '17', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '18', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '20', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '21', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '23', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '23', 'a', NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '24', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '25', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '26', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '27', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '28', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '29', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '30', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '32', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '33', NULL, NULL, current_timestamp(), current_timestamp());
INSERT INTO `locus` (`id`, `excavation_id`, `number`, `addendum`, `description`, `created`, `modified`) VALUES (NULL, '107', '34', NULL, NULL, current_timestamp(), current_timestamp());
 
-- local ✅
-- production ✅

-- ---------------------------- --
-- ---------------------------- --
-- BUCKETS

SELECT i.loci_site_id, i.loci_season_id, i.loci_trench_id, i.loci_locusno,
l.id as locus_id, i.pb_pb_no,
b.id as bucket_id,
GROUP_CONCAT(f.id) as finds, count(*) as finds_count

FROM (SELECT * FROM `iwona_3` i WHERE i.loci_site_id LIKE 'BE' and i.loci_season_id = '25' and loci_trench_id = '171') as i
LEFT JOIN locus l on l.number = cast(REGEXP_REPLACE(i.loci_locusno, '[^0-9]', '') as unsigned) and (LOWER(REGEXP_SUBSTR(i.loci_locusno, '[A-Za-z]')) = '' or l.addendum = LOWER(REGEXP_SUBSTR(i.loci_locusno, '[A-Za-z]'))) and l.excavation_id = 107
LEFT JOIN bucket b on b.locus_id = l.id and b.number = cast(i.pb_pb_no as unsigned)
LEFT JOIN find f on f.id = i.id


WHERE f.id is null

GROUP BY i.loci_site_id, i.loci_season_id, i.loci_trench_id, i.loci_locusno, i.pb_pb_no LIMIT 100;

-- 52 Buckets with 525 finds in iwona_3 that are not present in berenike.find
-- all from BE 25 171, i.e. excavation_id 107

-- insert missing buckets
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2101, 59, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2102, 9, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2102, 18, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2102, 29, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2102, 30, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2259, 60, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2808, 16, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2809, 24, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2809, 27, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2810, 21, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2811, 19, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2811, 26, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2812, 22, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2813, 23, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2813, 37, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2814, 20, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2814, 22, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2814, 36, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2814, 41, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2814, 43, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2815, 25, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2815, 39, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2816, 28, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2817, 31, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2818, 32, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2819, 35, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2819, 44, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2819, 47, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2820, 33, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2821, 42, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2821, 65, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2821, 67, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2822, 46, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2823, 40, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2824, 45, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2824, 48, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2825, 49, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2825, 50, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2825, 51, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2826, 52, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2827, 56, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2827, 57, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2827, 58, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2827, 66, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2828, 54, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2829, 55, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2830, 61, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2831, 63, current_timestamp(), current_timestamp());
INSERT INTO `bucket` (`id`, `locus_id`, `number`, `created`, `modified`) VALUES (NULL, 2832, 64, current_timestamp(), current_timestamp());

-- local ✅
-- production ✅

-- ---------------------------- --
-- ---------------------------- --

-- insert finds from iwona_3 into berenike.find

INSERT INTO `find` (`id`, `bucket_id`, `year`, `trench`, `category`, `category_no`, `created`, `date`, `dating_absolute`, `description`, `dimensions`, `material`, `material_remarks`, `modified`, `object`, `object_no`, `preservation`, `publications`, `quantity`, `rebuild_changes`, `sca_register`, `typology_reference`, `weight`)

SELECT              i.id, b.id as bucket_id,        2025, i.trench2, i.category, i.category_no, i.created, i.date, i.dating_absolute, i.description, i.dimensions, i.material, i.material_remarks, i.modified, i.object_id, i.object_no, i.preservation, i.publications, i.quantity, i.rebuild_changes, i.sca_register, i.typology_reference, i.weight

FROM (SELECT * FROM `iwona_3` i WHERE i.loci_site_id LIKE 'BE' and i.loci_season_id = '25' and loci_trench_id = '171') as i
LEFT JOIN locus l on l.number = cast(REGEXP_REPLACE(i.loci_locusno, '[^0-9]', '') as unsigned) 
  and COALESCE(l.addendum, '') = COALESCE(LOWER(REGEXP_SUBSTR(i.loci_locusno, '[A-Za-z]')), '')
  and l.excavation_id = 107
LEFT JOIN bucket b on b.locus_id = l.id and b.number = cast(i.pb_pb_no as unsigned)
LEFT JOIN find f on f.id = i.id
WHERE f.id is null AND l.id IS NOT NULL AND b.id IS NOT NULL
LIMIT 1000;

-- drawing_author, drawing_no, photo_author, photo_author_2, specialist_id, specialist_id_copy are always null in iwona_3, so we don't need to insert those values into berenike.find