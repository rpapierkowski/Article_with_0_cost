SELECT rate_month 
,	curr_code 
,	value 
FROM rate_average
WHERE  curr_code  = "EUR"
order by rate_month DESC 