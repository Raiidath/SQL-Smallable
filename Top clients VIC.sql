SELECT 
	    bc.customer_id AS cid, bc.email AS email, 
	CASE
		WHEN c9."client running %" < 1 THEN 'top 1%'
		WHEN c9."client running %" < 8 THEN 'top 1 - 8%'
		WHEN c9."client running %" < 15 THEN 'top 8 - 15%'
		WHEN c9."client running %" < 20 THEN 'top 20%'
		WHEN c9."client running %" < 50 THEN 'top 50%'
		WHEN c9."client running %" IS NULL THEN 'nc'
		ELSE 'top 51+'
	END AS top_clients
FROM
	smallable2_datawarehouse.b_customers bc
LEFT JOIN (
	SELECT
		c2.cid, c2.email,
		100 * c2.running_nb / c2.nb AS "client running %",
		100 * c2.ca / c2.total AS "%",
		100 * c2.running_total / c2.total AS "running %"
	FROM
		(
		SELECT
			*,
			sum(c1.ca) OVER() AS total,
			sum(c1.ca) OVER(
		ORDER BY
			c1.ca DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
			count(c1.cid) OVER() AS nb,
			count(c1.cid) OVER(
		ORDER BY
			c1.ca DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_nb
		FROM
			(
			SELECT
				bo.customer_id AS cid, bc2.email AS email,
				sum(bo.billing_product_ht / 100) AS ca
			FROM
				smallable2_datawarehouse.b_orders bo
			INNER JOIN smallable2_datawarehouse.b_customers bc2 
			ON bc2.customer_id = bo.customer_id
			inner join smallable2_front.customer_order_address coa
				on
				coa.id = bo.delivery_address_id
				--and coa.country_id = 11
			WHERE
				bo.is_valid = 1
				AND bo.is_ca_net_ht_not_zero = 1
				--AND bo.created_at BETWEEN '2023-08-14' AND '2024-02-14' 
				AND bo.created_at BETWEEN '2024-01-14' AND '2024-02-14'
				AND bo.delivery_country_iso  = 'UK'
				--AND coa.city ilike 'porto'
			GROUP BY
				cid,email
			ORDER BY
				ca DESC) c1
		GROUP BY
			cid, email,
			ca
		ORDER BY
			ca DESC) c2) c9 ON bc.customer_id = c9.cid AND bc.email = c9.email
WHERE top_clients NOT IN ('nc')			
			

			
SELECT 
	    bc.customer_id AS cid, bc.email AS email, 	lower(hex(MD5(lower(bc.email)))) AS md5,
	CASE
		WHEN c9."client running %" < 1 THEN 'top 1%'
		WHEN c9."client running %" < 8 THEN 'top 1 - 8%'
		WHEN c9."client running %" < 15 THEN 'top 8 - 15%'
		WHEN c9."client running %" < 20 THEN 'top 20%'
		WHEN c9."client running %" < 50 THEN 'top 50%'
		WHEN c9."client running %" IS NULL THEN 'nc'
		ELSE 'top 51+'
	END AS top_clients
FROM
	smallable2_datawarehouse.b_customers bc
LEFT JOIN (
	SELECT
		c2.cid, c2.email,
		100 * c2.running_nb / c2.nb AS "client running %",
		100 * c2.ca / c2.total AS "%",
		100 * c2.running_total / c2.total AS "running %"
	FROM
		(
		SELECT
			*,
			sum(c1.ca) OVER() AS total,
			sum(c1.ca) OVER(
		ORDER BY
			c1.ca DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
			count(c1.cid) OVER() AS nb,
			count(c1.cid) OVER(
		ORDER BY
			c1.ca DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_nb
		FROM
			(
			SELECT
				bo.customer_id AS cid, bc2.email AS email,
				sum(bo.billing_product_ht / 100) AS ca
			FROM
				smallable2_datawarehouse.b_orders bo
			INNER JOIN smallable2_datawarehouse.b_customers bc2 
			ON bc2.customer_id = bo.customer_id
			WHERE
				bo.is_valid = 1
				AND bo.is_ca_net_ht_not_zero = 1
				--AND bo.created_at BETWEEN '2021-08-14' AND '2024-02-14'
			--AND bo.delivery_country_iso  IN ('UK', 'FR') -- ,'DK'--('AE','SA', 'QA', 'KW', 'BH', 'IL' )
			GROUP BY
				cid, email
			ORDER BY
				ca DESC) c1
		GROUP BY
			cid, email,
			ca
		ORDER BY
			ca DESC) c2) c9 ON bc.customer_id = c9.cid AND bc.email = c9.email
WHERE top_clients NOT IN ('nc') 
			

SELECT DISTINCT 
   -- bo.customer_id AS clients_global, 
   -- CONCAT(bc.lastname, ' ', bc.firstname) AS fullname, 
    DISTINCT bc.email as email,
    CASE 
        WHEN bc.email IN ('violaine.lopez@wanadoo.fr', 'audrey.caminades@dechert.com', 'asmouquet@mac.com', 'beck.patricia@moebelthoeny.li') 
        THEN LOWER(HEX(MD5(LOWER(bc.email))))
    END AS md5
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
	--AND bp.persons IN ('child', 'teenager')
inner join smallable2_datawarehouse.b_customers bc 
on bo.customer_id = bc.customer_id 



select
	--distinct bo.customer_id as clients_global, 
	--concat(bc.lastname, ' ', bc.firstname), 
	DISTINCT bc.customer_id  , bc.email as email, 
	lower(hex(MD5(lower(bc.email)))) AS md5
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
	--AND bp.persons IN ('child', 'teenager')
inner join smallable2_datawarehouse.b_customers bc 
on bo.customer_id = bc.customer_id 
 --AND bc.email = 'violaine.lopez@wanadoo.fr'  --'audrey.caminades@dechert.com'
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
where
    --bo.created_at BETWEEN '2023-08-14' AND '2024-02-14'
    bo.created_at BETWEEN '2022-01-14' AND '2024-02-18' 
   -- email in ('violaine.lopez@wanadoo.fr', 'audrey.caminades@dechert.com', 'asmouquet@mac.com', 'beck.patricia@moebelthoeny.li')
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	--and bp.sml_team = 'mode'
	--AND s.cible IN  ('Femme') --('BB/Enf/Ado', 'Bébé', 'Enfant', 'Adolescent')  --('femme')   --'Enfant', 'Adolescent')
--	AND s.product_type_N5  IN  ('Jouets') --('Chaussures') --Jouets
	
	
SELECT * from	smallable2_datawarehouse.b_products bp 

SELECT   * -- DISTINCT s.cible  
FROM smallable2_datawarehouse.b_skus s