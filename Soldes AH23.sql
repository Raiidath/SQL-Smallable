--------------- Soldes AH23 GE 

SELECT
	bc.zone_code  as pays,
    --s.product_type_N5 AS Typo, 
    --bop.sml_team AS secteur, 	
    --count(DISTINCT CASE WHEN bo.created_at >= '2023-12-13' AND bo.created_at <= '2023-12-17' THEN bo.order_id ELSE NULL END) AS cmd_ah23,
    --count(DISTINCT CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-18' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	--sum(CASE WHEN bo.created_at >= '2023-12-13' AND bo.created_at <= '2023-12-17' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	--sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-18' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	--round(sum(CASE WHEN bo.created_at >= '2023-12-13' AND bo.created_at <= '2023-12-17' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3,
	--round(sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-18' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	--sum(CASE WHEN bo.created_at >= '2023-12-13' AND bo.created_at <= '2023-12-17' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	--sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-18' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	(sum(CASE WHEN bo.created_at >= '2024-01-01' AND bo.created_at <= '2024-01-21' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2024-01-01' AND bo.created_at <= '2024-01-21' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2024-01-01' AND bo.created_at <= '2024-01-21' THEN bop.billing_product_ht  ELSE NULL END) as TMB3--,
	--(sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-18' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-18' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-18' THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	--1-(sum(CASE WHEN bo.created_at >= '2023-01-01' AND bo.created_at <= '2024-01-21' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2023-01-01' AND bo.created_at <= '2024-01-21' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3,
--	1-(sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-18' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-18' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
--and bc.country_name NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse','Danemark',
--'Irlande','Pays-Bas','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Malte', 'Chypre', 'Croatie','Îles Canaries', 'Montenegro','Monaco',
--'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy', 'Guyane française','Andorre','Réunion','Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française','Mayotte')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND (bo.created_at >= '2024-01-01' AND bo.created_at <= '2024-01-21')
	--	OR (bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-18'))
GROUP BY pays 
--ORDER BY ca_ah23 DESC



SELECT
	--bc.country_name  as pays,
    --s.product_type_N5 AS Typo, 
   bop.sml_team AS secteur, 	
    count(DISTINCT CASE WHEN bo.created_at = '2024-01-10'  THEN bo.order_id ELSE NULL END) AS cmd_ah23,
    count(DISTINCT CASE WHEN bo.created_at = '2023-01-11'  THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at = '2024-01-10' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at = '2023-01-11' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	round(sum(CASE WHEN bo.created_at = '2024-01-10' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3,
	round(sum(CASE WHEN bo.created_at = '2023-01-11' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	sum(CASE WHEN bo.created_at = '2024-01-10' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	sum(CASE WHEN bo.created_at = '2023-01-11' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	(sum(CASE WHEN bo.created_at = '2024-01-10' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at = '2024-01-10' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at = '2024-01-10' THEN bop.billing_product_ht  ELSE NULL END) as TMB3,
	(sum(CASE WHEN bo.created_at = '2023-01-11' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at = '2023-01-11' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at = '2023-01-11' THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	1-(sum(CASE WHEN bo.created_at = '2024-01-10' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at = '2024-01-10' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3,
	1-(sum(CASE WHEN bo.created_at = '2023-01-11' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at = '2023-01-11' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name IN ('France', 'Monaco', 'Andorre')
--and bc.country_name NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse','Danemark',
--'Irlande','Pays-Bas','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Malte', 'Chypre', 'Croatie','Îles Canaries', 'Montenegro','Monaco',
--'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy', 'Guyane française','Andorre','Réunion','Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française','Mayotte')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at = '2024-01-10' 
	OR bo.created_at = '2023-01-11'
GROUP BY secteur 
ORDER BY ca_ah23 DESC




SELECT
	--bc.country_name AS canal,
	count(DISTINCT CASE WHEN bt.ref_date = '2024-01-10'  THEN bt.traffic_id ELSE NULL END) AS sess_pe22,
	count(DISTINCT CASE WHEN bt.ref_date  = '2023-01-11' THEN bt.traffic_id ELSE NULL END) AS sess_pe23
	FROM
	smallable2_datawarehouse.b_traffic bt
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bt.country_id 
--and bc.country_name IN ('France', 'Monaco', 'Andorre')
	
	

and bc.country_name NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse','Danemark',
'Irlande','Pays-Bas','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Malte', 'Chypre', 'Croatie','Îles Canaries', 'Montenegro','Monaco',
'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy', 'Guyane française','Andorre','Réunion','Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française','Mayotte')
--GROUP BY canal
--order by sess_pe23 desc

SELECT * FROM 	smallable2_datawarehouse.b_traffic bt



--------------- Ventes Privilèges AH23 FR 

SELECT
	--bc.country_name  as pays,
    --s.product_type_N5 AS Typo, 
    --bop.sml_team AS secteur, 	
    count(DISTINCT CASE WHEN bo.created_at = '2023-12-28' THEN bo.order_id ELSE NULL END) AS cmd_ah23,
    count(DISTINCT CASE WHEN bo.created_at = '2023-01-04'  THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at = '2023-12-28' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at = '2023-01-04' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	round(sum(CASE WHEN bo.created_at = '2023-12-28' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3,
	round(sum(CASE WHEN bo.created_at = '2023-01-04' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	sum(CASE WHEN bo.created_at = '2023-12-28' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	sum(CASE WHEN bo.created_at = '2023-01-04' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	(sum(CASE WHEN bo.created_at = '2023-12-28' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at = '2023-12-28' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at = '2023-12-28' THEN bop.billing_product_ht  ELSE NULL END) as TMB3,
	(sum(CASE WHEN bo.created_at = '2023-01-04' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at = '2023-01-04' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at = '2023-01-04' THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	1-(sum(CASE WHEN bo.created_at = '2023-12-28' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at = '2023-12-28' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3,
	1-(sum(CASE WHEN bo.created_at = '2023-01-04' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at = '2023-01-04' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name IN ('France', 'Monaco', 'Andorre')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at = '2023-12-28' 
	OR bo.created_at = '2023-01-04'
---GROUP BY secteur 
ORDER BY ca_ah23 DESC




SELECT
	--bc.country_name AS canal,
	count(DISTINCT CASE WHEN bt.Vis_date = '2023-12-28' THEN bt.traffic_id ELSE NULL END) AS sess_pe22,
	count(DISTINCT CASE WHEN bt.Vis_date = '2023-01-04' THEN bt.traffic_id ELSE NULL END) AS sess_pe23
	FROM
	smallable2_datawarehouse.b_traffic bt
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bt.country_id 
and bc.country_name IN ('France', 'Monaco', 'Andorre')

	
--------------- Ventes Privilèges AH23 EU Hors FR 

SELECT
	--bc.country_name  as pays,
    --s.product_type_N5 AS Typo, 
    bop.sml_team AS secteur, 	
    count(DISTINCT CASE WHEN bo.created_at = '2023-12-20' THEN bo.order_id ELSE NULL END) AS cmd_ah23,
    count(DISTINCT CASE WHEN bo.created_at = '2023-01-05' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at = '2023-12-20' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at = '2023-01-05' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	round(sum(CASE WHEN bo.created_at = '2023-12-20'AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3,
	round(sum(CASE WHEN bo.created_at = '2023-01-05' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	sum(CASE WHEN bo.created_at ='2023-12-20' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	sum(CASE WHEN bo.created_at = '2023-01-05' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	(sum(CASE WHEN bo.created_at = '2023-12-20' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at = '2023-12-20'THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at = '2023-12-20' THEN bop.billing_product_ht  ELSE NULL END) as TMB3,
	(sum(CASE WHEN bo.created_at = '2023-01-05' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at = '2023-01-05' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at = '2023-01-05' THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	1-(sum(CASE WHEN bo.created_at = '2023-12-20' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at = '2023-12-20' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3,
	1-(sum(CASE WHEN bo.created_at = '2023-01-05' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at = '2023-01-05' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name IN ('Allemagne', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse','Danemark',
'Irlande','Pays-Bas','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Malte', 'Chypre', 'Croatie','Îles Canaries', 'Montenegro')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at = '2023-12-20' 
	OR bo.created_at = '2023-01-05'
GROUP BY secteur 
ORDER BY ca_ah23 DESC



SELECT
	--bc.country_name AS canal,
	count(DISTINCT CASE WHEN bt.ref_date = '2023-12-20' THEN bt.traffic_id ELSE NULL END) AS sess_pe22,
	count(DISTINCT CASE WHEN bt.ref_date = '2023-01-05' THEN bt.traffic_id ELSE NULL END) AS sess_pe23
	FROM
	smallable2_datawarehouse.b_traffic bt
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bt.country_id 
and bc.country_name IN ('Allemagne', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse','Danemark',
'Irlande','Pays-Bas','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Malte', 'Chypre', 'Croatie','Îles Canaries', 'Montenegro')




SELECT *
FROM
	smallable2_datawarehouse.b_traffic bt

--------------- Boxingday10

SELECT
	--bc.zone_code  as pays,
    --s.product_type_N5 AS Typo, 
   -- bop.sml_team AS secteur, 	
    count(DISTINCT CASE WHEN bo.created_at >= '2023-12-26' AND bo.created_at <= '2023-12-27' THEN bo.order_id ELSE NULL END) AS cmd_ah23,
    count(DISTINCT CASE WHEN bo.created_at >= '2022-12-26' AND bo.created_at <= '2022-12-27' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2023-12-26' AND bo.created_at <= '2023-12-27' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at  >= '2022-12-26' AND bo.created_at <= '2022-12-27' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	ca_ah23/cmd_ah23 AS pm_ah23, ca_ah22/cmd_ah22 AS pm_ah22,
	round(sum(CASE WHEN bo.created_at >= '2023-12-26' AND bo.created_at <= '2023-12-27' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3,
	round(sum(CASE WHEN bo.created_at  >= '2022-12-26' AND bo.created_at <= '2022-12-27' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	sum(CASE WHEN bo.created_at >= '2023-12-26' AND bo.created_at <= '2023-12-27' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	sum(CASE WHEN bo.created_at  >= '2022-12-26' AND bo.created_at <= '2022-12-27' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2--,
	--(sum(CASE WHEN bo.created_at >= '2023-12-26' AND bo.created_at <= '2023-12-27' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2023-12-26' AND bo.created_at <= '2023-12-27' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2023-12-26' AND bo.created_at <= '2023-12-27' THEN bop.billing_product_ht  ELSE NULL END) as TMB3,
	--(sum(CASE WHEN bo.created_at  >= '2022-12-26' AND bo.created_at <= '2022-12-27' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at  >= '2022-12-26' AND bo.created_at <= '2022-12-27' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at  >= '2022-12-26' AND bo.created_at <= '2022-12-27' THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	--1-(sum(CASE WHEN bo.created_at >= '2023-12-26' AND bo.created_at <= '2023-12-27' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2023-12-26' AND bo.created_at <= '2023-12-27' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3,
	--1-(sum(CASE WHEN bo.created_at  >= '2022-12-26' AND bo.created_at <= '2022-12-27' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2022-12-26' AND bo.created_at <= '2022-12-27' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.code_promo LIKE 'BOXINGDAY10' OR bop.code_promo LIKE 'BOXINGDAY2627'
	AND (bo.created_at >= '2023-12-26' AND bo.created_at <= '2023-12-27'
		OR (bo.created_at  >= '2022-12-26' AND bo.created_at <= '2022-12-27'))
--GROUP BY pays 
ORDER BY ca_ah23 DESC





SELECT *
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
WHERE bop.code_promo LIKE 'BOXINGDAY2627'