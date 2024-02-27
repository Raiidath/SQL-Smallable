with b as (
select
	min(bo.invoiced_at) as date,
	bb.brand_id as bid,
	bb.brand_name as name
from
	smallable2_datawarehouse.b_brands bb
inner join smallable2_datawarehouse.b_products bp 
on
	bp.brand_id = bb.brand_id
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.product_id = bp.product_id
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.is_valid = 1
	and bo.is_ca_net_ht_not_zero = 1
where
	bo.invoiced_at >= '2021-02-22'
	and bo.invoiced_at <= '2023-02-22'
group by
	name,
	bid
order by
	date desc)
select
	--distinct b.name,
	toStartOfMonth(bo2.created_at) as mois,
	case
		when b.date <= bo2.invoiced_at
		and bo2.invoiced_at < date_add(MONTH,
		6,
		toDate(b.date)) then 'new brand'
		when bo2.invoiced_at >= date_add(MONTH,
		6,
		toDate(b.date)) then 'old brand'
	end as type_brand,
	sum(bop.billing_product_ht / 100) as ca
from smallable2_datawarehouse.b_orders bo2 
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo2.order_id
	and bo2.is_valid = 1
	and bo2.is_ca_net_ht_not_zero = 1
	and bo2.invoiced_at >= '2021-02-22'
	and bo2.invoiced_at <= '2023-02-22'
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join b
on b.name = bp.brand_name 
group by
	--b.name,
 mois,
	type_brand
--order by b.name asc


select sum(bo.billing_product_ht / 100) as ca
from smallable2_datawarehouse.b_orders bo 
where
	bo.invoiced_at >= '2021-02-22'
	and bo.invoiced_at <= '2023-02-22'
	and bo.is_valid = 1
	and bo.is_ca_net_ht_not_zero = 1
	
	
	
SELECT date_add(MONTH, 6, toDate(b.date))

	
	
with brand as (	
select min(bo.invoiced_at) as date, bb.brand_id as bid, bb.brand_name as name  
from smallable2_datawarehouse.b_brands bb 
inner join smallable2_datawarehouse.b_products bp 
on bp.brand_id  = bb.brand_id  
inner join smallable2_datawarehouse.b_order_products bop 
on bop.product_id = bp.product_id 
inner join smallable2_datawarehouse.b_orders bo
on bo.order_id = bop.order_id 
group by name, bid
order by date desc)



SELECT
	CASE
		WHEN bb.first_saison_integration_marque = 'PE23' then 'Nouvelles marques' else 'Anciennes marques'
	END AS Type_marque,
	sum(bop.billing_product_ht / 100) AS ca,
	count(DISTINCT bo.order_id) AS cmd
from smallable2_datawarehouse.b_orders bo 
inner join smallable2_datawarehouse.b_order_products bop 
on bop.order_id = bo.order_id 
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bop.product_id 
inner join smallable2_datawarehouse.b_brands bb 
on bb.brand_id = bp.brand_id 
	AND bo.is_valid = 1
	AND bo.is_ca_net_ht_not_zero = 1 --filtre sur net
where bo.created_at  >= '2021-02-21'
	and bo.created_at  <= '2023-02-21'
GROUP BY
	Type_marque
ORDER BY
	ca DESC
	
	
SELECT
	toStartOfMonth(bo.invoiced_at) AS m, -- filtre sur date de validation de paiement et pas création
	CASE
		WHEN LEFT(trim(coa.postcode),
		2) = '75' THEN 'Paris'
		WHEN LEFT(trim(coa.postcode),
		2) IN ('77', '78', '91', '92', '93', '94', '95') THEN 'IDF'
		WHEN trim(coa.postcode) IN ('33000', '33100', '33200', '33300', '33800') THEN 'Bordeaux'
		WHEN trim(coa.postcode) IN ('13000', '13001', '13002', '13003', '13004', '13005', '13006', '13007', '13008', '13009') THEN 'Marseille'
		WHEN trim(coa.postcode) IN ('69000', '69001', '69002', '69003', '69004', '69005', '69006', '69007', '69008', '69009') THEN 'Lyon'
		WHEN trim(coa.postcode) IN ('31000', '31100', '31200', '31300', '31400', '31500') THEN 'Toulouse'
		ELSE 'Autre'
	END AS region,
	sum(bo.billing_product_ht / 100) AS ca,
	count(DISTINCT bo.order_id) AS cmd
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_front.customer_order_address coa ON
	bo.delivery_address_id = coa.id
	AND coa.country_id = 7
	AND bo.is_valid = 1
	AND bo.is_ca_net_ht_not_zero = 1 --filtre sur net
GROUP BY
	m,
	region
ORDER BY
	m ASC,
	ca DESC