
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
	
	
----------------------------- UNIQUEMMENT FRONT 
		
SELECT 
	count(c1.bid) AS cmd,
	sum(c1.Montant_Euros) AS CA, 
	CA / cmd AS panier_moyen
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
	sum(bop.billing_product_ht)/ 100 AS CA
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
	
	
						