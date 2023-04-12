 SELECT	
	sa.id AS "SA id"
,	IF(au.source_seller_id = 0
	,	au.username
	,	IF(ss.username= ' '
	,	ss.name,ss.username))  AS "Seller"

FROM saved_auctions sa
	
LEFT JOIN
	auction au ON au.saved_id = sa.id

LEFT JOIN
	source_seller ss ON ss.id = au.source_seller_id
WHERE au.end_time > "2017-12-31 23:59:59"
AND IF(au.source_seller_id = 0
	,	au.username
	,	IF(ss.username= ' '
	,	ss.name,ss.username)) != ' '
GROUP BY sa.id, IF(au.source_seller_id = 0
	,	au.username
	,	IF(ss.username= ' '
	,	ss.name,ss.username))



