------------ Nb d'enfants 

SELECT
	AVG(DISTINCT cc.id) AS nb_enf
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
    AND bo.created_at >= '2021-01-01'
    AND bo.created_at <= '2023-09-05'  -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
	--AND bop.business_season = 'PE23'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_name  = 'Bobo Choses'
INNER JOIN smallable2_front.customer_child cc ON
cc.customer_id = bo.customer_id 
inner join smallable2_front.customer c 
on
	bo.customer_id  = c.id 
	AND c.title_id ='2'
	--AND bs.personne_genre = 'Adulte woman'

	
select
	count(distinct cc.id) as Nb_child, Nb_child/count(distinct bo.customer_id) as Nb_child_par_client,
	Round(avg((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400 * 365.25)),
	0) as Moyenne,
	Round(stddevPop((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400 * 365.25)),
	2) as Etype
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
    AND bo.created_at >= '2021-01-01'
    AND bo.created_at <= '2023-09-05'  -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
	--AND bop.business_season = 'PE23'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_name  = 'Bobo Choses'
INNER JOIN smallable2_front.customer_child cc ON
cc.customer_id = bo.customer_id 
inner join smallable2_front.customer c 
on
	bo.customer_id  = c.id 
	AND c.title_id ='2'
	
	
select
	count(distinct c.id) as Nb_child, count(distinct bo.order_id) as Nb_o,
	Round(avg((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(c.date_of_birth)))/(86400 * 365.25)),
	0) as Moyenne,
	Round(stddevPop((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(c.date_of_birth)))/(86400 * 365.25)),
	2) as Etype
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
    AND bo.created_at >= '2021-01-01'
    AND bo.created_at <= '2023-09-05'  -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
	--AND bop.business_season = 'PE23'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_name  = 'Bobo Choses'
inner join smallable2_front.customer c 
on
	bo.customer_id  = c.id 
	AND c.title_id ='2'

select  count(distinct cc.customer_id) as clients
from smallable2_front.customer_child cc 


select cc.customer_id, count(cc.id) as Nb
from smallable2_front.customer_child cc 
WHERE cc.customer_id = '600798'
group by cc.customer_id
order by Nb desc 


select
count(distinct bo.customer_id) as Nb_clients_log_rep
from
	smallable2_datawarehouse.b_orders bo
where
	bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.first_order_vs_repeat = 'Réachat'
	and bo.customer_id in (
	select
		aa.customer_id
	from
		smallable2_front.availability_alert aa
	where
		aa.created > '2021-01-01'
		and aa.created < '2021-12-31' )
		

----------------------------------------------------- Age du client -----------------------------------------------------------------
	
SELECT DISTINCT c.id,
	c.firstname,
	c.lastname,
	c.email,
	c.date_of_birth,
	AVG(toUnixTimestamp(now())-toUnixTimestamp(toDateTime(c.date_of_birth)))/(86400 * 365.25) as Age
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
    AND bo.created_at >= '2021-01-01'
    AND bo.created_at <= '2023-09-05' -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
	--AND bop.business_season = 'PE23'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_name  = 'Bobo Choses'
INNER JOIN smallable2_front.customer_child cc ON
cc.customer_id = bo.customer_id 
inner join smallable2_front.customer c 
on
	bo.customer_id  = c.id 
	AND c.title_id ='2'
ORDER BY Age DESC 
	

	

SELECT
	DISTINCT bc2.country_name as zone,  
				count(DISTINCT bo.customer_id) as Nb
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
    AND bo.created_at >= '2021-01-01'
    AND bo.created_at <= '2023-09-05'   -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
	--AND bop.business_season = 'PE23'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_name  = 'Bobo Choses'
INNER JOIN smallable2_datawarehouse.b_customers bc  ON
bc.customer_id  = bo.customer_id 
inner join smallable2_datawarehouse.b_countries bc2 
on
	bc2.country_id = bc.country_id
	inner join smallable2_front.customer c 
on
	bo.customer_id  = c.id 
	AND c.title_id ='2'
group by zone
ORDER BY Nb desc


SELECT
	DISTINCT bc2.zone_code as zone,  
				count(DISTINCT bo.customer_id) as Nb
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
    AND bo.created_at >= '2021-01-01'
    AND bo.created_at <= '2023-09-05'   -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
	--AND bop.business_season = 'PE23'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_name  = 'Bobo Choses'
INNER JOIN smallable2_datawarehouse.b_customers bc  ON
bc.customer_id  = bo.customer_id 
inner join smallable2_datawarehouse.b_countries bc2 
on
	bc2.country_id = bc.country_id
inner join smallable2_front.customer c 
on
	bo.customer_id  = c.id 
	AND c.title_id ='2'
group by zone
ORDER BY Nb DESC


	

select
	count(distinct bo.order_id) as total
		FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
    AND bo.created_at >= '2021-01-01'
    AND bo.created_at <= '2023-09-05'  -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
	--AND bop.business_season = 'PE23'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_name  = 'Bobo Choses'
INNER JOIN smallable2_datawarehouse.b_customers bc  ON
bc.customer_id  = bo.customer_id 
inner join smallable2_front.customer c 
on
	bo.customer_id  = c.id 
	AND c.title_id ='2'

	
select
	count(distinct case when bc.email is not null then bc.email else null end) as repeat
	FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
    AND bo.created_at >= '2021-01-01'
    AND bo.created_at <= '2023-09-05'  -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
	--AND bop.business_season = 'PE23'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_name  = 'Bobo Choses'
INNER JOIN smallable2_datawarehouse.b_customers bc  ON
bc.customer_id  = bo.customer_id 
inner join smallable2_front.customer c 
ON
	bo.customer_id  = c.id 
	AND c.title_id ='2'
	
where
	bo.first_order_vs_repeat = 'Réachat'

	
	
select
	count(distinct case when bc.email is not null then bc.email else null end) as repeat
	FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
    AND bo.created_at >= '2021-01-01'
    AND bo.created_at <= '2023-09-05'  -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
	--AND bop.business_season = 'PE23'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_name  = 'Bobo Choses'
INNER JOIN smallable2_datawarehouse.b_customers bc  ON
bc.customer_id  = bo.customer_id 
inner join smallable2_front.customer c 
on
	bo.customer_id  = c.id 
	AND c.title_id ='2'	
where
	bo.first_order_vs_repeat = '1ère Commande'

	
	
-------------
SELECT
	DISTINCT bs.sml_team , count(DISTINCT c.id) AS nb_enf
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
    AND bo.created_at >= '2021-01-01'
    AND bo.created_at <= '2023-09-05'  -- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
	--AND bop.business_season = 'PE23'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_name  = 'Bobo Choses'
INNER JOIN smallable2_front.customer_child cc ON
cc.customer_id = bo.customer_id 
inner join smallable2_front.customer c 
on
	bo.customer_id  = c.id 
	AND c.title_id ='2'
	--AND bs.personne_genre = 'Adulte woman'
group by bs.sml_team 
ORDER BY nb_enf DESC
	
	