SELECT
sm.shipping_method_id AS 'Shiping Method ID'
, u.name AS 'Shipping Company'
, sm.company_name AS 'Shipping Method'
, CONCAT(sm.shipping_method_id,IFNULL(u.name,'')) AS unique_name

FROM shipping_method sm 

LEFT JOIN  users u ON sm.shipping_method_id = u.shipping_method

WHERE sm.shipping_method_id IS NOT NULL
and sm.shipping_method_id = 295

GROUP BY sm.shipping_method_id, u.name

HAVING unique_name IS NOT NULL