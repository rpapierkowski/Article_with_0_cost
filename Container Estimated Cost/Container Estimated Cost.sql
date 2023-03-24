SELECT	
	ooc.id AS "Container Id"
,	ooc2.id as "Main Container Id"
,	IF(ooc.master_id = 0, "Main Container", "Subcontainer") master_container
,	IF(ooc.id = 
			 (
			 SELECT DISTINCT(ooc3.master_id)
			 FROM op_order_container ooc3
			 WHERE ooc.id = ooc3.master_id
			 ) , 'YES', 'NO') AS "Have Subcontainers"
,	imp.Import_Date						
,	IF(ooc.master_id = 0, ooc.container_no, ooc2.container_no) container_name 
,	ooc.order_id
,	CONCAT('https://www.prologistics.info/op_order.php?id=',ooc.order_id) AS link_order
,	SUM(IFNULL(IF(oof.currency = 'USD', oof.value, r.value * oof.value),0)) AS "Cost USD"
,	oof.comment AS Invoice
,	IF(ooc.master_id = 0 ,TRIM(ooc.shipping_line), TRIM(ooc2.shipping_line)) AS "Shipping Line"
,	IF(ooc.master_id = 0 , opc.name, opc2.name) AS "Shipping Company Name"
,	oo.close_date AS "Order Closed Date"
,	IF(oo.close_date IS NULL, 'No', 'Yes') AS "Order Closed"
,	(
		SELECT rate_chf_average.value
		FROM rate_chf_average
		WHERE rate_chf_average.curr_code = 'USD'
			AND rate_chf_average.rate_month = DATE_FORMAT(oaa.delivered, '%Y-%m-01')
		LIMIT 1
	) rate_chf
,		oaa.delivered AS "Delivered"
,	oo.order_date
,	IF(ooc.agent_payment IS NULL, NULL, IF(ooc.agent_payment = 1, 'Paid', 'Not Paid')) AS "Agent Payment"
,	IF(ooc.agent_payment = 1 AND ooc.balance_payment = 1 AND ooc.local_charge_payment = 1 AND ooc.container_released = 1 , 'Closed', 'Open') AS "Container Closed"
,	IF(oof.fee_name IN("shipping_fee", "THC"), 'Sea Logistics' , IF(oof.fee_name IN("transport_fee", "custom_cost"), 'Import Customs', 'Others')) AS "Fee Group"
,	IF(oof.fee_name = "shipping_fee"
		, (SELECT  IF(oaa.delivered < "2022-09-06 00:00:00" 
		 	, SUM(ROUND(IFNULL(IF(oof.currency = 'USD', oof.value, r.value * oof.value),0),2))
			, (		SELECT tl.New_value 
				FROM total_log tl
				LEFT JOIN list_value lv ON tl.TableID = lv.id
				WHERE 
				tl.table_name_id = 254
				AND tl.field_name_id = 58
				AND tl.Updated >= "2022-09-06 00:00:00"
				AND tl.TableID = 229
				AND tl.Updated <= oaa.delivered
			 	ORDER BY tl.Updated DESC
				LIMIT 1)) Estimated_cost
		
		FROM op_order_fee oof
		
		LEFT JOIN 	(
			SELECT	 MIN(oa.add_to_warehouse_date ) AS delivered
				, oa.container_id
				FROM op_article oa
				GROUP BY oa.container_id
					) oaa ON oaa.container_id = oof.order_container_id
					
		LEFT JOIN rate r ON r.curr_code = oof.currency AND Date(oaa.delivered) = r.date
		
		WHERE oaa.delivered >  "2020-01-01 00:00:00" 
		AND oof.order_container_id = ooc.id
		GROUP BY oof.order_container_id)
		,0) AS "Estimated Cost (USD)"
		

FROM op_order_container ooc

	-- INFO ABOUT SUBCONTAINERS
LEFT JOIN 	
(SELECT
	id,
	container_no,
	master_id,
	shipping_line,
	shipping_company_id
FROM
	op_order_container) ooc2 ON
	ooc2.id = ooc.master_id

LEFT JOIN op_company opc ON
	opc.id = ooc.shipping_company_id
LEFT JOIN op_company opc2 ON
	opc2.id = ooc2.shipping_company_id 

-- Setting date for calculation as first article added to warehouse
LEFT JOIN 	(
	SELECT	 MIN(oa.add_to_warehouse_date ) AS delivered
,			oa.container_id
	FROM op_article oa
	GROUP BY oa.container_id
			) oaa ON oaa.container_id = ooc.id	
			
LEFT JOIN op_order_fee oof ON oof.order_container_id = ooc.id

LEFT JOIN rate r ON r.curr_code = oof.currency AND Date(oaa.delivered) = r.date

LEFT JOIN
	(SELECT 
		MIN(ai1.import_date) AS "Import_Date"
	,	MIN(oa1.add_to_warehouse_date) "Delivery"
	, 	oa1.container_id
	FROM article_import ai1 
	
	LEFT JOIN
	op_article oa1 ON ai1.article_id = oa1.article_id
	AND oa1.op_order_id = ai1.op_order_id
	 
	WHERE oa1.add_to_warehouse_date >= "2020-01-01 00:00:00"
	 
	GROUP BY oa1.container_id ) imp ON imp.container_id = ooc.id

LEFT JOIN op_order oo ON ooc.order_id = oo.id

WHERE oaa.delivered >  "2020-01-01 00:00:00" 
--  AND ooc.id = 16396
 -- AND ooc.order_id = 9094
GROUP BY ooc.id, IF(oof.fee_name IN("shipping_fee", "THC"), 'Sea Logistics' , IF(oof.fee_name IN("transport_fee", "custom_cost"), 'Import Customs', 'Others')), oof.comment