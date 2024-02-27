------------------------------------------2022---------------------------------------------------
-------------------------Générés ----------------------------------------------------------------
select toStartOfMonth(cv.created) as month,
	count(case when cv.code like ('WELCOME________') then cv.id else null end) as Welcome_pack
from
	smallable2_front.commercial_voucher cv
where
	cv.created >= '2022-01-01'
	and cv.created <= '2022-11-27'
group by month 


--------------------Utilisés et CA--------------------------------------------------------------------

select toStartOfYear(bl.created) as month,
	count(distinct case when bl.sku like ('JUST4YOU______') then bl.basket_id else null end) as Welcome_pack,
	sum(distinct case when bl.sku like ('JUST4YOU______') then bo.billing_product_ht/100 else null end) as Welcome_ca
from
	smallable2_front.basket_line bl
inner join smallable2_datawarehouse.b_orders bo 
on bo.basket_id = bl.basket_id 
	and bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
inner join smallable2_front.commercial_voucher cv
on cv.code = bl.sku 
where bo.created_at  >= '2021-01-01'
and bo.created_at  <= '2021-12-31'
group by month 


-------------------------Durée moyenne d'utilisation ---------------------------------------------

SELECT
	toStartOfYear(cv.created) AS mois_generation,
	count(DISTINCT cv.id) AS nb_generes,
	count(DISTINCT o.oid) AS nb_utilises,
	sum(distinct case when o.code like ('WELCOME________') then o.ca else null end) as Welcome_pack_ca,
	avg(CASE WHEN o.date_commande IS NOT NULL THEN date(o.date_commande) - date(cv.created) ELSE NULL end) AS moyenne_delais,
	stddevPop(CASE WHEN o.date_commande IS NOT NULL THEN date(o.date_commande) - date(cv.created) ELSE NULL end) AS etype_delais,
	count(DISTINCT CASE WHEN o.date_commande IS NOT NULL AND date(o.date_commande) - date(cv.created) < 1 THEN o.oid ELSE NULL end) AS nb_utilises_sous24,
	count(DISTINCT CASE WHEN o.date_commande IS NOT NULL AND date(o.date_commande) - date(cv.created) > 15 THEN o.oid ELSE NULL end) AS nb_utilises_plus15j,
	count(DISTINCT CASE WHEN o.date_commande IS NOT NULL AND date(o.date_commande) - date(cv.created) > 30 THEN o.oid ELSE NULL end) AS nb_utilises_plus30j
FROM
	smallable2_front.commercial_voucher cv
LEFT JOIN (
	SELECT
		bop.code_promo_product AS code,
		bo.order_id AS oid,
		bo.created_at AS date_commande,
		bop.billing_product_ht/100 as ca
	FROM
		smallable2_datawarehouse.b_orders bo
	INNER JOIN smallable2_datawarehouse.b_order_products bop ON
		bop.order_id = bo.order_id
		AND bo.is_valid = 1
		AND bo.is_ca_ht_not_zero = 1
		AND bop.code_promo_product LIKE 'WELCOME________'
	GROUP BY
		bo.order_id,
		date_commande,
		code, ca) o ON
	o.code = cv.code
	WHERE
	cv.code LIKE 'WELCOME________'
	GROUP BY mois_generation
	
	

	
SELECT
	toStartOfYear(cv.created) AS year,
	count(DISTINCT cv.id) AS nb_generes,
	count(distinct case when o.code like ('JUST4YOU______') then o.oid else null end) as nb_utilises,
	sum(distinct case when o.code like ('JUST4YOU______') then o.ca else null end) as Churner_ca,
	avg(CASE WHEN o.date_commande IS NOT NULL THEN date(o.date_commande) - date(cv.created) ELSE NULL end) AS moyenne_delais,
	stddevPop(CASE WHEN o.date_commande IS NOT NULL THEN date(o.date_commande) - date(cv.created) ELSE NULL end) AS etype_delais,
	count(DISTINCT CASE WHEN o.date_commande IS NOT NULL AND date(o.date_commande) - date(cv.created) < 7 THEN o.oid ELSE NULL end) AS nb_utilises_sous7j,
	count(DISTINCT CASE WHEN o.date_commande IS NOT NULL AND date(o.date_commande) - date(cv.created) > 15 THEN o.oid ELSE NULL end) AS nb_utilises_plus15j,
	count(DISTINCT CASE WHEN o.date_commande IS NOT NULL AND date(o.date_commande) - date(cv.created) > 30 THEN o.oid ELSE NULL end) AS nb_utilises_plus30j
FROM
	smallable2_front.commercial_voucher cv
LEFT JOIN (
	SELECT
		bop.code_promo_product AS code,
		bo.order_id AS oid,
		bo.created_at AS date_commande,
		bop.billing_product_ht / 100 as ca
	FROM
		smallable2_datawarehouse.b_orders bo
	INNER JOIN smallable2_datawarehouse.b_order_products bop ON
		bop.order_id = bo.order_id
		AND bo.is_valid = 1
		AND bo.is_ca_ht_not_zero = 1
		AND bop.code_promo_product LIKE 'JUST4YOU______'
	GROUP BY
		bo.order_id,
		date_commande,
		code,
		ca) o 
ON	
	o.code = cv.code
WHERE
	cv.code LIKE 'JUST4YOU______'
GROUP BY
	year

------------------------------------------2021---------------------------------------------------
-------------------------Générés ----------------------------------------------------------------
select toStartOfMonth(cv.created) as month,
	count(case when cv.code like ('WELCOME________') then cv.id else null end) as  Welcome_pack
from
	smallable2_front.commercial_voucher cv
where
	cv.created >= '2021-01-01'
	and cv.created <= '2021-12-31'
group by month


select toStartOfYear(cv.created) as year,
	count(case when cv.code like ('JUST4YOU______') then cv.id else null end) as  Churner
from
	smallable2_front.commercial_voucher cv
where
	cv.created >= '2021-01-01'
	and cv.created <= '2022-12-31'
group by year

--------------------Utilisés--------------------------------------------------------------------

select toStartOfMonth(bl.created) as month,
	count(distinct case when bl.sku like ('WELCOME________') then bl.basket_id else null end) as Welcome_pack,
	sum(distinct case when bl.sku like ('WELCOME________') then bo.billing_product_ht/100 else null end) as Welcome_ca
from
	smallable2_front.basket_line bl
inner join smallable2_datawarehouse.b_orders bo 
on bo.basket_id = bl.basket_id 
	and bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
inner join smallable2_front.commercial_voucher cv
on cv.code = bl.sku 
where bl.created >= '2021-01-01'
and bl.created <= '2021-12-31'
group by month


select toStartOfYear(bl.created) as year--, count(cv.id)  as code, 
	count(distinct case when cv.code like ('JUST4YOU______')  then bl.basket_id else null end) as Churner,
	sum(distinct case when cv.code like ('JUST4YOU______')  then bo.billing_product_ht/100 else null end) as Churner_ca
from
	smallable2_front.basket_line bl
inner join smallable2_datawarehouse.b_orders bo 
on bo.basket_id = bl.basket_id 
	and bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
inner join smallable2_front.commercial_voucher cv
on cv.code = bl.sku 
where bl.created >= '2021-01-01'
and bl.created <= '2022-12-31'
group by year


---------- premiers codes churner ----------------------------------------
	
WITH C1 AS (
SELECT
	bo.customer_id AS boi,
		bo.created_at AS bod,
		bo.order_id AS boo,
		bop.code_promo AS boc
FROM 
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.basket_id = bop.basket_id
WHERE 
	bop.code_promo LIKE ('JUST4YOU______')
	AND right(trim(bop.code_promo),
	6) > ('065804')
	and right(trim(bop.code_promo),
	6) < ('300000')
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1),
C2 AS (
SELECT
		bo.customer_id AS cid2,
		bo.created_at AS date2,
		bo.order_id AS oid2,
		bo.billing_product_ht AS ca2
FROM 
	smallable2_datawarehouse.b_orders bo
WHERE 
	cid2 IN (
	SELECT
		C1.boi
	FROM
		C1))
SELECT
	count(DISTINCT CASE WHEN bo2.customer_id IN (SELECT C1.boi FROM C1) THEN bo2.customer_id ELSE NULL END) as utilises,
	sum(CASE WHEN bo2.order_id IN (SELECT C1.boo FROM C1) THEN bo2.billing_product_ht ELSE NULL END)/100 as CA
FROM
	smallable2_datawarehouse.b_orders bo2

----------------------------------- 	bON CODE -----------------------------------------	
WITH C1 AS (
SELECT
	bo.customer_id AS cid1,
		bo.created_at AS date1,
		bo.order_id AS oid1, 
		bop.code_promo AS boc
FROM 
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.basket_id = bop.basket_id
WHERE 
	bop.code_promo LIKE ('JUST4YOU______')
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1),
C2 AS (
SELECT
		bo.customer_id AS cid2,
		bo.created_at AS date2,
		bo.order_id AS oid2,
		bo.billing_product_ht AS ca2
FROM 
	smallable2_datawarehouse.b_orders bo
WHERE 
	cid2 IN (
	SELECT
		C1.oid1
	FROM
		C1))
SELECT
CASE WHEN bo2.customer_id IN (SELECT C1.cid1 FROM C1 WHERE C1.boc LIKE 'JUST4YOU______' AND right(trim(C1.boc),6) < ('065804')) THEN 'Vague 1'
WHEN bo2.customer_id IN (SELECT C1.cid1 FROM C1 WHERE C1.boc LIKE 'JUST4YOU______' AND RIGHT(trim(C1.boc),6) > ('065804') 	AND RIGHT(trim(C1.boc),6) < ('300000')) THEN 'Vague 2'
WHEN bo2.customer_id IN (SELECT C1.cid1 FROM C1 WHERE C1.boc LIKE 'JUST4YOU3_____') THEN 'Vague 3'
WHEN bo2.customer_id IN (SELECT C1.cid1 FROM C1 WHERE C1.boc LIKE 'JUST4YOU4_____') THEN 'Vague 4'
WHEN bo2.customer_id IN (SELECT C1.cid1 FROM C1 WHERE C1.boc LIKE 'JUST4YOU5_____') THEN 'Vague 5' ELSE NULL END AS vague,
	count(DISTINCT CASE WHEN bo2.customer_id IN (SELECT C1.cid1 FROM C1) THEN bo2.customer_id ELSE NULL END) AS codes_churners,
	count(DISTINCT CASE WHEN bo2.customer_id IN (SELECT C1.cid1 FROM C1 INNER JOIN C2 ON C2.cid2 = C1.cid1 WHERE C2.date2 > C1.date1 AND C2.date2 < date_add(MONTH, 4, C1.date1)) THEN bo2.customer_id ELSE NULL END) AS repeaters_4mois,
	sum(CASE WHEN bo2.order_id IN (SELECT C1.oid1 FROM C1) THEN bo2.billing_product_ht ELSE NULL END)/100 AS ca_churner,
	count(DISTINCT CASE WHEN bo2.customer_id IN (SELECT C1.cid1 FROM C1 INNER JOIN C2 ON C2.cid2 = C1.cid1 WHERE C2.date2 > C1.date1) THEN bo2.customer_id ELSE NULL END) AS repeaters
FROM
	smallable2_datawarehouse.b_orders bo2
GROUP BY vague

	
WITH C1 AS (
SELECT
	bo.customer_id AS boi,
		bo.created_at AS bod,
		bo.order_id AS boo,
		bop.code_promo AS boc
FROM 
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.basket_id = bop.basket_id
WHERE 
	bop.code_promo LIKE ('JUST4YOU______')
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1),
C2 AS (
SELECT
		bo.customer_id AS cid2,
		bo.created_at AS date2,
		bo.order_id AS oid2,
		bo.billing_product_ht AS ca2
FROM 
	smallable2_datawarehouse.b_orders bo
WHERE 
	cid2 IN (
	SELECT
		C1.boi
	FROM
		C1))
SELECT
CASE WHEN bo2.customer_id IN (SELECT C1.boi FROM C1 WHERE C1.boc LIKE 'JUST4YOU______' AND right(trim(C1.boc),6) < ('065804')) THEN 'Vague 1'
WHEN bo2.customer_id IN (SELECT C1.boi FROM C1 WHERE C1.boc LIKE 'JUST4YOU______' AND RIGHT(trim(C1.boc),6) > ('065804') 	AND RIGHT(trim(C1.boc),6) < ('300000')) THEN 'Vague 2'
WHEN bo2.customer_id IN (SELECT C1.boi FROM C1 WHERE C1.boc LIKE 'JUST4YOU3_____') THEN 'Vague 3'
WHEN bo2.customer_id IN (SELECT C1.boi FROM C1 WHERE C1.boc LIKE 'JUST4YOU4_____') THEN 'Vague 4'
WHEN bo2.customer_id IN (SELECT C1.boi FROM C1 WHERE C1.boc LIKE 'JUST4YOU5_____') THEN 'Vague 5' ELSE NULL END AS vague,
	count(DISTINCT CASE WHEN bo2.customer_id IN (SELECT C1.boi FROM C1) THEN bo2.customer_id ELSE NULL END) AS codes_churners,
	sum(CASE WHEN bo2.order_id IN (SELECT C1.boo FROM C1) THEN bo2.billing_product_ht ELSE NULL END)/100 AS ca_churner,
	count(DISTINCT CASE WHEN bo2.customer_id IN (SELECT C1.boi FROM C1 INNER JOIN C2 ON C2.cid2 = C1.boi WHERE C2.date2 > C1.bod) THEN bo2.customer_id ELSE NULL END) AS repeaters,
count(DISTINCT CASE WHEN bo2.customer_id IN (SELECT C1.boi FROM C1 INNER JOIN C2 ON C2.cid2 = C1.boi WHERE C2.date2 > C1.bod AND C2.date2 < date_add(MONTH, 4, C1.bod)) THEN bo2.customer_id ELSE NULL END) AS repeaters_1mois
FROM
	smallable2_datawarehouse.b_orders bo2
GROUP BY vague

------------------- 3 derniers codes churner ------------------------------------
	
WITH C1 AS (
SELECT
	bo.customer_id AS boi,
		bo.created_at AS bod,
		bo.order_id AS boo,
		bop.code_promo AS boc
FROM 
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.basket_id = bop.basket_id
WHERE 
	bop.code_promo LIKE ('JUST4YOU5_____')
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1),
C2 AS (
SELECT
		bo.customer_id AS cid2,
		bo.created_at AS date2,
		bo.order_id AS oid2,
		bo.billing_product_ht AS ca2
FROM 
	smallable2_datawarehouse.b_orders bo
WHERE 
	cid2 IN (
	SELECT
		C1.boi
	FROM
		C1))
SELECT
	count(DISTINCT CASE WHEN bo2.customer_id IN (SELECT C1.boi FROM C1) THEN bo2.customer_id ELSE NULL END) as utilises,
	sum(CASE WHEN bo2.order_id IN (SELECT C1.boo FROM C1) THEN bo2.billing_product_ht ELSE NULL END)/100 as CA
FROM
	smallable2_datawarehouse.b_orders bo2