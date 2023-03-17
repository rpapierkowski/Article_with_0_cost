SELECT ss.name AS 'Source Seller'
,	IFNULL(mau.auction_number, au.auction_number) AS 'Main Auction Number'
,	au.auction_number AS 'Auction Number'
,	CONCAT(au.auction_number,'/',au.txnid) AS 'auction_number/txnid'
,	au.end_time AS 'Auction End Time'
,	sa.id AS 'SA ID'
, IFNULL(tr.value, '') AS 'Child Category'
, sa.username
, IFNULL(ROUND((IFNULL(ac.price_sold, 0) - IFNULL(ac.ebay_listing_fee, 0) - IFNULL(ac.additional_listing_fee, 0) - IFNULL(ac.ebay_commission, 0) - IFNULL(ac.vat, 0) - IF(au.resell,
		0,
		IFNULL(ac.purchase_price, 0)) + IF(a.admin_id = 4,
		IFNULL(i.total_shipping,
		IFNULL(ac.shipping_cost, 0)),
		0) - IFNULL(ac.effective_shipping_cost, 0) + IF(a.admin_id = 4,
		IFNULL(i.total_cod, IFNULL(ac.COD_cost, 0)) - IFNULL(ac.effective_COD_cost, 0),
		0) - IFNULL(ac.packing_cost, 0) / IFNULL(ac.curr_rate, 0) - IFNULL(ac.vat_shipping, 0) - IFNULL(ac.vat_COD, 0)) * ac.curr_rate,
		2),
		0) AS 'Brutto Income 2 (EUR)'
, IFNULL(ROUND(((ac.price_sold - ac.vat + (ac.shipping_cost - ac.vat_shipping) + (ac.COD_cost - ac.vat_COD) + IF(a.admin_id = 3,
		- IF(au.resell,
		0,
		IFNULL(ac.purchase_price, 0)),
		0)) * ac.curr_rate),
		2),
		0) AS 'Revenue (EUR)'
,	au.quantity
,	CONCAT('https://www.prologistics.info/auction.php?number=',IFNULL(mau.auction_number, au.auction_number),'&txnid=',IFNULL(mau.txnid, au.txnid)) AS 'URL'
FROM orders o

LEFT JOIN 
	auction au ON au.auction_number = o.auction_number
		AND au.txnid = o.txnid

LEFT JOIN 
	auction mau ON mau.auction_number = au.main_auction_number
		AND mau.txnid = au.main_txnid

JOIN 
	article a ON a.article_id = o.article_id
		AND a.admin_id = o.manual

LEFT JOIN 
	saved_auctions sa ON sa.id = au.saved_id

LEFT JOIN 
	auction_calcs ac ON ac.order_id = o.id

LEFT JOIN 
	invoice i ON i.invoice_number = au.invoice_number

LEFT JOIN
	saved_auctions msa ON msa.id = sa.master_sa

LEFT JOIN
	translation tr ON tr.id = IFNULL(sa.main_assigned_category,msa.main_assigned_category)
		AND tr.field_name_id = 8
		AND tr.table_name_id = 573
		AND tr.language = 'english'
		
LEFT JOIN 
	source_seller ss ON ss.id  = IFNULL(mau.source_seller_id, au.source_seller_id) 
	
LEFT JOIN 
	saved_auctions_price_comment sapc ON sa.id = sapc.saved_id 

LEFT JOIN 
		(
		SELECT a.auction_number
		,	a.main_auction_number
		,	a.saved_id
		,	a.txnid
		,	sapc.id
		,	(
			SELECT tl.new_value AS new_comment_id		
			FROM total_log tl 				
			WHERE tl.TableID = sapc.id
				AND table_name_id = 991
				AND field_name_id = 5949
				AND tl.updated <= a.end_time
			ORDER BY tl.updated DESC 
			LIMIT 1
			) comment_id
			
		FROM auction a
		LEFT JOIN saved_auctions_price_comment sapc ON sapc.saved_id = a.saved_id
		
		WHERE a.end_time > "2022-01-01 00:00:00"
			AND (
			SELECT 	tl.new_value AS new_comment_id
			FROM total_log tl 				
			WHERE tl.TableID = sapc.id
				AND table_name_id = 991
				AND field_name_id = 5949
				AND tl.updated <= a.end_time
			ORDER BY tl.updated DESC 
			LIMIT 1
			) = 10
		) xx
		ON xx.auction_number = au.auction_number
			AND		xx.txnid = au.txnid

WHERE au.end_time < "2023-01-01 00:00:00"
 	AND au.end_time >= "2021-01-01 00:00:00"
	AND ss.group = "shop"
	AND xx.comment_id IS NULL
	AND IFNULL(tr.value, '') != ''

GROUP BY au.auction_number, IFNULL(tr.value, ''), a.article_id
