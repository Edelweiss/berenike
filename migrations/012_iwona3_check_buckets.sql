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
