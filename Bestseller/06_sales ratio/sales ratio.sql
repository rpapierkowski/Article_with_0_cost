SELECT	
	CONCAT(au.auction_number, "/", au.txnid) AS "Auftrag number / txnid"
,	au.auction_number AS "Auftrag number"
,	au.saved_id AS "SA id"
,	au.end_time AS "Auftrag end time"
,	o.article_id AS "Article id"
,	au.main_auction_number AS "Main auftrag"
,	ac.purchase_price AS 'Purchase price'
,	o.quantity AS "Total no of articles"
,	IF(au.deleted=1 and a_del.name is null,'other reason',a_del.name) as 'Delete reason'
,	CONCAT("https://www.prologistics.info/auction.php?number=", au.main_auction_number,"&txnid=",au.txnid) AS "URL Main auftrag"
,	IF(au.source_seller_id = 0
	,	au.username
	,	IF(ss.username= ' '
	,	ss.name,ss.username)) AS "Seller"
	, a.group_id
,	IF(au.source_seller_id=0
	,	si.seller_name
	,	ss.name) AS "Source seller"


,	IF(
		IF(au.source_seller_id = 0
		,	mau.source_seller_id
		,	au.source_seller_id) = 0
	,	si.country
	,	IF(ss.calc_country_code = ''
		,	IF(si.defshcountry = ''
			,	si.country
			,	si.defshcountry)
		,	ss.calc_country_code)) AS "Calculation Country"

,	IFNULL(ROUND((IFNULL(ac.price_sold, 0) 
		- IFNULL(ac.ebay_listing_fee, 0) 
		- IFNULL(ac.additional_listing_fee, 0) 
		- IFNULL(ac.ebay_commission, 0) 
		- IFNULL(ac.vat, 0) 
		- IF(au.resell,0, IFNULL(ac.purchase_price, 0)) 
		+ IF(a.admin_id = 4, IFNULL(i.total_shipping, IFNULL(ac.shipping_cost, 0)),0) 
		- IFNULL(ac.effective_shipping_cost, 0) 
		+ IF(a.admin_id = 4, IFNULL(i.total_cod, IFNULL(ac.COD_cost, 0)) 
		- IFNULL(ac.effective_COD_cost, 0), 0) 
		- IFNULL(ac.packing_cost, 0) 
		/ IFNULL(ac.curr_rate, 0) - IFNULL(ac.vat_shipping, 0) 
		- IFNULL(ac.vat_COD, 0)) 
		* ac.curr_rate, 2),  0) AS "Brutto Income (EUR)"
		
,	IFNULL(ROUND(((ac.price_sold 
		- ac.vat 
		+ (ac.shipping_cost 
		- ac.vat_shipping) 
		+ (ac.COD_cost - ac.vat_COD) 
		+ IF(a.admin_id = 3,
		- IF(au.resell, 0, IFNULL(ac.purchase_price, 0)), 0)) 
		* ac.curr_rate), 2), 0) AS "Revenue (EUR)"

,        CONCAT('https://www.prologistics.info/react/condensed/condensed_sa/',IFNULL(sa.master_sa, sa.id),'/slave/',sa.id,'/shop/Beliani%20'
        ,                IFNULL( IF(IF(au.source_seller_id = 0,mau.source_seller_id,au.source_seller_id) = 0,si.country
        ,                IF(ss.calc_country_code = ''
        ,                IF(si.defshcountry = ''
        ,                si.country
        ,                si.defshcountry)
        ,                ss.calc_country_code)),'' ),'/beliani.'
        , IFNULL( IF(IF(au.source_seller_id = 0,mau.source_seller_id,au.source_seller_id) = 0,si.country
        ,                IF(ss.calc_country_code = ''
        ,                IF(si.defshcountry = ''
        ,                si.country
        ,                si.defshcountry)
        ,                ss.calc_country_code)),' ' )) AS 'SA URL'
        

        
FROM orders o

JOIN auction au ON (au.auction_number=o.auction_number
AND au.txnid=o.txnid)

LEFT JOIN
auction_calcs ac ON o.id = ac.order_id

LEFT JOIN
saved_auctions sa ON au.saved_id = sa.id
    
LEFT JOIN
invoice i ON i.invoice_number = au.invoice_number

JOIN
article a ON a.article_id = o.article_id

LEFT JOIN
auction mau ON (mau.auction_number = au.main_auction_number
    AND mau.txnid = au.main_txnid)
    
LEFT JOIN
source_seller ss ON ss.id = IFNULL(mau.source_seller_id,au.source_seller_id)

LEFT JOIN 
seller_information si ON au.username = si.username

LEFT JOIN
    auction_delete_reason a_del
    ON au.delete_reason_id=a_del.id

WHERE au.end_time > "2017-12-31 23:59:59"
	AND IF(mau.rma_id IS NULL, au.rma_id,mau.rma_id) = 0 
	AND a.admin_id = 0
	AND o.manual = 0 
		
GROUP BY o.id