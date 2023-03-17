SELECT CONCAT(au.auction_number,'/',au.txnid) AS 'auction_number/txnid'
,	IFNULL( IF(IF(au.source_seller_id = 0,mau.source_seller_id,au.source_seller_id) = 0,seller_information.country
,		IF(ss.calc_country_code = ''
,		IF(seller_information.defshcountry = ''
,		seller_information.country
,		seller_information.defshcountry)
,		ss.calc_country_code)),IFNULL(auc_pv.value, auc_pv1.value) ) AS 'Country'

FROM auction au 
LEFT JOIN 
	auction mau ON mau.auction_number = au.main_auction_number
		AND mau.txnid = au.main_txnid

LEFT JOIN 
	source_seller ss ON ss.id  = IFNULL(mau.source_seller_id, au.source_seller_id) 

LEFT JOIN auction_par_varchar auc_pv ON au.auction_number = auc_pv.auction_number
	AND au.txnid = auc_pv.txnid 
	AND auc_pv.key = 'country_shipping'
	
LEFT JOIN auction_par_varchar auc_pv1 ON au.auction_number = auc_pv1.auction_number
	AND au.txnid = auc_pv1.txnid 
	AND auc_pv.key = 'country_invoice'

LEFT JOIN 
	seller_information ON au.username = seller_information.username
	
WHERE au.end_time < "2023-01-01 00:00:00"
 	AND au.end_time >= "2021-01-01 00:00:00"
 	
GROUP BY au.auction_number