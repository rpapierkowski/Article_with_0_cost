SELECT	tl.New_value AS "Real Shipping Cost (EUR)"
,	tl.username_id 
,	tl.Updated 
,	ssp.sa_id AS "Sa Id"

FROM total_log tl 

LEFT JOIN sa_shipping_price ssp on ssp.id = tl.TableID

WHERE 	tl.table_name_id = 1020
		AND tl.field_name_id = 603
ORDER BY tl.Updated