 SELECT	
	sa.id AS "SA id"
, 	IFNULL(tr.value, '') AS "Child Category"
,	IFNULL(tra.value, '') AS "Room"
,	IFNULL(tran.value, '') AS "Parent Category"
,	(SELECT  name 
	FROM translation 
	JOIN offer_name ON offer_name.id = translation.value
	WHERE field_name_id=1678 
		AND table_name_id=411 
		AND translation.id=IFNULL(sa.master_sa, sa.id) 
	ORDER BY FIELD(language,"german","english")DESC LIMIT 1) AS "SA Article Name"
,	s_par.par_value AS "SA name"
,	sa_type.title AS "SA type"
,	IF(sa.available=1,"Yes","No") Available
,	IF(sa.inactive = 1, 'No','Yes') AS Active
,	s_param.par_value as "Total carton number"
,	IF(s_pic.doc_id IS NULL,' ',CONCAT("https://pictureserver.net/images/pic/5e/2b/undef_src_sa_picid_",s_pic.doc_id,"_type_whitesh_image.jpg?ver=21")) AS "Master SA image"
,	IFNULL(sa.master_sa, sa.id) AS "Master SA ID"
,	CONCAT("https://www.prologistics.info/react/condensed/condensed_sa/",IFNULL(sa.master_sa, sa.id),"/") AS "URL Master SA"
,	sa.available_date
,	opc.ptd
,	opc.eda
,	opc.edd

,	(
		SELECT name 
		FROM translation 
		JOIN offer_name ON offer_name.id = translation.value
		WHERE field_name_id=1678 
			AND table_name_id=411 
			AND translation.id=IFNULL(sa.master_sa, sa.id) 
		ORDER BY FIELD(language,"german","english")DESC LIMIT 1
	) AS "Master SA name"
		
,	(
		SELECT transl.value 
		FROM  prologis2.saved_params p
		JOIN sa_field_content_value_sa s ON s.id = p.par_value 
			AND s.field_id=397 
			AND s.content_id=4
		JOIN translation  transl ON  transl.id =  s.value_id
			AND transl.field_name_id = 58
			AND transl.table_name_id = 446
			AND transl.language = 'english'
		WHERE saved_id = IFNULL(msa.id,sa.id)
			AND p.par_key = 'sa_description[]' 
		ORDER BY s.id LIMIT 1 
	) AS "Material"
    
,	(
		SELECT transl.value 
		FROM  prologis2.saved_params p
		JOIN sa_field_content_value_sa s ON s.id = p.par_value 
			AND s.field_id=533 
			AND s.content_id=316
		JOIN translation  transl ON  transl.id =  s.value_id
			AND transl.field_name_id = 58
			AND transl.table_name_id = 446
			AND transl.language = 'english'
		WHERE saved_id = IFNULL(msa.id,sa.id)  
			AND p.par_key = 'sa_description[]' 
		ORDER BY s.id LIMIT 1 
	) AS "Color"
	

FROM saved_auctions sa
	
LEFT JOIN saved_auctions msa ON msa.id = sa.master_sa

    LEFT JOIN
saved_auctions uksa ON uksa.master_sa = sa.master_sa AND uksa.username="Beliani UK"

LEFT JOIN
saved_auctions desa ON desa.master_sa = sa.master_sa AND desa.username="Beliani DE"

LEFT JOIN
saved_auctions frsa ON frsa.master_sa = sa.master_sa AND frsa.username="Beliani FR"
    
LEFT JOIN
    shop_catalogue sp ON sp.id = IF(sa.username="Design_UK",uksa.main_assigned_category,
	IF(sa.username="Schoenteakmoebel",desa.main_assigned_category,
		IF(sa.username="FR_Design",frsa.main_assigned_category, IFNULL(sa.main_assigned_category,msa.main_assigned_category))))
        
LEFT JOIN
    translation tr ON tr.id = IF(sa.username="Design_UK",uksa.main_assigned_category,
	IF(sa.username="Schoenteakmoebel",desa.main_assigned_category,
		IF(sa.username="FR_Design",frsa.main_assigned_category,IFNULL(sa.main_assigned_category,msa.main_assigned_category))))
			AND tr.field_name_id = 8
			AND tr.table_name_id = 573
			AND tr.language = 'english'

LEFT JOIN
    translation tra ON tra.id = IF(sa.username="Design_UK",uksa.main_assigned_group,
	IF(sa.username="Schoenteakmoebel",desa.main_assigned_group,
		IF(sa.username="FR_Design",frsa.main_assigned_group,IFNULL(sa.main_assigned_group,msa.main_assigned_group))))
			AND tra.field_name_id = 8
			AND tra.table_name_id = 573
			AND tra.language = 'english'
            
LEFT JOIN
    translation  tran ON  tran.id =  sp.parent_id
			AND tran.field_name_id = 8
			AND tran.table_name_id = 573
			AND tran.language = 'english'

LEFT JOIN saved_params s_par ON s_par.saved_id=IFNULL(msa.id,sa.id)
	AND s_par.par_key="article_name"
	
LEFT JOIN saved_params s_params ON s_params.saved_id=IFNULL(msa.id,sa.id)
	AND s_params.par_key="sa_type"

LEFT JOIN sa_type ON sa_type.id=s_params.par_value	

LEFT JOIN saved_params s_param ON s_param.saved_id=IFNULL(msa.id,sa.id)
	AND s_param.par_key="total_carton_number"

LEFT JOIN saved_pic s_pic ON s_pic.saved_id=IFNULL(msa.id,sa.id)
	AND s_pic.ordering=1	

LEFT JOIN op_order_container opc ON opc.id=sa.available_container_id

GROUP BY sa.id