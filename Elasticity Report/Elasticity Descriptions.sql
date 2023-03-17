 SELECT
	sa.id AS "SA ID"
,	IFNULL(sa.master_sa, sa.id) AS "Master SA ID"
,   IFNULL(tr.value, '') AS "Child Category"
,	IFNULL(tra.value, '') AS "Room"
,	IFNULL(tran.value, '') AS "Parent Category"
,    s_par.par_value AS "SA Name"
,    s_param.par_value AS "Total Carton Number"
,    sa_type.title AS "SA Type"
,	sa.inactive
,	sa.available
,	sa.available_date
,	sa.available_weeks
,		IFNULL( IF(IF(au.source_seller_id = 0,mau.source_seller_id,au.source_seller_id) = 0,seller_information.country
,		IF(source_seller.calc_country_code = ''
,		IF(seller_information.defshcountry = ''
,		seller_information.country
,		seller_information.defshcountry)
,		source_seller.calc_country_code)),' ' ) AS "Country"
,	sa.ShopPrice AS "Shop Price"
,	IFNULL(ssp.cost_eur, ' ') AS "Real Shipping Cost (EUR)"
,	sa.margin_perc/100 AS "Margin %"
, 	CONCAT('https://www.prologistics.info/react/condensed/condensed_sa/',IFNULL(sa.master_sa, sa.id)) AS "Master SA URL"
,	CONCAT('https://pictureserver.net/images/pic/24/8d/undef_src_sa_picid_',pix.doc_id,'_type_whitenosh_image.png') AS "Foto"
,	CONCAT('https://www.prologistics.info/react/condensed/condensed_sa/',IFNULL(sa.master_sa, sa.id),'/slave/',sa.id,'/shop/Beliani%20'
,		IFNULL( IF(IF(au.source_seller_id = 0,mau.source_seller_id,au.source_seller_id) = 0,seller_information.country
,		IF(source_seller.calc_country_code = ''
,		IF(seller_information.defshcountry = ''
,		seller_information.country
,		seller_information.defshcountry)
,		source_seller.calc_country_code)),' ' ),'/beliani.'
															,IFNULL( IF(IF(au.source_seller_id = 0,mau.source_seller_id,au.source_seller_id) = 0,seller_information.country
															,		IF(source_seller.calc_country_code = ''
															,		IF(seller_information.defshcountry = ''
															,		seller_information.country
															,		seller_information.defshcountry)
															,		source_seller.calc_country_code)),' ' )) AS "SA URL"



FROM saved_auctions sa
	
	LEFT JOIN
		saved_auctions msa ON msa.id = sa.master_sa
    
	LEFT JOIN
		shop_catalogue sp ON sp.id = IFNULL(sa.main_assigned_category,msa.main_assigned_category)
        
	LEFT JOIN
		translation tr ON tr.id = IFNULL(sa.main_assigned_category,msa.main_assigned_category)
			AND tr.field_name_id = 8
			AND tr.table_name_id = 573
			AND tr.language = 'english'

    LEFT JOIN
		translation tra ON tra.id = IFNULL(sa.main_assigned_group,msa.main_assigned_group)
			AND tra.field_name_id = 8
			AND tra.table_name_id = 573
			AND tra.language = 'english'
            
	LEFT JOIN
		translation  tran ON  tran.id = sp.parent_id
			AND tran.field_name_id = 8
			AND tran.table_name_id = 573
			AND tran.language = 'english'
            
	LEFT JOIN 
		saved_params s_par ON s_par.saved_id = IFNULL(msa.id,sa.id)
			AND s_par.par_key="article_name"
    
	LEFT JOIN 
		saved_params s_param ON s_param.saved_id = IFNULL(msa.id,sa.id)
			AND s_param.par_key="total_carton_number"
    
	LEFT JOIN 
		saved_params s_params ON s_params.saved_id = IFNULL(msa.id,sa.id)
			AND s_params.par_key = "sa_type"
    
	LEFT JOIN
		sa_type ON sa_type.id = s_params.par_value
    /*
	LEFT JOIN
		saved_pic s_pic ON s_pic.saved_id=IFNULL(msa.id,sa.id) AND s_pic.ordering=1
    */
	LEFT JOIN  
		op_order_container opc ON opc.id=sa.available_container_id
	
	LEFT JOIN
		auction au ON au.saved_id = sa.id

    LEFT JOIN
		auction mau ON (mau.auction_number = au.main_auction_number
        AND mau.txnid = au.main_txnid)		
				
	LEFT JOIN
		source_seller ON source_seller.id = au.source_seller_id
	
    LEFT JOIN 
		seller_information ON au.username = seller_information.username
		
	LEFT JOIN 
		sa_shipping_price ssp ON ssp.sa_id = sa.id
			 	
	-- FOTO 	
	LEFT JOIN
 		(SELECT pic.doc_id, pic.saved_id, pic.primary
		FROM saved_pic pic
		
		 	INNER JOIN 
		 		(SELECT pic.doc_id AS doc_id 
	 			FROM saved_pic pic
	 			GROUP BY saved_id) AS table_auxy 
		 		ON pic.doc_id = table_auxy.doc_id)  AS pix
		 			ON pix.saved_id = msa.id
		 			
GROUP BY sa.id
