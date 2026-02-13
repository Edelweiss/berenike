-- All buckets in iwona_3 finds not matching existing buckets
SELECT * FROM

(SELECT i.loci_site_id as site, concat(IF(i.loci_season_id > 50, '19', '20'), i.loci_season_id) as season, TRIM(LEADING '0' FROM i.loci_trench_id) as trench, CONCAT_WS('', loci_locusno+0, LOWER(REGEXP_SUBSTR(loci_locusno, '[A-Za-z]'))) as locus, REGEXP_REPLACE(f.pb_pb_no, '^0*(.+)$', '\\1') as bucket, count(*) as finds FROM iwona_3 i JOIN import on import.id = i.id and authority = 'iwona_3' GROUP BY site, season, trench, locus, bucket) f

LEFT JOIN (SELECT e.id excavation_id, e.site, e.season, e.trench, CONCAT_WS('', l.number, LOWER(l.addendum)) as locus, b.number as bucket FROM bucket b JOIN locus l ON b.locus_id = l.id JOIN excavation e ON l.excavation_id = e.id group by e.id, site, season, trench, locus, bucket) b
ON  f.site = b.site
AND LOCATE(f.season, b.season) > 0
AND f.trench = b.trench
AND f.locus = b.locus
AND f.bucket = b.bucket

WHERE f.site = 'BE' AND f.season is not null AND f.trench is not null AND f.locus is not null AND f.bucket is not null AND b.excavation_id is NULL
ORDER BY f.site, f.season, f.trench, f.locus, f.bucket;

Total: 6963
Unique buckets: 1778 (-5 because of missing trench, season, locus, or bucket number)

Matches: 242
Unmatches: 3673


SELECT * FROM

(SELECT f.loci_site_id as site, concat(IF(f.loci_season_id > 50, '19', '20'), f.loci_season_id) as season, TRIM(LEADING '0' FROM f.loci_trench_id) as trench, CONCAT_WS('', f.loci_locusno+0, LOWER(REGEXP_SUBSTR(f.loci_locusno, '[A-Za-z]'))) as locus, REGEXP_REPLACE(f.pb_pb_no, '^0*(.+)$', '\\1') as bucket, f.id FROM iwona_3 f JOIN import on import.id = f.id and authority = 'iwona_3') f

LEFT JOIN (SELECT e.id excavation_id, e.site, e.season, e.trench, CONCAT_WS('', l.number, LOWER(l.addendum)) as locus, b.number as bucket, b.id as bucket_id FROM bucket b JOIN locus l ON b.locus_id = l.id JOIN excavation e ON l.excavation_id = e.id group by e.id, site, season, trench, locus, bucket) b
ON  f.site = b.site
AND LOCATE(f.season, b.season) > 0
AND f.trench = b.trench
AND f.locus = b.locus
AND f.bucket = b.bucket

WHERE f.site = 'BE' AND f.season is not null AND f.trench is not null AND f.locus is not null AND f.bucket is not null AND b.bucket_id is null
ORDER BY f.site, f.season, f.trench, f.locus, f.bucket;

-- prepare update statements

SELECT i.id as find_id, l.bucket_id FROM iwona_3 i JOIN import on import.id = i.id and authority = 'iwona_3'

LEFT JOIN (SELECT e.id excavation_id, e.site, e.season, e.trench, l.number as locus, b.number as bucket, b.id as bucket_id FROM bucket b JOIN locus l ON b.locus_id = l.id JOIN excavation e ON l.excavation_id = e.id) l
ON  i.loci_site_id = l.site
AND l.season LIKE concat('%', IF(i.loci_season_id > 50, '19', '20'), i.loci_season_id, '%')
AND TRIM(LEADING '0' FROM i.loci_trench_id) = l.trench
AND i.loci_locusno = l.locus
AND TRIM(LEADING '0' FROM i.pb_pb_no) = l.bucket

WHERE i.loci_site_id = 'BE' AND i.loci_season_id AND i.loci_trench_id AND i.loci_locusno AND i.pb_pb_no AND l.excavation_id is not NULL

ORDER BY i.loci_site_id, i.loci_season_id, i.loci_trench_id, i.loci_locusno, i.pb_pb_no;


Iwona duplicate ids?!

 find_id 	c 	
3619 	2
3639 	2
3738 	2
23065 	2
23067 	2
23068 	2
23069 	2
23070 	2
23071 	2
23072 	2
23073 	2
23074 	2
23075 	2
23076 	2
23077 	2
23079 	2
23080 	2
23082 	2
23088 	3
23089 	3
23090 	3
23091 	3
23092 	3
23093 	3
23094 	3



Buckets doubles?!

SELECT i.id, i.loci_site_id, i.loci_season_id, i.loci_trench_id, i.loci_locusno, i.pb_pb_no, GROUP_CONCAT(l.bucket SEPARATOR ',') as buckets, GROUP_CONCAT(l.bucket_id SEPARATOR ',') as bucket_id, count(*) as bucket_duplicates FROM iwona_3 i JOIN import on import.id = i.id and authority = 'iwona_3'

LEFT JOIN (SELECT e.id excavation_id, e.site, e.season, e.trench, l.number as locus, b.number as bucket, b.id as bucket_id FROM bucket b JOIN locus l ON b.locus_id = l.id JOIN excavation e ON l.excavation_id = e.id) l
ON  i.loci_site_id = l.site
AND l.season LIKE concat('%', IF(i.loci_season_id > 50, '19', '20'), i.loci_season_id, '%')
AND i.loci_trench_id+0 = l.trench
AND i.loci_locusno = l.locus
AND i.pb_pb_no+0 = l.bucket+0

WHERE i.loci_site_id = 'BE' AND i.loci_season_id AND i.loci_trench_id AND i.loci_locusno AND i.pb_pb_no AND l.excavation_id is not NULL

group by i.id, i.loci_site_id, i.loci_season_id, i.loci_trench_id, i.loci_locusno, i.pb_pb_no
having bucket_duplicates > 1
ORDER BY i.loci_season_id, i.loci_trench_id, i.loci_locusno, i.pb_pb_no;