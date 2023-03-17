SELECT o.auction_number
,	o.shipping_username AS 'Shipping Company Name'
,	sm.company_name AS 'Shipping Method' 
,	tn.auction_number AS 'Main Action Number'
,	tn.date_time AS 'Tracking Number Date'
,	tn.number AS 'Tracking Number'
,	auc_pv.value AS 'Destination country'
,	tn.shipping_method AS 'Shipping Method ID' 
,	ac.effective_shipping_cost AS 'Effective Shipping Cost'


FROM orders o 

LEFT JOIN auction a ON a.auction_number = o.auction_number
	AND a.txnid = o.txnid 
	
LEFT JOIN tn_orders tor ON tor.order_id = o.id

LEFT JOIN tracking_numbers tn ON tn.id = tor.tn_id

LEFT JOIN users u ON u.username = o.shipping_username

LEFT JOIN auction_par_varchar auc_pv ON a.auction_number = auc_pv.auction_number
	AND a.txnid = auc_pv.txnid 
	AND auc_pv.key = 'country_shipping'
	
LEFT JOIN auction_calcs ac ON ac.order_id = o.id

LEFT JOIN shipping_method sm ON sm.shipping_method_id = tn.shipping_method

WHERE o.shipping_username IS NOT NULL
	AND tn.number  IS NOT NULL 
	AND o.sent != 0 
	AND tn.date_time >= "2021-01-01 00:00:00" 
	AND o.shipping_username != 'Employee Order'
-- 	AND a.auction_number in (6549821, 6549822 , 65498223, 6549824, 6549825, 6549826)

GROUP BY tn.number
