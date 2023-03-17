SELECT
	concat(au.auction_number, "/", au.txnid) AS "Auftrag Number / txnid"
,	au.auction_number AS "Auftrag Number"
,	au.txnid
,	au.saved_id AS "SA Id"
,	au.end_time AS "Auftrag End Time"
,	o.article_id AS "Article Id"
,	sa.master_sa AS "Master SA Id"
,	au.offer_id AS "Offer Id"
,	mau.source_seller_id
,	IF(au.source_seller_id = 0,au.username
,	IF(source_seller.username= ' ', source_seller.name,source_seller.username)) AS "Seller"
,	IF(au.source_seller_id = 0, seller_information.seller_name, source_seller.name) AS "Source Seller"
,	IF(IF(au.source_seller_id = 0,mau.source_seller_id,au.source_seller_id) = 0,seller_information.country
,	IF(source_seller.calc_country_code = ''
,	IF(seller_information.defshcountry = ''
,	seller_information.country
,	seller_information.defshcountry)
,	source_seller.calc_country_code)) AS "Country"
,	au.main_auction_number AS "Main Auftrag"
,	IF(IFNULL(au.code_id,mau.code_id) > 0, 'TRUE' , 'FALSE') AS "Voucher Used"
,	IFNULL(au.code_id,mau.code_id) AS "Voucher Code"
,   vc.name AS "Voucher Name"
,	au.deleted
,	IF(au.deleted = 1 AND a_del.name is null,'other reason',a_del.name) AS "Delete Reason"
,	o.quantity AS "Total # Of Articles"
,	au.quantity AS "Quantity Auftrag"
,	sa.inactive
,	au.available
,	ac.curr_code AS "Currency"
,	ac.curr_rate AS "Currency/EUR Rate"
,	ac.purchase_price AS "Purchase Price"
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
,	IFNULL(effective_shipping_cost,0) AS "Effective Shipping Cost"
,	IFNULL(Marg.Margin, sa.margin_perc/100) AS "Shop Margin"
,	IFNULL(Pric.New_Price,sa.ShopPrice) AS "Shop Price"
,	IFNULL(Shi.Real_Shipping_Cost, ssp.cost_eur) AS "Real Shipping Cost (EUR)"
,	IFNULL(IFNULL(Comm.Comment, spc.comment),' ') AS "Comment"
,	oc.name AS "Supplier"
            
 FROM orders o
        
	JOIN 
		auction au ON (au.auction_number=o.auction_number
		AND au.txnid=o.txnid)
        
	LEFT JOIN
		auction_calcs ac ON o.id = ac.order_id
        
	LEFT JOIN
		invoice i ON i.invoice_number = au.invoice_number
    
	JOIN
		article a ON a.article_id = o.article_id
		
	LEFT JOIN
		op_company oc  ON oc.id = a.company_id

	LEFT JOIN
		offer ON au.offer_id = offer.offer_id
		
	LEFT JOIN
		saved_auctions sa ON au.saved_id = sa.id
    
    LEFT JOIN
		saved_auctions msa ON msa.id = sa.master_sa

    LEFT JOIN
		auction mau ON (mau.auction_number = au.main_auction_number
        AND mau.txnid = au.main_txnid)
        
	LEFT JOIN
		source_seller ON source_seller.id = IFNULL(mau.source_seller_id,au.source_seller_id)
    
    LEFT JOIN 
		seller_information ON au.username = seller_information.username
    
    LEFT JOIN
        auction_delete_reason a_del
        ON au.delete_reason_id = a_del.id
        
	LEFT JOIN 
		shop_promo_codes vc ON vc.id = IFNULL(au.code_id,mau.code_id)
		
	LEFT JOIN 
		sa_shipping_price ssp ON au.saved_id = ssp.sa_id
    
    LEFT JOIN 
			(
					SELECT 	tl.New_value/100 AS "Margin"
			,		IFNULL(tl.username_id,'SYS') AS "Username"
			,		tl.Updated 
			,		tl.TableID AS "Sa Id"
			, a.auction_number
			, a.txnid
			, MIN(IF(a.end_time-tl.Updated < 0, NULL, a.end_time-tl.Updated)) Diff2

					FROM total_log tl 


					LEFT JOIN 
						auction a ON a.saved_id = tl.TableID 

					WHERE 	tl.table_name_id = 495
							AND tl.field_name_id = 6018
							AND IF(a.end_time-tl.Updated < 0, NULL, a.end_time-tl.Updated) > 0
							AND a.end_time >= "2022-11-28 00:00:00"
					GROUP  by a.auction_number
					ORDER by a.end_time DESC
					) Marg	
		ON    Marg.auction_number = au.auction_number
		AND Marg.txnid = au.txnid
		
	LEFT JOIN 
		(
				SELECT 	tl1.TableID AS "Sa Id"
		,		tl1.Old_value AS "Old_Price"
		,		tl1.New_value AS "New_Price"
		,		tl1.Updated
		,		Date(tl1.Updated) AS "Update Date"
		,		Time(tl1.updated) AS "Update Time"
		, 		a.auction_number
		,		a.txnid
		, a.end_time
		, 		Min(IF(a.end_time-tl1.Updated < 0, NULL, a.end_time-tl1.Updated)) Diff2

				FROM total_log tl1

				LEFT JOIN auction a ON a.saved_id = tl1.TableID 

				WHERE 	tl1.table_name_id = 495
						AND tl1.field_name_id = 1677
						AND IF(a.end_time-tl1.Updated<0, NULL, a.end_time-tl1.Updated) > 0
						AND a.end_time >= "2022-11-28 00:00:00"
						
				GROUP BY a.auction_number
				ORDER BY a.end_time DESC
				) Pric
		
		ON		Pric.auction_number = au.auction_number
		AND		Pric.txnid = au.txnid
				
	LEFT JOIN 
		(
				SELECT		tl3.New_value AS "Real_Shipping_Cost"
					,		tl3.Updated AS "Shipping Updated "
					, 		a.auction_number
					,		a.txnid
					, 		a.end_time
					, 		Min(IF(a.end_time-tl3.Updated<0, NULL, a.end_time-tl3.Updated)) Diff

				FROM total_log tl3

				LEFT JOIN sa_shipping_price ssp on ssp.id = tl3.TableID

				LEFT JOIN auction a ON a.saved_id = ssp.sa_id
					
				WHERE 	tl3.table_name_id = 1020
						AND tl3.field_name_id = 603
						AND IF(a.end_time-tl3.Updated<0, NULL, a.end_time-tl3.Updated) > 0
						AND a.end_time >= "2022-11-28 00:00:00"
								
				GROUP BY a.auction_number
				ORDER BY a.end_time DESC
		) Shi
		
		ON		Shi.auction_number = au.auction_number
		AND		Shi.txnid = au.txnid
		
		LEFT JOIN 
		(
				SELECT		sapc.saved_id 
					,		tl4.new_value
					,		tl4.updated
					,		IFNULL(spc.comment,' ') AS "Comment"
					, 		a.auction_number
					,		a.txnid
					, 		a.end_time
					, 		Min(IF(a.end_time-tl4.Updated < 0, NULL, a.end_time-tl4.Updated)) Diff

				FROM total_log tl4

				LEFT JOIN 
					saved_auctions_price_comment sapc ON tl4.TableID  = sapc.id
					
				LEFT JOIN 
					saved_price_comment spc ON sapc.comment_id = spc.id
					
				LEFT JOIN 
					auction a ON a.saved_id = sapc.saved_id
					
				WHERE 	tl4.table_name_id = 991
						AND tl4.field_name_id = 5949
						AND IF(a.end_time-tl4.Updated < 0, NULL, a.end_time-tl4.Updated) > 0
						AND a.end_time >= "2022-11-28 00:00:00"
						AND sapc.comment_id in (
												1
											,	3
											,	5
											,	6
											,	9
											,	10
											,	42
											,	43
											,	44
											,	45
											,	50
											,	51
											,	52
											,	53
											,	54
											,	55
											,	56
											,	57)
								
				GROUP BY a.auction_number
				ORDER BY a.end_time DESC
		) Comm
		
		ON		Comm.auction_number = au.auction_number
		AND		Comm.txnid = au.txnid
	
	LEFT JOIN 
	 	saved_auctions_price_comment sapc ON sapc.saved_id = sa.id
	 	
	LEFT JOIN 
	 	saved_price_comment spc ON sapc.comment_id = spc.id
	 	
    
WHERE au.end_time >= "2022-11-29 00:00:00"
	AND IF(mau.rma_id IS NULL, au.rma_id,mau.rma_id) = 0 
	AND a.admin_id = 0
	AND o.manual = 0
        
GROUP BY o.id