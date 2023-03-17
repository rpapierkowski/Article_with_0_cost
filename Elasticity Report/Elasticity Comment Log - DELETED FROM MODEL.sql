SELECT	sapc.saved_id 
,		tl4.new_value
,		tl4.updated
,		IFNULL(spc.comment,' ') AS "Comment"
FROM total_log tl4

LEFT JOIN saved_auctions_price_comment sapc ON tl4.TableID  = sapc.id
LEFT JOIN saved_price_comment spc ON sapc.comment_id = spc.id

WHERE 	tl4.table_name_id = 991
		AND tl4.field_name_id = 5949
		AND tl4.updated >= "2022-11-28 00:00:00"


		
		