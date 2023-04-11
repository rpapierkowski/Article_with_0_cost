SELECT  a.article_id
,	t.value AS 'Article Name'
,	IF(a.wpicture_URL = '',CONCAT("https://www.prologistics.info",a.picture_URL),CONCAT("https://www.prologistics.info",a.wpicture_URL)) AS "URL article pic"
,	CONCAT('https://www.prologistics.info/article.php?original_article_id=', a.article_id , 'order=name') AS 'URL Article'
, 	oc.name AS Supplier
,	a.group_id AS "Article Group ID"
,	(
	SELECT `prologis2`.`fget_Article_stock`
		( a.article_id,"0")
	) AS Stock
	
,	(
	SELECT `prologis2`.`fget_Article_Reserved`
		(a.article_id,"0")
	) AS Reserved
	
,	(
	SELECT CONCAT(TRIM(name), " ", TRIM(name2)) 'Name'
    FROM op_company_emp oce
    
    LEFT JOIN employee e 
    ON e.id = oce.emp_id
    
    WHERE
    oce.type = 'purch'
	and oce.emp_id > 0
	and oce.company_id = a.company_id
	AND e.inactive = 0
    
    order by oce.id desc
    LIMIT 1
    ) AS 'Product Manager'

FROM article a

LEFT JOIN translation t ON t.id = a.article_id
    AND t.field_name_id = 8
    AND t.table_name_id = 50
    AND t.language = 'english'

LEFT JOIN op_company oc ON oc.id = a.company_id

WHERE   a.admin_id=0 
   AND 	a.article_id<>0  
