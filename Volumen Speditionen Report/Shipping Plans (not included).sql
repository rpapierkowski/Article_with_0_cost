SELECT sm.shipping_method_id 
,	sp1.shipping_plan_id
,	spc.country_code
,	sp.id AS shipping_price_id
,	CONCAT(sm.shipping_method_id,u.name) AS unique_name

FROM shipping_method sm 

LEFT JOIN shipping_price sp ON sm.shipping_method_id = sp.shipping_method_id

LEFT JOIN shipping_plan sp1 ON sp1.shipping_price_id = sp.id

LEFT JOIN shipping_plan_country spc ON spc.shipping_plan_id = sp1.shipping_plan_id

LEFT JOIN  users u ON sm.shipping_method_id = u.shipping_method
