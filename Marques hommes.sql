---------------------------------------Remplacer les rawgender par gender  -----------------------

select bp.product_name  as Produit,
	bp.brand_name as Marques,
	bs.product_type_N4   as type,
	--count(distinct bo.order_id) as Nb_order,
	sum(bop.qty_ordered) as Nb_achat,
	sum(bop.billing_product_ht)/100 AS ca
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
	and bp.gender = 'man'
	and bp.sml_team = 'mode'
inner join smallable2_datawarehouse.b_orders bo 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bop.basket_line_type_id = 2
where
	bo.created_at <= '2022-03-31'
	and
	 bo.created_at >= '2021-01-01'
	and bo.first_order_vs_repeat = 'Réachat'
group by
	Produit, 
	Marques,
	type  
order by
	Nb_achat desc 
      

select
	bc.zone_code  as country, 
	sum(bop.qty_ordered) as Nb_achat,
	sum(bop.billing_product_ht)/100 AS ca
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
	and bp.gender = 'man'
	and bp.sml_team = 'mode'
inner join smallable2_datawarehouse.b_orders bo 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1 
inner join smallable2_datawarehouse.b_countries bc 
on bc.country_id  = bo.delivery_country_id 
where
	bo.created_at < '2022-03-28'
	and bo.created_at > '2021-03-28'
group by
	country 
order by Nb_achat desc





select
	bc.country_name  as country, 
	sum(bop.qty_ordered) as Nb_achat,
	sum(bop.billing_product_ht)/100 AS ca
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
	--and bp.gender = 'man'
	--and bp.sml_team = 'mode'
inner join smallable2_datawarehouse.b_orders bo 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1 
inner join smallable2_datawarehouse.b_countries bc 
on bc.country_id  = bo.delivery_country_id 
where
	bo.created_at < '2022-03-28'
	and bo.created_at > '2021-03-28'
group by
	country 
order by Nb_achat desc

select
	bc.zone_code  as country,
	count(CASE WHEN bp.sml_team = 'mode' and bp.gender = 'man' then bop.qty_ordered  ELSE NULL END) as Nb_achat,
	sum(CASE WHEN bp.sml_team = 'mode' and bp.gender = 'man' then bop.billing_product_ht ELSE NULL END)/ 100 as mode_homme,
	sum(CASE WHEN bp.sml_team = 'mode' and bp.gender = 'woman' then bop.billing_product_ht ELSE NULL END)/ 100 as mode_femme,
	sum(CASE WHEN bp.sml_team = 'mode' and bp.gender = 'boy' or  bp.gender = 'mixte_child' or  bp.gender = 'girl' then bop.billing_product_ht ELSE NULL END)/ 100 as mode_enfant,
	sum(CASE WHEN bp.sml_team = 'design' then bop.billing_product_ht ELSE NULL END)/ 100 as design,
	sum(bop.billing_product_ht)/100 as global_site
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
inner join smallable2_datawarehouse.b_orders bo 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
inner join smallable2_datawarehouse.b_countries bc 
on
	bc.country_id = bo.delivery_country_id
where
	bo.created_at < '2022-03-28'
	and bo.created_at > '2021-03-28'
group by
	country
order by
	mode_homme desc

SELECT sum(bop.billing_discount_product_ht)/100 as ca, bc.country_name as country
from smallable2_datawarehouse.b_order_products bop 
inner join smallable2_datawarehouse.b_orders bo 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	and bo.created_at < '2022-03-28'
	and bo.created_at > '2021-03-28'
inner join smallable2_datawarehouse.b_countries bc 
on bc.country_id  = bo.delivery_country_id 
group by country
order by ca desc
----------------------------------------------------------------------

select
	toStartOfMonth(bo.created_at) as Mois,
	sum(bop.billing_product_ht)/100 AS ca
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
	--and bp.gender = 'man'
	and bp.sml_team = 'mode'
inner join smallable2_datawarehouse.b_orders bo 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1 
inner join smallable2_datawarehouse.b_countries bc 
on bc.country_id  = bo.delivery_country_id 
where
	bo.created_at < '2022-03-28'
	and bo.created_at > '2021-03-28'
	--and bp.brand_id = '1492'
group by
	Mois

---------------------------------------------------------------------------
	
WITH paniers AS (
SELECT
	DISTINCT bo.order_id AS oid
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	and bo.created_at < '2022-03-28'
	and bo.created_at > '2021-03-28' -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	and bp.gender = 'man'
	and bp.sml_team = 'mode'
	AND bp.brand_id = 180 -- changer id marque ici
	)
SELECT bp.brand_name,
count(DISTINCT bo.order_id) AS commandes,
sum(bop.billing_product_ht)/100 AS ca
FROM
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
inner join smallable2_datawarehouse.b_orders bo 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bop.basket_line_type_id = 2
where
	bo.created_at < '2022-03-28'
	and bo.created_at > '2021-03-28'
	--and bo.first_order_vs_repeat = '1ère Commande'
	and bo.order_id IN (SELECT oid FROM paniers)
GROUP BY bp.brand_name 
ORDER BY commandes desc

-----------------------------------------------------------------------------------------------------------------------------------------------------

select
	distinct bop.basket_id as Panier,
	bp.brand_name as Marques, 
	bo.customer_id as client,
	--bs.product_type_N4  as type,
	--sum(bo.qty_ordered) as Nb_achat,
	--count(distinct bo.order_id) as Nb_order,
	sum(bo.qty_ordered) as Nb_achat,
	sum(bop.billing_product_ht)/100 AS ca
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
	and bp.gender = 'man'
	and bp.sml_team  = 'mode'
inner join smallable2_datawarehouse.b_orders bo 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bop.basket_line_type_id = 2
where
	bo.created_at < '2022-03-28'
	and bo.created_at > '2021-03-28'
	--and bo.first_order_vs_repeat = '1ère Commande'
group by
	Panier, Marques,client
order by
	Nb_achat desc 
	
-----------------------  Produits / marques / typo associés dans les paniers qui contiennent de la mode homme --------------------------------

WITH paniers AS (
SELECT
	DISTINCT bo.order_id AS oid
from
	smallable2_datawarehouse.b_orders bo
inner JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	AND bo.created_at < '2022-03-28'
	and bo.created_at > '2021-03-28' -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	and bp.gender = 'woman'
	and bp.sml_team = 'mode'
	)
select
	bo.basket_id as panier,
	sum(bop.qty_ordered) as commandes,
	sum(bop.billing_product_ht)/ 100 AS ca
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	AND bo.created_at < '2022-03-28'
	and bo.created_at > '2021-03-28' -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	WHERE bo.order_id IN (SELECT oid FROM paniers)
	GROUP BY panier 
	ORDER BY commandes desc
	
-------------------------------------------------- produits que les anciens clients avaients dans leur paniers ---------------------------------------------------------------------------	
	
WITH paniers AS (
SELECT
	DISTINCT bo.order_id AS oid, bo.customer_id as cid
from
	smallable2_datawarehouse.b_orders bo
inner JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	AND bo.created_at < '2022-03-28'
	and bo.created_at > '2021-03-28' -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
	and bo.first_order_vs_repeat = 'Réachat'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	and bp.gender = 'man'
	and bp.sml_team = 'mode'	
	)
select
	--bp.product_name as produit,
	bp.brand_name  as marques, 
	--bs.product_type_N4  as type, 
	sum(bop.qty_ordered) as commandes,
	sum(bop.billing_product_ht)/ 100 AS ca
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	and bo.created_at < '2021-03-28' -- changer plage de date ici
	and bo.created_at > '2018-03-28'
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	WHERE bo.customer_id in (select cid from paniers)
	and bo.order_id not IN (SELECT oid FROM paniers)
	GROUP BY marques
	--,produit
	--, type
	ORDER BY commandes desc
	