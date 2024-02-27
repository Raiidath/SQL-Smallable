---------------------------------Client affinitaire bobo chose -----------------------------------------------
WITH paniers AS (
SELECT
	DISTINCT bo.order_id AS oid
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	AND bo.created_at > '2021-03-25' -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_id = 75 -- changer id marque ici
	)
SELECT top 20 bp.brand_name,
count(DISTINCT bo.order_id) AS commandes,
sum(bop.billing_product_ht)/100 AS ca
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	AND bo.created_at > '2021-03-25'  -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	WHERE bo.order_id IN (SELECT oid FROM paniers)
	GROUP BY bp.brand_name 
	ORDER BY commandes desc
	

-------------------TOP clients Bobo chose -------------------------------------------
	
SELECT
	DISTINCT bo.customer_id,  bc.email, count(bc.email) as Nb
	, sum(distinct bo.billing_product_ht)/100 as CA
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	AND bo.created_at > '2021-03-25' -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
INNER JOIN smallable2_datawarehouse.b_customers bc 
on bc.customer_id = bo.customer_id 
	AND bp.brand_id = 75 -- changer id marque ici
group by bo.customer_id, bc.email 
order by Nb desc 

------------------------------ Top achat bobo chose ------------------------------

SELECT
	DISTINCT bp.product_name as produit, bs.product_type_N4 as type,  count(bo.customer_id) as Nb 
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	AND bo.created_at > '2021-03-25' -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_id = 75 -- changer id marque ici
group by produit, type 
order by Nb desc 


SELECT
	DISTINCT bp.persons  as type ,  count(bo.customer_id) as Nb 
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	AND bo.created_at > '2021-03-25' -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_id = 75 -- changer id marque ici
group by type 
order by Nb desc 


SELECT
	DISTINCT bs.product_type_N4 as type ,  count(bo.customer_id) as Nb 
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	AND bo.created_at > '2021-03-25' -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_id = 75 -- changer id marque ici
group by type 
order by Nb desc


--------------------------- Fréquence d'achat clients historiques ----------------------------------------

SELECT
	distinct bo.created_at as date_cmd, bo.billing_product_ht/100 as CA 
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	AND bo.created_at > '2021-03-25' -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
	AND bo.customer_id = '545279'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_id = 75 -- changer id marque ici