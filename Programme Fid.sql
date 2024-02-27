SELECT * FROM
	public."Customer" c
GROUP BY
	1
	ORDER BY 1 ASC 	


SELECT * FROM
	public."Order" o
GROUP BY
	1
	ORDER BY 1 ASC 	

	
	
SELECT * FROM
	public."Reward" r
GROUP BY
	1
	ORDER BY 1 ASC 
	
	
SELECT * FROM
	public."Voucher" v
GROUP BY
	1
	ORDER BY 1 ASC 	

-- nombre d'inscrits par jour--
SELECT
Date(c."subscribedToLoyaltyAt") AS d,
	count(1),
	max(c."subscribedToLoyaltyAt")
FROM
	public."Customer" c
GROUP BY
	1
	ORDER BY 1 ASC 
	
	
SELECT
Date(c."subscribedToLoyaltyAt") AS d,
	count(1),
	max(c."subscribedToLoyaltyAt")
FROM
	public."Customer" c
GROUP BY
	1
	ORDER BY 1 ASC 
	
	
	
-- nombre de bons émis par jours--
SELECT
	date(v."createdAt") AS d,
	count(v.id) AS nb_emis,
	count(v.id) FILTER (
WHERE
	v.status = 'AVAILABLE') AS available,
	count(v.id) FILTER (
WHERE
	v.status = 'USED') +
	count(v.id) FILTER (
WHERE
	v.status = 'SPENT') AS spent,
	count(v.id) FILTER (
WHERE
	v.status = 'EXPIRED') AS expired
FROM
	public."Voucher" v
GROUP BY
	1
ORDER BY
	1 ASC

	
	
SELECT count(DISTINCT bo.basket_id)  
FROM
	smallable2_datawarehouse.b_orders bo 
INNER JOIN smallable2_front.basket_line bl
ON bo.basket_id = bl.basket_id 
AND bl.basket_line_type_id = '15'	
	
		
	

SELECT --bc.country_name  as pays,
    --s.product_type_N5 AS Typo, 
   --bop.sml_team AS secteur, 
	count(DISTINCT bo.order_id) AS cmd,  
	sum(CASE WHEN  bl.basket_line_type_id = '15' THEN bop.billing_product_ht / 100 ELSE NULL end) AS ca,
	--round(sum(CASE WHEN b_order_products.discount_product_rate in ('0', 'NaN') THEN bop.billing_product_ht / 100 ELSE NULL END), 0) AS CA_FP,
	sum((bop.billing_product_ht - bop.cost_product_ht) / 100) AS marge_ht3,
	ca/cmd AS PM
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_front.basket_line bl
ON bo.basket_id = bl.basket_id 
AND bl.basket_line_type_id = '15'	
AND bo.validated >= '2023-06-14'
WHERE
		bo.basket_id IN (
							SELECT
							bl.basket_id
							FROM
							smallable2_front.basket_line bl
							WHERE
							bl.basket_line_type_id = '15'
						)
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1

GROUP BY secteur 
ORDER BY ca_ah23 DESC
	
	
-- Panier moyens des paniers avec bons fid


SELECT DISTINCT bo.currency_rate_dim  FROM smallable2_datawarehouse.b_orders bo 

	
	
SELECT 
	count(c1.bid) AS cmd,
	sum(c1.Montant_Euros) AS CA, 
	CA / cmd AS panier_moyen
FROM
	(
	SELECT
		bo.basket_id AS bid,
		CAST(bo.total_amount AS Decimal(18,
		5)) / CAST(bo.currency_rate_dim AS Decimal(18,
		5)) AS Montant_Euros
	FROM
		smallable2_datawarehouse.b_orders bo 
	WHERE
		bo.basket_id IN (
							SELECT
							bl.basket_id
							FROM
							smallable2_front.basket_line bl
							WHERE
							bl.basket_line_type_id = '15'
						)
	GROUP BY
		bo.basket_id,
		bo.total_amount,
		bo.currency_rate_dim) c1 	
	
		
		
SELECT 
	count(DISTINCT bo.order_id) AS cmd,
	round(sum(CASE WHEN bl.basket_line_type_id = '15' then bop.billing_product_ht/100 ELSE NULL END),0) AS CA, 
	round(CA / cmd, 0) AS panier_moyen
FROM
		smallable2_datawarehouse.b_orders bo 
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON bo.order_id = bop.order_id
	AND bo.basket_id = bo.basket_id
INNER JOIN smallable2_front.basket_line bl
ON bo.basket_id = bl.basket_id 
	AND bl.basket_line_type_id = '15'
	
	
	
SELECT * FROM smallable2_datawarehouse.b_baskets bb 	


	
----------------------------- UNIQUEMMENT FRONT 
		
SELECT 
	count(c1.bid) AS cmd,
	round(sum(c1.Montant_Euros), 0) AS CA, 
	round(CA / cmd, 0) AS panier_moyen
FROM
	(
	SELECT
		co.basket_id AS bid,
		co.customer_id AS cid,
		CAST(co.total_amount AS Decimal(18,
		5)) / CAST(co.currency_rate AS Decimal(18,
		5)) AS Montant_Euros
	FROM
		smallable2_front.customer_order co
	WHERE
		co.basket_id IN (
							SELECT
							bl.basket_id
							FROM
							smallable2_front.basket_line bl
							WHERE
							bl.basket_line_type_id = '15'
						)
	GROUP BY
		co.basket_id,
		co.customer_id,
		co.total_amount,
		co.currency_rate) c1 			
		
		
						
SELECT c.id, c.rate AS rate
FROM
	smallable2_front.currency c  
						
-------------------------- Top  Produits



SELECT
	DISTINCT bop.product_id AS ID,
	bp.product_name AS top_produits,
	bp.brand_name AS brand,
	count(bop.order_id) AS cmd,
	sum(bop.qty_ordered) AS N_produit,
	round(sum(bop.billing_product_ht)/ 100, 0) AS CA
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_front.basket_line bl	
ON
	bo.basket_id = bl.basket_id
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bo.basket_id
INNER JOIN smallable2_datawarehouse.b_products bp 
ON
	bp.product_id = bop.product_id
WHERE
	bl.basket_line_type_id = '15'
GROUP BY
	bop.product_id,
	bp.product_name,
	bp.brand_name
ORDER BY
	CA DESC 
	

SELECT
	DISTINCT bp.brand_name AS brand,
	count(bop.order_id) AS cmd,
	sum(bop.qty_ordered) AS N_produit,
	round(sum(bop.billing_product_ht)/ 100, 0) AS CA
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_front.basket_line bl	
ON
	bo.basket_id = bl.basket_id
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bo.basket_id
INNER JOIN smallable2_datawarehouse.b_products bp 
ON
	bp.product_id = bop.product_id
WHERE
	bl.basket_line_type_id = '15'
GROUP BY
	bp.brand_name
ORDER BY
	CA DESC 
	
			
SELECT
	DISTINCT bp.sml_team  AS Secteur,
	count(DISTINCT bop.order_id) AS cmd,
	sum(bop.qty_ordered) AS N_produit,
	round(sum(bop.billing_product_ht)/ 100, 0) AS CA
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_front.basket_line bl	
ON
	bo.basket_id = bl.basket_id
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bo.basket_id
INNER JOIN smallable2_datawarehouse.b_products bp 
ON
	bp.product_id = bop.product_id
WHERE
	bl.basket_line_type_id = '15'
GROUP BY
	bp.sml_team 
ORDER BY
	CA DESC 
	
			
		
	
----------------------- basket line type = 15 pour les opés Loyalty
SELECT *
FROM smallable2_front.basket_line bl	
WHERE
	bl.basket_line_type_id = '15'
	
	
