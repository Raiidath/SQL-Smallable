SELECT
	bo.first_order_vs_repeat as Rep,
	count(DISTINCT CASE WHEN bo.created_at >= '2023-06-14' AND bo.created_at <=  '2023-06-18'  THEN bo.order_id ELSE NULL END) AS cmd_pe23,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-06-08' AND bo.created_at <=  '2022-06-12'  THEN bo.order_id ELSE NULL END) AS cmd_pe22,
	round(sum(CASE WHEN bo.created_at >= '2023-06-14' AND bo.created_at <=  '2023-06-18'  AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP23,
	round(sum(CASE WHEN bo.created_at >= '2022-06-08' AND bo.created_at <=  '2022-06-12'  AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP22,
	sum(CASE WHEN bo.created_at >= '2023-06-14' AND bo.created_at <=  '2023-06-18'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_pe23,
	sum(CASE WHEN bo.created_at >= '2022-06-08' AND bo.created_at <=  '2022-06-12'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_pe22
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.regroup_zone not in ( 'US')
INNER JOIN smallable2_datawarehouse.b_traffic bt ON
	bt.traffic_id = bo.traffic_id
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at >= '2023-06-14' AND bo.created_at <=  '2023-06-18' --AND bo.created_at <  '2023-01-23'
	OR bo.created_at >= '2022-06-08' AND bo.created_at <=  '2022-06-12'
Group by Rep
ORDER BY ca_pe23 DESC
	
SELECT
	count(DISTINCT CASE WHEN bt.Vis_date >= '2023-06-14' AND bt.Vis_date <=  '2023-06-18'  THEN bt.traffic_id ELSE NULL END) AS sess_pe23,
	count(DISTINCT CASE WHEN bt.Vis_date >= '2022-06-08' AND bt.Vis_date <=  '2022-06-12' THEN bt.traffic_id ELSE NULL END) AS sess_pe22
FROM
	smallable2_datawarehouse.b_traffic bt
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bt.country_id 
and bc.regroup_zone in ('US')
--and bc.country_name in ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Suisse', 'Monaco', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy'
--,'Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie française', 'Reunion', 'Ile Canaries')
--GROUP BY canal
order by sess_pe23 desc





------------------------------- CA et  CMD PAYS------------------------------------------------------------

SELECT
	bc.zone_code  as pays ,
	count(DISTINCT bo.order_id) AS cmd_pe23,
	round(sum(CASE WHEN b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3,
	sum(bop.billing_product_ht / 100) AS ca_pe23,
	sum(bop.billing_product_ht - bop.cost_product_ht) / 100 AS marge_ht,
    (sum(bop.billing_product_ht) - sum(bop.cost_product_ht))/sum(bop.billing_product_ht) as TMB,
    1-(sum(bop.billing_product_ht)/sum(bop.billing_product_before_discount_ht)) AS taux_discount_moyen
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
INNER JOIN smallable2_datawarehouse.b_traffic bt ON
	bt.traffic_id = bo.traffic_id
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at >=  '2023-06-21' and  bo.created_at <= '2023-06-25' 
	--AND bo.created_at >= '2022-06-15' and bo.created_at <= '2022-06-19' 
	--AND bo.created_at >= '2023-01-04' and bo.created_at  <= '2023-01-08' 
GROUP BY pays
ORDER BY ca_pe23 DESC


SELECT
	--bc.zone_code  as pays ,
	count(DISTINCT CASE WHEN bo.created_at = '2023-06-28'  THEN bo.order_id ELSE NULL END) AS cmd_pe23,
	count(DISTINCT CASE WHEN bo.created_at = '2022-06-22'  THEN bo.order_id ELSE NULL END) AS cmd_pe22,
	count(DISTINCT CASE WHEN bo.created_at = '2023-01-11'  THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	round(sum(CASE WHEN bo.created_at = '2023-06-28' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP1,
	round(sum(CASE WHEN bo.created_at = '2022-06-22' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	round(sum(CASE WHEN bo.created_at = '2023-01-11' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3,
	sum(CASE WHEN bo.created_at = '2023-06-28' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_pe23,
	sum(CASE WHEN bo.created_at = '2022-06-22' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_pe22,
	sum(CASE WHEN bo.created_at = '2023-01-11' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	sum(CASE WHEN bo.created_at = '2023-06-28' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht1,
	sum(CASE WHEN bo.created_at = '2022-06-22' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	sum(CASE WHEN bo.created_at = '2023-01-11' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	(sum(CASE WHEN bo.created_at =  '2023-06-28' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at = '2023-06-28' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at = '2023-06-28' THEN bop.billing_product_ht  ELSE NULL END) as TMB1,
	(sum(CASE WHEN bo.created_at =  '2022-06-22' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at = '2022-06-22' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at = '2022-06-22' THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	(sum(CASE WHEN bo.created_at =  '2023-01-11' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at = '2023-01-11' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at = '2023-01-11' THEN bop.billing_product_ht  ELSE NULL END) as TMB3,
	 1-(sum(CASE WHEN bo.created_at = '2023-06-28' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at = '2023-06-28' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen1, 
	 1-(sum(CASE WHEN bo.created_at = '2022-06-22' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at = '2022-06-22' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2, 
	 1-(sum(CASE WHEN bo.created_at = '2023-01-11' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at = '2023-01-11' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
INNER JOIN smallable2_datawarehouse.b_traffic bt ON
	bt.traffic_id = bo.traffic_id
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at = '2023-06-28' --AND bo.created_at <  '2023-01-23'
	OR bo.created_at = '2022-06-22' --AND bo.created_at <  '2022-01-24'
	OR bo.created_at = '2023-01-11' --AND bo.created_at <  '2022-01-24'
--GROUP BY pays
ORDER BY ca_pe23 DESC