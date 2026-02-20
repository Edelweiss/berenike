-- wrong date format in marina und iwona

SELECT m.id, m.date, f.date, f.year, f.date_remarks  FROM `v_marina` m join find f on m.id = f.id WHERE m.`date` NOT REGEXP '\\d\\d\\d\\d[\-\._]\\d\\d[\-\._]\\d\\d|\\d\\d[\-\._]\\d\\d[\-\._]\\d\\d\\d\\d'
UNION
SELECT m.id, m.date, f.date, f.year, f.date_remarks  FROM `v_iwona` m join find f on m.id = f.id WHERE m.`date` NOT REGEXP '\\d\\d\\d\\d[\-\._]\\d\\d[\-\._]\\d\\d|\\d\\d[\-\._]\\d\\d[\-\._]\\d\\d\\d\\d';

UPDATE find SET date_remarks = '1997-01-??' WHERE id = 12922;
UPDATE find SET date = '1998-01-01' WHERE id = 15138;
UPDATE find SET date_remarks = '1998-??-??' WHERE id = 15138;

-- date IS NULL in bereninke.find

select f.id, f.date, f.year, f.date_remarks, m.date, m.object_no from find f left join v_marina m on f.id = m.id where f.date is null LIMIT 1000; 