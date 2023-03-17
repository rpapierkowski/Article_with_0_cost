-- https://www.prologistics.info/react/logs/issue_logs/183026/
SELECT ai1.article_id
,	ai1.import_date
,	ai1.country_code
,	ai1.purchase_price
,	CONCAT('https://www.prologistics.info/article.php?original_article_id=',ai1.article_id) AS "Article URL"
		
FROM article_import ai1 

LEFT JOIN article_list al ON ai1.article_id = al.article_id 

LEFT JOIN offer_group og ON al.group_id = og.offer_group_id

LEFT JOIN offer of ON og.offer_id = of.offer_id

LEFT JOIN saved_auctions sa ON of.offer_id = sa.offer_id

WHERE sa.inactive = 0 and
	 ai1.import_date =	(	SELECT Max(ai2.import_date)
								FROM article_import ai2 
								WHERE ai1.article_id = ai2.article_id
								LIMIT 1)
	AND ai1.country_code = "DE"
	AND ai1.import_date > "2022-09-01 00:00:00"
GROUP BY ai1.article_id
HAVING ai1.purchase_price = 0
ORDER BY import_date desc