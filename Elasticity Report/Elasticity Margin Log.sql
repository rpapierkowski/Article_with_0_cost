SELECT 	tl.New_value/100 AS "Margin %"
,		IFNULL(tl.username_id,'SYS') AS "Username"
,		tl.Updated 
,		tl.TableID AS "Sa Id"
FROM total_log tl 
WHERE 	tl.table_name_id = 495
		AND tl.field_name_id = 6018