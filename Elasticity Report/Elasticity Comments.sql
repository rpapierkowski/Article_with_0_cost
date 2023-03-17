SELECT sa.id AS "SA ID"
,	IFNULL(com.Comment, ' ') AS "Comment"

FROM saved_auctions sa 

LEFT JOIN
(
SELECT sapc.Saved_id AS "sa"
,	spc.Comment AS "Comment"
FROM
	saved_auctions_price_comment sapc

LEFT JOIN
	saved_price_comment spc ON spc.id = sapc.comment_id
	
WHERE spc.Comment is not null
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
,	57
)

GROUP BY sapc.Saved_id,	spc.Comment ) com 
									ON sa.id = com.sa