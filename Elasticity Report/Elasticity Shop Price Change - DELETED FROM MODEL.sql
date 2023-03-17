SELECT 	TableID AS "Sa Id"
,		Old_value AS "Old Price"
,		New_value AS "New Price"
,		Updated

FROM total_log
WHERE 	table_name_id = 495
		AND field_name_id = 1677
		AND Updated >= "2022-11-28 00:00:00"