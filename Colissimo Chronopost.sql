-- opé en cours -- 

SELECT
CASE WHEN bo.billing_shipping_product_ht = 0 THEN 'fdp offert' ELSE 'fdp payant' END AS fdp,
 sum(bop.billing_product_ht /100) as CA,
count(DISTINCT CASE WHEN bo.repeat_number = 1 THEN bo.order_id ELSE NULL END) AS nouveau,
count(DISTINCT CASE WHEN bo.repeat_number > 1 THEN bo.order_id ELSE NULL END) AS repeat,
count(DISTINCT CASE WHEN bo.repeat_number = 1 THEN bo.order_id ELSE NULL END)/count(DISTINCT bo.order_id) AS "% nouveaux clients",
sum(CASE WHEN bop.product_id IN (148488,148484) THEN 0 ELSE bop.qty_ordered END)/count(DISTINCT bo.order_id) AS cmd_panier,
sum(bop.billing_product_ht/100)/count(DISTINCT bo.order_id) AS pm,
sum((bop.billing_product_ht - bop.cost_product_ht)/100)/count(DISTINCT bo.order_id) AS marge_moyenne,
sum(bp.weight_amount)/count(DISTINCT bo.order_id) AS poids_moyen, sum(bop.billing_shipping_product_ht/100)/count(DISTINCT bo.order_id) as fdp_moy
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bo.order_id = bop.order_id
	INNER JOIN smallable2_datawarehouse.b_products bp ON bop.product_id = bp.product_id 
WHERE
	bo.is_valid = 1
	AND bo.is_ca_net_ht_not_zero  = 1
	AND bo.delivery_country_iso in ('FR','DE','IT','ES','BE','NL')
	AND bo.created_at >= '2022-06-05'
	AND bo.created_at <= '2022-09-05'
	AND bo.order_id IN (SELECT DISTINCT bop2.order_id FROM smallable2_datawarehouse.b_order_products bop2 WHERE bop2.carrier_id_theo  IN (1044,1018))
GROUP BY fdp


SELECT
CASE WHEN bo.billing_shipping_product_ht = 0 THEN 'fdp offert' ELSE 'fdp payant' END AS fdp,
 sum(bop.billing_product_ht /100) as CA,
count(DISTINCT CASE WHEN bo.repeat_number = 1 THEN bo.order_id ELSE NULL END) AS nouveau,
count(DISTINCT CASE WHEN bo.repeat_number > 1 THEN bo.order_id ELSE NULL END) AS repeat,
count(DISTINCT CASE WHEN bo.repeat_number = 1 THEN bo.order_id ELSE NULL END)/count(DISTINCT bo.order_id) AS "% nouveaux clients",
sum(CASE WHEN bop.product_id IN (148488,148484) THEN 0 ELSE bop.qty_ordered END)/count(DISTINCT bo.order_id) AS cmd_panier,
sum(bop.billing_product_ht/100)/count(DISTINCT bo.order_id) AS pm,
sum((bop.billing_product_ht - bop.cost_product_ht)/100)/count(DISTINCT bo.order_id) AS marge_moyenne,
sum(bp.weight_amount)/count(DISTINCT bo.order_id) AS poids_moyen, sum(bop.billing_shipping_product_ht/100)/count(DISTINCT bo.order_id) as fdp_moy
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bo.order_id = bop.order_id
	INNER JOIN smallable2_datawarehouse.b_products bp ON bop.product_id = bp.product_id 
WHERE
	bo.is_valid = 1
	AND bo.is_ca_net_ht_not_zero  = 1
	AND bo.delivery_country_iso in ('FR','DE','IT','ES','BE','NL')
	AND bo.created_at >= '2022-10-14'
	--AND bo.created_at < '2022-10-14'
	AND bo.order_id IN (SELECT DISTINCT bop2.order_id FROM smallable2_datawarehouse.b_order_products bop2 WHERE bop2.carrier_id_theo  IN (1044,1018))
GROUP BY fdp


SELECT
bop.delivery_country_iso as pays,
count(DISTINCT CASE WHEN bo.repeat_number = 1 THEN bo.order_id ELSE NULL END) AS nouveau,
count(DISTINCT CASE WHEN bo.repeat_number > 1 THEN bo.order_id ELSE NULL END) AS repeat,
count(DISTINCT CASE WHEN bo.repeat_number = 1 THEN bo.order_id ELSE NULL END)/count(DISTINCT bo.order_id) AS "% nouveaux clients",
sum(CASE WHEN bop.product_id IN (148488,148484) THEN 0 ELSE bop.qty_ordered END)/count(DISTINCT bo.order_id) AS cmd_panier,
sum(bop.billing_product_ht/100)/count(DISTINCT bo.order_id) AS pm,
sum((bop.billing_product_ht - bop.cost_product_ht)/100)/count(DISTINCT bo.order_id) AS marge_moyenne,
sum(bp.weight_amount)/count(DISTINCT bo.order_id) AS poids_moyen, sum(bop.billing_shipping_product_ht/100)/count(DISTINCT bo.order_id) as fdp_moy
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bo.order_id = bop.order_id
	INNER JOIN smallable2_datawarehouse.b_products bp ON bop.product_id = bp.product_id 
WHERE
	bo.is_valid = 1
	AND bo.is_ca_net_ht_not_zero  = 1
	AND bo.delivery_country_iso in ('FR','DE','IT','ES','BE','NL')
	AND bo.created_at > '2022-09-05'
	AND bo.order_id IN (SELECT DISTINCT bop2.order_id FROM smallable2_datawarehouse.b_order_products bop2 WHERE bop2.carrier_id_theo IN (1044,1018))
GROUP BY pays

-- période précedente --

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
	AND bo.delivery_country_iso in ('FR','DE','IT','ES','BE','NL')
	AND bo.created_at >= '2021-09-06' AND bo.created_at <= '2021-12-07'
	AND bo.order_id IN (SELECT DISTINCT bop2.order_id FROM smallable2_datawarehouse.b_order_products bop2 WHERE bop2.carrier_id_theo IN (1044,1018))
--GROUP BY fdp
	
	
SELECT toStartOfWeek(bo.created_at) as month,
--CASE WHEN bo.billing_shipping_product_ht = 0 THEN 'fdp offert' ELSE 'fdp payant' END AS fdp,
count(DISTINCT CASE WHEN bo.repeat_number = 1 THEN bo.order_id ELSE NULL END) AS nouveau,
count(DISTINCT CASE WHEN bo.repeat_number > 1 THEN bo.order_id ELSE NULL END) AS  repeat,
count(DISTINCT CASE WHEN bo.repeat_number = 1 THEN bo.order_id ELSE NULL END)/count(DISTINCT bo.order_id) AS "% nouveaux clients",
count(DISTINCT CASE WHEN bo.repeat_number > 1 THEN bo.order_id ELSE NULL END)/count(DISTINCT bo.order_id) AS "% ancien clients",
count(distinct bo.order_id) as cmd,
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
	AND bo.delivery_country_iso in ('FR','DE','IT','ES','BE','NL')
	AND bo.created_at >= '2022-09-06' AND bo.created_at < '2022-12-08'
	AND bo.order_id IN (SELECT DISTINCT bop2.order_id FROM smallable2_datawarehouse.b_order_products bop2 WHERE bop2.carrier_id_theo IN (1044,1018))
GROUP BY month
	
	
-- levier -- 
	
SELECT
bo.traffic_source_name AS canal,
count(DISTINCT CASE WHEN bo.repeat_number = 1 AND bo.billing_shipping_product_ht = 0 THEN bo.order_id ELSE NULL END) AS nouveau_fdp_gratuit,
count(DISTINCT CASE WHEN bo.repeat_number > 1 AND bo.billing_shipping_product_ht = 0 THEN bo.order_id ELSE NULL END) AS repeat_fdp_gratuit,
count(DISTINCT CASE WHEN bo.repeat_number = 1 AND bo.billing_shipping_product_ht != 0 THEN bo.order_id ELSE NULL END) AS nouveau_fdp_payant,
count(DISTINCT CASE WHEN bo.repeat_number > 1 AND bo.billing_shipping_product_ht != 0 THEN bo.order_id ELSE NULL END) AS repeat_fdp_payant
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bo.order_id = bop.order_id
WHERE
	bo.is_valid = 1
	AND bo.is_ca_net_ht_not_zero  = 1
	AND bo.delivery_country_iso in ('FR','DE','IT','ES','BE','NL')
	AND bo.created_at > '2022-09-05' AND bo.created_at < '2022-12-08'
	AND bo.order_id IN (SELECT DISTINCT bop2.order_id FROM smallable2_datawarehouse.b_order_products bop2 WHERE bop2.carrier_id_theo IN (1044,1018))
GROUP BY canal
