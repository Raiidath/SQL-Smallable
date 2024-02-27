select
	toStartOfMonth(bsxd.ref_date) as Mois,
	count(DISTINCT product_id)
from
	smallable2_datawarehouse.b_skus_x_days bsxd
where
	bsxd.ref_date > '2021-01-01'
	and bsxd.ref_date < '2021-12-31'
group by
	Mois
	
	
select
	toStartOfMonth(bpxd.ref_date) as Mois,
	count(DISTINCT product_id)
from
	smallable2_datawarehouse.b_products_x_days bpxd 
where
	bpxd.ref_date > '2021-01-01'
	and bpxd.ref_date < '2021-12-31'
group by
	Mois

	
select * from smallable2_datawarehouse.b_products_x_days bpxd 		


select
	bp.persons as persons,
	count(bp.persons)
from
	smallable2_datawarehouse.b_stocks bs
INNER JOIN smallable2_datawarehouse.b_skus bs2
on
	bs2.sku_id = bs.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
where
	bs.ref_date > '2021-01-01'
	and bs.ref_date < '2021-12-31'
	and bs.quantity_type_id = '1'
	and bp.sml_team = 'mode'
group by
	persons	
	
