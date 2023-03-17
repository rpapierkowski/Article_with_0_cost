SELECT tl.New_value 
,	tl.Updated 
,	tl.TableID 
, 	date(tl.updated) AS 'date2'
, 	concat(tl.tableid," ",DATE(tl.updated)) AS 'sa_upd' 

FROM total_log tl 

WHERE tl.table_name_id=495 
	AND tl.field_name_id=1677
	AND tl.updated>"2020-01-01 00:00:00"
	
-- 	AND tl.tableID BETWEEN 20000 AND 30000
