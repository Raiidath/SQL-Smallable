-------------------------------------------------------------------HOMME----------------------------------------------
select
	bo.order_id as order_id,
	bs.sku_code as sku,
	bp.product_name as Nom_produit,  
	bp.brand_name as Marques,
	bs.sml_team as univers,
	bs.gender_mixte  as gender,
	bs.personne  as persons,
	count(DISTINCT bo.order_id) AS commandes,
	sum(bop.billing_product_ht)/ 100 AS ca
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	AND bop.basket_id = bo.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
	bo.order_id in ('8038980',
'8018344',
'8046173',)
group by
	bo.order_id,
	bs.sku_code,
	bp.product_name,
	bp.brand_name,
	bs.sml_team,
	bs.personne,
	bs.gender_mixte  
		
	
	
WITH ancien AS (
SELECT
	DISTINCT bo.customer_id AS cid
FROM
	smallable2_datawarehouse.b_orders bo
WHERE
	bo.is_valid = 1
	AND bo.is_ca_net_ht_not_zero = 1
	AND bo.created_at >= '2020-10-01'
	AND bo.order_id NOT IN ('8038980',
'8018344',
'8046173',
'8067663'
))
SELECT
	bo.order_id,
	bo.billing_product_ht / 100 AS ca,
	bo.repeat_number,
	CASE
		WHEN bo.customer_id IN (
		SELECT
			cid
		FROM
			ancien) THEN 'ancien'
		ELSE 'nouveau'
	END AS type_client,
	bo.traffic_source_name,
	bo.is_valid ,
	bo.is_ca_ht_not_zero
FROM
	smallable2_datawarehouse.b_orders bo
WHERE
	bo.order_id IN (
'8111996',
'8109133',
'8067663')


----------------------------------------------------Bébé------------------------------------------------------
select
	bo.order_id as order_id,
	bs.sku_code as sku,
	bp.product_name as Nom_produit,  
	bp.brand_name as Marques,
	bs.sml_team as univers,
	bs.gender_mixte  as gender,
	bs.personne as persons,
	count(DISTINCT bo.qty_ordered) AS commandes,
	sum(bop.billing_product_ht)/ 100 AS ca
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	AND bop.basket_id = bo.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
	bo.order_id in (8022765,
8027487,
8067663)
group by
	bo.order_id,
	bs.sku_code,
	bp.product_name,
	bp.brand_name ,
	bs.sml_team,
	bs.personne ,
	bs.gender_mixte  
	
-----------------------------------------------------DESIGN-------------------------------------------------------	
select
	bo.order_id as order_id,
	bs.sku_code as sku,
	bp.product_name as Nom_produit,  
	bp.brand_name as Marques,
	bs.sml_team as univers,
	bs.gender as gender,
	bs.personne as persons,
	count(DISTINCT bo.qty_ordered) AS commandes,
	sum(bop.billing_product_ht)/ 100 AS ca
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	AND bop.basket_id = bo.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
	bo.order_id in ('7982406', '7982072', '7979561', '7978974', '7919416', '7976571')
group by
	bo.order_id,
	bs.sku_code,
	bp.product_name,
	bp.brand_name ,
	bs.sml_team,
	bs.personne  ,
	bs.gender 

-----------------------------------------------------------VIDE-----------------------------------------------------
select
	bo.order_id as order_id,
	bs.sku_code as sku,
	bp.product_name as Nom_produit,  
	bp.brand_name as Marques,
	bs.sml_team as univers,
	--bs.gender as gender,
	--bs.personne  as persons,
	count(DISTINCT bo.qty_ordered) AS commandes,
	sum(bop.billing_product_ht)/ 100 AS ca
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	AND bop.basket_id = bo.basket_id
	AND bo.is_valid= 1
	AND bo.is_ca_ht_not_zero = 1
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
	bo.order_id in ('7935268', '7934307', '7550386', '7933883', '7933849', '7933603', '7929708')
group by
	bo.order_id,
	bs.sku_code,
	bp.product_name,
	bp.brand_name ,
	bs.sml_team--,
	--bs.personne  ,
	--bs.gender 
	
---------------------------------------Produits commandés 2ème démarqque/soldes------------------------

select
	count(bop.product_id) as Nb_produits
from
	 smallable2_datawarehouse.b_order_products bop 
where bop.billing_discount_product_ht > 0
AND  bop.order_id in ('8220041',
'8213257',
'8228233',
'8204011',
'8227915',
'7290503',
'8138803',
'8228791',
'8171357',
'8225475',
'8175906',
'8147253',
'8226250',
'8233444',
'8229266',
'8232849',
'8057920',
'8210325',
'8232700',
'8187470',
'8232330',
'8152825',
'8224735',
'8224832',
'4085177',
'8231357',
'8224390',
'8231024',
'7946367',
'8229811',
'8226551',
'8221300',
'8226091',
'8228941',
'8225597',
'8223501',
'8189754',
'8038933',
'8223594',
'8225692',
'8218327',
'8221275',
'8162038',
'8220007',
'8209682',
'8201609',
'8185267',
'8181803',
'8174815',
'8194138',
'8185522',
'8197732',
'8196261',
'8195231',
'8195436',
'8195079',
'6281394',
'8186353',
'8192572',
'8189983',
'7196269',
'8114830',
'8182685',
'8005796',
'6544855',
'7986676',
'8182808',
'8188622',
'8181523',
'8173823',
'7810239',
'8185313',
'8186433',
'8172320',
'8182171',
'8184219',
'8183587',
'8182630',
'8181298',
'8181045',
'8181089',
'8182713',
'8182335',
'8181842',
'8173399',
'8171046',
'8108544',
'8127314',
'8180810',
'8180856',
'8161695',
'8170741',
'8174161',
'8174207',
'8177710',
'4379094',
'8155870',
'8055408',
'8148052',
'8171926',
'8176070',
'8176081',
'8173618',
'8174797',
'8174058',
'8168467',
'8172465',
'8169679',
'8172516',
'8172484')

select bop.discount_product_rate as remise, count(bop.product_id) Nb_rpoduits
from smallable2_datawarehouse.b_order_products bop 
where  bop.order_id in ('8220041',
'8213257',
'8228233',
'8204011',
'8227915',
'7290503',
'8138803',
'8228791',
'8171357',
'8225475',
'8175906',
'8147253',
'8226250',
'8233444',
'8229266',
'8232849',
'8057920',
'8210325',
'8232700',
'8187470',
'8232330',
'8152825',
'8224735',
'8224832',
'4085177',
'8231357',
'8224390',
'8231024',
'7946367',
'8229811',
'8226551',
'8221300',
'8226091',
'8228941',
'8225597',
'8223501',
'8189754',
'8038933',
'8223594',
'8225692',
'8218327',
'8221275',
'8162038',
'8220007',
'8209682',
'8201609',
'8185267',
'8181803',
'8174815',
'8194138',
'8185522',
'8197732',
'8196261',
'8195231',
'8195436',
'8195079',
'6281394',
'8186353',
'8192572',
'8189983',
'7196269',
'8114830',
'8182685',
'8005796',
'6544855',
'7986676',
'8182808',
'8188622',
'8181523',
'8173823',
'7810239',
'8185313',
'8186433',
'8172320',
'8182171',
'8184219',
'8183587',
'8182630',
'8181298',
'8181045',
'8181089',
'8182713',
'8182335',
'8181842',
'8173399',
'8171046',
'8108544',
'8127314',
'8180810',
'8180856',
'8161695',
'8170741',
'8174161',
'8174207',
'8177710',
'4379094',
'8155870',
'8055408',
'8148052',
'8171926',
'8176070',
'8176081',
'8173618',
'8174797',
'8174058',
'8168467',
'8172465',
'8169679',
'8172516',
'8172484')
group by bop.discount_product_rate 
	
select count(bop.product_id) as Nb_produits 
from smallable2_datawarehouse.b_order_products bop 
where bop.order_id in ('8220041',
'8213257',
'8228233',
'8204011',
'8227915',
'7290503',
'8138803',
'8228791',
'8171357',
'8225475',
'8175906',
'8147253',
'8226250',
'8233444',
'8229266',
'8232849',
'8057920',
'8210325',
'8232700',
'8187470',
'8232330',
'8152825',
'8224735',
'8224832',
'4085177',
'8231357',
'8224390',
'8231024',
'7946367',
'8229811',
'8226551',
'8221300',
'8226091',
'8228941',
'8225597',
'8223501',
'8189754',
'8038933',
'8223594',
'8225692',
'8218327',
'8221275',
'8162038',
'8220007',
'8209682',
'8201609',
'8185267',
'8181803',
'8174815',
'8194138',
'8185522',
'8197732',
'8196261',
'8195231',
'8195436',
'8195079',
'6281394',
'8186353',
'8192572',
'8189983',
'7196269',
'8114830',
'8182685',
'8005796',
'6544855',
'7986676',
'8182808',
'8188622',
'8181523',
'8173823',
'7810239',
'8185313',
'8186433',
'8172320',
'8182171',
'8184219',
'8183587',
'8182630',
'8181298',
'8181045',
'8181089',
'8182713',
'8182335',
'8181842',
'8173399',
'8171046',
'8108544',
'8127314',
'8180810',
'8180856',
'8161695',
'8170741',
'8174161',
'8174207',
'8177710',
'4379094',
'8155870',
'8055408',
'8148052',
'8171926',
'8176070',
'8176081',
'8173618',
'8174797',
'8174058',
'8168467',
'8172465',
'8169679',
'8172516',
'8172484')