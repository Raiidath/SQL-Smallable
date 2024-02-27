	------------------------------------------------ Nb CLients concernés ---------------------------------------	
select ofo.segment, count(distinct bo.customer_id)
from smallable2_playground.ope_fdp_offerts ofo
inner join smallable2_datawarehouse.b_orders bo 
on ofo.customer_id = bo.customer_id
where bo.delivery_country_id = 7
group by segment

	
select ofo.segment, count(distinct bo.customer_id)
from smallable2_playground.ope_fdp_offerts ofo
inner join smallable2_datawarehouse.b_orders bo 
on ofo.customer_id = bo.customer_id
where bo.delivery_country_id IN (1, 8, 5, 18, 3, 2)
group by segment
	
	
select ofo.segment, count(distinct customer_id)
from smallable2_playground.ope_fdp_offerts ofo
group by ofo.segment 


----------------------------------------------------- GLOBAL -------------------------------------------------
select
	ofo.segment,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.order_id ELSE NULL END) AS nb_commandes,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.customer_id ELSE NULL END) AS nb_clients,
		count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.order_id ELSE NULL END)/count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.customer_id ELSE NULL END) AS nb_cmd_clients,
	round(sum(bop.billing_product_ht)/ 100, 0) AS CA,
	round(sum((bop.billing_product_ht)/100)/count(distinct bop.order_id), 0) AS PM,
	sum(CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bop.billing_product_ht/100 ELSE NULL END) AS ca,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.order_id ELSE NULL END) AS nb_cp_utilises,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.customer_id ELSE NULL END) AS nb_cp_uniques
FROM
	smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id 
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and bo.created_at < '2022-09-15' --attention: 1 commande créée avant le 20/09 avec CP à prendre en compte (CA et PM qui changent) --> bo.created_at < '2021-09-20' (à utiliser pour les voir)
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	segment

-------------------------------------------------------PAYS-------------------------------------------------------
	
select
	bp.product_type_N4_refco   , --bo.delivery_country_iso,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' and bo.created_at < '2022-09-15' THEN bo.order_id ELSE NULL END) AS nb_commandes,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' and bo.created_at < '2022-09-15' THEN bo.customer_id ELSE NULL END) AS nb_clients,
		count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' and bo.created_at < '2022-09-15' THEN bo.order_id ELSE NULL END)/count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.customer_id ELSE NULL END) AS nb_cmd_clients,
	round(sum(bop.billing_product_ht)/ 100, 0) AS CA,
	round(sum((bop.billing_product_ht)/100)/count(distinct bop.order_id), 0) AS PM,
	sum(CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bop.billing_product_ht/100 ELSE NULL END) AS ca,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.order_id ELSE NULL END) AS nb_cp_utilises,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.customer_id ELSE NULL END) AS nb_cp_uniques
FROM
	smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id 
INNER JOIN smallable2_datawarehouse.b_skus bs 
ON
	bs.sku_id  = bop.sku_id 
	AND bs.brand_id != '940'
left join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and bo.created_at < '2022-09-15' --attention: 1 commande créée avant le 20/09 avec CP à prendre en compte (CA et PM qui changent) --> bo.created_at < '2021-09-20' (à utiliser pour les voir)
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created 0211018)
group by
		bp.product_type_N4_refco  --, bo.delivery_country_iso 
order by CA desc

-------------- 2 critère KO FR -------------------------------------------------------	
select
	ofo.segment,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.order_id ELSE NULL END) AS nb_commandes,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' and bop.discount_product_rate > 0 THEN bo.order_id ELSE NULL END) AS nb_commandes_avec_article_remise,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.customer_id ELSE NULL END) AS nb_clients,
	round(sum(bop.billing_product_ht /(bop.conversion_rate / 10000000))/ 100, 0) AS CA,
	round(sum((bop.billing_product_ht /(bop.conversion_rate / 10000000))/100)/count(distinct bop.order_id), 0) AS PM,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.order_id ELSE NULL END) AS nb_cp_utilises,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.customer_id ELSE NULL END) AS nb_cp_uniques
FROM
	smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id 
	and bo.delivery_country_iso in ('FR', 'DE', 'IT', 'BE', 'ES', 'NL', 'AT')
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and bo.created_at < '2022-09-15'
	and coa.country_id = 7
	and bo.billing_product_ttc < 15000
	and ca.name != 'Colissimo'
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	segment
	

	
------------------------------ FR AVEC CRITERE LIVRAISON KO ---------------------------------
select
	ofo.segment,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.order_id ELSE NULL END) AS nb_commandes,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' and bop.discount_product_rate > 0 THEN bo.order_id ELSE NULL END) AS nb_commandes_avec_article_remise,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.customer_id ELSE NULL END) AS nb_clients,
	round(sum(bop.billing_product_ht /(bop.conversion_rate / 10000000))/ 100, 0) AS CA,
	round(sum((bop.billing_product_ht /(bop.conversion_rate / 10000000))/100)/count(distinct bop.order_id), 0) AS PM,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.order_id ELSE NULL END) AS nb_cp_utilises,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.customer_id ELSE NULL END) AS nb_cp_uniques
FROM
	smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id 
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and bo.created_at < '2022-09-15'
	and coa.country_id = 7
	and bo.billing_product_ttc >= 15000
	and ca.name != 'Colissimo'
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	segment
	
	
------------------------------ FR AVEC CRITERE PRIX KO ---------------------------------
select
	ofo.segment,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.order_id ELSE NULL END) AS nb_commandes,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25'and bop.discount_product_rate > 0 THEN bo.order_id ELSE NULL END) AS nb_commandes_avec_article_remise,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.customer_id ELSE NULL END) AS nb_clients,
	round(sum(bop.billing_product_ht /(bop.conversion_rate / 10000000))/ 100, 0) AS CA,
	round(sum((bop.billing_product_ht /(bop.conversion_rate / 10000000))/100)/count(distinct bop.order_id), 0) AS PM,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.order_id ELSE NULL END) AS nb_cp_utilises,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.customer_id ELSE NULL END) AS nb_cp_uniques
FROM
	smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id 
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and bo.created_at < '2022-09-15'
	and coa.country_id = 7
	and bo.billing_product_ttc < 15000
	and ca.name = 'Colissimo'
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	segment

------------------------------ FR AVEC CRITERE KO ---------------------------------
	
select
	ofo.segment,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.order_id ELSE NULL END) AS nb_commandes,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' and bop.discount_product_rate > 0 THEN bo.order_id ELSE NULL END) AS nb_commandes_avec_article_remise,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.customer_id ELSE NULL END) AS nb_clients,
	round(sum(bop.billing_product_ht /(bop.conversion_rate / 10000000))/ 100, 0) AS CA,
	round(sum((bop.billing_product_ht /(bop.conversion_rate / 10000000))/100)/count(distinct bop.order_id), 0) AS PM,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.order_id ELSE NULL END) AS nb_cp_utilises,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.customer_id ELSE NULL END) AS nb_cp_uniques
FROM
	smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id 
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and bo.created_at < '2022-09-15'
	and coa.country_id = 7
	and (bo.billing_product_ttc < 15000
	or ca.name != 'Colissimo')
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	segment	

	
------------------------------ FR AVEC CRITERE OK ---------------------------------
select
	ofo.segment,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.order_id ELSE NULL END) AS nb_commandes,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' and bop.discount_product_rate > 0 THEN bo.order_id ELSE NULL END) AS nb_commandes_avec_article_remise,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.customer_id ELSE NULL END) AS nb_clients,
	round(sum(bop.billing_product_ht /(bop.conversion_rate / 10000000))/ 100, 0) AS CA,
	round(sum((bop.billing_product_ht /(bop.conversion_rate / 10000000))/100)/count(distinct bop.order_id), 0) AS PM,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.order_id ELSE NULL END) AS nb_cp_utilises,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.customer_id ELSE NULL END) AS nb_cp_uniques
FROM
	smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id 
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and bo.created_at < '2022-09-15'
	and coa.country_id = 7
	and bo.billing_product_ttc >= 15000
	and ca.name = 'Colissimo'
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	segment
	
---------------------------------------- EU 2 critère KO -------Transporteur différent de Chronopost et de colissimo --------------------------	
select
	ofo.segment,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.order_id ELSE NULL END) AS nb_commandes,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' and bop.discount_product_rate > 0 THEN bo.order_id ELSE NULL END) AS nb_commandes_avec_article_remise,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.customer_id ELSE NULL END) AS nb_clients,
	round(sum(bop.billing_product_ht /(bop.conversion_rate / 10000000))/ 100, 0) AS CA,
	round(sum((bop.billing_product_ht /(bop.conversion_rate / 10000000))/100)/count(distinct bop.order_id), 0) AS PM,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.order_id ELSE NULL END) AS nb_cp_utilises,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.customer_id ELSE NULL END) AS nb_cp_uniques
FROM
	smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id 
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and bo.created_at < '2022-09-15'
	and coa.country_id IN (1, 8, 5, 18, 3, 2)
	and bo.billing_product_ttc < 20000
	and ca.name != 'CHRONOPOST CLASSIC EUROPE L4'
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	segment
		
	
--------------------------------------------------- Commandes avec CP mais critère livraison KO
SELECT * FROM smallable2_playground.ope_fdp_offerts ofo 
		
	
---------------------------------------------- EU critères livraison KO	--------------------------------	
select
	ofo.segment,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.order_id ELSE NULL END) AS nb_commandes,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' and bop.discount_product_rate > 0 THEN bo.order_id ELSE NULL END) AS nb_commandes_avec_article_remise,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.customer_id ELSE NULL END) AS nb_clients,
	round(sum(bop.billing_product_ht /(bop.conversion_rate / 10000000))/ 100, 0) AS CA,
	round(sum((bop.billing_product_ht /(bop.conversion_rate / 10000000))/100)/count(distinct bop.order_id), 0) AS PM,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.order_id ELSE NULL END) AS nb_cp_utilises,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.customer_id ELSE NULL END) AS nb_cp_uniques
FROM
	smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id 
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and bo.created_at < '2022-09-15'
	and coa.country_id IN (1, 8, 5, 18, 3, 2)
	and bo.billing_product_ttc >= 20000
	and ca.name != 'CHRONOPOST CLASSIC EUROPE L4'
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	segment
	
---------------------------------------------- EU critères prix KO	--------------------------------	
select
	ofo.segment,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.order_id ELSE NULL END) AS nb_commandes,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' and bop.discount_product_rate > 0 THEN bo.order_id ELSE NULL END) AS nb_commandes_avec_article_remise,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.customer_id ELSE NULL END) AS nb_clients,
	round(sum(bop.billing_product_ht /(bop.conversion_rate / 10000000))/ 100, 0) AS CA,
	round(sum((bop.billing_product_ht /(bop.conversion_rate / 10000000))/100)/count(distinct bop.order_id), 0) AS PM,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.order_id ELSE NULL END) AS nb_cp_utilises,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.customer_id ELSE NULL END) AS nb_cp_uniques
FROM
	smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id 
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and bo.created_at < '2022-09-15'
	and coa.country_id IN (1, 8, 5, 18, 3, 2)
	and bo.billing_product_ttc < 20000
	and ca.name = 'CHRONOPOST CLASSIC EUROPE L4'
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	segment	
	

---------------------------------------------- EU - critère KO ------------------------------
	
select
	ofo.segment,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.order_id ELSE NULL END) AS nb_commandes,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' and bop.discount_product_rate > 0 THEN bo.order_id ELSE NULL END) AS nb_commandes_avec_article_remise,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.customer_id ELSE NULL END) AS nb_clients,
	round(sum(bop.billing_product_ht /(bop.conversion_rate / 10000000))/ 100, 0) AS CA,
	round(sum((bop.billing_product_ht /(bop.conversion_rate / 10000000))/100)/count(distinct bop.order_id), 0) AS PM,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.order_id ELSE NULL END) AS nb_cp_utilises,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.customer_id ELSE NULL END) AS nb_cp_uniques
FROM
	smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id 
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and bo.created_at < '2022-09-15'
	and coa.country_id IN (1, 8, 5, 18, 3, 2)
	and (bo.billing_product_ttc < 20000
	or ca.name != 'CHRONOPOST CLASSIC EUROPE L4')
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	segment

	
---------------------------------------------- EU - critère OK ------------------------------
select
	ofo.segment,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.order_id ELSE NULL END) AS nb_commandes,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' and bop.discount_product_rate > 0 THEN bo.order_id ELSE NULL END) AS nb_commandes_avec_article_remise,
	count(DISTINCT CASE WHEN bo.created_at > '2021-08-25' THEN bo.customer_id ELSE NULL END) AS nb_clients,
	round(sum(bop.billing_product_ht /(bop.conversion_rate / 10000000))/ 100, 0) AS CA,
	round(sum((bop.billing_product_ht /(bop.conversion_rate / 10000000))/100)/count(distinct bop.order_id), 0) AS PM,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.order_id ELSE NULL END) AS nb_cp_utilises,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.customer_id ELSE NULL END) AS nb_cp_uniques
FROM
	smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id 
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and bo.created_at < '2022-09-15'
	and coa.country_id IN (1, 8, 5, 18, 3, 2)
	and bo.billing_product_ttc >= 20000
	and ca.name = 'CHRONOPOST CLASSIC EUROPE L4'
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	segment	
	

---------------------------------------------- Produits retournés ----------------------------------------------
------------------------- COMMENTAIRES COMMANDES retournés ---------------------------------	
select
DISTINCT case when bl.sku LIKE 'DELIVERY_____' and bo.order_id = cr.order_id THEN crli.comment ELSE NULL END AS comment
from smallable2_datawarehouse.b_orders bo
left join smallable2_front.customer_return cr on bo.order_id = cr.order_id
left join smallable2_front.basket_line bl on bo.basket_id = bl.basket_id
left join smallable2_front.basket_line bl2 on cr.basket_id = bl2.basket_id
left join smallable2_front.customer_return_line_info crli on bl2.id = crli.basket_line_id
where cr.created > '2021-08-25'	
	
	
----------------------------- Infos commandes retournés ----------------------------------	
	
select 
count(DISTINCT CASE WHEN ofo.segment = 'eligible_w_cp' and bl.sku LIKE 'DELIVERY_____' THEN bo.order_id ELSE NULL END) AS nb_commandes_eligibles_avec_cp_utilise,
count(DISTINCT CASE WHEN ofo.segment = 'eligible_w_cp' and bl.sku LIKE 'DELIVERY_____' and bo.order_id = cr.order_id THEN bo.order_id ELSE NULL END) AS nb_commandes_eligibles_avec_cp_utilise_retournees,
count(DISTINCT CASE WHEN ofo.segment = 'eligible_w_cp'and bl.sku NOT LIKE 'DELIVERY_____' THEN bo.order_id ELSE NULL END) AS nb_commandes_eligibles_avec_cp_non_utilise,
count(DISTINCT CASE WHEN ofo.segment = 'eligible_w_cp' and bl.sku NOT LIKE 'DELIVERY_____' and bo.order_id = cr.order_id THEN bo.order_id ELSE NULL END) AS nb_commandes_eligibles_avec_cp_non_utilise_retournees,
count(DISTINCT CASE WHEN ofo.segment = 'eligible_wo_cp' THEN bo.order_id ELSE NULL END) AS nb_commandes_eligibles_sans_cp,
count(DISTINCT CASE WHEN ofo.segment = 'eligible_wo_cp' and bo.order_id = cr.order_id THEN bo.order_id ELSE NULL END) AS nb_commandes_eligibles_sans_cp_retournees,
count(DISTINCT CASE WHEN ofo.segment = 'not_eligible' THEN bo.order_id ELSE NULL END) AS nb_commandes_hors_segment,
count(DISTINCT CASE WHEN ofo.segment = 'not_eligible' and bo.order_id = cr.order_id THEN bo.order_id ELSE NULL END) AS nb_commandes_hors_segment_retournees
from smallable2_datawarehouse.b_orders bo
left join smallable2_front.customer_return cr on
	bo.order_id = cr.order_id
left join smallable2_front.basket_line bl on
	bo.basket_id = bl.basket_id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id 
where bo.created_at >  '2021-08-25'	
	
	
--------------------------- Listes commandes retournés -------------------------------------	
select
Count(DISTINCT case when bo.order_id = cr.order_id THEN bo.order_id ELSE NULL END AS nb_commandes_retournees)
from smallable2_datawarehouse.b_orders bo
left join smallable2_front.customer_return cr on bo.order_id = cr.order_id
left join smallable2_front.basket_line bl on bo.basket_id = bl.basket_id
where bl.sku like 'DELIVERY_____'
and bo.created_at > '2021-08-25' and bo.created_at < '2022-09-15'	
	
	
	
-------------------------------- Nb commandes retournés avec utilisateurs CP ------------------------------
select
	count(DISTINCT case when bl2.basket_id is not null then bo.order_id else null end) AS nb_commandes_avec_cp,
	count(DISTINCT case when bl2.basket_id is not null and bo.order_id = cr.order_id THEN bo.order_id ELSE NULL END) AS nb_commandes_retournees,
	count(DISTINCT case when bl2.basket_id is not null and bo.order_id = ex.is_commande_echange THEN bo.order_id ELSE NULL END) AS nb_commandes_echangees,
	sum(case when bl2.basket_id is not null and bo.order_id = ca.order_id then round(ca.CA_refund, 0) else 0 end) as ca_refund
from
	smallable2_datawarehouse.b_orders bo
left join smallable2_front.customer_return cr on
	bo.order_id = cr.order_id
left join (
	select
		distinct bl.basket_id
	from
		smallable2_front.basket_line bl
	where
		bl.sku like 'DELIVERY_____') bl2 on
	bo.basket_id = bl2.basket_id
left join (
	select
		bo2.is_commande_echange
	from
		smallable2_datawarehouse.b_orders bo2
	where
		bo2.is_commande_echange = 1) ex on
	bo.order_id = ex.is_commande_echange
left join (
	select
		br.order_id,
		sum((br.total_paid_ttc / br.conv)/ 100) AS CA_refund
	from
		smallable2_datawarehouse.b_refunds br
	group by
		br.order_id) ca on
	bo.order_id = ca.order_id
where
	bo.created_at > '2021-08-25'




--------------------------------Repartition trancehs panier commandés EU ---------------------------------
select
	CASE  
		 WHEN bo.billing_product_ttc >= 20000 AND bo.billing_product_ttc <= 25000 THEN 'entre 200 et 250€'
		 WHEN bo.billing_product_ttc >= 25000 AND bo.billing_product_ttc <= 50000 THEN 'entre 250 et 500€'
		 WHEN bo.billing_product_ttc >= 50000 AND bo.billing_product_ttc <= 100000 THEN 'entre 500 et 1 000€'
		 WHEN bo.billing_product_ttc >= 100000 AND bo.billing_product_ttc <= 150000 THEN 'entre 1 000 et 1 500€'
		 WHEN bo.billing_product_ttc > 150000 THEN 'plus de 1 500€'
	END AS tranche_panier,
	count(distinct bo.order_id) as nb_commandes
FROM smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id
left join (select distinct bl.basket_id from smallable2_front.basket_line bl
where bl.sku like 'DELIVERY_____') bl2  on bo.basket_id = bl2.basket_id
left join smallable2_front.customer_return cr on
	bo.order_id = cr.order_id
WHERE ofo.segment = 'eligible_w_cp'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and coa.country_id IN (1, 8, 5, 18, 3, 2)
	and bl2.basket_id is not null
	and bo.order_id = cr.order_id 
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	tranche_panier
	
	
	
	
--------------------------------Repartition trancehs panier commandés FR ---------------------------------
	
select
	CASE  
		 WHEN bo.billing_product_ttc >= 15000 AND bo.billing_product_ttc <= 20000 THEN 'entre 150 et 200€'
		 WHEN bo.billing_product_ttc >= 20000 AND bo.billing_product_ttc <= 25000 THEN 'entre 200 et 250€'
		 WHEN bo.billing_product_ttc >= 25000 AND bo.billing_product_ttc <= 50000 THEN 'entre 250 et 500€'
		 WHEN bo.billing_product_ttc >= 50000 AND bo.billing_product_ttc <= 100000 THEN 'entre 500 et 1 000€'
		 WHEN bo.billing_product_ttc >= 100000 AND bo.billing_product_ttc <= 150000 THEN 'entre 1 000 et 1 500€'
		 WHEN bo.billing_product_ttc > 150000 THEN 'plus de 1 500€'
	END AS tranche_panier,
	count(distinct bo.order_id) as nb_commandes
FROM smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id
left join (select distinct bl.basket_id from smallable2_front.basket_line bl
where bl.sku like 'DELIVERY_____') bl2  on bo.basket_id = bl2.basket_id
left join smallable2_front.customer_return cr on
	bo.order_id = cr.order_id
WHERE ofo.segment = 'eligible_w_cp'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and coa.country_id = 7
	and bl2.basket_id is not null
	and bo.order_id = cr.order_id  
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	tranche_panier	
	
	
	
----------------------------------------- FR : Répartition montant panier commandes avec cp -------------------------

select
	CASE  
		 WHEN bo.billing_product_ttc >= 15000 AND bo.billing_product_ttc <= 20000 THEN 'entre 150 et 200€'
		 WHEN bo.billing_product_ttc >= 20000 AND bo.billing_product_ttc <= 25000 THEN 'entre 200 et 250€'
		 WHEN bo.billing_product_ttc >= 25000 AND bo.billing_product_ttc <= 50000 THEN 'entre 250 et 500€'
		 WHEN bo.billing_product_ttc >= 50000 AND bo.billing_product_ttc <= 100000 THEN 'entre 500 et 1 000€'
		 WHEN bo.billing_product_ttc >= 100000 AND bo.billing_product_ttc <= 150000 THEN 'entre 1 000 et 1 500€'
		 WHEN bo.billing_product_ttc > 150000 THEN 'plus de 1 500€'
	END AS tranche_panier,
	count(distinct bo.order_id) as nb_commandes
FROM smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id
left join (select distinct bl.basket_id from smallable2_front.basket_line bl
where bl.sku like 'DELIVERY_____') bl2  on bo.basket_id = bl2.basket_id
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and coa.country_id = 7
	and bo.billing_product_ttc >= 15000
	and ca.name = 'Colissimo'
	and bl2.basket_id is not null 
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	tranche_panier
	
	
--------------------------------------- EU : Répartition montant panier commandes avec cp --------------------
	
select
	CASE  
		 WHEN bo.billing_product_ttc >= 20000 AND bo.billing_product_ttc <= 25000 THEN 'entre 200 et 250€'
		 WHEN bo.billing_product_ttc >= 25000 AND bo.billing_product_ttc <= 50000 THEN 'entre 250 et 500€'
		 WHEN bo.billing_product_ttc >= 50000 AND bo.billing_product_ttc <= 100000 THEN 'entre 500 et 1 000€'
		 WHEN bo.billing_product_ttc >= 100000 AND bo.billing_product_ttc <= 150000 THEN 'entre 1 000 et 1 500€'
		 WHEN bo.billing_product_ttc > 150000 THEN 'plus de 1 500€'
	END AS tranche_panier,
	count(distinct bo.order_id) as nb_commandes
FROM smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id
left join (select distinct bl.basket_id from smallable2_front.basket_line bl
where bl.sku like 'DELIVERY_____') bl2  on bo.basket_id = bl2.basket_id
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and coa.country_id IN (1, 8, 5, 18, 3, 2)
	and bo.billing_product_ttc >= 20000
	and ca.name = 'CHRONOPOST CLASSIC EUROPE L4'
	and bl2.basket_id is not null 
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	tranche_panier
	

-------------------------------------------- FR : Tranche panier ----------------------------------------------
	
	
select
	CASE  
		 WHEN bo.billing_product_ttc >= 15000 AND bo.billing_product_ttc < 20000 THEN 'tranche 2: entre 150 et 199€'
		 WHEN bo.billing_product_ttc >= 20000 AND bo.billing_product_ttc < 30000 THEN 'tranche 2: entre 200 et 299€'
		 WHEN bo.billing_product_ttc >= 30000 AND bo.billing_product_ttc < 40000 THEN 'tranche 3: entre 300 et 399€'
		 WHEN bo.billing_product_ttc >= 40000 AND bo.billing_product_ttc < 50000 THEN 'tranche 4: entre 400 et 499€'
		 WHEN bo.billing_product_ttc >= 50000 AND bo.billing_product_ttc < 60000 THEN 'tranche 5: entre 500 et 599€'
		 WHEN bo.billing_product_ttc >= 60000 AND bo.billing_product_ttc < 70000 THEN 'tranche 6: entre 600 et 699€'
		 WHEN bo.billing_product_ttc >= 70000 AND bo.billing_product_ttc < 80000 THEN 'tranche 8: entre 700 et 799€'
		 WHEN bo.billing_product_ttc >= 80000 AND bo.billing_product_ttc < 90000 THEN 'tranche 8: entre 800 et 899€'
		 WHEN bo.billing_product_ttc >= 90000 AND bo.billing_product_ttc < 100000 THEN 'tranche 10: entre 900 et 999€'
		 WHEN bo.billing_product_ttc >= 100000 AND bo.billing_product_ttc < 110000 THEN 'tranche 11: entre 1 000 et 1 099€'
		 WHEN bo.billing_product_ttc >= 110000 AND bo.billing_product_ttc < 120000 THEN 'tranche 11: entre 1 100 et 1 199€'
		 WHEN bo.billing_product_ttc >= 120000 AND bo.billing_product_ttc < 130000 THEN 'tranche 11: entre 1 200 et 1 299€'
		 WHEN bo.billing_product_ttc >= 130000 AND bo.billing_product_ttc < 140000 THEN 'tranche 12: entre 1 300 et 1 399€'
		 WHEN bo.billing_product_ttc >= 140000 AND bo.billing_product_ttc < 150000 THEN 'tranche 12: entre 1 400 et 1 499€'
		 WHEN bo.billing_product_ttc >= 150000 AND bo.billing_product_ttc < 160000 THEN 'tranche 12: entre 1 500 et 1 599€'
		 WHEN bo.billing_product_ttc >= 160000 AND bo.billing_product_ttc < 170000 THEN 'tranche 12: entre 1 600 et 1 699€'
		 WHEN bo.billing_product_ttc >= 170000 AND bo.billing_product_ttc < 180000 THEN 'tranche 12: entre 1 700 et 1 799€'
		 WHEN bo.billing_product_ttc >= 180000 AND bo.billing_product_ttc < 190000 THEN 'tranche 12: entre 1 800 et 1 899€'
		 WHEN bo.billing_product_ttc >= 190000 AND bo.billing_product_ttc < 200000 THEN 'tranche 12: entre 1 900 et 1 999€'
		 WHEN bo.billing_product_ttc >= 200000 THEN 'tranche 13: 2 000€ et +'
	END AS tranche_panier,
	count(distinct bo.order_id) as nb_commandes
FROM smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id 
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and coa.country_id = 7
	and bo.billing_product_ttc >= 15000
	and ca.name = 'Colissimo'
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	tranche_panier
	
	
	
-------------------------------------------- EU : Tranche panier ----------------------------------------------
	
select
	CASE  
		 WHEN bo.billing_product_ttc >= 20000 AND bo.billing_product_ttc < 25000 THEN 'tranche 2: entre 200 et 249€'
		 WHEN bo.billing_product_ttc >= 25000 AND bo.billing_product_ttc < 30000 THEN 'tranche 2: entre 250 et 299€'
		 WHEN bo.billing_product_ttc >= 30000 AND bo.billing_product_ttc < 40000 THEN 'tranche 3: entre 300 et 399€'
		 WHEN bo.billing_product_ttc >= 40000 AND bo.billing_product_ttc < 50000 THEN 'tranche 4: entre 400 et 499€'
		 WHEN bo.billing_product_ttc >= 50000 AND bo.billing_product_ttc < 60000 THEN 'tranche 5: entre 500 et 599€'
		 WHEN bo.billing_product_ttc >= 60000 AND bo.billing_product_ttc < 70000 THEN 'tranche 6: entre 600 et 699€'
		 WHEN bo.billing_product_ttc >= 70000 AND bo.billing_product_ttc < 80000 THEN 'tranche 8: entre 700 et 799€'
		 WHEN bo.billing_product_ttc >= 80000 AND bo.billing_product_ttc < 90000 THEN 'tranche 8: entre 800 et 899€'
		 WHEN bo.billing_product_ttc >= 90000 AND bo.billing_product_ttc < 100000 THEN 'tranche 10: entre 900 et 999€'
		 WHEN bo.billing_product_ttc >= 100000 AND bo.billing_product_ttc < 110000 THEN 'tranche 11: entre 1 000 et 1 099€'
		 WHEN bo.billing_product_ttc >= 110000 AND bo.billing_product_ttc < 120000 THEN 'tranche 11: entre 1 100 et 1 199€'
		 WHEN bo.billing_product_ttc >= 120000 AND bo.billing_product_ttc < 130000 THEN 'tranche 11: entre 1 200 et 1 299€'
		 WHEN bo.billing_product_ttc >= 130000 AND bo.billing_product_ttc < 140000 THEN 'tranche 12: entre 1 300 et 1 399€'
		 WHEN bo.billing_product_ttc >= 140000 AND bo.billing_product_ttc < 150000 THEN 'tranche 12: entre 1 400 et 1 499€'
		 WHEN bo.billing_product_ttc >= 150000 AND bo.billing_product_ttc < 160000 THEN 'tranche 12: entre 1 500 et 1 599€'
		 WHEN bo.billing_product_ttc >= 160000 AND bo.billing_product_ttc < 170000 THEN 'tranche 12: entre 1 600 et 1 699€'
		 WHEN bo.billing_product_ttc >= 170000 AND bo.billing_product_ttc < 180000 THEN 'tranche 12: entre 1 700 et 1 799€'
		 WHEN bo.billing_product_ttc >= 180000 AND bo.billing_product_ttc < 190000 THEN 'tranche 12: entre 1 800 et 1 899€'
		 WHEN bo.billing_product_ttc >= 190000 AND bo.billing_product_ttc < 200000 THEN 'tranche 12: entre 1 900 et 1 999€'
		 WHEN bo.billing_product_ttc >= 200000 THEN 'tranche 13: 2 000€ et +'
	END AS tranche_panier,
	count(distinct bo.order_id)
FROM smallable2_datawarehouse.b_orders bo 
left join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id 
left join smallable2_front.basket_carrier_selection bcs ON
	bcs.basket_id = bo.basket_id 
left join smallable2_front.carrier ca ON
	bcs.carrier_id = ca.id
left join smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
left join smallable2_front.customer_order_address coa on
	bo.delivery_address_id = coa.id 
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	and coa.country_id IN (1, 8, 5, 18, 3, 2)
	and bo.billing_product_ttc >= 20000
	and ca.name = 'CHRONOPOST CLASSIC EUROPE L4'
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
group by
	tranche_panier
	
	
	
------------------------------------ Eligible CP vs non Eligible ------------------------------------------------

SELECT toStartOfMonth(bo.created_at) as date,
	count(DISTINCT CASE WHEN ofo.segment = 'eligible_w_cp' THEN bo.order_id ELSE NULL END) AS nb_commandes_clients_avec_cp,
	count(DISTINCT CASE WHEN ofo.segment = 'eligible_wo_cp' THEN bo.order_id ELSE NULL END) AS nb_commandes_clients_sans_cp,
	count(DISTINCT CASE WHEN ofo.segment = 'eligible_w_cp' THEN bo.customer_id ELSE NULL END) AS nb_clients_avec_cp,
	count(DISTINCT CASE WHEN ofo.segment = 'eligible_wo_cp' THEN bo.customer_id ELSE NULL END) AS nb_clients_sans_cp,	
	round(sum(CASE WHEN ofo.segment = 'eligible_w_cp' THEN bo.billing_product_ttc/100 ELSE NULL END)/ count(DISTINCT CASE WHEN ofo.segment = 'eligible_w_cp' THEN bo.customer_id ELSE NULL END), 0) AS PM_clients_avec_cp,
	round(sum(CASE WHEN ofo.segment = 'eligible_wo_cp' THEN bo.billing_product_ttc/100 ELSE NULL END)/ count(DISTINCT CASE WHEN ofo.segment = 'eligible_wo_cp' THEN bo.customer_id ELSE NULL END), 0) AS PM_clients_sans_cp,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.order_id ELSE NULL END) AS nb_cp_utilises,
	count(DISTINCT CASE WHEN bo.basket_id IN (SELECT bl.basket_id FROM smallable2_front.basket_line bl WHERE bl.sku LIKE 'DELIVERY_____') THEN bo.customer_id ELSE NULL END) AS nb_cp_uniques
FROM smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_playground.ope_fdp_offerts ofo on
	bo.customer_id = ofo.customer_id
WHERE ofo.segment != 'not_eligible'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-08-25'
	-- AND (co.created > 20210921
	-- AND co.created < 20210929 OR co.created > 20211018)
GROUP BY
	date
	
---------------------------------------------------Nb de commandes avec FDP dfferts ------------------------------------------

select
	toStartOfMonth(bo2.created_at) as jour,
	count(distinct bo2.order_id) as nb_commandes,
	round(sum(bop.billing_product_ht )/ 100, 0) AS CA,
	round(sum((bop.billing_product_ht /(bop.conversion_rate / 10000000))/100)/count(distinct bop.order_id), 0) AS Panier_moyen
from
	smallable2_datawarehouse.b_orders bo2
inner join smallable2_datawarehouse.b_order_products bop 
on
	bo2.order_id = bop.order_id
inner join
	(
select
		distinct bo.order_id as order
	from
		smallable2_datawarehouse.b_orders bo
	inner join smallable2_front.basket_line bl 
on
		bo.basket_id = bl.basket_id
	where
		bo.is_valid = 1
		and bo.is_ca_ht_not_zero = 1
		and bo.created_at > '2021-08-25'
		and bl.sku LIKE 'DELIVERY_____')r1 on
	r1.order = bo2.order_id
group by jour
order by jour	
	