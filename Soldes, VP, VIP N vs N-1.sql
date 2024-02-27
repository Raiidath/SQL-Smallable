SELECT
	bc.zone_code,
	count(DISTINCT bo.order_id) AS cmd,
	count(DISTINCT bo.customer_id) AS client,
	sum(bop.billing_product_ht)/ 100 AS CA,
	sum(bop.billing_product_ht / 100)/ count(DISTINCT bo.order_id) AS panier_moyen,
	count(CASE WHEN bop.nouveaute_vs_existant = 'Nouveauté' THEN bo.order_id ELSE NULL END)
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
	--inner join smallable2_datawarehouse.b_traffic bt 
	--on bt.
WHERE
	bo.created_at = '2023-05-09'
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	--and bop.sml_team = 'mode'
	--and bc.zone_code in ('UK','ROW')
GROUP BY
	bc.zone_code 


SELECT
	bc.zone_code,
	count(DISTINCT bo.order_id) AS cmd,
	count(DISTINCT bo.customer_id) AS client,
	sum(bop.billing_product_ht)/ 100 AS CA,
	sum(bop.billing_product_ht / 100)/ count(DISTINCT bo.order_id) AS panier_moyen,
	count(CASE WHEN bop.nouveaute_vs_existant = 'Nouveauté' THEN bo.order_id ELSE NULL END)
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
	bo.created_at = '2022-12-14'
	AND bc.country_name
	--not in ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Suisse', 'Monaco', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy','Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie fran�aise', 'Reunion', 'Ile Canaries')
GROUP BY
	bc.zone_code 

select distinct bc.zone_code, bc.country_name  
from smallable2_datawarehouse.b_countries bc 

------------------------------- CA et  CMD PAYS------------------------------------------------------------
SELECT
	--bc.country_name  as pays,
	--count(DISTINCT CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-17' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	count(DISTINCT CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-30'  THEN bo.order_id ELSE NULL END) AS cmd_ah23,
	--round(sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-17' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	round(sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-30' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3,
	--sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-17' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-30' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah23,
	--sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-17' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht2,
	sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-30'  THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht3,
	--(sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-17' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-17' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-17' THEN bop.billing_product_ht  ELSE NULL END) as TMB2,
	(sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-30' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-30'  THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-30'  THEN bop.billing_product_ht  ELSE NULL END) as TMB3,
	-- 1-(sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-17' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-17' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen2--, 
	 1-(sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-30'  THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-30'  THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen3
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
and bc.country_name NOT IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suede', 'Suisse', 'Monaco','Danemark',
'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grece','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy',
'Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie française', 'Reunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane française')
INNER JOIN smallable2_datawarehouse.b_traffic bt ON
	bt.traffic_id = bo.traffic_id
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	--AND bo.created_at = '2023-06-29' --AND bo.created_at <  '2023-01-23'
	--AND bo.created_at >= '2022-12-14' AND bo.created_at <= '2022-12-17'
	AND bo.created_at >= '2023-10-26' AND bo.created_at <= '2023-10-30' --AND bo.created_at <  '2022-01-24'
--GROUP BY pays
--ORDER BY ca_ah23 DESC

	

SELECT
	--bc.country_name AS canal,
	--count(DISTINCT CASE WHEN bt.Vis_date = '2022-12-14' THEN bt.traffic_id ELSE NULL END) AS sess_pe23,
	count(DISTINCT CASE WHEN bt.Vis_date  = '2023-11-02'  THEN bt.traffic_id ELSE NULL END) AS sess_pe22--,
	--count(DISTINCT CASE WHEN bt.Vis_date = '2023-01-11' THEN bt.traffic_id ELSE NULL END) AS sess_ah22
FROM
	smallable2_datawarehouse.b_traffic bt
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bt.country_id 
--and bc.country_name IN ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Portugal', 'Suède', 'Suisse', 'Monaco','Danemark',
--'Irlande','Pays-Bas','Monaco','Estonie','Lettonie','Grece','Lituanie','Slovaquie','Slovénie', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthélemy',
--'Saint-Martin', 'Nouvelle-Calédonie', 'Polynésie Française', 'Réunion', 'Malte','Andorre', 'Chypre', 'Croatie','Ile Canaries', 'Mayotte', 'Montenegro', 'Guyane Française')
--GROUP BY canal
--order by sess_pe22 desc
------------------------------------------------ZONE--------------------------------------	

SELECT
	bc.zone_code  ,
	count(DISTINCT CASE WHEN bo.created_at =  '2023-06-21'  THEN bo.order_id ELSE NULL END) AS cmd_pe23,
	count(DISTINCT CASE WHEN bo.created_at = '2023-01-04' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	count(DISTINCT CASE WHEN bo.created_at = '2022-06-15' THEN bo.order_id ELSE NULL END) AS cmd_pe22,
	sum(CASE WHEN bo.created_at =  '2023-06-21' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_pe23,
	sum(CASE WHEN bo.created_at = '2023-01-04' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	sum(CASE WHEN bo.created_at = '2022-06-15' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_pe22,
	round(sum(CASE WHEN bo.created_at  =  '2023-06-21' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP1,
	round(sum(CASE WHEN bo.created_at  = '2023-01-04' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP2,
	round(sum(CASE WHEN bo.created_at = '2022-06-15'  AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP3
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
	--and bc.country_name in ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Suisse', 'Monaco', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy'
--,'Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie fran�aise', 'Reunion', 'Ile Canaries')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	--AND bo.created_at BETWEEN '2022-06-08' AND '2022-07-19'
	AND bo.created_at =  '2023-06-21'
	--and bc.country_iso_code not in ('DE', 'FR', 'IT', 'ES', 'ROE')
	OR bo.created_at = '2023-01-04'   --AND '2021-07-27'
	OR bo.created_at = '2022-06-15'  
GROUP BY
	bc.zone_code  
ORDER BY
	ca_pe22 DESC
    
-----------------------------------------Secteur/Univer----------------------------------------------------
	
select
	distinct bop.sml_team as code,
	count(DISTINCT CASE WHEN bo.created_at = '2023-06-28' THEN bo.order_id ELSE NULL END) AS cmd_pe23,
	sum(CASE WHEN bo.created_at = '2023-06-28'  THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_pe23,
		round(sum(CASE WHEN bo.created_at = '2023-06-28' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP1,	
     sum(CASE WHEN bo.created_at = '2023-06-28' THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_ht1,
	(sum(CASE WHEN bo.created_at =  '2023-06-28' THEN bop.billing_product_ht ELSE NULL END) - sum(CASE WHEN bo.created_at = '2023-06-28' THEN bop.cost_product_ht  ELSE NULL END))/sum(CASE WHEN bo.created_at = '2023-06-28' THEN bop.billing_product_ht  ELSE NULL END) as TMB1,
	 1-(sum(CASE WHEN bo.created_at = '2023-06-28' THEN bop.billing_product_ht ELSE NULL END)/sum(CASE WHEN bo.created_at = '2023-06-28' THEN bop.billing_product_before_discount_ht ELSE NULL END)) AS taux_discount_moyen1
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_iso_code  = bop.delivery_country_iso  
--and bc.regroup_zone not in ('ROE')
--	and bc.zone_code not in ('DE', 'FR', 'IT', 'ES', 'ROE')--and bc.country_name in ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Suisse', 'Monaco', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy'
--,'Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie fran�aise', 'Reunion', 'Ile Canaries')
where
	  bo.created_at = '2023-06-28' 
group by
	code
	
---------------------------------------------%  nouveaux clients -----------------------	
	
---sous requ�te sessions par levier---
WITH sess AS (
SELECT
	bt.channel_grouping AS canal,
	count(DISTINCT CASE WHEN bt.Vis_date =  '2023-06-28' THEN bt.traffic_id ELSE NULL END) AS sess_pe23,
	count(DISTINCT CASE WHEN bt.Vis_date = '2022-06-22' THEN bt.traffic_id ELSE NULL END) AS sess_pe22,
	count(DISTINCT CASE WHEN bt.Vis_date = '2023-01-11'  THEN bt.traffic_id ELSE NULL END) AS sess_ah22
FROM
	smallable2_datawarehouse.b_traffic bt
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bt.country_id 
--and bc.regroup_zone not in ('ROE')
--and bc.zone_code not in ('DE', 'FR', 'IT', 'ES', 'ROE')
--and bc.country_name in ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Suisse', 'Monaco', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy'
--,'Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie fran�aise', 'Reunion', 'Ile Canaries')
GROUP BY
	bt.channel_grouping),
---sous requ�te commandes par levier---
cmd AS (
SELECT
	bt.channel_grouping AS canal,
	count(DISTINCT CASE WHEN bo.created_at =  '2023-06-28' THEN bo.order_id ELSE NULL END) AS cmd_pe23,
	count(DISTINCT CASE WHEN bo.created_at = '2022-06-22' THEN bo.order_id ELSE NULL END) AS cmd_pe22,
	count(DISTINCT CASE WHEN bo.created_at = '2023-01-11' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	sum(CASE WHEN bo.created_at =  '2023-06-28' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_pe23,
	sum(CASE WHEN bo.created_at = '2022-06-22' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_pe22,
	sum(CASE WHEN bo.created_at = '2023-01-11' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	count(DISTINCT CASE WHEN bo.repeat_number = 1 AND bo.created_at =  '2023-06-28' THEN bo.order_id ELSE NULL END) AS nvx_clients_pe23,
	count(DISTINCT CASE WHEN bo.repeat_number = 1 AND bo.created_at = '2022-06-22' THEN bo.order_id ELSE NULL END) AS nvx_clients_pe22,
	count(DISTINCT CASE WHEN bo.repeat_number = 1 AND bo.created_at = '2023-01-11' THEN bo.order_id ELSE NULL END) AS nvx_clients_ah22
FROM	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_traffic bt ON
	bt.traffic_id = bo.traffic_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bo.order_id = bop.order_id 
	AND bo.basket_id = bop.basket_id 
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_iso_code  = bop.delivery_country_iso  
--and bc.country_name in ('Allemagne','France', 'Autriche', 'Belgique', 'Espagne', 'Italie', 'Luxembourg', 'Suisse', 'Monaco', 'Guadeloupe', 'Martinique', 'Guyana', 'Saint-Barthelemy'
--,'Saint-Martin', 'Nouvelle-Caledonie', 'Polynesie fran�aise', 'Reunion', 'Ile Canaries'
--and bc.regroup_zone in ('EU', 'FR')
WHERE bo.created_at =  '2023-06-28'
	OR bo.created_at = '2022-06-22'
	OR bo.created_at = '2023-01-11'
GROUP BY
	canal)
---requ�te principale---
SELECT
	sess.canal, 
	sess.sess_pe23 AS sessions_pe23,
	cmd.cmd_pe23 AS commandes_pe23,	
	cmd.cmd_pe23 / sess.sess_pe23 AS cvr_pe23, ca_pe23, 
	sess.sess_pe22 AS sessions_pe22,
	cmd.cmd_pe22 AS commandes_pe22,
	cmd.cmd_pe22 / sess.sess_pe22 AS cvr_pe22,ca_pe22,	
	sess.sess_ah22 AS sessions_ah22,
	cmd.cmd_ah22 AS commandes_ah22,
	cmd.cmd_ah22 / sess.sess_ah22 AS cvr_ah22,ca_ah22,
	cmd.nvx_clients_pe23,
	cmd.nvx_clients_pe22, 	
	cmd.nvx_clients_ah22,
	cmd.nvx_clients_pe23/cmd.cmd_pe23 as "% nouveaux clients pe23",
	cmd.nvx_clients_pe22/cmd.cmd_pe22 as "% nouveaux clients pe22",
	cmd.nvx_clients_ah22/cmd.cmd_ah22 as "% nouveaux clients ah22"
FROM
	sess
INNER JOIN cmd ON
	sess.canal = cmd.canal
ORDER BY
	sessions_pe23 DESC
	
	
	
SELECT
	bo.created_at as d,
	count(DISTINCT bo.order_id) AS cmd,
	count(distinct bop.sku_id) as sku,
	count(distinct bo.customer_id)
FROM
	smallable2_datawarehouse.b_orders bo
	inner join smallable2_datawarehouse.b_order_products bop on bop.order_id = bo.order_id 
WHERE bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at IN ('2022-11-08', '2022-11-09')
	group by d
	
----------------------------------------------- filtr� ADW - Hors NDM ---------------------------
---sous requ�te sessions par levier---
WITH sess AS (
SELECT
	bc.zone_code  AS canal,
	count(DISTINCT CASE WHEN bt.ref_date >= '2022-11-08' AND bt.ref_date <= '2022-11-14' THEN bt.traffic_id ELSE NULL END) AS sess_ah22--,
	--count(DISTINCT CASE WHEN bt.ref_date >= '2021-11-09' AND bt.ref_date <= '2021-11-12' THEN bt.traffic_id ELSE NULL END) AS sess_ah21
FROM
	smallable2_datawarehouse.b_traffic bt
INNER JOIN smallable2_datawarehouse.b_countries bc ON
	bt.country_iso_code  = bc.country_iso_code 
AND bt.channel_grouping = 'ADW - Hors NDM'
GROUP BY
	canal),
---sous requ�te commandes par levier---
cmd AS (
SELECT
	bc.zone_code  AS canal,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	--count(DISTINCT CASE WHEN bo.created_at >= '2021-11-09' AND bo.created_at <= '2021-11-12' THEN bo.order_id ELSE NULL END) AS cmd_ah21,
	count(DISTINCT CASE WHEN bo.repeat_number = 1 AND bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bo.order_id ELSE NULL END) AS nvx_clients_ah22,
	--count(DISTINCT CASE WHEN bo.repeat_number = 1 AND bo.created_at >= '2021-11-09' AND bo.created_at <= '2021-11-12' THEN bo.order_id ELSE NULL END) AS nvx_clients_ah21,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22--,
	--sum(CASE WHEN bo.created_at >= '2021-11-09' AND bo.created_at <= '2021-11-12' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah21
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
	AND bt.channel_grouping = 'ADW - Hors NDM'
WHERE bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'
	--OR bo.created_at >= '2021-11-09' AND bo.created_at <= '2021-11-12'
GROUP BY
	canal)
---requ�te principale---
SELECT
	sess.canal,
	sess.sess_ah22 AS sessions_ah22,--	sess.sess_ah21 AS sessions_ah21,
	cmd.cmd_ah22 AS commandes_ah22, 	--cmd.cmd_ah21 AS commandes_ah21,
	ca_ah22, --ca_ah21,
	cmd.cmd_ah22 / sess.sess_ah22 AS cvr_ah22,
	--cmd.cmd_ah21 / sess.sess_ah22 AS cvr_ah21,
	cmd.nvx_clients_ah22,
	--cmd.nvx_clients_ah21,
	cmd.nvx_clients_ah22/cmd.cmd_ah22 as "% nouveaux clients ah22"--,
	--cmd.nvx_clients_ah21/cmd.cmd_ah21 as "% nouveaux clients ah21"
FROM
	sess
INNER JOIN cmd ON
	sess.canal = cmd.canal
ORDER BY
	commandes_ah22 DESC
		
--------------------------------- SHOPPING ------------------------------------
---sous requ�te sessions par levier---
WITH sess AS (
SELECT
	bc.zone_code AS canal,
	count(DISTINCT CASE WHEN bt.ref_date >= '2022-11-08' AND bt.ref_date <= '2022-11-14' THEN bt.traffic_id ELSE NULL END) AS sess_ah22--,
	--count(DISTINCT CASE WHEN bt.ref_date >= '2021-11-09' AND bt.ref_date <= '2021-11-12' THEN bt.traffic_id ELSE NULL END) AS sess_ah21
FROM
	smallable2_datawarehouse.b_traffic bt
INNER JOIN smallable2_datawarehouse.b_countries bc ON
	bc.country_id = bt.country_id 
WHERE
	bt.campaign ilike '%shopping%'
	OR bt.campaign ilike '%pmax%'
GROUP BY
	bc.zone_code),
---sous requ�te commandes par levier---
cmd AS (
SELECT
	bc.zone_code  AS canal,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	--count(DISTINCT CASE WHEN bo.created_at >= '2021-11-09' AND bo.created_at <= '2021-11-12' THEN bo.order_id ELSE NULL END) AS cmd_ah21,
	count(DISTINCT CASE WHEN bo.repeat_number = 1 AND bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bo.order_id ELSE NULL END) AS nvx_clients_ah22,
	--count(DISTINCT CASE WHEN bo.repeat_number = 1 AND bo.created_at >= '2021-11-09' AND bo.created_at <= '2021-11-12' THEN bo.order_id ELSE NULL END) AS nvx_clients_ah21,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22--,
--	sum(CASE WHEN bo.created_at >= '2021-11-09' AND bo.created_at <= '2021-11-12' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah21
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
	bc.country_id = bt.country_id 
WHERE 
	bt.campaign ilike '%shopping%'
	OR bt.campaign ilike '%pmax%'
	--AND bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-11'
	--OR bo.created_at >= '2021-11-09' AND bo.created_at <= '2021-11-12'
GROUP BY
	canal)
---requ�te principale---
SELECT
	sess.canal,
	sess.sess_ah22 AS sessions_ah22, 	--sess.sess_ah21 AS sessions_ah21,
	cmd.cmd_ah22 AS commandes_ah22, 	--cmd.cmd_ah21 AS commandes_ah21,
	ca_ah22, --ca_ah21,
	cmd.cmd_ah22 / sess.sess_ah22 AS cvr_ah22,
	--cmd.cmd_ah21 / sess.sess_ah22 AS cvr_ah21,
	cmd.nvx_clients_ah22,
	--cmd.nvx_clients_ah21,
	cmd.nvx_clients_ah22/cmd.cmd_ah22 as "% nouveaux clients ah22"--,
	--cmd.nvx_clients_ah21/cmd.cmd_ah21 as "% nouveaux clients ah21"
FROM
	sess
INNER JOIN cmd ON
	sess.canal = cmd.canal
ORDER BY
	commandes_ah22 DESC
		
	
	
	
	
	
SELECT
	*
FROM
	smallable2_datawarehouse.b_traffic bt
WHERE
	bt.campaign ilike '%shopping%'
	OR bt.campaign ilike '%pmax%'
	
	
------------------------------------------LEVIER Soldes VP --------------------------------------------------
SELECT
	bt.channel_grouping as total,
	count(DISTINCT CASE WHEN bt.Vis_date = '2022-11-08' THEN bt.traffic_id ELSE NULL END) AS AH22,
	count(DISTINCT CASE WHEN bt.Vis_date = '2021-11-09' THEN bt.traffic_id ELSE NULL END) AS AH21
FROM
	smallable2_datawarehouse.b_traffic bt
GROUP BY
	bt.channel_grouping

	
	
---sous requ�te sessions par levier---
WITH sess AS (
SELECT
	bt.channel_grouping AS canal,
	count(DISTINCT CASE WHEN bt.Vis_date = '2022-11-09' THEN bt.traffic_id ELSE NULL END) AS sess_ah22,
	count(DISTINCT CASE WHEN bt.Vis_date = '2021-11-10' THEN bt.traffic_id ELSE NULL END) AS sess_ah21
FROM
	smallable2_datawarehouse.b_traffic bt
GROUP BY
	bt.channel_grouping),
---sous requ�te commandes par levier---
cmd AS (
SELECT
	bt.channel_grouping AS canal,
	count(DISTINCT CASE WHEN bo.created_at = '2022-11-09' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	count(DISTINCT CASE WHEN bo.created_at = '2021-11-10' THEN bo.order_id ELSE NULL END) AS cmd_ah21
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_traffic bt ON
	bt.traffic_id = bo.traffic_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at IN ('2022-11-09', '2021-11-10')
GROUP BY
	canal)
---requ�te principale---
SELECT
	sess.canal,
	sess.sess_ah22 AS sessions_ah22,
	cmd.cmd_ah22 AS commandes_ah22,
	cmd.cmd_ah22 / sess.sess_ah22 AS cvr_ah22,
	sess.sess_ah21 AS sessions_ah21,
	cmd.cmd_ah21 AS commandes_ah21,
	cmd.cmd_ah21 / sess.sess_ah22 AS cvr_ah21
FROM
	sess
INNER JOIN cmd ON
	sess.canal = cmd.canal
ORDER BY
	commandes_ah22 DESC
--count(DISTINCT CASE WHEN bt.Vis_date >= '2021-12-15' AND bt.Vis_date <= '2022-02-08' THEN bt.traffic_id  ELSE NULL END) AS ah21,
	

--------------------- R�partition des ventes selon remises  ---------------------------------------------------------------------

select
toStartOfWeek(bo.created_at) as Day,
--	count(distinct case when bop.discount_product_rate_range = '20%' AND bo.created_at BETWEEN '2021-12-15' AND '2022-02-08' 
-- then bop.product_id else null end) as remise20AH21,
--	count(distinct case when bop.discount_product_rate_range = '30%' AND bo.created_at BETWEEN '2021-12-15' AND '2022-02-08' 
--then bop.product_id else null end) as remise30AH21,
--	count(distinct case when bop.discount_product_rate_range = '40%' AND bo.created_at BETWEEN '2021-12-15' AND '2022-02-08' 
--then bop.product_id else null end) as remise40AH21,
--	count(distinct case when bop.discount_product_rate_range = '50%' AND bo.created_at BETWEEN '2021-12-15' AND '2022-02-08' 
--then bop.product_id else null end) as remise50AH21,
--	count(distinct case when bop.discount_product_rate_range = '60%' AND bo.created_at BETWEEN '2021-12-15' AND '2022-02-08' 
--then bop.product_id else null end) as remise60AH21,
--	count(distinct case when bop.discount_product_rate_range = '70%' AND bo.created_at BETWEEN '2021-12-15' AND '2022-02-08' 
--then bop.product_id else null end) as remise70AH21
--	count(distinct case when bop.discount_product_rate_range = '20%' AND bo.created_at BETWEEN '2021-06-09' AND '2021-07-27'
--then bop.product_id else null end) as remise20PE21,
--	count(distinct case when bop.discount_product_rate_range = '30%' AND bo.created_at BETWEEN '2021-06-09' AND '2021-07-27' 
--then bop.product_id else null end) as remise30PE21,
--	count(distinct case when bop.discount_product_rate_range = '40%' AND bo.created_at BETWEEN '2021-06-09' AND '2021-07-27' 
--then bop.product_id else null end) as remise40PE21,
--	count(distinct case when bop.discount_product_rate_range = '50%' AND bo.created_at BETWEEN '2021-06-09' AND '2021-07-27' 
--then bop.product_id else null end) as remise50PE21,
--	count(distinct case when bop.discount_product_rate_range = '60%' AND bo.created_at BETWEEN '2021-06-09' AND '2021-07-27'
--then bop.product_id else null end) as remise60PE21,
--	count(distinct case when bop.discount_product_rate_range = '70%' AND bo.created_at BETWEEN '2021-06-09' AND '2021-07-27'
--then bop.product_id else null end) as remise70PE21,
	count(distinct case when bop.discount_product_rate_range = '20%' AND bo.created_at BETWEEN '2022-06-08' AND '2022-07-19'
then bop.product_id else null end) as remise20PE22,
	count(distinct case when bop.discount_product_rate_range = '30%' AND bo.created_at BETWEEN '2022-06-08' AND '2022-07-19'
then bop.product_id else null end) as remise30PE22,
	count(distinct case when bop.discount_product_rate_range = '40%' AND bo.created_at BETWEEN '2022-06-08' AND '2022-07-19' 
then bop.product_id else null end) as remise40PE22,
	count(distinct case when bop.discount_product_rate_range = '50%' AND bo.created_at BETWEEN '2022-06-08' AND '2022-07-19'
then bop.product_id else null end) as remise50PE22,
	count(distinct case when bop.discount_product_rate_range = '60%' AND bo.created_at BETWEEN '2022-06-08' AND '2022-07-19'
then bop.product_id else null end) as remise60PE22,
	count(distinct case when bop.discount_product_rate_range = '70%' AND bo.created_at BETWEEN '2022-06-08' AND '2022-07-19'
then bop.product_id else null end) as remise70PE22
from
	smallable2_datawarehouse.b_order_products bop
INNER JOIN smallable2_datawarehouse.b_orders bo
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_products bp 
ON
	bp.product_id = bop.product_id 
--AND bp.season = 'AH21'
WHERE bo.created_at >= '2022-06-08' AND  bo.created_at <= '2022-07-19'
group by Day
	


select
	count(distinct case when bop.discount_product_rate_range = '20%' AND bo.created_at BETWEEN '2022-06-08' AND '2022-07-19'
then bop.product_id else null end) as remise20PE22,
	count(distinct case when bop.discount_product_rate_range = '30%' AND bo.created_at BETWEEN '2022-06-08' AND '2022-07-19'
then bop.product_id else null end) as remise30PE22,
	count(distinct case when bop.discount_product_rate_range = '40%' AND bo.created_at BETWEEN '2022-06-08' AND '2022-07-19' 
then bop.product_id else null end) as remise40PE22,
	count(distinct case when bop.discount_product_rate_range = '50%' AND bo.created_at BETWEEN '2022-06-08' AND '2022-07-19'
then bop.product_id else null end) as remise50PE22,
	count(distinct case when bop.discount_product_rate_range = '60%' AND bo.created_at BETWEEN '2022-06-08' AND '2022-07-19'
then bop.product_id else null end) as remise60PE22,
	count(distinct case when bop.discount_product_rate_range = '70%' AND bo.created_at BETWEEN '2022-06-08' AND '2022-07-19'
then bop.product_id else null end) as remise70PE22
from
	smallable2_datawarehouse.b_order_products bop
INNER JOIN smallable2_datawarehouse.b_orders bo
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_products bp 
ON
	bp.product_id = bop.product_id 
AND bp.season = 'PE22'
WHERE bo.created_at >= '2022-06-08' AND  bo.created_at <= '2022-07-19'


select
	distinct order_id, 
	bop.discount_product_rate,
	bop.discount_product_rate_range
from
	smallable2_datawarehouse.b_order_products bop
INNER JOIN smallable2_datawarehouse.b_orders bo
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
where
	bo.created_at BETWEEN '2022-06-08' AND '2022-07-19'
	OR bo.created_at BETWEEN '2021-06-09' AND '2021-07-27'
	OR bo.created_at BETWEEN '2021-12-15' AND '2022-02-08' 
	
	
-------------------------------Perf par univers et typologies ----------------------------------------------
	
SELECT
	bs.product_type_N5  ,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	--count(DISTINCT CASE WHEN bo.created_at >= '2021-11-09' AND bo.created_at <= '2021-11-12' THEN bo.order_id ELSE NULL END) AS cmd_ah21,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22--,
	--sum(CASE WHEN bo.created_at >= '2021-11-09' AND bo.created_at <= '2021-11-12' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah21
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus bs 
ON
	bs.sku_id  = bop.sku_id 
	AND bs.brand_id != '940'
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'
	--OR bo.created_at >= '2021-11-09' AND bo.created_at <= '2021-11-12'  
GROUP BY
	bs.product_type_N5  
ORDER BY
	ca_ah22 DESC
	

SELECT
	bp.product_type_N4_refco  ,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	--count(DISTINCT CASE WHEN bo.created_at >= '2021-11-09' AND bo.created_at <= '2021-11-12' THEN bo.order_id ELSE NULL END) AS cmd_ah21,
	sum(CASE WHEN bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22--,
	--sum(CASE WHEN bo.created_at >= '2021-11-09' AND bo.created_at <= '2021-11-12' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah21
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus bs 
ON
	bs.sku_id  = bop.sku_id 
	AND bs.brand_id != '940'
left join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
	--and bp.sml_team = 'mode'
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at >= '2022-11-08' AND bo.created_at <= '2022-11-14'
	--OR bo.created_at >= '2021-11-09' AND bo.created_at <= '2021-11-12' 
GROUP BY
	bp.product_type_N4_refco  
ORDER BY
	ca_ah22 DESC
	

	
select
	count(DISTINCT CASE WHEN bo.created_at >= '2022-06-08' AND bo.created_at <= '2022-07-19' AND bp.season = 'PE22' THEN bop.product_id ELSE NULL END) AS cmd_pe22,
	count(DISTINCT CASE WHEN bo.created_at >= '2021-12-15' AND bo.created_at <= '2022-02-08' AND bp.season = 'AH21' THEN bop.product_id ELSE NULL END) AS cmd_ah21,
	count(DISTINCT CASE WHEN bo.created_at >= '2021-06-09' AND bo.created_at <= '2021-07-27' AND bp.season = 'PE21' THEN bop.product_id ELSE NULL END) AS cmd_pe21
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus bs 
ON
	bs.sku_id = bop.sku_id
left join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
	and bp.sml_team = 'mode'
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at BETWEEN '2022-06-08' AND '2022-07-19'
	OR bo.created_at BETWEEN '2021-06-09' AND '2021-07-27'
	OR bo.created_at BETWEEN '2021-12-15' AND '2022-02-08' 
	
	
----------------------------------- Stocks ---------------------------------------------------------------
select *
from smallable2_playground.soldes s

select
	s.periode_soldes,
	count(distinct s.ref_co)
from
	smallable2_playground.soldes s
group by
	s.periode_soldes 

select
	s.remise_3eme_dem * 100 as remise,
	count(distinct case when s.periode_soldes = 'AH21' then s.id_product else null end) as AH21,
	count(distinct case when s.periode_soldes = 'PE21' then s.id_product else null end) as PE21,
	count(distinct case when s.periode_soldes = 'PE22' then s.id_product else null end)as PE22
from
	smallable2_playground.soldes s
group by
	remise
order by remise asc


select
	bs.univers  as univers,
	count(distinct case when s.id_product = bs.product_id then s.id_product else null end) as Nb_Stocks,
	count(case when s.id_product = bop.product_id then s.id_product else null end)
from
	smallable2_playground.soldes s
inner join smallable2_datawarehouse.b_skus bs 
on
	s.id_product  = bs.product_id 
inner join smallable2_datawarehouse.b_order_products bop 
on bop.product_id = s.id_product 
group by
	univers 
order by Nb_Stocks desc 

	
	
select *
FROM smallable2_datawarehouse.b_skus bs 



--------------------------------------CA jour -------------------
select bo.created_at as date, sum(CASE WHEN bo.created_at >= '2022-11-01' AND bo.created_at <= '2022-11-31' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca
from smallable2_datawarehouse.b_orders bo 
inner join smallable2_datawarehouse.b_order_products bop 
on bo.order_id = bop.order_id 
and bo.basket_id = bop.basket_id 
where bo.created_at >= '2022-11-01' AND bo.created_at <= '2022-11-31' 
group by date
