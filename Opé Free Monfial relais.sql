

----------------------------------------------------- MONDIAL RELAIS -------------------------------------------------------------
SELECT
	--count(DISTINCT bo.order_id) as Nb_commande,
	--sum(bop.billing_product_ht / 100) as CA,
	--count(DISTINCT CASE WHEN bop.carrier_id_theo = 1023 THEN bo.order_id ELSE NULL end)/ count(DISTINCT bo.order_id) AS "% mondial relay",
	count(DISTINCT CASE WHEN bop.carrier_id_theo = 1023 AND bo.created_at < '2022-09-05' THEN bo.order_id ELSE NULL end)/ count(DISTINCT CASE WHEN bo.created_at < '2022-09-05' then bo.order_id ELSE NULL end) AS b4,
	count(DISTINCT CASE WHEN bop.carrier_id_theo = 1023 AND bo.created_at >= '2022-09-05' THEN bo.order_id ELSE NULL end)/ count(DISTINCT CASE WHEN bo.created_at >= '2022-09-05' then bo.order_id ELSE NULL end) AS AFTER,
	sum(CASE WHEN bop.carrier_id_theo = 1023 AND bo.created_at < '2022-09-05' THEN bop.billing_product_ht / 100 ELSE NULL end)/ count(DISTINCT CASE WHEN bop.carrier_id_theo = 1023 AND bo.created_at < '2022-09-05' THEN bo.order_id ELSE NULL end) AS avant,
	sum(CASE WHEN bop.carrier_id_theo = 1023 AND bo.created_at >= '2022-09-05' THEN bop.billing_product_ht / 100 ELSE NULL end)/ count(DISTINCT CASE WHEN bop.carrier_id_theo = 1023 AND bo.created_at >= '2022-09-05' THEN bo.order_id ELSE NULL end) AS apres
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bo.order_id = bop.order_id
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	--AND bo.billing_product_ht > 10000
	AND bo.delivery_country_iso = 'FR'
	--AND bo.created_at >= '2022-07-03'
	
	
	
SELECT
	count(DISTINCT bo.order_id),
	sum(bop.billing_product_ht / 100) as CA, count(DISTINCT CASE WHEN bo.repeat_number = 1 THEN bo.order_id ELSE NULL END) AS nouveau,
count(DISTINCT CASE WHEN bo.repeat_number > 1 THEN bo.order_id ELSE NULL END) AS repeat,count(DISTINCT CASE WHEN bo.repeat_number = 1 THEN bo.order_id ELSE NULL END)/count(DISTINCT bo.order_id) AS "% nouveaux clients",
count(DISTINCT CASE WHEN bo.repeat_number > 1 THEN bo.order_id ELSE NULL END)/count(DISTINCT bo.order_id) AS "% ancien clients",
	count(DISTINCT CASE WHEN bop.carrier_id_theo = 1023 THEN bo.order_id ELSE NULL end)/count(DISTINCT bo.order_id) AS "% mondial relay",
	count(DISTINCT CASE WHEN bop.carrier_id_theo = 1023 THEN bo.order_id ELSE NULL end)
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bo.order_id = bop.order_id
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	--AND bo.billing_product_ht > 10000
	AND bo.delivery_country_iso = 'FR'
	AND bo.created_at >= '2022-09-05'
	AND bo.created_at <= '2022-12-07'
	
	
	
select * 
from smallable2_datawarehouse.b_order_products bop 
where bop.carrier_id_theo = 1023
	



select count(DISTINCT bo.order_id) as Nb_commande,
	sum(bop.billing_product_ht / 100) as CA
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bo.order_id = bop.order_id
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	--AND bo.billing_product_ht > 10000
	AND bo.delivery_country_iso = 'FR'
	AND bo.created_at = '2022-10-09'
	
		
	
select
	bop.code_promo as code,
	count(distinct bop.order_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	CA/order as pm
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
where
	bop.code_promo ilike 'FREEMONDIALRELAY'
group by
	bop.code_promo
	
	
SELECT
--CASE WHEN bo.billing_shipping_product_ht = 0 THEN 'fdp offert' ELSE 'fdp payant' END AS fdp,
count(DISTINCT CASE WHEN bo.repeat_number = 1 THEN bo.order_id ELSE NULL END) AS nouveau,
count(DISTINCT CASE WHEN bo.repeat_number > 1 THEN bo.order_id ELSE NULL END) AS repeat,
 sum(bop.billing_product_ht /100) as CA,
count(DISTINCT CASE WHEN bo.repeat_number = 1 THEN bo.order_id ELSE NULL END)/count(DISTINCT bo.order_id) AS "% nouveaux clients",
count(DISTINCT CASE WHEN bo.repeat_number > 1 THEN bo.order_id ELSE NULL END)/count(DISTINCT bo.order_id) AS "% ancien clients",
sum(CASE WHEN bop.product_id IN (148488,148484) THEN 0 ELSE bop.qty_ordered END)/count(DISTINCT bo.order_id) AS cmd_panier,
sum(bop.billing_product_ht/100)/count(DISTINCT bo.order_id) AS pm,
sum((bop.billing_product_ht - bop.cost_product_ht)/100)/count(DISTINCT bo.order_id) AS marge_moyenne,
sum(bop.billing_shipping_product_ht/100)/count(DISTINCT bo.order_id) as fdp_moy
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bo.order_id = bop.order_id
WHERE
	bo.is_valid = 1
	AND bo.is_ca_net_ht_not_zero  = 1
	AND bo.delivery_country_iso = 'FR'
	AND bo.created_at >= '2021-09-05'
		AND bop.carrier_id_theo = 1023
	AND bo.order_id IN (SELECT DISTINCT bop2.order_id FROM smallable2_datawarehouse.b_order_products bop2 WHERE bop2.carrier_id_theo = 1023)
--GROUP BY fd
