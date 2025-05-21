-- Bucket

SELECT
  t.Textile_ID, tpb.Pottery_bucket_number1, tl.Locus_number1
FROM textile t
JOIN textile_pottery_bucket tpb ON tpb.Textile_ID13 = t.Textile_ID
JOIN textile_locus tl ON tl.Textile_ID12 = t.Textile_ID


-- Locus & Trench

SELECT
  textile.Textile_ID, b.Pottery_bucket_number1, l.Locus_number1, t.Trench_number1
FROM textile
JOIN textile_pottery_bucket b ON b.Textile_ID13 = textile.Textile_ID
JOIN textile_locus l ON l.Textile_ID12 = textile.Textile_ID
JOIN textile_trench t ON t.Textile_ID11 = textile.Textile_ID


SELECT
  t.Trench_number1 textile_t, l.Locus_number1 textile_l, b.Pottery_bucket_number1 textile_b, count(textile.Textile_ID) as count_textiles, GROUP_CONCAT(textile.Textile_ID SEPARATOR '|')
FROM textile
LEFT JOIN textile_pottery_bucket b ON b.Textile_ID13 = textile.Textile_ID
LEFT JOIN textile_locus l ON l.Textile_ID12 = textile.Textile_ID
LEFT JOIN textile_trench t ON t.Textile_ID11 = textile.Textile_ID
GROUP BY
  b.Pottery_bucket_number1,
  l.Locus_number1,
  t.Trench_number1
ORDER BY textile_t, textile_l, textile_b
LIMIT 1000

SELECT
  t.number berenike_t, l.number berenike_l, b.number berenike_b, b.id berenike_b_id
FROM bucket b
JOIN locus l ON b.locus_id = l.id
JOIN trench t ON l.trench_id = t.id
WHERE
  t.site = 'BE' AND
  t.number in ('59', '60', '111', '112', '114', '118', '120', '122', '137')
GROUP BY
  b.id,
  l.id,
  t.id
ORDER BY CAST(berenike_t AS INT), berenike_l, CAST(berenike_b AS INT)
LIMIT 1000


berenike::site mit der neuen Tabelle berenike::trench verknüpfen

Trench-Tabelle füllen:

SELECT site, trench FROM `locus` group by site, trench ORDER BY `trench` DESC;

INSERT INTO trench (site, `number`) SELECT site, trench FROM `locus` WHERE NOT trench IN ('59', '60', '111', '112', '114', '118', '120', '122', '137') group by site, trench ORDER BY `trench` DESC;

Trench-Tabelle verknüpfen:

UPDATE locus JOIN trench ON locus.site = trench.site AND locus.trench = trench.number SET locus.trench_id = trench.id