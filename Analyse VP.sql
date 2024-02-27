------------------------------------ Analyse Novembre 2022 VP KIDS ----------------------------------
---------- GE
SELECT
	--bc.country_name  as pays,
    --s.product_type_N5 AS Typo, 
    --bop.sml_team AS secteur, 	
    count(DISTINCT CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bo.order_id ELSE NULL END) AS cmd_ah23,
    count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	--round(sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND b_order_products.discount_product_rate in ('0', 'NaN') AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3,
	--round(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' AND b_order_products.discount_product_rate in ('0', 'NaN')  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	(sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.billing_product_ht  ELSE NULL END) as TMB3,
	(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	1-(sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3,
	1-(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
	AND  s.cible in ('BB/Enf/Ado','Bébé', 'Enfant', 'Adolescent')
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND (bo.created_at >= '2022-11-08'
		AND bo.created_at <= '2022-11-14'
		OR (bo.created_at >= '2023-10-26'
			AND bo.created_at <= '2023-10-31')) 
--GROUP BY --secteur 
ORDER BY ca_ah23 DESC



SELECT
    Top 100 bp.brand_name AS marque,	
    count(DISTINCT CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bo.order_id ELSE NULL END) AS cmd_ah23,
        count(DISTINCT CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' THEN bo.order_id ELSE NULL END) AS cmd_ah23_HP,
    count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
        count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bo.order_id ELSE NULL END) AS cmd_ah22_HP,
	sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
		sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23_HP,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
		sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22_HP
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
	AND  s.cible in ('BB/Enf/Ado','Bébé', 'Enfant', 'Adolescent')
left join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND (bo.created_at >= '2022-11-08'
		AND bo.created_at <= '2022-11-14'
		OR (bo.created_at >= '2023-10-26'
			AND bo.created_at <= '2023-10-31')) 
GROUP BY marque
ORDER BY ca_ah23 DESC





---sous requête sessions par levier---
WITH sess AS (
SELECT
	bt.channel_grouping AS canal,
	count(DISTINCT CASE WHEN bt.Vis_date >= '2023-10-26' AND bt.Vis_date <= '2023-10-31'  THEN bt.traffic_id ELSE NULL END) AS sess_ah23,
	count(DISTINCT CASE WHEN bt.Vis_date >= '2022-11-08' AND bt.Vis_date <= '2022-11-14'  THEN bt.traffic_id ELSE NULL END) AS sess_ah22
FROM
	smallable2_datawarehouse.b_traffic bt
INNER JOIN smallable2_datawarehouse.b_countries bc ON
	bt.country_iso_code  = bc.country_iso_code 
AND bc.country_name NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
GROUP BY
	canal),
---sous requête commandes par levier---
cmd AS (
SELECT
	bt.channel_grouping AS canal,
	count(DISTINCT CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31'   THEN bo.order_id ELSE NULL END) AS cmd_ah23,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'   THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_traffic bt ON
	bt.traffic_id = bo.traffic_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bo.order_id = bop.order_id 
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc ON
	bt.country_iso_code  = bc.country_iso_code 
AND bc.country_name NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	(bo.created_at >= '2022-11-08'
		AND bo.created_at <= '2022-11-14'
		OR (bo.created_at >= '2023-10-26'
			AND bo.created_at <= '2023-10-31'))
GROUP BY
	canal)
---requête principale---
SELECT
	sess.canal,
	sess.sess_ah23 AS sessions_ah23,
		sess.sess_ah22 AS sessions_ah22,
	cmd.cmd_ah23 AS commandes_ah23,
		cmd.cmd_ah22 AS commandes_ah22,
	cmd.ca_ah23 AS ca_ah23,
		cmd.ca_ah22 AS ca_ah22,
	cmd.cmd_ah23 / sess.sess_ah23 AS cvr_ah23,
	cmd.cmd_ah22 / sess.sess_ah22 AS cvr_ah22
FROM
	sess
INNER JOIN cmd ON
	sess.canal = cmd.canal
ORDER BY
	sessions_ah23 DESC


--------- EU
SELECT
	--bc.country_name  as pays,
    --s.product_type_N5 AS Typo, 
    --bop.sml_team AS secteur, 	
    count(DISTINCT CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bo.order_id ELSE NULL END) AS cmd_ah23,
    count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	--round(sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3,
	--round(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	(sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht  ELSE NULL END) as TMB3,
	(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	1-(sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3,
	1-(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
	AND  s.cible in ('BB/Enf/Ado','Bébé', 'Enfant', 'Adolescent')
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane Française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND (bo.created_at >= '2022-11-08'
		AND bo.created_at <= '2022-11-14'
		OR (bo.created_at >= '2023-11-02'
			AND bo.created_at <= '2023-11-07'))  
--GROUP BY Typo
ORDER BY ca_ah23 DESC




SELECT
	Top 100 bp.brand_name AS marque,
    count(DISTINCT CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bo.order_id ELSE NULL END) AS cmd_ah23,
        count(DISTINCT CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' THEN bo.order_id ELSE NULL END) AS cmd_ah23_HP,
    count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bo.order_id ELSE NULL END) AS cmd_ah22,
        count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  THEN bo.order_id ELSE NULL END) AS cmd_ah22_HP,
	sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
		sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23_HP,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
		sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22_HP
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
	AND  s.cible in ('BB/Enf/Ado','Bébé', 'Enfant', 'Adolescent')
INNER JOIN smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND (bo.created_at >= '2022-11-08'
		AND bo.created_at <= '2022-11-14'
		OR (bo.created_at >= '2023-11-02'
			AND bo.created_at <= '2023-11-07'))  
GROUP BY marque
ORDER BY ca_ah23 DESC




---sous requête sessions par levier---
WITH sess AS (
SELECT
	bt.channel_grouping AS canal,
	count(DISTINCT CASE WHEN bt.Vis_date >= '2023-11-02' AND bt.Vis_date <= '2023-11-07'   THEN bt.traffic_id ELSE NULL END) AS sess_ah23,
	count(DISTINCT CASE WHEN bt.Vis_date >= '2022-11-08' AND bt.Vis_date <= '2022-11-14'  THEN bt.traffic_id ELSE NULL END) AS sess_ah22
FROM
	smallable2_datawarehouse.b_traffic bt
INNER JOIN smallable2_datawarehouse.b_countries bc ON
	bt.country_iso_code  = bc.country_iso_code 
AND bc.country_name IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
GROUP BY
	canal),
---sous requête commandes par levier---
cmd AS (
SELECT
	bt.channel_grouping AS canal,
	count(DISTINCT CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07'    THEN bo.order_id ELSE NULL END) AS cmd_ah23,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'   THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_traffic bt ON
	bt.traffic_id = bo.traffic_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bo.order_id = bop.order_id 
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc ON
	bt.country_iso_code  = bc.country_iso_code 
AND bc.country_name IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	(bo.created_at >= '2022-11-08'
		AND bo.created_at <= '2022-11-14'
		OR (bo.created_at >= '2023-11-02'
			AND bo.created_at <= '2023-11-07'))  
GROUP BY
	canal)
---requête principale---
SELECT
	sess.canal,
	sess.sess_ah23 AS sessions_ah23,
		sess.sess_ah22 AS sessions_ah22,
	cmd.cmd_ah23 AS commandes_ah23,
		cmd.cmd_ah22 AS commandes_ah22,
	cmd.ca_ah23 AS ca_ah23,
		cmd.ca_ah22 AS ca_ah22,
	cmd.cmd_ah23 / sess.sess_ah23 AS cvr_ah23,
	cmd.cmd_ah22 / sess.sess_ah22 AS cvr_ah22
FROM
	sess
INNER JOIN cmd ON
	sess.canal = cmd.canal
ORDER BY
	sessions_ah23 DESC





------------------------------------ Analyse Novembre 2022 VP ADULT ----------------------------------
---------- GE
SELECT
	--bc.country_name  as pays,
    s.product_type_N5 AS Typo, 
    --bop.sml_team AS secteur, 	
    count(DISTINCT CASE WHEN bo.created_at >= '2023-11-08' AND bo.created_at <= '2023-11-13' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bo.order_id ELSE NULL END) AS cmd_ah23,
    count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2023-11-08' AND bo.created_at <= '2023-11-13' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	round(sum(CASE WHEN bo.created_at >= '2023-11-08' AND bo.created_at <= '2023-11-13' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3,
	round(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	sum(CASE WHEN bo.created_at >= '2023-11-08' AND bo.created_at <= '2023-11-13' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	(sum(CASE WHEN bo.created_at >= '2023-11-08' AND bo.created_at <= '2023-11-13' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2023-11-08' AND bo.created_at <= '2023-11-13' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2023-11-08' AND bo.created_at <= '2023-11-13' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.billing_product_ht  ELSE NULL END) as TMB3,
	(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	1-(sum(CASE WHEN bo.created_at >= '2023-11-08' AND bo.created_at <= '2023-11-13' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2023-11-08' AND bo.created_at <= '2023-11-13' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3,
	1-(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
	AND s.cible in ('Adulte','Homme','Femme') 
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND (bo.created_at >= '2022-11-08'
		AND bo.created_at <= '2022-11-14'
		OR (bo.created_at >= '2023-11-08' 
		AND bo.created_at <= '2023-11-13')) 
GROUP BY Typo
ORDER BY ca_ah23 DESC




SELECT	
    Top 100 bp.brand_name AS marque,
    count(DISTINCT CASE WHEN bo.created_at >= '2023-11-08' AND bo.created_at <= '2023-11-13' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bo.order_id ELSE NULL END) AS cmd_ah23,
    count(DISTINCT CASE WHEN bo.created_at >= '2023-11-08' AND bo.created_at <= '2023-11-13' THEN bo.order_id ELSE NULL END) AS cmd_ah23_HP,
    count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' AND bop.promo_type = 'vente-privee'  THEN bo.order_id ELSE NULL END) AS cmd_ah22,
    count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bo.order_id ELSE NULL END) AS cmd_ah22_HP,
	sum(CASE WHEN bo.created_at >= '2023-11-08' AND bo.created_at <= '2023-11-13' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at >= '2023-11-08' AND bo.created_at <= '2023-11-13' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23_HP,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' AND bop.promo_type = 'vente-privee'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22_HP
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
	AND s.cible in ('Adulte','Homme','Femme') 
left join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND (bo.created_at >= '2022-11-08'
		AND bo.created_at <= '2022-11-14'
		OR (bo.created_at >= '2023-11-08' 
		AND bo.created_at <= '2023-11-13')) 
GROUP BY marque
ORDER BY ca_ah23 DESC


---sous requête sessions par levier---
WITH sess AS (
SELECT
	bt.channel_grouping AS canal,
	count(DISTINCT CASE WHEN bt.Vis_date >= '2023-11-08' AND bt.Vis_date <= '2023-11-13'   THEN bt.traffic_id ELSE NULL END) AS sess_ah23,
	count(DISTINCT CASE WHEN bt.Vis_date >= '2022-11-08' AND bt.Vis_date <= '2022-11-14'  THEN bt.traffic_id ELSE NULL END) AS sess_ah22
FROM
	smallable2_datawarehouse.b_traffic bt
INNER JOIN smallable2_datawarehouse.b_countries bc ON
	bt.country_iso_code  = bc.country_iso_code 
AND bc.country_name NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
GROUP BY
	canal),
---sous requête commandes par levier---
cmd AS (
SELECT
	bt.channel_grouping AS canal,
	count(DISTINCT CASE WHEN bo.created_at >= '2023-11-08' AND bo.created_at <= '2023-11-13'    THEN bo.order_id ELSE NULL END) AS cmd_ah23,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'   THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2023-11-08' AND bo.created_at <= '2023-11-13'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_traffic bt ON
	bt.traffic_id = bo.traffic_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bo.order_id = bop.order_id 
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc ON
	bt.country_iso_code  = bc.country_iso_code 
AND bc.country_name NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	(bo.created_at >= '2022-11-08'
		AND bo.created_at <= '2022-11-14'
		OR (bo.created_at >= '2023-11-08' 
		AND bo.created_at <= '2023-11-13'))
GROUP BY
	canal)
---requête principale---
SELECT
	sess.canal,
	sess.sess_ah23 AS sessions_ah23,
		sess.sess_ah22 AS sessions_ah22,
	cmd.cmd_ah23 AS commandes_ah23,
		cmd.cmd_ah22 AS commandes_ah22,
	cmd.ca_ah23 AS ca_ah23,
		cmd.ca_ah22 AS ca_ah22,
	cmd.cmd_ah23 / sess.sess_ah23 AS cvr_ah23,
	cmd.cmd_ah22 / sess.sess_ah22 AS cvr_ah22
FROM
	sess
INNER JOIN cmd ON
	sess.canal = cmd.canal
ORDER BY
	sessions_ah23 DESC


------------- EU 


SELECT
	--bc.country_name  as pays,
    --s.product_type_N5 AS Typo, 
    --bop.sml_team AS secteur, 	
    count(DISTINCT CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bo.order_id ELSE NULL END) AS cmd_ah23,
    count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30   THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	round(sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3,
	round(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30   THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	(sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30   THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30   THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht  ELSE NULL END) as TMB3,
	(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	1-(sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20'  AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3,
	1-(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
 	AND s.cible in ('Adulte','Homme','Femme') 
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND (bo.created_at >= '2022-11-08'
		AND bo.created_at <= '2022-11-14'
		OR (bo.created_at >= '2023-11-14' 
		AND bo.created_at <= '2023-11-20' )) 
--GROUP BY Typo
ORDER BY ca_ah23 DESC





SELECT
	Top 100 bp.brand_name AS marque,
    count(DISTINCT CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bo.order_id ELSE NULL END) AS cmd_ah23,
    count(DISTINCT CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' THEN bo.order_id ELSE NULL END) AS cmd_ah23_HP,
    count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bo.order_id ELSE NULL END) AS cmd_ah22,
    count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bo.order_id ELSE NULL END) AS cmd_ah22_HP,
	sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30   THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23_HP,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22_HP--,
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
 	AND s.cible in ('Adulte','Homme','Femme') 
INNER JOIN smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND (bo.created_at >= '2022-11-08'
		AND bo.created_at <= '2022-11-14'
		OR (bo.created_at >= '2023-11-14' 
		AND bo.created_at <= '2023-11-20' )) 
GROUP BY marque
ORDER BY ca_ah23 DESC




---sous requête sessions par levier---
WITH sess AS (
SELECT
	bt.channel_grouping AS canal,
	count(DISTINCT CASE WHEN bt.Vis_date >= '2023-11-14' AND bt.Vis_date <= '2023-11-20'   THEN bt.traffic_id ELSE NULL END) AS sess_ah23,
	count(DISTINCT CASE WHEN bt.Vis_date >= '2022-11-08' AND bt.Vis_date <= '2022-11-14'  THEN bt.traffic_id ELSE NULL END) AS sess_ah22
FROM
	smallable2_datawarehouse.b_traffic bt
INNER JOIN smallable2_datawarehouse.b_countries bc ON
	bt.country_iso_code  = bc.country_iso_code 
AND bc.country_name IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
GROUP BY
	canal),
---sous requête commandes par levier---
cmd AS (
SELECT
	bt.channel_grouping AS canal,
	count(DISTINCT CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20'    THEN bo.order_id ELSE NULL END) AS cmd_ah23,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'   THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_traffic bt ON
	bt.traffic_id = bo.traffic_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bo.order_id = bop.order_id 
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc ON
	bt.country_iso_code  = bc.country_iso_code 
AND bc.country_name IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grèce','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyane', 'Saint-Barthélemy',
'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	(bo.created_at >= '2022-11-08'
		AND bo.created_at <= '2022-11-14'
		OR (bo.created_at >= '2023-11-14' 
		AND bo.created_at <= '2023-11-20'))
GROUP BY
	canal)
---requête principale---
SELECT
	sess.canal,
	sess.sess_ah23 AS sessions_ah23,
		sess.sess_ah22 AS sessions_ah22,
	cmd.cmd_ah23 AS commandes_ah23,
		cmd.cmd_ah22 AS commandes_ah22,
	cmd.ca_ah23 AS ca_ah23,
		cmd.ca_ah22 AS ca_ah22,
	cmd.cmd_ah23 / sess.sess_ah23 AS cvr_ah23,
	cmd.cmd_ah22 / sess.sess_ah22 AS cvr_ah22
FROM
	sess
INNER JOIN cmd ON
	sess.canal = cmd.canal
ORDER BY
	sessions_ah23 DESC




SELECT
	--bc.country_name  as pays,
    --s.product_type_N5 AS Typo, 
    --bop.sml_team AS secteur, 	
    count(DISTINCT CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20'  THEN bo.order_id ELSE NULL END) AS cmd_ah23,
	sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	round(sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3,
	sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	(sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20'  THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' THEN bop.billing_product_ht  ELSE NULL END) as TMB3,
	1-(sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suede', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grece','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy',
'Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie française', 'Reunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at >= '2023-11-14' AND bo.created_at <= '2023-11-20'  --AND bo.created_at <= '2022-11-14'
--	OR bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' 
--GROUP BY secteur
ORDER BY ca_ah23 DESC







SELECT
	bc.country_name  as pays,
   -- s.product_type_N5 AS Typo, --bop.sml_team AS secteur, 	
    count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	round(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	1-(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suede', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grece','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy',
'Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie française', 'Reunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  --AND bo.created_at <= '2022-11-14'
GROUP BY pays
ORDER BY ca_ah22 DESC




SELECT
	bc.country_name  as pays,
   -- s.product_type_N5 AS Typo, --bop.sml_team AS secteur, 	
	count(DISTINCT CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bo.order_id ELSE NULL END) AS cmd_ah23,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' AND bop.promo_type = 'vente-privee' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07'AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	round(sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07'  AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3,
	round(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	(sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.billing_product_ht  ELSE NULL END) as TMB3,
	(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	1-(sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30   THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07'  AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3,
	1-(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suede', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grece','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy',
'Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie française', 'Reunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	--AND bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' --AND bo.created_at <= '2022-11-14'
 	AND bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07'
	GROUP BY pays
ORDER BY ca_ah23 DESC


SELECT
	--bc.country_name AS canal,
	--count(DISTINCT CASE WHEN bt.Vis_date = '2022-12-14' THEN bt.traffic_id ELSE NULL END) AS sess_pe23,
	count(DISTINCT CASE WHEN bt.Vis_date  >= '2023-10-26' AND bt.Vis_date  <= '2023-10-31'   THEN bt.traffic_id ELSE NULL END) AS sess_pe22--,
	--count(DISTINCT CASE WHEN bt.Vis_date = '2023-01-11' THEN bt.traffic_id ELSE NULL END) AS sess_ah22
FROM
	smallable2_datawarehouse.b_traffic bt
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bt.country_id 
--and bc.country_name NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
--'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grece','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthélemy',
--'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie Française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane Française')
--GROUP BY canal




SELECT
	bc.zone_code AS zone, 
	count(DISTINCT CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bo.order_id ELSE NULL END) AS cmd_ah23,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' AND bop.promo_type = 'vente-privee' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07'AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	round(sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07'  AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3,
	round(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	(sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.billing_product_ht  ELSE NULL END) as TMB3,
	(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	1-(sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30   THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07'  AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3,
	1-(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
	AND bop.sml_team = 'mode'
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suede', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grece','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy',
'Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie française', 'Reunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'
	OR bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07'
	AND s.cible IN ('BB/Enf/Ado', 'Enfant', 'Bébé', 'Adolescent')
	GROUP BY zone
ORDER BY ca_ah23 DESC



SELECT
	bc.zone_code AS ZONE, 
	count(DISTINCT CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate = 30 THEN bo.order_id ELSE NULL END) AS cmd_ah23,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' AND bop.promo_type = 'vente-privee' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate = 30 THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate = 30 THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' AND bop.promo_type = 'vente-privee' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	(sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate = 30 THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate = 30 THEN bop.cost_product_ht ELSE NULL END))/ sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate = 30 THEN bop.billing_product_ht ELSE NULL END) AS TMB3,
	(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' AND bop.promo_type = 'vente-privee' THEN bop.cost_product_ht ELSE NULL END))/ sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht ELSE NULL END) AS TMB2,
	1-(sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate = 30 THEN bop.billing_product_ht ELSE NULL END)/ sum(CASE WHEN bo.created_at >= '2023-11-02' AND bo.created_at <= '2023-11-07' AND bop.promo_type != 'outlet' AND bop.discount_product_rate = 30 THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3,
	1-(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht ELSE NULL END)/ sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' AND bop.promo_type = 'vente-privee' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
	AND bop.sml_team = 'mode'
INNER JOIN smallable2_datawarehouse.b_skus s
ON
	bop.sku_code = s.sku_code
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
	AND bc.country_name IN ('Allemagne', 'France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suede', 'Suisse', 'Monaco', 'Danemark',
'Irlande', 'Pays-Bas', 'Monaco', 'Estonie', 'Lettonie', 'Grece', 'Lituanie', 'Slovaquie', 'Slovénie', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy',
'Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie française', 'Reunion', 'Malte', 'Andorre', 'Chypre', 'Croatie', 'Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND s.cible IN ('BB/Enf/Ado', 'Enfant', 'Bébé', 'Adolescent')
	AND (bo.created_at >= '2022-11-08'
		AND bo.created_at <= '2022-11-14'
		OR (bo.created_at >= '2023-11-02'
			AND bo.created_at <= '2023-11-07'))
GROUP BY
	ZONE
ORDER BY
	ca_ah23 DESC


--le poids de CA et volume CA des achats VP Enfant avec split Jouets vs Mode vs Design

SELECT
	--s.product_type_N4 AS Typo, bop.sml_team AS secteur, 
	count(DISTINCT CASE WHEN bo.created_at = '2023-11-02'  THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at = '2023-11-02'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
		round(sum(CASE WHEN bo.created_at = '2023-11-02'  AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	sum(CASE WHEN bo.created_at = '2023-11-02'  THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	(sum(CASE WHEN bo.created_at = '2023-11-02'  THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at = '2023-11-02' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at = '2023-11-02'  THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	1-(sum(CASE WHEN bo.created_at = '2023-11-02' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at = '2023-11-02' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
--and bc.country_name  IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suede', 'Suisse', 'Monaco','Danemark',
--'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grece','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy',
--'Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie française', 'Reunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at = '2023-11-02' 
	--AND s.cible IN ('BB/Enf/Ado', 'Enfant', 'Bébé', 'Adolescent')
--GROUP BY secteur, Typo
ORDER BY ca_ah22 DESC



--le poids de CA et volume CA des achats VP Adulte (avec split Mode vs Design)
SELECT
	--s.product_type_N4 AS Typo, 
	bc.zone_code  AS secteur, 
	--count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name  IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suede', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grece','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy',
'Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie française', 'Reunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'
	AND s.cible IN ('BB/Enf/Ado', 'Enfant', 'Bébé', 'Adolescent') --('Adulte','Homme', 'Femme')
GROUP BY secteur--, Typo
ORDER BY ca_ah22 DESC



--Enfin pourrais-tu stp me sortir le CA par zone géo par jours en nov 22 ?

 SELECT
 --toStartOfDay(bo.created_at) as jour,
 --bc.zone_code AS zone,
	--count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2022-11-01' AND bo.created_at <= '2022-11-30' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
--and bc.country_name  NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suede', 'Suisse', 'Monaco','Danemark',
--'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grece','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy',
--'Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie française', 'Reunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at >= '2022-11-01' AND bo.created_at <= '2022-11-30'
--GROUP BY zone,jour
--ORDER BY ca_ah22 DESC

	
------------------------------------ Analyse VP KIDS VS N-1 ----------------------------------
	
SELECT
	bc.zone_code AS zone, 
	count(DISTINCT CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bo.order_id ELSE NULL END) AS cmd_ah23,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' AND bop.promo_type = 'vente-privee' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30  THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	(sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31'  AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.billing_product_ht  ELSE NULL END) as TMB3,
	(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	1-(sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30   THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31'  AND bop.promo_type != 'outlet' AND bop.discount_product_rate  = 30 THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3,
	1-(sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'  AND bop.promo_type = 'vente-privee' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
	AND bop.sml_team = 'mode'
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suede', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grece','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy',
'Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie française', 'Reunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND (bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'
	OR bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31') 
	AND s.cible IN ('BB/Enf/Ado', 'Enfant', 'Bébé', 'Adolescent')
	GROUP BY zone
ORDER BY ca_ah23 DESC



--pour filtrer sur les VP AH22 :

smallable2_datawarehouse.b_order_products
bop.promo_type = vente-privee 

--pour les VP AH23 :

AND bop.promo_type != ’outlet” AND bop.promo_percent = ‘30’


SELECT DISTINCT bop.promo_type, bop.promo_percent, bo.
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
WHERE
	bop.promo_type = 'outlet'
	AND 
	bop.promo_percent = '30'
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at >= '2023-10-26'


SELECT
		count(DISTINCT CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' THEN bo.order_id ELSE NULL END) AS cmd_ah23,
		sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-31' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
WHERE
	bop.promo_type = 'outlet'
	AND bop.discount_product_rate  = 30
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1