SELECT  IF(oaa.delivered < "2022-09-20 00:00:00", 
	SUM(ROUND(IFNULL(IF(oof.currency = 'USD', oof.value, r.value * oof.value),0),2))
	, (		SELECT tl.New_value 
		FROM total_log tl
		LEFT JOIN list_value lv ON tl.TableID = lv.id
		WHERE 
		tl.table_name_id = 254
		AND tl.field_name_id = 58
		AND tl.Updated >= "2022-09-20 00:00:00"
		AND tl.TableID = 229
		AND tl.Updated <= oaa.delivered
	-- 	AND lv.`key` = oof.fee_name
	 	ORDER BY tl.Updated DESC
		LIMIT 1)) Estimated_cost
,	oof.order_container_id
,	'Sea Logistics'

FROM op_order_fee oof

LEFT JOIN 	(
	SELECT	 MIN(oa.add_to_warehouse_date ) AS delivered
		, oa.container_id
		FROM op_article oa
		GROUP BY oa.container_id
			) oaa ON oaa.container_id = oof.order_container_id
			
LEFT JOIN rate r ON r.curr_code = oof.currency AND Date(oaa.delivered) = r.date

WHERE oaa.delivered >  "2020-01-01 00:00:00" 
GROUP BY oof.order_container_id
