-- Barcodes Wietzendorf
SELECT 
	bd.barcode AS Barcode
,	w.name AS 'Last Warehouse'
,	vb.ware_loc AS 'Warehouse Location'
,	w2.name AS 'Location Warehouse Name'

FROM vbarcode vb

JOIN barcode_dn bd ON bd.id = vb.id

LEFT JOIN warehouse w ON w.warehouse_id = bd.last_warehouse_id

LEFT JOIN ware_la wl ON wl.id = vb.ware_la_id

LEFT JOIN warehouse w2 ON w2.warehouse_id = wl.warehouse_id

WHERE 
vb.inactive = 0
AND bd.last_warehouse_id NOT IN (115, 134)
AND wl.warehouse_id IN (115, 134)
AND wl.id NOT IN (188, 189, 190, 743)


UNION ALL 

-- Barcodes Rajkowo
SELECT 
	bd.barcode AS Barcode
,	w.name AS 'Last Warehouse'
,	vb.ware_loc AS 'Warehouse Location'
,	w2.name AS 'Location Warehouse Name'

FROM vbarcode vb

JOIN barcode_dn bd ON bd.id = vb.id

LEFT JOIN warehouse w ON w.warehouse_id = bd.last_warehouse_id

LEFT JOIN ware_la wl ON wl.id = vb.ware_la_id

LEFT JOIN warehouse w2 ON w2.warehouse_id = wl.warehouse_id

WHERE 
vb.inactive = 0
AND bd.last_warehouse_id NOT IN (107, 132)
AND wl.warehouse_id IN (107, 132)
AND wl.id NOT IN (188, 189, 190, 743)

UNION ALL 

-- Barcodes Lager Däniken
SELECT 
	bd.barcode AS Barcode
,	w.name AS 'Last Warehouse'
,	vb.ware_loc AS 'Warehouse Location'
,	w2.name AS 'Location Warehouse Name'

FROM vbarcode vb

JOIN barcode_dn bd ON bd.id = vb.id

LEFT JOIN warehouse w ON w.warehouse_id = bd.last_warehouse_id

LEFT JOIN ware_la wl ON wl.id = vb.ware_la_id

LEFT JOIN warehouse w2 ON w2.warehouse_id = wl.warehouse_id

WHERE 
vb.inactive = 0
AND bd.last_warehouse_id NOT IN (116, 133)
AND wl.warehouse_id IN (116, 133)
AND wl.id NOT IN (188, 189, 190, 743)
