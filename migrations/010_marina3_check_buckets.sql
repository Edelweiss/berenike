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