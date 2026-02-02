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

(SELECT m.loci_site_id, m.loci_season_id, m.loci_trench_id FROM marina_3 m GROUP BY m.loci_site_id, m.loci_season_id, m.loci_trench_id) m

LEFT JOIN excavation e
ON  m.loci_site_id = e.site
AND e.season LIKE concat('%', IF(m.loci_season_id > 50, '19', '20'), m.loci_season_id, '%')
AND m.loci_trench_id = e.trench

WHERE e.id is NULL
ORDER BY m.loci_site_id, m.loci_season_id, m.loci_trench_id;
