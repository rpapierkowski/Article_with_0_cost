SELECT afcv.article_id AS 'Article ID'
,	sf.name AS 'Tag Group'
,	sc.name AS 'Tag'
,	t.value AS 'Subtag'
FROM article_field_content_value afcv


LEFT JOIN sa_field_content_value_sa sfcvs ON sfcvs.id = afcv.field_content_value_id
LEFT JOIN sa_field sf ON sf.id = sfcvs.field_id
LEFT JOIN sa_content sc ON sc.id = sfcvs.content_id
LEFT JOIN `translation` t ON sfcvs.value_id = t.id
			AND t.language = 'english'
			AND t.field_name_id = 58
			AND t.table_name_id = 446
WHERE 
sfcvs.field_id = 758
