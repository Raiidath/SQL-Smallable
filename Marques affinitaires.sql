---------- Sortir les marques qui sont pr�sentes dans les paniers contenant au moins un produit de la marque petite friture 
--------------Marques affinitaires (dernier an) de Petit Nord
	
WITH paniers AS (
SELECT
	DISTINCT bo.order_id AS oid
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
    AND bo.created_at >= '2023-11-01'
    AND bo.created_at <= '2024-02-05' -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
	--AND bop.business_season = 'PE23'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_name  = 'garbo&friends'
--WHERE bs.raw_gender  in ('boy', 'girl')
	--AND bs.personne_genre = 'Adulte woman'
	--AND bs.product_type_N5 = 'Jouets' -- changer id marque et typo ici
	)
SELECT
	bp.brand_name,
	count(DISTINCT bo.order_id) AS commandes,
	sum(bop.billing_product_ht)/ 100 AS ca
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
    AND bo.created_at >= '2023-11-01'
    AND bo.created_at <= '2024-02-05' -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	--AND bs.product_type_N5 = 'Jouets'
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
	
	 
	
select distinct bp.brand_name, count(distinct bo.order_id) as cmd 
from smallable2_datawarehouse.b_products bp 
inner join smallable2_datawarehouse.b_order_products bop 
on bp.product_id  = bop.product_id 
inner join smallable2_datawarehouse.b_orders bo 
on bop.basket_id = bo.basket_id 
AND bop.order_id = bo.order_id 
where bo.created_at >= '2021-09-15'
	AND bo.created_at <= '2021-12-31'
	AND bp.product_type_N5_refco = 'Jouets'
	--AND bp.brand_id = 1107
group by bp.brand_name 




SELECT
 bo.order_id AS oid
FROM
	smallable2_datawarehouse.b_order_products bop
INNER JOIN smallable2_datawarehouse.b_orders bo ON
	bop.order_id = bo.order_id
    AND bo.created_at  >= '2023-01-01'
    AND bo.created_at  <= '2023-05-13' -- changer plage de date ici
	AND bo.is_valid  = 1
	AND bo.is_ca_net_ht_not_zero  = 1
	AND bop.basket_line_type_id  = 2
INNER JOIN smallable2_datawarehouse.b_skus bs  ON
	bs.sku_id  = bop.sku_id 
	AND bs.brand_id = '75'
	
INNER JOIN smallable2_datawarehouse.b_products bp  ON
	bs.product_id  = bp.product_id 
	AND bp.brand_name  = '75'




SELECT
	bp.brand_name  as Marque ,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-04-19' AND bo.created_at <=  '2022-04-25' THEN bo.order_id ELSE NULL END) AS cmd_s,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-04-12' AND bo.created_at <=  '2022-04-18' THEN bo.order_id ELSE NULL END) AS cmd_s1,
	sum(CASE WHEN bo.created_at >= '2022-04-19' AND bo.created_at <=  '2022-04-25' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_s,
	sum(CASE WHEN bo.created_at >= '2022-04-12' AND bo.created_at <=  '2022-04-18' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_s1
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bp.product_id  = bop.product_id 
	AND bp.brand_name in ('Bloomingville','Serax','Petite friture','Broste Copenhagen', 'Business & Pleasure Co.', 'Communaut� de biens','Houe','Verpan','Fermob','Cosydar','Chabi Chic','Rice')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at >= '2022-04-19' AND bo.created_at <=  '2022-04-25'
	OR bo.created_at >= '2022-04-12' AND bo.created_at <=  '2022-04-18'
GROUP BY
	bp.brand_name  
ORDER BY
	ca_s desc
	
	
SELECT
	bp.brand_name  as Marque ,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-11-24' AND bo.created_at <=  '2022-11-30' THEN bo.order_id ELSE NULL END) AS cmd_s,
	count(DISTINCT CASE WHEN bo.created_at >= '2022-11-17' AND bo.created_at <=  '2022-11-23' THEN bo.order_id ELSE NULL END) AS cmd_s1,
	sum(CASE WHEN bo.created_at >= '2022-11-24' AND bo.created_at <=  '2022-11-30' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_s,
	sum(CASE WHEN bo.created_at >= '2022-11-17' AND bo.created_at <=  '2022-11-23' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_s1
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bp.product_id  = bop.product_id 
	AND bp.brand_name in ('Petit Nord','Risu Risu','Aiayu','Jars C�ramistes','Inuikii','Liewood','Sess�n','Toasties'
,'Haps Nordic','Bobo Choses','D-LAB NUTRICOSMETICS','Hevea','Gray Label','Picture','Mini Bloom','Golden Editions','Konges Slojd'
,'Faithfull the Brand','Bien Fait','the new society','Main Story','Repose AMS','B�ho','Swedish Stockings','FUB')
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at >= '2022-11-24' AND bo.created_at <=  '2022-11-30'
	OR bo.created_at >= '2022-11-17' AND bo.created_at <=  '2022-11-23'
GROUP BY
	bp.brand_name  
ORDER BY
	ca_s desc
	
-----------------CAMPAGNES ----------------------------------------------

select
	bp.product_id, bp.product_name as type, bs.categories_N1 as cat, bp.brand_name,
	sum(bop.qty_ordered) as Nb_cmd,
	sum(bop.billing_product_ht)/ 100 as CA
from
	smallable2_datawarehouse.b_acquisition ba 
inner join smallable2_datawarehouse.b_orders bo on
	bo.traffic_id = ba.traffic_id
inner join smallable2_datawarehouse.b_order_products bop
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bop.product_id 
where
	ba.campaign  like 'BRAND_PETITNORD%'
	and ba.traffic_created_at  >= '2022-09-26' and ba.traffic_created_at  <= '2022-10-21'
	and bo.created_at  >=  '2022-09-26' and bo.created_at  <= '2022-10-21'
	and bp.brand_name = 'Petit Nord'
group by type, cat, bp.brand_name, bp.product_id 
order by Nb_cmd desc