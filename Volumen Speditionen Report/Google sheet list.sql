SELECT
sm.shipping_method_id AS 'Shiping Method ID'
, sm.company_name AS 'Shipping Method'
,	GROUP_CONCAT(u.name SEPARATOR ', ') AS 'Shipping Company'
, sm.country AS 'Shipping Metod Country'

FROM shipping_method sm 

LEFT JOIN  users u ON sm.shipping_method_id = u.shipping_method

WHERE sm.shipping_method_id IS NOT NULL


GROUP BY sm.shipping_method_id
