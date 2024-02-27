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


------------------------- GLOBAL -------------------------------------------------
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
	
