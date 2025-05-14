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
  b.Pottery_bucket_number1, l.Locus_number1, t.Trench_number1, count(textile.Textile_ID) as count_textiles
FROM textile
JOIN textile_pottery_bucket b ON b.Textile_ID13 = textile.Textile_ID
JOIN textile_locus l ON l.Textile_ID12 = textile.Textile_ID
JOIN textile_trench t ON t.Textile_ID11 = textile.Textile_ID
GROUP BY b.Pottery_bucket_number1, l.Locus_number1, t.Trench_number1