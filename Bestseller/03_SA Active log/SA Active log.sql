SELECT tl.tableid AS sa_id
,	datediff(curdate(),tl.Updated) as "today"
,	tl.Updated as"new"
,	tl2.Updated as "old"
,	tl.new_value
,	tl.old_value

FROM total_log tl


CROSS JOIN total_log tl2 ON tl2.table_name_id=495 
	AND tl2.field_name_id=36 
	AND tl2.tableid=tl.tableid
	AND tl2.id<tl.id
	
	WHERE 
	 tl.table_name_id=495 
	AND tl.field_name_id=36 
	
GROUP BY tl2.id