---------------------------------------------%  nouveaux clients -----------------------	
	
---sous requête sessions par levier---
WITH sess AS (
SELECT
	bt.channel_grouping AS canal,
	count(DISTINCT CASE WHEN bt.Vis_date >= '2022-12-14' AND bt.Vis_date < '2023-01-11' THEN bt.traffic_id ELSE NULL END) AS sess_ah22,
	count(DISTINCT CASE WHEN bt.Vis_date >= '2021-12-15' AND bt.Vis_date < '2022-01-12' THEN bt.traffic_id ELSE NULL END) AS sess_ah21
FROM
	smallable2_datawarehouse.b_traffic bt
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bt.country_id 
and bc.zone_code in ('ME')--('CN', 'KR', 'JP', 'ROA', 'UK', 'US', 'ME')
GROUP BY
	bt.channel_grouping),
---sous requête commandes par levier---
cmd AS (
SELECT
	bt.channel_grouping AS canal,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <  '2023-01-11' THEN bo.order_id ELSE NULL END) AS cmd_ah22,
	count(DISTINCT CASE WHEN  bo.created_at >= '2021-12-15'AND bo.created_at <  '2022-01-12' THEN bo.order_id ELSE NULL END) AS cmd_ah21,
	count(DISTINCT CASE WHEN bo.repeat_number = 1 AND bo.created_at >= '2022-12-14' AND bo.created_at <  '2023-01-11' THEN bo.order_id ELSE NULL END) AS nvx_clients_ah22,
	count(DISTINCT CASE WHEN bo.repeat_number = 1 AND  bo.created_at >= '2021-12-15'AND bo.created_at <  '2022-01-12' THEN bo.order_id ELSE NULL END) AS nvx_clients_ah21,
	sum(CASE WHEN bo.created_at >= '2022-12-14' AND bo.created_at <  '2023-01-11' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah22,
	sum(CASE WHEN  bo.created_at >= '2021-12-15'AND bo.created_at <  '2022-01-12' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_ah21
FROM
	smallable2_datawarehouse.b_orders bo
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
and bc.zone_code in ('ME')--('CN', 'KR', 'JP', 'ROA', 'UK', 'US', 'ME')
WHERE bo.created_at >= '2022-12-14' AND bo.created_at <  '2023-01-11'
	OR bo.created_at >= '2021-12-15'AND bo.created_at <  '2022-01-12' 
GROUP BY
	canal)
---requête principale---
SELECT
	sess.canal, 	sess.sess_ah22 AS sessions_ah22,
	cmd.cmd_ah22 AS commandes_ah22,	cmd.cmd_ah22 / sess.sess_ah22 AS cvr_ah22, ca_ah22, 
	sess.sess_ah21 AS sessions_ah21,
	cmd.cmd_ah21 AS commandes_ah21,
	cmd.cmd_ah21 / sess.sess_ah21 AS cvr_ah21,	ca_ah21,
	cmd.nvx_clients_ah22,
	cmd.nvx_clients_ah21,
	cmd.nvx_clients_ah22/cmd.cmd_ah22 as "% nouveaux clients ah22",
	cmd.nvx_clients_ah21/cmd.cmd_ah21 as "% nouveaux clients ah21"
FROM
	sess
INNER JOIN cmd ON
	sess.canal = cmd.canal
ORDER BY
	sessions_ah22 DESC
	
	
	
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
	
----------------------------------------------- filtré ADW - Hors NDM ---------------------------
---sous requête sessions par levier---
WITH sess AS (
SELECT
	bc.zone_code  AS canal,
	count(DISTINCT CASE WHEN bt.Vis_date >= '2022-11-08' AND bt.Vis_date <= '2022-11-14' THEN bt.traffic_id ELSE NULL END) AS sess_ah22--,
	count(DISTINCT CASE WHEN bt.Vis_date >= '2021-11-09' AND bt.Vis_date <= '2021-11-12' THEN bt.traffic_id ELSE NULL END) AS sess_ah21
FROM
	smallable2_datawarehouse.b_traffic bt
INNER JOIN smallable2_datawarehouse.b_countries bc ON
	bt.country_iso_code  = bc.country_iso_code 
AND bt.channel_grouping = 'ADW - Hors NDM'
GROUP BY
	canal),
---sous requête commandes par levier---
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
---requête principale---
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