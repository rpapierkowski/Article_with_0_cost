-- Barcodes Wietzendorf
SELECT 
	bd.barcode AS Barcode
,	vb.ware_loc AS 'Warehouse location'
,	w.name AS 'Last Warehouse'

FROM vbarcode vb

JOIN barcode_dn bd ON bd.id = vb.id

LEFT JOIN warehouse w ON w.warehouse_id = bd.last_warehouse_id

WHERE 
LEFT(vb.ware_loc,1) = "W"
AND LEFT(vb.ware_loc,2) NOT IN ( "WW" , "Wa")
AND bd.last_warehouse_id NOT IN (115, 134)
AND vb.inactive = 0

UNION ALL

-- Barcodes Rajkowo
SELECT 
	bd.barcode AS Barcode
,	vb.ware_loc AS 'Warehouse location'
,	w.name AS 'Last Warehouse'

FROM vbarcode vb

JOIN barcode_dn bd ON bd.id = vb.id

LEFT JOIN warehouse w ON w.warehouse_id = bd.last_warehouse_id

WHERE 
LEFT(vb.ware_loc,2) = "R1"
AND bd.last_warehouse_id NOT IN (107, 132)
AND vb.inactive = 0

UNION ALL 

-- Barcodes Lager Däniken
SELECT 
	bd.barcode AS Barcode
,	vb.ware_loc AS 'Warehouse location'
,	w.name AS 'Last Warehouse'

FROM vbarcode vb

JOIN barcode_dn bd ON bd.id = vb.id

LEFT JOIN warehouse w ON w.warehouse_id = bd.last_warehouse_id

WHERE 
LEFT(vb.ware_loc,2) = "D1"
AND bd.last_warehouse_id NOT IN (116, 133)
AND vb.inactive = 0