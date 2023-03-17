SELECT tl.tableid AS "SA ID"
,	IF(tl.new_value = 1, 'Inactive', 'Active') AS "Status"
,	tl.updated AS "From"
,	IFNULL((SELECT MIN(tl1.Updated)
	FROM total_log tl1	
	WHERE tl.tableid = tl1.tableid
		AND tl1.table_name_id = 495 
		AND tl1.field_name_id = 36
		AND tl1.Updated > tl.updated
	ORDER BY tl1.updated DESC
			), curdate()) AS "To"
			
,	datediff(IFNULL((SELECT MIN(tl1.Updated)
			FROM total_log tl1	
			WHERE tl.tableid = tl1.tableid
				AND tl1.table_name_id = 495 
				AND tl1.field_name_id = 36
				AND tl1.Updated > tl.updated
			ORDER BY tl1.updated DESC
					), curdate()), tl.updated) AS "Days of Status"
,	Concat('W', week(tl.updated)) AS "Week"
,	Date(DATE(tl.updated) - WEEKDAY(tl.updated)) AS "Weeks Start"
,	Date(DATE(tl.updated) - WEEKDAY(tl.updated)+6) AS "Weeks End"

FROM total_log tl 

WHERE tl.table_name_id = 495 
	AND tl.field_name_id = 36
-- 	AND tl.tableid = 342700
	AND  tl.updated >= IFNULL((SELECT MAX(tl2.Updated)
						FROM total_log tl2	
						WHERE tl.tableid = tl2.tableid
							AND tl2.table_name_id = 495 
							AND tl2.field_name_id = 36
							AND tl2.Updated < "2022-11-27 00:00:00"
						ORDER BY tl2.updated DESC
						LIMIT 1
), "2022-11-27 00:00:00")
	
	
	
