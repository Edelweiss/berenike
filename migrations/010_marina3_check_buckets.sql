-- marina_3 data

SELECT f.loci_site_id as site, concat(IF(f.loci_season_id > 50, '19', '20'), f.loci_season_id) as season, REGEXP_REPLACE(f.loci_trench_id, '^0*(.+)$', '\\1') as trench, CONCAT_WS('', f.loci_locusno+0, LOWER(REGEXP_SUBSTR(f.loci_locusno, '[A-Za-z]'))) as locus, REGEXP_REPLACE(f.pb_pb_no, '^0*(.+)$', '\\1') as bucket, f.id FROM marina_3 f JOIN import on import.id = f.id and authority LIKE 'marina_3%' WHERE f.loci_site_id = 'BE' AND f.loci_season_id is not null AND f.loci_trench_id is not null AND f.loci_locusno is not null AND f.pb_pb_no is not null;

-- check

SELECT * FROM

(SELECT m.loci_site_id, m.loci_season_id, m.loci_trench_id, m.loci_locusno, m.pb_pb_no, count(*) as finds FROM marina_3 m GROUP BY m.loci_site_id, m.loci_season_id, m.loci_trench_id, m.loci_locusno, m.pb_pb_no) m

LEFT JOIN (SELECT e.id excavation_id, e.site, e.season, e.trench, l.number as locus, b.number as bucket FROM bucket b JOIN locus l ON b.locus_id = l.id JOIN excavation e ON l.excavation_id = e.id) l
ON  m.loci_site_id = l.site
AND l.season LIKE concat('%', IF(m.loci_season_id > 50, '19', '20'), m.loci_season_id, '%')
AND m.loci_trench_id = l.trench
AND m.loci_locusno = l.locus
AND m.pb_pb_no+0 = l.bucket+0

WHERE m.loci_site_id = 'BE' AND m.loci_season_id AND m.loci_trench_id AND m.loci_locusno AND m.pb_pb_no AND l.excavation_id is NULL
ORDER BY m.loci_site_id, m.loci_season_id, m.loci_trench_id, m.loci_locusno, m.pb_pb_no;

Matches: 242
Unmatches: 3673


-- NEW TRENCHES TO ADD:

SELECT * FROM

(SELECT m.loci_site_id, m.loci_season_id, m.loci_trench_id, count(*) as finds FROM marina_3 m GROUP BY m.loci_site_id, m.loci_season_id, m.loci_trench_id) m

LEFT JOIN excavation e
ON  m.loci_site_id = e.site
AND e.season LIKE concat('%', IF(m.loci_season_id > 50, '19', '20'), m.loci_season_id, '%')
AND m.loci_trench_id = e.trench

WHERE e.id is NULL
ORDER BY m.loci_site_id, m.loci_season_id, m.loci_trench_id;

-- NEW LOCI TO ADD:

SELECT * FROM

(SELECT m.loci_site_id, m.loci_season_id, m.loci_trench_id, m.loci_locusno, count(*) as finds FROM marina_3 m GROUP BY m.loci_site_id, m.loci_season_id, m.loci_trench_id, m.loci_locusno) m

LEFT JOIN (SELECT e.id excavation_id, e.site, e.season, e.trench, l.number as locus FROM locus l JOIN excavation e ON l.excavation_id = e.id) l
ON  m.loci_site_id = l.site
AND l.season LIKE concat('%', IF(m.loci_season_id > 50, '19', '20'), m.loci_season_id, '%')
AND m.loci_trench_id = l.trench
AND m.loci_locusno = l.locus

WHERE m.loci_site_id = 'BE' AND m.loci_season_id AND m.loci_trench_id AND m.loci_locusno AND l.excavation_id is NULL
ORDER BY m.loci_site_id, m.loci_season_id, m.loci_trench_id, m.loci_locusno;

-- NEW BUCKETS TO ADD:

SELECT * FROM

(SELECT m.loci_site_id, m.loci_season_id, m.loci_trench_id, m.loci_locusno, m.pb_pb_no, count(*) as finds FROM marina_3 m GROUP BY m.loci_site_id, m.loci_season_id, m.loci_trench_id, m.loci_locusno, m.pb_pb_no) m

LEFT JOIN (SELECT e.id excavation_id, e.site, e.season, e.trench, l.number as locus, b.number as bucket FROM bucket b JOIN locus l ON b.locus_id = l.id JOIN excavation e ON l.excavation_id = e.id) b
ON  m.loci_site_id = b.site
AND b.season LIKE concat('%', IF(m.loci_season_id > 50, '19', '20'), m.loci_season_id, '%')
AND m.loci_trench_id = b.trench
AND m.loci_locusno = b.locus
AND m.pb_pb_no+0 = b.bucket+0

LEFT JOIN (SELECT e.id excavation_id, e.site, e.season, e.trench, l.number as locus FROM locus l JOIN excavation e ON l.excavation_id = e.id) l
ON  m.loci_site_id = l.site
AND l.season LIKE concat('%', IF(m.loci_season_id > 50, '19', '20'), m.loci_season_id, '%')
AND m.loci_trench_id = l.trench
AND m.loci_locusno = l.locus

WHERE m.loci_site_id = 'BE' AND m.loci_season_id AND m.loci_trench_id AND m.loci_locusno AND m.pb_pb_no
AND b.excavation_id is NULL
ORDER BY m.loci_site_id, m.loci_season_id, m.loci_trench_id, m.loci_locusno, m.pb_pb_no;

Number of new buckets to add: 582
Number of loci for new buckets to add that cannot be matched to a locus: 1 (BE44 300-2000/212)

-- 579 buckets added
-- -1 because of unmatched locus (BE44 300-2000/212)
-- -1 because of duplicate bucket number (2595, 1)
-- -1 because of span in field pb_pb_no (in Marina_3 002+004)
-- = 579 new bucket entries to add


-- check iwona_3 authority:

SELECT * FROM

(SELECT f.loci_site_id as site, concat(IF(f.loci_season_id > 50, '19', '20'), f.loci_season_id) as season, REGEXP_REPLACE(f.loci_trench_id, '^0*(.+)$', '\\1') as trench, CONCAT_WS('', f.loci_locusno+0, LOWER(REGEXP_SUBSTR(f.loci_locusno, '[A-Za-z]'))) as locus, REGEXP_REPLACE(REGEXP_REPLACE(f.pb_pb_no, '^0*(.+)$', '\\1'), '/0+', '/') as bucket, f.id FROM marina_3 f JOIN import on import.id = f.id and authority LIKE 'marina_3%') f

LEFT JOIN (SELECT e.id excavation_id, e.site, e.season, e.trench, CONCAT_WS('', l.number, LOWER(l.addendum)) as locus, b.number as bucket, b.id as bucket_id FROM bucket b JOIN locus l ON b.locus_id = l.id JOIN excavation e ON l.excavation_id = e.id group by e.id, site, season, trench, locus, bucket) b
ON  f.site = b.site
AND LOCATE(f.season, b.season) > 0
AND f.trench = b.trench
AND f.locus = b.locus
AND f.bucket = b.bucket

WHERE f.site = 'BE' AND f.season is not null AND f.trench is not null AND f.locus is not null AND f.bucket is not null AND b.bucket_id is null
ORDER BY f.site, f.season, f.trench, f.locus, f.bucket;

-- 20468 - 20347 = 121 finds that cannot be matched to a bucket

-- create missing bucket numbers:

SELECT * FROM

(SELECT f.loci_site_id as site, concat(IF(f.loci_season_id > 50, '19', '20'), f.loci_season_id) as season, REGEXP_REPLACE(f.loci_trench_id, '^0*(.+)$', '\\1') as trench, CONCAT_WS('', f.loci_locusno+0, LOWER(REGEXP_SUBSTR(f.loci_locusno, '[A-Za-z]'))) as locus, REGEXP_REPLACE(REGEXP_REPLACE(f.pb_pb_no, '^0*(.+)$', '\\1'), '/0+', '/') as bucket, count(f.id) as num_finds FROM marina_3 f JOIN import on import.id = f.id and authority LIKE 'marina_3%' group by f.loci_site_id, f.loci_season_id, f.loci_trench_id, f.loci_locusno, f.pb_pb_no) f

LEFT JOIN (SELECT e.id excavation_id, e.site, e.season, e.trench, CONCAT_WS('', l.number, LOWER(l.addendum)) as locus, b.number as bucket, b.id as bucket_id FROM bucket b JOIN locus l ON b.locus_id = l.id JOIN excavation e ON l.excavation_id = e.id group by e.id, site, season, trench, locus, bucket) b
ON  f.site = b.site
AND LOCATE(f.season, b.season) > 0
AND f.trench = b.trench
AND f.locus = b.locus
AND f.bucket = b.bucket

WHERE f.site = 'BE' AND f.season is not null AND f.trench is not null AND f.locus is not null AND f.bucket is not null AND b.bucket_id is null
ORDER BY f.site, f.season, f.trench, f.locus, f.bucket;

-- 23 missing buckets, all with bs and as and xx.s and stuff

-- check fork

SELECT * FROM

(SELECT m.id, m.loci_site_id, m.loci_season_id, m.loci_trench_id, m.loci_locusno, m.pb_pb_no FROM marina_3 m JOIN fork ON fork.id = m.id AND (fork.source = 'marina_3' OR fork.source IS NULL) AND fork.bucket_not_found IS TRUE) m

LEFT JOIN (SELECT e.id excavation_id, e.site, e.season, e.trench, l.number as locus, b.number as bucket FROM bucket b JOIN locus l ON b.locus_id = l.id JOIN excavation e ON l.excavation_id = e.id) l
ON  m.loci_site_id = l.site
AND l.season LIKE concat('%', IF(m.loci_season_id > 50, '19', '20'), m.loci_season_id, '%')
AND m.loci_trench_id = l.trench
AND m.loci_locusno = l.locus
AND m.pb_pb_no+0 = l.bucket+0

WHERE m.loci_site_id = 'BE' AND m.loci_season_id AND m.loci_trench_id AND m.loci_locusno AND m.pb_pb_no AND l.excavation_id is not NULL
ORDER BY m.loci_site_id, m.loci_season_id, m.loci_trench_id, m.loci_locusno, m.pb_pb_no;