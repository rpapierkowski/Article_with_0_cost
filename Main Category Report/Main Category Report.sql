 SELECT
	sa.id AS "SA ID"
,	IFNULL(sa.master_sa, sa.id) AS "Master SA ID"
,   IFNULL(tr.value, '') AS "Child Category"
,	IFNULL(sa.main_assigned_category,msa.main_assigned_category) AS "Child Category ID"
,	IFNULL(tra.value, '') AS "Room"
,	IFNULL(sa.main_assigned_group,msa.main_assigned_group) AS "Room ID"
,	IFNULL(tran.value, '') AS "Parent Category"
,	sp.parent_id AS "Parent Category ID"
,		IFNULL( IF(IF(au.source_seller_id = 0,mau.source_seller_id,au.source_seller_id) = 0,seller_information.country
,		IF(source_seller.calc_country_code = ''
,		IF(seller_information.defshcountry = ''
,		seller_information.country
,		seller_information.defshcountry)
,		source_seller.calc_country_code)),' ' ) AS "Country"
,	sa.inactive AS "Inactive"
, 	CONCAT('https://www.prologistics.info/react/condensed/condensed_sa/',IFNULL(sa.master_sa, sa.id)) AS "LINK"

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
		saved_params s_params ON s_params.saved_id = IFNULL(msa.id,sa.id)
			AND s_params.par_key = "sa_type"
    
	LEFT JOIN
		sa_type ON sa_type.id = s_params.par_value
	
	LEFT JOIN
		auction au ON au.saved_id = sa.id

    LEFT JOIN
		auction mau ON (mau.auction_number = au.main_auction_number
        AND mau.txnid = au.main_txnid)		
				
	LEFT JOIN
		source_seller ON source_seller.id = au.source_seller_id
	
    LEFT JOIN 
		seller_information ON au.username = seller_information.username
		
WHERE sa.main_assigned_category not in (	1704
,	1708
,	1709
,	1710
,	1871
,	1872
,	1873
,	2301
,	2307
,	2308
,	2310
,	2311
,	2316
,	2317
,	2323
,	2324
,	2326
,	2328
,	2329
,	2330
,	2331
,	2335
,	2336
,	2337
,	2339
,	2340
,	2341
,	2344
,	2345
,	2354
,	2356
,	2366
,	2372
,	2385
,	2388
,	2389
,	2390
,	2391
,	2392
,	2394
,	2396
,	2398
,	2399
,	2405
,	2407
,	2408
,	2412
,	2414
,	2416
,	2417
,	2418
,	2420
,	2422
,	2423
,	2429
,	2432
,	2435
,	2441
,	2452
,	2453
,	2454
,	2459
,	2496
,	2497
,	2498
,	2499
,	2511
,	2516
,	2517
,	2520
,	2521
,	2539
,	2542
,	2543
,	2544
,	2545
,	2549
,	2552
,	2567
,	2581
,	2602
,	2606
,	2607
,	2616
,	2635
,	2636
,	2637
,	2640
,	2646
,	2647
,	2687
,	2688
,	2689
,	2697
,	2718
,	2723
,	2724
,	2725
,	2727
,	2728
,	2729
,	2732
,	2733
,	2736
,	2746
,	2747
,	2751
,	2752
,	2757
,	2769
,	2775
,	2795
,	2800
,	2805
,	2816
,	2817
,	2905
,	2907
,	2909
,	2910
,	2913
,	2926
,	2927
,	2928
,	2934
,	2938
,	2974
,	2989
,	2990
,	2992
,	2997
,	3001
,	3020
,	3021
,	3031
,	3048
,	3049
,	3062
,	3080
,	3088
,	3089
,	3090
,	3092
,	3094
,	3095
,	3096
,	3106
,	3114
,	3121
,	3134
,	3135
,	3142
,	3144
,	3154
,	3155
,	3156
,	3157
,	3166
,	3179
,	3188
,	3195
,	3216
,	3292
,	3295
,	3296
,	3320
,	3321
,	3322
,	3323
,	3324
,	3325
,	3326
,	3327
,	3328
,	3330
,	3331
,	3332
,	3350
,	3356
,	3363
,	3365
,	3366
,	3377
,	3378
,	3383
,	3397
,	3398
,	3399
,	3400
,	3430
,	3434
,	3435
,	3442
)


GROUP BY sa.id
