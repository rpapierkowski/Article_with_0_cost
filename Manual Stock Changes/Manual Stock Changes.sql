SELECT 
	ah.article_id AS "Article Number"
,	t.value AS "Article Name"
,	ah.quantity AS "Quantity"
,	ah.comment AS "Action Comment"
,	ah.date AS "Date"
,	(SELECT item_cost_avg+shipping_cost_avg
	FROM article_warehouse_cost awc 
	LEFT JOIN op_article oa ON awc.op_article_id = oa.id
	WHERE oa.article_id = ah.article_id
		AND oa.add_to_warehouse_date  <= ah.date
	ORDER BY oa.add_to_warehouse_date  DESC
	Limit 1) AS "Aveco" 
,	(SELECT oa.add_to_warehouse_date
	FROM article_warehouse_cost awc 
	LEFT JOIN op_article oa ON awc.op_article_id = oa.id
	WHERE oa.article_id = ah.article_id
		AND oa.add_to_warehouse_date  <= ah.date
	ORDER BY oa.add_to_warehouse_date  DESC
	Limit 1) AS "Aveco Date" 
,	w.name AS "Warehouse"
,	w.country_code warehouse_country
,	IF(a.barcode_type = 'C', "Replacement Part", "Standard") AS "Article Type"
,	IF(ah.quantity > 0, "Addition",IF(ah.quantity < 0, "Subtraction", 0 )) AS "Action Type"
,	CONCAT("https://www.prologistics.info/article.php?original_article_id=",ah.article_id) AS "Article Url"
,	ah.comment [0-9]{4}-[0-9]{2}-[0-9]{2} REGEXP
FROM article_history ah

LEFT JOIN 
	translation t on t.id = ah.article_id 
			AND t.field_name_id = 8
			AND t.table_name_id = 50
			AND t.language = 'english'
			
LEFT JOIN 
	warehouse w ON w.warehouse_id = ah.warehouse_id 
	
LEFT JOIN article a ON ah.article_id = a.article_id 
	AND admin_id = 0
	
WHERE ah.date IS NULL

GROUP BY ah.article_id, ah.date