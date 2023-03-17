	SELECT 
		*
,		COUNT(Updated)
,		DATE_FORMAT(Updated, '%M.%Y') AS Month

	FROM prologis2.total_log 

	WHERE 
		field_name_id = 383 
		AND table_name_id = 495
		AND DATE(updated) > "2022-11-27"		
		
	GROUP BY 
		tableid
	,	new_value
	,	Old_value


UNION ALL

	SELECT
		*
,		COUNT(Updated)
,		DATE_FORMAT(Updated, '%M.%Y') AS Month

	FROM prologis2.total_log 

	WHERE

		field_name_id = 384 
		AND table_name_id = 495
		AND DATE(updated) > "2022-11-27"

UNION ALL

	SELECT
		*
,		COUNT(Updated)
,		DATE_FORMAT(Updated, '%M.%Y') AS Month

	FROM prologis2.total_log 

	WHERE 

		field_name_id = 5767 
		AND table_name_id = 495
		AND DATE(updated) > "2022-11-27"
UNION ALL

	SELECT 
		*
,		COUNT(Updated)
,		DATE_FORMAT(Updated, '%M.%Y') AS Month

	FROM prologis2.total_log 

	WHERE 

		field_name_id = 5691 
		AND table_name_id = 495
		AND DATE(updated) > "2022-11-27"