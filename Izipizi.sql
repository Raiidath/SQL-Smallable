---Je sors d’un RDV avec Izipizi.
--Peux-tu me renseigner sur la fréquence des paniers multi personnes sur la marque? c’est à dire 1 produit adulte et enfant et/ou bébé.

select count(distinct bop.basket_id) as basket
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop
on
	bo.order_id = bop.order_id
		AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bop.product_id 
inner join smallable2_datawarehouse.b_products bs ON
	bs.product_id = bp.product_id
where bs.brand_id = '967'
    AND bo.created_at >= '2022-08-29'
    AND bo.created_at <= '2023-08-28'
and bs.persons ilike ('child')


WITH paniers AS (
select
	distinct bop.basket_id as basket
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop
on
	bo.order_id = bop.order_id
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_products bs 
on
	bs.product_id = bop.product_id
where
	bs.brand_id = '967'
	and bo.created_at >= '2022-08-29'
	and bo.created_at <= '2023-08-28'
	and bs.persons ilike 'Adult' -- changer personnes ici
	)
select
	distinct bop.basket_id as basket1
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop
on
	bo.order_id = bop.order_id
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bop.basket_line_type_id = 2
	and bo.created_at >= '2022-08-29'
	and bo.created_at <= '2023-08-28'
inner join smallable2_datawarehouse.b_products bs 
on
	bs.product_id = bop.product_id
	and bs.brand_id = '967'
	and bs.persons in ('child', 'baby') -- changer personnes ici
WHERE
	basket1 IN (
	SELECT
		basket
	FROM
		paniers)
		
		
--Aussi pourrais-tu me renseigner sur les tops marques achetées dans les paniers comprenant Izipizi? Sur le kids d’une part et sur l’adulte d’autre part.
--Ceci sur une fenêtre des 12 derniers mois?

WITH paniers AS (
select
	distinct bo.order_id as oid
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop
on
	bo.order_id = bop.order_id
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_products bs 
on
	bs.product_id = bp.product_id
where
	bs.brand_id = '967'
	and bo.created_at >= '2022-08-29'
	and bo.created_at <= '2023-08-28'
	and bs.persons in ('baby', 'chid') -- changer personnes ici
	)
select
	bp.brand_name,
	count(distinct bo.order_id) as commandes,
	sum(bop.billing_product_ht)/ 100 AS ca
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bo.created_at >= '2022-08-29'
	and bo.created_at <= '2023-08-28'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_id = bop.sku_id
inner join smallable2_datawarehouse.b_products bp 
on
	bs.product_id = bp.product_id
WHERE
	bo.order_id IN (
	SELECT
		oid
	FROM
		paniers)
GROUP BY
	bp.brand_name
ORDER BY
	commandes desc
	

WITH paniers AS (
SELECT
	DISTINCT bo.order_id AS oid
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop
on
	bo.order_id = bop.order_id
		AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bop.product_id 
inner join smallable2_datawarehouse.b_products bs ON
	bs.product_id = bp.product_id
where bs.brand_id = '967'
    AND bo.created_at >= '2022-08-29'
    AND bo.created_at <= '2023-08-28'
	and bs.persons ilike 'adult' -- changer id marque et typo ici
	)
SELECT
	bp.brand_name,
	count(DISTINCT bo.order_id) AS commandes,
	sum(bop.billing_product_ht)/ 100 AS ca
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
    AND bo.created_at >= '2022-08-29'
    AND bo.created_at <= '2023-08-28' -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	--AND bp.default_person ilike 'child'
WHERE
	bo.order_id IN (
	SELECT
		oid
	FROM
		paniers)
GROUP BY
	bp.brand_name
ORDER BY
	commandes desc	

	
	
	
	

select distinct bp.default_person  
from smallable2_datawarehouse.b_products bp 

select distinct bp.persons 
from smallable2_datawarehouse.b_order_products bop 
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id 
where basket_id = '31520789'



select distinct bop.basket_id 
from smallable2_datawarehouse.b_order_products bop 
