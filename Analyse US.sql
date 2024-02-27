----------------------------- Zone US global
select 
	case
		when bo.created_at >= '2020-08-01' AND bo.created_at <=  '2021-07-31' then 'FY2021'
		when  bo.created_at >= '2021-08-01' AND bo.created_at <=  '2022-07-31' then 'FY2122'
		when  bo.created_at >= '2022-08-01' AND bo.created_at <=  '2023-03-31' then 'FY2223'
		else 'Autres'
	end as Year,
	round(sum(CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA,
	count(DISTINCT CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' THEN bo.order_id ELSE NULL END) AS Cmd,
	round(CA / Cmd, 0) as PM,	
	sum( CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' THEN bop.qty_ordered  ELSE NULL END) as N_produits,
	round(N_produits / Cmd, 0) as N_ProduitsMoyen,
	round(sum(CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP,
	count(distinct CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients,
	Nvx_clients/Cmd as "% nouveaux clients ah22"
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
	AND bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' 
	AND bc.zone_code = 'US'
group by Year
ORDER BY
	Year ASC

------------------ Global site --------------------------------	
select 
	round(sum(CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA,
	count(DISTINCT CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' THEN bo.order_id ELSE NULL END) AS Cmd,
	round(CA / Cmd, 0) as PM,	
	sum( CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' THEN bop.qty_ordered  ELSE NULL END) as N_produits,
	round(N_produits / Cmd, 2) as N_ProduitsMoyen,
	round(sum(CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP,
	count(distinct CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients,
	Nvx_clients/Cmd as "% nouveaux clients ah22"
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
	AND bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' 
	
	
	
select 
	case
		when bt.Vis_date >= '2020-08-01' AND bt.Vis_date <=  '2021-07-31' then 'FY2021'
		when  bt.Vis_date >= '2021-08-01' AND bt.Vis_date <=  '2022-07-31' then 'FY2122'
		when bt.Vis_date >= '2022-08-01' AND bt.Vis_date <=  '2023-03-31' then 'FY2223'
		else 'Autres'
	end as Year,
	count( CASE WHEN bt.Vis_date >= '2020-08-01' AND bt.Vis_date <  '2023-03-31' THEN bt.traffic_id ELSE NULL END) AS Session
FROM smallable2_datawarehouse.b_countries bc 
INNER JOIN smallable2_datawarehouse.b_traffic bt 
ON
	bc.country_id = bt.country_id 
WHERE bt.Vis_date >= '2020-08-01' AND bt.Vis_date <=  '2023-03-31' 
	AND bc.zone_code = 'US'
group by Year
ORDER BY
	Year ASC

------------------------------ Split Mode vs Design

select 	bp.sml_team  as Secteur ,
	round(sum(CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA,
	count(DISTINCT CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' THEN bo.order_id ELSE NULL END) AS Cmd,
	round(CA / Cmd, 0) as PM,	
	sum( CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' THEN bop.qty_ordered ELSE NULL END) as N_produits,
	round(N_produits / Cmd, 0) as N_ProduitsMoyen,
	round(sum(CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP,
	count(distinct CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients,
	Nvx_clients/Cmd as "% nouveaux clients"
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
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bop.product_id 
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' 
	AND bc.zone_code = 'US'
group by Secteur
ORDER BY
	CA DESC
	
	
select 	bp.sml_team  as Secteur ,
	round(sum(CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA,
	count(DISTINCT CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' THEN bo.order_id ELSE NULL END) AS Cmd,
	round(CA / Cmd, 0) as PM,	
	sum( CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' THEN bop.qty_ordered ELSE NULL END) as N_produits,
	round(N_produits / Cmd, 0) as N_ProduitsMoyen,
	round(sum(CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP,
	count(distinct CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients,
	Nvx_clients/Cmd as "% nouveaux clients"
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
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bop.product_id 
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' 
group by Secteur
ORDER BY
	CA DESC


select
	--bp.sml_team as Secteur,
	count( CASE WHEN bt.Vis_date >= '2020-08-01' AND bt.Vis_date < '2023-03-31' THEN bt.traffic_id ELSE NULL END) AS Session
FROM
	smallable2_datawarehouse.b_countries bc
INNER JOIN smallable2_datawarehouse.b_traffic bt 
ON
	bc.country_id = bt.country_id
WHERE
	bt.Vis_date >= '2020-08-01'
	AND bt.Vis_date <= '2023-03-31'
	AND bc.zone_code = 'US'
	
------------------------------ Split US vs Canada   01/04/2022 au 31/03/2023 vs N-1 01/04/2021 au 31/03/2022
select --	bc.country_name  as Pays ,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N1,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N,
	count(DISTINCT CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N1,
	round(CA_N / Cmd_N, 0) as PM_N,		round(CA_N1 / Cmd_N1, 0) as PM_N1,	
	sum( CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' THEN bop.qty_ordered ELSE NULL END) as N_produits_N,
	sum( CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-3'  THEN bop.qty_ordered ELSE NULL END) as N_produits_N1,
	round(N_produits_N / Cmd_N, 0) as N_ProduitsMoyen_N, round(N_produits_N1 / Cmd_N1, 0) as N_ProduitsMoyen_N1,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP_N1,
	count(distinct CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients_N,
	count(distinct CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients_N1,
	Nvx_clients_N/Cmd_N as "% nouveaux clients",
	Nvx_clients_N1/Cmd_N1 as "% nouveaux clients N1"
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
	AND bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31'
	OR bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31'
	--AND bc.zone_code = 'US'
	--AND bc.country_name in ('Etats-Unis', 'Canada')
--group by Pays
ORDER BY
	CA_N DESC
	

select
	bt.country as Pays, 
	count( CASE WHEN bt.Vis_date >= '2022-04-01' AND bt.Vis_date < '2023-03-31' THEN bt.traffic_id ELSE NULL END) AS Session_N,
	count( CASE WHEN bt.Vis_date >= '2021-04-01' AND bt.Vis_date < '2022-03-31' THEN bt.traffic_id ELSE NULL END) AS Session_N1
FROM
	smallable2_datawarehouse.b_countries bc
INNER JOIN smallable2_datawarehouse.b_traffic bt 
ON
	bc.country_id = bt.country_id
WHERE
	bt.Vis_date >= '2022-04-01' AND bt.Vis_date < '2023-03-31'
	OR bt.Vis_date >= '2021-04-01' AND bt.Vis_date < '2022-03-31' 
	AND bc.zone_code = 'US'	
group by Pays
ORDER BY Session_N DESC
	

select 	bp.sml_team  as Secteur ,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N1,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N,
	count(DISTINCT CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N1,
	round(CA_N / Cmd_N, 0) as PM_N,		round(CA_N1 / Cmd_N1, 0) as PM_N1,	
	sum( CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' THEN bop.qty_ordered ELSE NULL END) as N_produits_N,
	sum( CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-3'  THEN bop.qty_ordered ELSE NULL END) as N_produits_N1,
	round(N_produits_N / Cmd_N, 0) as N_ProduitsMoyen_N, round(N_produits_N1 / Cmd_N1, 0) as N_ProduitsMoyen_N1,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP_N1,
	count(distinct CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients_N,
	count(distinct CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients_N1,
	Nvx_clients_N/Cmd_N as "% nouveaux clients",
	Nvx_clients_N1/Cmd_N1 as "% nouveaux clients N1"
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
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bop.product_id 
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	--AND bc.zone_code = 'US'
	AND bc.country_iso_code  = 'US'
	--AND bt.country_raw  = 'États-Unis'
	--AND bc.country_name  = 'États-Unis'
group by Secteur
ORDER BY
	CA_N DESC

	
------------------------------- Split levier free / paid
select 	bc.country_name  as Pays , bt.source_paid_vs_free ,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N1,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N,
	count(DISTINCT CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N1,
	round(CA_N / Cmd_N, 0) as PM_N,		round(CA_N1 / Cmd_N1, 0) as PM_N1,	
	sum( CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' THEN bop.qty_ordered ELSE NULL END) as N_produits_N,
	sum( CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-3'  THEN bop.qty_ordered ELSE NULL END) as N_produits_N1,
	round(N_produits_N / Cmd_N, 0) as N_ProduitsMoyen_N, round(N_produits_N1 / Cmd_N1, 0) as N_ProduitsMoyen_N1,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP_N1,
	count(distinct CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients_N,
	count(distinct CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients_N1,
	Nvx_clients_N/Cmd_N as "% nouveaux clients",
	Nvx_clients_N1/Cmd_N1 as "% nouveaux clients N1"
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
	AND bc.country_iso_code  = 'CA'
group by Pays ,bt.source_paid_vs_free 
ORDER BY
	CA_N DESC
	
	
select 	bc.country_name  as Pays , bt.source_paid_vs_free ,
	count( CASE WHEN bt.Vis_date >= '2022-04-01' AND bt.Vis_date < '2023-03-31' THEN bt.traffic_id ELSE NULL END) AS Session,
	count( CASE WHEN bt.Vis_date >= '2021-04-01' AND bt.Vis_date < '2022-03-31' THEN bt.traffic_id ELSE NULL END) AS Session_N1
FROM smallable2_datawarehouse.b_countries bc 
INNER JOIN smallable2_datawarehouse.b_traffic bt 
ON
	bc.country_id = bt.country_id 
WHERE 	 bc.zone_code = 'US'
group by Pays, bt.source_paid_vs_free 
order by Pays, Session desc


------------------------------- Split device
select 	bc.country_name  as Pays , bt.device_grouping  ,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N1,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N,
	count(DISTINCT CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N1,
	round(CA_N / Cmd_N, 0) as PM_N,		round(CA_N1 / Cmd_N1, 0) as PM_N1,	
	sum( CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' THEN bop.qty_ordered ELSE NULL END) as N_produits_N,
	sum( CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-3'  THEN bop.qty_ordered ELSE NULL END) as N_produits_N1,
	round(N_produits_N / Cmd_N, 0) as N_ProduitsMoyen_N, round(N_produits_N1 / Cmd_N1, 0) as N_ProduitsMoyen_N1,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP_N1,
	count(distinct CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients_N,
	count(distinct CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients_N1,
	Nvx_clients_N/Cmd_N as "% nouveaux clients",
	Nvx_clients_N1/Cmd_N1 as "% nouveaux clients N1"
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
	AND bc.country_iso_code  = 'CA'
	AND bt.channel_grouping = 'ADW - Hors NDM'
group by Pays,bt.device_grouping  
order by CA_N desc

select 	bc.country_name  as Pays , bt.device_grouping ,
	count( CASE WHEN bt.Vis_date >= '2022-04-01' AND bt.Vis_date < '2023-03-31' THEN bt.traffic_id ELSE NULL END) AS Session,
	count( CASE WHEN bt.Vis_date >= '2021-04-01' AND bt.Vis_date < '2022-03-31' THEN bt.traffic_id ELSE NULL END) AS Session_N1
FROM smallable2_datawarehouse.b_countries bc 
INNER JOIN smallable2_datawarehouse.b_traffic bt 
ON
	bc.country_id = bt.country_id 
WHERE bc.zone_code = 'US'	AND bt.channel_grouping = 'ADW - Hors NDM'
group by Pays, bt.device_grouping  
order by Session desc


------------------------------- Split leviers/canaux
select  bt.channel_grouping  ,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N1,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N,
	count(DISTINCT CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N1,
	round(CA_N / Cmd_N, 0) as PM_N,		round(CA_N1 / Cmd_N1, 0) as PM_N1,	
	sum( CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' THEN bop.qty_ordered ELSE NULL END) as N_produits_N,
	sum( CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-3'  THEN bop.qty_ordered ELSE NULL END) as N_produits_N1,
	round(N_produits_N / Cmd_N, 0) as N_ProduitsMoyen_N, round(N_produits_N1 / Cmd_N1, 0) as N_ProduitsMoyen_N1,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP_N1,
	count(distinct CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients_N,
	count(distinct CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients_N1,
	Nvx_clients_N/Cmd_N as "% nouveaux clients",
	Nvx_clients_N1/Cmd_N1 as "% nouveaux clients N1"
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
	AND bc.zone_code = 'US'
group by bt.channel_grouping  
order by CA_N desc



select bt.channel_grouping ,
	count( CASE WHEN bt.Vis_date >= '2022-04-01' AND bt.Vis_date < '2023-03-31' THEN bt.traffic_id ELSE NULL END) AS Session,
	count( CASE WHEN bt.Vis_date >= '2021-04-01' AND bt.Vis_date < '2022-03-31' THEN bt.traffic_id ELSE NULL END) AS Session_N1
FROM smallable2_datawarehouse.b_countries bc 
INNER JOIN smallable2_datawarehouse.b_traffic bt 
ON
	bc.country_id = bt.country_id 
WHERE bc.zone_code = 'US'
	AND bc.zone_code = 'US'
group by  bt.channel_grouping  
order by  Session desc



------------------------------- Split SEA texte vs Google Shopping
SELECT
	CASE
		WHEN bt.campaign ilike '%Shopping%'
		OR bt.campaign ilike '%Pmax%' THEN 'Shopping'
		ELSE 'Text'
	END AS texte_vs_shopping,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <= '2023-03-31' THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <= '2022-03-31' THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N1,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <= '2023-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N,
	count(DISTINCT CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <= '2022-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N1,
	round(CA_N / Cmd_N,0) as PM_N,
	round(CA_N1 / Cmd_N1,0) as PM_N1,	
	sum( CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <= '2023-03-31' THEN bop.qty_ordered ELSE NULL END) as N_produits_N,
	sum( CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <= '2022-03-3' THEN bop.qty_ordered ELSE NULL END) as N_produits_N1,
	round(N_produits_N / Cmd_N,0) as N_ProduitsMoyen_N,
	round(N_produits_N1 / Cmd_N1,0) as N_ProduitsMoyen_N1,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <= '2023-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_FP_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <= '2022-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_FP_N1,
	count(distinct CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <= '2023-03-31' AND bo.repeat_number = 1 THEN bo.order_id ELSE NULL END) AS Nvx_clients_N,
	count(distinct CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <= '2022-03-31' AND bo.repeat_number = 1 THEN bo.order_id ELSE NULL END) AS Nvx_clients_N1,
	Nvx_clients_N / Cmd_N as "% nouveaux clients",
	Nvx_clients_N1 / Cmd_N1 as "% nouveaux clients N1"
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON  bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON  bc.country_id = bo.delivery_country_id
INNER JOIN smallable2_datawarehouse.b_traffic bt 
ON bt.traffic_id = bo.traffic_id
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bc.zone_code = 'US'
	AND bt.source_name = 'SEA' 
GROUP BY texte_vs_shopping? 
ORDER BY CA_N DESC  

	
	
select 	CASE
		WHEN bt.campaign ilike '%Shopping%'
		OR bt.campaign ilike '%Pmax%' THEN 'Shopping'
		ELSE 'Text'
	END AS texte_vs_shopping, --bt.region  ,
	count( CASE WHEN bt.Vis_date >= '2022-04-01' AND bt.Vis_date < '2023-03-31' THEN bt.traffic_id ELSE NULL END) AS Session,
	count( CASE WHEN bt.Vis_date >= '2021-04-01' AND bt.Vis_date < '2022-03-31' THEN bt.traffic_id ELSE NULL END) AS Session_N1
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON  bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON  bc.country_id = bo.delivery_country_id
INNER JOIN smallable2_datawarehouse.b_traffic bt 
ON bt.traffic_id = bo.traffic_id
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bop.product_id 
WHERE bc.zone_code = 'US' AND bt.source_name = 'SEA'
group by  texte_vs_shopping  
order by  texte_vs_shopping asc



SELECT
	bp.sml_team as Secteur,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <= '2023-03-31' THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <= '2022-03-31' THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N1,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <= '2023-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N,
	count(DISTINCT CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <= '2022-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N1,
	round(CA_N / Cmd_N,0) as PM_N,
	round(CA_N1 / Cmd_N1,0) as PM_N1,	
	sum( CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <= '2023-03-31' THEN bop.qty_ordered ELSE NULL END) as N_produits_N,
	sum( CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <= '2022-03-3' THEN bop.qty_ordered ELSE NULL END) as N_produits_N1,
	round(N_produits_N / Cmd_N,0) as N_ProduitsMoyen_N,
	round(N_produits_N1 / Cmd_N1,0) as N_ProduitsMoyen_N1,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <= '2023-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_FP_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <= '2022-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_FP_N1,
	count(distinct CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <= '2023-03-31' AND bo.repeat_number = 1 THEN bo.order_id ELSE NULL END) AS Nvx_clients_N,
	count(distinct CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <= '2022-03-31' AND bo.repeat_number = 1 THEN bo.order_id ELSE NULL END) AS Nvx_clients_N1,
	Nvx_clients_N / Cmd_N as "% nouveaux clients",
	Nvx_clients_N1 / Cmd_N1 as "% nouveaux clients N1"
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON  bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON  bc.country_id = bo.delivery_country_id
INNER JOIN smallable2_datawarehouse.b_traffic bt 
ON bt.traffic_id = bo.traffic_id
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bop.product_id 
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bc.zone_code = 'US'
	AND bt.source_name = 'SEA' 
GROUP BY Secteur
ORDER BY CA_N DESC 


------------------------------- Split Etat
select 	bt.region  as region ,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA_N1,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N,
	count(DISTINCT CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' THEN bo.order_id ELSE NULL END) AS Cmd_N1,
	round(CA_N / Cmd_N, 0) as PM_N,		round(CA_N1 / Cmd_N1, 0) as PM_N1,	
	sum( CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' THEN bop.qty_ordered ELSE NULL END) as N_produits_N,
	sum( CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-3'  THEN bop.qty_ordered ELSE NULL END) as N_produits_N1,
	round(N_produits_N / Cmd_N, 0) as N_ProduitsMoyen_N, round(N_produits_N1 / Cmd_N1, 0) as N_ProduitsMoyen_N1,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP_N,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP_N1,
	count(distinct CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients_N,
	count(distinct CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients_N1,
	Nvx_clients_N/Cmd_N as "% nouveaux clients",
	Nvx_clients_N1/Cmd_N1 as "% nouveaux clients N1"
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
	AND bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31'
	OR bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31'	AND bc.zone_code = 'US'
	--AND bt.country_raw  = 'États-Unis'
	AND bt.country_raw  != 'Canada'
group by bt.region
ORDER BY
	CA_N DESC  


	
select bt.region  ,
	count( CASE WHEN bt.Vis_date >= '2022-04-01' AND bt.Vis_date < '2023-03-31' THEN bt.traffic_id ELSE NULL END) AS Session,
	count( CASE WHEN bt.Vis_date >= '2021-04-01' AND bt.Vis_date < '2022-03-31' THEN bt.traffic_id ELSE NULL END) AS Session_N1
FROM smallable2_datawarehouse.b_traffic bt 
WHERE 	bt.Vis_date >= '2022-04-01' AND bt.Vis_date < '2023-03-31'
	OR bt.Vis_date >= '2021-04-01' AND bt.Vis_date < '2022-03-31' 
	AND bt.country_raw  = 'États-Unis' --'Canada'  --'États-Unis'
group by  bt.region  
order by  region asc
	

-------------------------------- Evolution /mois
select 
	toStartOfMonth(bo.created_at) AS m,
	round(sum(CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA,
	count(DISTINCT CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' THEN bo.order_id ELSE NULL END) AS Cmd,
	round(CA / Cmd, 0) as PM,	
	sum( CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' THEN bop.qty_ordered ELSE NULL END) as N_produits,
	round(N_produits / Cmd, 0) as N_ProduitsMoyen,
	round(sum(CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP,
	count(distinct CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients,
	Nvx_clients/Cmd as "% nouveaux clients ah22"
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
	AND bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' 
	AND bc.zone_code = 'US'
	--AND bt.country_raw  = 'États-Unis'
	AND bt.country_raw  != 'Canada'
group by m
ORDER BY m asc ,CA DESC
	


select 
	toStartOfMonth(bo.created_at) AS m,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' THEN bo.order_id ELSE NULL END) AS Cmd,
	round(CA / Cmd, 0) as PM,	
	sum( CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' THEN bop.qty_ordered ELSE NULL END) as N_produits,
	round(N_produits / Cmd, 0) as N_ProduitsMoyen,
	round(sum(CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP,
	count(distinct CASE WHEN bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients,
	Nvx_clients/Cmd as "% nouveaux clients ah22"
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
	AND bo.created_at >= '2022-04-01' AND bo.created_at <=  '2023-03-31' 
	AND bc.zone_code = 'US'
group by m
ORDER BY m asc ,CA DESC
	

select 
	toStartOfMonth(bo.created_at) AS m,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA,
	count(DISTINCT CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' THEN bo.order_id ELSE NULL END) AS Cmd,
	round(CA / Cmd, 0) as PM,	
	sum( CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' THEN bop.qty_ordered ELSE NULL END) as N_produits,
	round(N_produits / Cmd, 0) as N_ProduitsMoyen,
	round(sum(CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' AND b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP,
	count(distinct CASE WHEN bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' AND bo.repeat_number = 1   THEN bo.order_id  ELSE NULL END) AS Nvx_clients,
	Nvx_clients/Cmd as "% nouveaux clients ah22"
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
	AND bo.created_at >= '2021-04-01' AND bo.created_at <=  '2022-03-31' 
	AND bc.zone_code = 'US'
group by m
ORDER BY m asc ,CA DESC


SELECT
	toStartOfMonth(bt.Vis_date) AS m, 
	count( CASE WHEN bt.Vis_date >= '2021-04-01' AND bt.Vis_date <  '2022-03-31' THEN bt.traffic_id ELSE NULL END) AS Session
FROM smallable2_datawarehouse.b_countries bc 
INNER JOIN smallable2_datawarehouse.b_traffic bt 
ON
	bc.country_id = bt.country_id 
WHERE bt.Vis_date >= '2021-04-01' AND bt.Vis_date <=  '2022-03-31' 
	AND bc.zone_code = 'US'
	--AND bt.country_raw  = 'Canada'  --'États-Unis'
group by m


------------------------------------------------------------------------------------

select bt.region  as region , toStartOfMonth(bo.created_at) AS m,
	round(sum(CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31'  THEN bop.billing_product_ht / 100 ELSE NULL END),0) AS CA,
	count(DISTINCT CASE WHEN bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' THEN bo.order_id ELSE NULL END) AS Cmd
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
	AND bo.created_at >= '2020-08-01' AND bo.created_at <=  '2023-03-31' 
	--AND bc.zone_code = 'US'
	--AND bt.country_raw  = 'États-Unis'
	AND bt.region in ('Massachusetts','Illinois','Washington','Pennsylvanie','Connecticut') --('Ontario', 'Québec','Colombie-Britannique','Alberta','Manitoba')
	--AND bt.country_raw  != 'Canada'
group by bt.region,m
ORDER BY region asc, m asc


	
select bt.region  , toStartOfMonth(bt.Vis_date ) AS m,
	count( CASE WHEN bt.Vis_date >= '2020-08-01' AND bt.Vis_date <  '2023-03-31' THEN bt.traffic_id ELSE NULL END) AS Session
FROM smallable2_datawarehouse.b_traffic bt 
WHERE bt.Vis_date >= '2020-08-01' AND bt.Vis_date <=  '2023-03-31' 
		--AND bt.country_raw  = 'États-Unis' --'Canada'  --'États-Unis'
AND bt.region in ('Massachusetts','Illinois','Washington','Pennsylvanie','Connecticut')  --('Ontario', 'Québec','Colombie-Britannique','Alberta','Manitoba') --
group by  bt.region ,m 
order by region asc, m asc