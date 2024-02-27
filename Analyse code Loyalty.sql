select
	CASE
		WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') then bop.code_promo
		else null
	end as code_promo,
	sum(CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN (bop.billing_product_ht-bop.billing_discount_product_ht) / 100 ELSE NULL END) AS CA_Loy,
	count(DISTINCT CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN bo.order_id ELSE NULL END) AS nb_commandes_Loy,
	sum(DISTINCT CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN bop.qty_ordered  ELSE NULL END) AS nb_produits_Loy
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bo.is_valid = 1
and bo.is_ca_ht_not_zero = 1
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
where
	bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED')
group by
	bop.code_promo
order by
	CA_Loy desc
	
	
select sum(bop.billing_product_ht / 100 as CA)
from smallable2_datawarehouse.b_order_products bop 
inner join smallable2_datawarehouse.b_orders bo 
on bo.order_id = bop.order_id 
where bop.basket_created_at >= '2022-03-25' and bop.basket_created_at <= '2022-04-12'
	
	

select
	bp.brand_name as Marques,
	sum(CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN (bop.billing_product_ht-bop.billing_discount_product_ht) / 100 ELSE NULL END) AS CA_Loy,
	count(DISTINCT CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN bo.order_id ELSE NULL END) AS nb_commandes_Loy,
	sum(DISTINCT CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN bop.qty_ordered  ELSE NULL END) AS nb_produits_Loy
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bo.is_valid = 1
and bo.is_ca_ht_not_zero = 1
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
where
	bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED')
group by
	Marques
order by
	nb_commandes_Loy desc
	
	

select
	bp.product_name  as produits, bp.brand_name as Marques, bp.ref_co as Refco, 
	sum(CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN (bop.billing_product_ht-bop.billing_discount_product_ht) / 100 ELSE NULL END) AS CA_Loy,
	count(DISTINCT CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN bo.order_id ELSE NULL END) AS nb_commandes_Loy,
	sum(DISTINCT CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN bop.qty_ordered  ELSE NULL END) AS nb_produits_Loy
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bo.is_valid = 1
and bo.is_ca_ht_not_zero = 1
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
where
	bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED')
group by
	produits, Marques, Refco
order by
	nb_commandes_Loy desc -- nb_commandes_Loy


	
select
	bp.sml_team  as secteur,
	sum(CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN (bop.billing_product_ht-bop.billing_discount_product_ht) / 100 ELSE NULL END) AS CA_Loy,
	count(DISTINCT CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN bo.order_id ELSE NULL END) AS nb_commandes_Loy,
	sum(DISTINCT CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN bop.qty_ordered  ELSE NULL END) AS nb_produits_Loy
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bo.is_valid = 1
and bo.is_ca_ht_not_zero = 1
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
where
	bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED')
group by
	secteur
order by
	CA_Loy desc
	

select
	bs.univers  as univers,
	sum(CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN (bop.billing_product_ht-bop.billing_discount_product_ht) / 100 ELSE NULL END) AS CA_Loy,
	count(DISTINCT CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN bo.order_id ELSE NULL END) AS nb_commandes_Loy,
	sum(DISTINCT CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN bop.qty_ordered  ELSE NULL END) AS nb_produits_Loy
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bo.is_valid = 1
and bo.is_ca_ht_not_zero = 1
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code 
where
	bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED')
group by
	univers
order by
	CA_Loy desc	
	
	
select
	bs.categories_N5  as categ,
	sum(CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Loy,
	count(DISTINCT CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN bo.order_id ELSE NULL END) AS nb_commandes_Loy,
	count(DISTINCT CASE WHEN bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED') THEN bp.product_id ELSE NULL END) AS nb_produits_Loy
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code 
where
	bop.code_promo in ('LOYALTY10-USD', 'LOYALTY20-USD', 'LOYALTY10-CAD', 'LOYALTY20-CAD', 'LOYALTY10-EUR', 'LOYALTY20-EUR', 'LOYALTY10-CHF', 'LOYALTY20-CHF', 'LOYALTY10-GBP', 'LOYALTY20-GBP', 'LOYALTY10-JPY', 'LOYALTY20-JPY', 'LOYALTY20-AED')
group by
	categ
order by
	CA_Loy desc	