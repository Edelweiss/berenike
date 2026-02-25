-- iwona_3 data

SELECT f.loci_site_id as site, concat(IF(f.loci_season_id > 50, '19', '20'), f.loci_season_id) as season, REGEXP_REPLACE(f.loci_trench_id, '^0*(.+)$', '\\1') as trench, CONCAT_WS('', f.loci_locusno+0, LOWER(REGEXP_SUBSTR(f.loci_locusno, '[A-Za-z]'))) as locus, REGEXP_REPLACE(f.pb_pb_no, '^0*(.+)$', '\\1') as bucket, f.id FROM iwona_3 f JOIN import on import.id = f.id and authority = 'iwona_3' WHERE f.loci_site_id = 'BE' AND f.loci_season_id is not null AND f.loci_trench_id is not null AND f.loci_locusno is not null AND f.pb_pb_no is not null;

-- All buckets in iwona_3 finds not matching existing buckets
SELECT * FROM

(SELECT i.loci_site_id as site, concat(IF(i.loci_season_id > 50, '19', '20'), i.loci_season_id) as season, REGEXP_REPLACE(i.loci_trench_id, '^0*(.+)$', '\\1') as trench, CONCAT_WS('', loci_locusno+0, LOWER(REGEXP_SUBSTR(loci_locusno, '[A-Za-z]'))) as locus, REGEXP_REPLACE(f.pb_pb_no, '^0*(.+)$', '\\1') as bucket, count(*) as finds FROM iwona_3 i JOIN import on import.id = i.id and authority = 'iwona_3' GROUP BY site, season, trench, locus, bucket) f

LEFT JOIN (SELECT e.id excavation_id, e.site, e.season, e.trench, CONCAT_WS('', l.number, LOWER(l.addendum)) as locus, b.number as bucket FROM bucket b JOIN locus l ON b.locus_id = l.id JOIN excavation e ON l.excavation_id = e.id group by e.id, site, season, trench, locus, bucket) b
ON  f.site = b.site
AND LOCATE(f.season, b.season) > 0
AND f.trench = b.trench
AND f.locus = b.locus
AND f.bucket = b.bucket

WHERE f.site = 'BE' AND f.season is not null AND f.trench is not null AND f.locus is not null AND f.bucket is not null AND b.excavation_id is NULL
ORDER BY f.site, f.season, f.trench, f.locus, f.bucket;

-- Total: 6963
-- Unique buckets: 1778 (-5 because of missing trench, season, locus, or bucket number)

SELECT * FROM

(SELECT f.loci_site_id as site, concat(IF(f.loci_season_id > 50, '19', '20'), f.loci_season_id) as season, REGEXP_REPLACE(f.loci_trench_id, '^0*(.+)$', '\\1') as trench, CONCAT_WS('', f.loci_locusno+0, LOWER(REGEXP_SUBSTR(f.loci_locusno, '[A-Za-z]'))) as locus, REGEXP_REPLACE(f.pb_pb_no, '^0*(.+)$', '\\1') as bucket, f.id FROM iwona_3 f JOIN import on import.id = f.id and authority = 'iwona_3') f

LEFT JOIN (SELECT e.id excavation_id, e.site, e.season, e.trench, CONCAT_WS('', l.number, LOWER(l.addendum)) as locus, b.number as bucket, b.id as bucket_id FROM bucket b JOIN locus l ON b.locus_id = l.id JOIN excavation e ON l.excavation_id = e.id group by e.id, site, season, trench, locus, bucket) b
ON  f.site = b.site
AND LOCATE(f.season, b.season) > 0
AND f.trench = b.trench
AND f.locus = b.locus
AND f.bucket = b.bucket

WHERE f.site = 'BE' AND f.season is not null AND f.trench is not null AND f.locus is not null AND f.bucket is not null AND b.bucket_id is null
ORDER BY f.site, f.season, f.trench, f.locus, f.bucket;


-- compoare marina_3 and iwona_3
-- fields that are not doubled are always the same 
SELECT
m.id as id,
m.loci_site_id as site,
m.loci_season_id as m_season, i.loci_season_id as i_season,
m.loci_trench_id as m_trench, i.loci_trench_id as i_trench,
m.loci_locusno as m_locus, i.loci_locusno as i_locus,
m.pb_pb_no as m_bucket, i.pb_pb_no as i_bucket,
m.object_id as m_object_id, i.object_id as i_object_id,
m.object_no as m_object_no, i.object_no as i_object_no,
m.material as m_material, i.material as i_material,
m.modified as m_modified, i.modified as i_modified,
m.date as m_date, i.date as i_date,
m.category as m_category, i.category as i_category,
m.category_no as m_category_no, i.category_no as i_category_no

FROM marina_3 m join iwona_3 i ON m.id = i.id

WHERE
  m.loci_season_id != i.loci_season_id
  or m.loci_trench_id != i.loci_trench_id
  or m.loci_locusno != i.loci_locusno
  or m.pb_pb_no != i.pb_pb_no
  or m.object_no != i.object_no
  or m.object_id != i.object_id
  or m.date != i.date
  or m.created != i.created
  or m.modified != i.modified
  or m.description != i.description
  or m.material != i.material
  or m.material_remarks != i.material_remarks
  or m.date != i.date
  or m.category != i.category
  or m.category_no != i.category_no
  or m.remarks != i.remarks
  or m.trench2 != i.trench2
  or m.typology_reference != i.typology_reference
  or m.quantity != i.quantity
  or m.dimensions != i.dimensions
  or m.weight != i.weight 
  or m.sca_register != i.sca_register
  or m.photo_author != i.photo_author
  or m.photo_author_2 != i.photo_author_2
  or m.drawing_author != i.drawing_author
  or m.drawing_no != i.drawing_no
  or m.specialist_id != i.specialist_id
  or m.specialist_id_copy != i.specialist_id_copy