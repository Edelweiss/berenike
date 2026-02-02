-- Check for duplicate bucket entries based on site, season, trench, locus number, and bucket number
SELECT e.site, e.season, e.trench, l.number as locus, b.number as bucket, COUNT(*) as c,
GROUP_CONCAT(b.dating), GROUP_CONCAT(b.remarks)
FROM bucket b join locus l on b.locus_id = l.id join excavation e on l.excavation_id = e.id
GROUP BY e.site, e.season, e.trench, l.number, b.number
HAVING c > 1
ORDER BY e.site, e.season, e.trench, l.number, b.number

-- Verify no orphaned references remain
SELECT * FROM find WHERE bucket_id NOT IN (SELECT id FROM bucket);
SELECT * FROM textile WHERE bucket_id NOT IN (SELECT id FROM bucket);

-- Re-run duplicate check (should return empty)
SELECT e.site, e.season, e.trench, l.number, b.number, COUNT(*)
FROM bucket b JOIN locus l ON b.locus_id = l.id JOIN excavation e ON l.excavation_id = e.id
GROUP BY e.site, e.season, e.trench, l.number, b.number
HAVING COUNT(*) > 1;
