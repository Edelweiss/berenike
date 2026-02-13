Show COLUMNS from `import`;

Field 	Type 	Null 	Key 	Default 	Extra 	
id
	int(11)
	NO
		NULL 	
authority
	varchar(256)
	YES
		NULL 	
source
	varchar(256)
	YES
		NULL 	
status
	varchar(256)
	YES
		NULL 	
comment
	text
	YES
		NULL 	

INSERT into `import` (id, authority, source, status, comment)
select m.id, 'marina_3', 'marina_3', 'completed', 'authority by timestamp'
from marina_3 m join iwona_3 i on m.id = i.id left join find f on m.id = f.id 
where m.modified > i.modified and f.id is not null; -- 801 records inserted

INSERT into `import` (id, authority, source, status, comment)
select m.id, 'marina_3', 'marina_3', 'completed', 'authority by exclusivity'
from marina_3 m left join iwona_3 i on m.id = i.id left join find f on m.id = f.id 
where i.id is null and f.id is not null; -- 143 records inserted

INSERT into `import` (id, authority, source, status, comment)
select i.id, 'iwona_3', 'iwona_3', 'completed', 'authority by timestamp'
from iwona_3 i join marina_3 m on i.id = m.id left join find f on m.id = f.id 
where i.modified > m.modified and f.id is not null; -- 5205 records inserted

INSERT into `import` (id, authority, source, status, comment)
select i.id, 'iwona_3', 'iwona_3', 'completed', 'authority by exclusivity'
from iwona_3 i left join marina_3 m on i.id = m.id left join find f on i.id = f.id 
where m.id is null and f.id is not null; -- 1758 records inserted

INSERT into `import` (id, authority, source, status, comment)
select m.id, 'marina_3, iwona_3', 'marina_3', 'completed', 'same modified timestamp, prefer marina_3'
from marina_3 m join iwona_3 i on m.id = i.id left join find f on m.id = f.id 
where m.modified = i.modified and f.id is not null; -- 19654 records inserted


-- Overview

SELECT authority, comment, count(*) c FROM `import`
GROUP BY authority, `comment`;