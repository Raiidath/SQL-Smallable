---------------------------------------------Nb cmd et clients distincts pour les 6 saisons ----------------------------------------------

SELECT
	count(distinct bo.order_id) as cmd,
	count(distinct customer_id) as clients
from
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
		bop.order_id = bo.order_id
	AND bo.created_at >= '2019-02-15'
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
		bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
		bs.product_id = bp.product_id
	AND bp.brand_id = 63
where
	bo.created_at >'2019-02-15'
	AND bo.created_at <'2022-02-15'

---------------------------------- Nb clients et commandes par saison GLOBAL SITE --------------------------------------------------------------------------

SELECT
		CASE
			WHEN bo.created_at BETWEEN '2021-02-15' AND '2021-08-15' THEN 'PE21'
		WHEN bo.created_at BETWEEN '2021-08-15' AND '2022-02-15' THEN 'AH21'
		WHEN bo.created_at BETWEEN '2020-02-15' AND '2020-08-15' THEN 'PE20'
		WHEN bo.created_at BETWEEN '2020-08-15' AND '2021-02-15' THEN 'AH20'
		WHEN bo.created_at BETWEEN '2019-02-15' AND '2019-08-15' THEN 'PE19'
		WHEN bo.created_at BETWEEN '2019-08-15' AND '2020-02-15' THEN 'AH19'
	END AS saison,
		count(distinct bo.customer_id) AS cid,
		count(DISTINCT bo.order_id) AS nb_commandes,
		sum(bop.qty_ordered) as Nb_produit,
		nb_commandes/cid AS commandes_saison,
		Nb_produit/cid AS produit_saison,
		sum(bop.billing_product_ht)/ 100 as CA
FROM
		smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
		bop.order_id = bo.order_id
	AND bo.created_at >= '2019-02-15'
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
		bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
		bs.product_id = bp.product_id
GROUP BY
		saison
		
SELECT	top 5 bc.country_name as Pays,
		count(distinct bo.customer_id) AS cid,
		count(DISTINCT bo.order_id) AS nb_commandes,
		sum(bop.qty_ordered) as Nb_produit,
		nb_commandes/cid AS commandes_saison,
		Nb_produit/cid AS produit_saison,
		sum(bop.billing_product_ht)/ 100 as CA
FROM
		smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
		bop.order_id = bo.order_id
	AND bo.created_at >= '2019-02-15'
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
		bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
		bs.product_id = bp.product_id
INNER JOIN smallable2_datawarehouse.b_countries bc 
	on
	bc.country_id = bo.delivery_country_id
WHERE bo.created_at > '2019-08-15' 
AND bo.created_at < '2020-02-15' 
GROUP BY
		Pays
order by CA desc 
		
---------------------------------- Nb clients et commandes par saison Bellerose --------------------------------------------------------------------------
		
SELECT
		CASE
			WHEN bo.created_at BETWEEN '2021-02-15' AND '2021-08-15' THEN 'PE21'
		WHEN bo.created_at BETWEEN '2021-08-15' AND '2022-02-15' THEN 'AH21'
		WHEN bo.created_at BETWEEN '2020-02-15' AND '2020-08-15' THEN 'PE20'
		WHEN bo.created_at BETWEEN '2020-08-15' AND '2021-02-15' THEN 'AH20'
		WHEN bo.created_at BETWEEN '2019-02-15' AND '2019-08-15' THEN 'PE19'
		WHEN bo.created_at BETWEEN '2019-08-15' AND '2020-02-15' THEN 'AH19'
	END AS saison,
		count(distinct bo.customer_id) AS cid,
		count(DISTINCT bo.order_id) AS nb_commandes,
		sum(bop.qty_ordered) as Nb_produit,
		nb_commandes/cid AS commandes_saison,
		Nb_produit/cid AS produit_saison,
		sum(bop.billing_product_ht)/ 100 as CA
FROM
		smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
		bop.order_id = bo.order_id
	AND bo.created_at >= '2019-02-15'
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
		bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
		bs.product_id = bp.product_id
	AND bp.brand_id = 63
GROUP BY
		saison

		
------------------------------------------- Top CA, nb clients par pays et saison --------------------------------------------------
		
SELECT
		CASE
			WHEN bo.created_at BETWEEN '2021-02-15' AND '2021-08-15' THEN 'PE21'
		WHEN bo.created_at BETWEEN '2021-08-15' AND '2022-02-15' THEN 'AH21'
		WHEN bo.created_at BETWEEN '2020-02-15' AND '2020-08-15' THEN 'PE20'
		WHEN bo.created_at BETWEEN '2020-08-15' AND '2021-02-15' THEN 'AH20'
		WHEN bo.created_at BETWEEN '2019-02-15' AND '2019-08-15' THEN 'PE19'
		WHEN bo.created_at BETWEEN '2019-08-15' AND '2020-02-15' THEN 'AH19'
	END AS saison,
		bc.country_name as country, 
		count(distinct bo.customer_id) AS cid,
		count(DISTINCT bo.order_id) AS nb_commandes,
		sum(bop.billing_product_ht)/ 100 as CA
FROM
		smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
		bop.order_id = bo.order_id
	AND bo.created_at >= '2019-02-15'
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
		bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
		bs.product_id = bp.product_id
	AND bp.brand_id = 63
INNER JOIN smallable2_datawarehouse.b_countries bc 
	on
	bc.country_id = bo.delivery_country_id
GROUP BY
		saison,
	country
ORDER BY
	CA desc 

-------------------------------------------- nombre de clients uniques bellerose par saison ------------------------------------------------------------
SELECT
	b.saison,
	sum(b.nb_commandes) AS commandes_bellerose,
	count(DISTINCT b.cid) AS clients_bellerose,
	sum(b.nb_commandes)/count(b.cid) AS commandes_saison,
	count(CASE WHEN b.nb_commandes = 1 THEN b.cid ELSE NULL END)/count(b.cid) AS "% 1 commande dans la saison",
	count(CASE WHEN b.nb_commandes = 2 THEN b.cid ELSE NULL END)/count(b.cid) AS "% 2 commandes dans la saison",
	count(CASE WHEN b.nb_commandes > 2 THEN b.cid ELSE NULL END)/count(b.cid) AS "% 3+ commandes dans la saison"
FROM
	(
	SELECT
		CASE
			WHEN bo.created_at BETWEEN '2021-02-15' AND '2021-08-15' THEN 'PE21'
			WHEN bo.created_at BETWEEN '2021-08-15' AND '2022-02-15' THEN 'AH21'
			WHEN bo.created_at BETWEEN '2020-02-15' AND '2020-08-15' THEN 'PE20'
			WHEN bo.created_at BETWEEN '2020-08-15' AND '2021-02-15' THEN 'AH20'
			WHEN bo.created_at BETWEEN '2019-02-15' AND '2019-08-15' THEN 'PE19'
			WHEN bo.created_at BETWEEN '2019-08-15' AND '2020-02-15' THEN 'AH19'
		END AS saison,
		bo.customer_id AS cid,
		count(DISTINCT bo.order_id) AS nb_commandes,
		count(DISTINCT CASE WHEN bp.gender IN ('boy', 'girl') THEN bo.order_id ELSE NULL END) AS commandes_enfant,
		count(DISTINCT CASE WHEN bp.gender = 'woman' THEN bo.order_id ELSE NULL END) AS commandes_femme
	FROM
		smallable2_datawarehouse.b_orders bo
	INNER JOIN smallable2_datawarehouse.b_order_products bop ON
		bop.order_id = bo.order_id
		AND bo.created_at >= '2019-02-15'
		AND bo.is_valid = 1
		AND bo.is_ca_ht_not_zero = 1
		AND bop.basket_line_type_id = 2
	INNER JOIN smallable2_datawarehouse.b_skus bs ON
		bs.sku_id = bop.sku_id
	INNER JOIN smallable2_datawarehouse.b_products bp ON
		bs.product_id = bp.product_id
		AND bp.brand_id = 63
	GROUP BY
		saison,
		cid) b
GROUP BY
	b.saison

	
--------------------------------------------% de client AH18 ayant acheté sur PE19, AH19, PE20------------------------------------------------------------	
			
With o_bellerose as (
select
	bo2.order_id as oid
FROM
	smallable2_datawarehouse.b_orders bo2
INNER JOIN smallable2_datawarehouse.b_order_products bop
			ON
			bo2.order_id = bop.order_id
	and bo2.basket_id = bop.basket_id
	AND bo2.is_valid = 1
	AND bo2.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_skus bs 
			ON
			bs.sku_code = bop.sku_code
INNER JOIN smallable2_datawarehouse.b_products bp 
			ON
			bp.product_id = bs.product_id
WHERE
	bp.brand_name = 'Bellerose')		
SELECT
	count(DISTINCT CASE WHEN v2.PE19 >= 1 THEN v2.customer_id ELSE NULL END) AS client_pe19,
	count(DISTINCT CASE WHEN v2.PE19 >= 1 AND v2.AH19 >= 1 THEN v2.customer_id ELSE NULL END) AS client_pe19_ah19,
	count(DISTINCT CASE WHEN v2.PE19 >= 1 AND v2.PE20 >= 1 THEN v2.customer_id ELSE NULL END) AS client_pe19_pe20,
	count(DISTINCT CASE WHEN v2.PE19 >= 1 AND v2.AH20 >= 1 THEN v2.customer_id ELSE NULL END) AS client_pe19_ah20,
	count(DISTINCT CASE WHEN v2.PE19 >= 1 AND v2.PE21 >= 1 THEN v2.customer_id ELSE NULL END) AS client_pe19_pe21,
	count(DISTINCT CASE WHEN v2.PE19 >= 1 AND v2.AH21 >= 1 THEN v2.customer_id ELSE NULL END) AS client_pe19_ah21,	
	count(DISTINCT CASE WHEN v2.AH19 >= 1 THEN v2.customer_id ELSE NULL END) AS client_ah19,
	count(DISTINCT CASE WHEN v2.AH19 >= 1 AND v2.PE20 >= 1 THEN v2.customer_id ELSE NULL END) AS client_ah19_pe20,
	count(DISTINCT CASE WHEN v2.AH19 >= 1 AND v2.AH20 >= 1 THEN v2.customer_id ELSE NULL END) AS client_ah19_ah20,
	count(DISTINCT CASE WHEN v2.AH19 >= 1 AND v2.PE21 >= 1 THEN v2.customer_id ELSE NULL END) AS client_ah19_pe21,
	count(DISTINCT CASE WHEN v2.AH19 >= 1 AND v2.AH21 >= 1 THEN v2.customer_id ELSE NULL END) AS client_ah19_ah21,
	count(DISTINCT CASE WHEN v2.PE20 >= 1 THEN v2.customer_id ELSE NULL END) AS client_pe20,
	count(DISTINCT CASE WHEN v2.PE20 >= 1 AND v2.AH20 >= 1 THEN v2.customer_id ELSE NULL END) AS client_pe20_ah20,
	count(DISTINCT CASE WHEN v2.PE20 >= 1 AND v2.PE21 >= 1 THEN v2.customer_id ELSE NULL END) AS client_pe20_pe21,
	count(DISTINCT CASE WHEN v2.PE20 >= 1 AND v2.AH21 >= 1 THEN v2.customer_id ELSE NULL END) AS client_pe20_ah21,
	count(DISTINCT CASE WHEN v2.AH20 >= 1 THEN v2.customer_id ELSE NULL END) AS client_ah20,
	count(DISTINCT CASE WHEN v2.AH20 >= 1 AND v2.PE21 >= 1 THEN v2.customer_id ELSE NULL END) AS client_ah20_pe21,
	count(DISTINCT CASE WHEN v2.AH20 >= 1 AND v2.AH21 >= 1 THEN v2.customer_id ELSE NULL END) AS client_ah20_ah21,
	count(DISTINCT CASE WHEN v2.PE21 >= 1 THEN v2.customer_id ELSE NULL END) AS client_pe21,
	count(DISTINCT CASE WHEN v2.PE21 >= 1 AND v2.AH21 >= 1 THEN v2.customer_id ELSE NULL END) AS client_pe21_ah21
FROM
	(
	SELECT
		v1.customer_id,
		sum(v1.AH19) AS AH19,
		sum(v1.AH20) AS AH20,
		sum(v1.PE19) AS PE19,
		sum(v1.PE20) AS PE20,
		sum(v1.PE21) AS PE21,
		sum(v1.AH21) AS AH21
	FROM
		(
		SELECT
			distinct bo.customer_id,
			CASE
				WHEN bo.created_at BETWEEN '2021-02-15' AND '2021-08-15' THEN 1
				ELSE 0
			END AS PE21,
			Case
				WHEN bo.created_at BETWEEN '2021-08-15' AND '2022-02-15' THEN 1
				ELSE 0
			END as AH21,
			case
				WHEN bo.created_at BETWEEN '2020-02-15' AND '2020-08-15' THEN 1
				ELSE 0
			END as PE20,
			case
				WHEN bo.created_at BETWEEN '2020-08-15' AND '2021-02-15' THEN 1
				ELSE 0
			END as AH20,
			case
				WHEN bo.created_at BETWEEN '2019-02-15' AND '2019-08-15' THEN 1
				ELSE 0
			END as PE19,
			case
				WHEN bo.created_at BETWEEN '2019-08-15' AND '2020-02-15' THEN 1
				ELSE 0
			END as AH19
		FROM
			smallable2_datawarehouse.b_orders bo
		where
			bo.created_at >= '2019-02-15'
			and bo.order_id IN (
			SELECT
				oid
			FROM
				o_bellerose)) v1
	GROUP BY
		v1.customer_id) v2