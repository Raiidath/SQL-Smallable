------------------------------------ Greenable ---------------------------------------
-------------------------------------Période S -------------------------------------------
select
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bo.order_id ELSE NULL END) AS nb_commandes_Green,
	count(DISTINCT bo.order_id) AS nb_commandes_Global,
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bp.product_id ELSE NULL END) AS nb_produits_commandes_Green,
	count(DISTINCT bp.product_id) AS nb_produits_commandes_Global,
	sum(CASE WHEN bp.greenable = 'OUI' THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Green,
	sum(bop.billing_product_ht / 100) AS CA_Global,
	CA_Green/nb_commandes_Green AS PM_Green,
	CA_Global/nb_commandes_Global AS PM_Global
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code 
	AND bs.brand_id != '940'
where
	bo.created_at >= '2022-11-24'
	and bo.created_at <= '2022-11-30'
	
------------------------------- Top produits et marques ----------------------------
	
select distinct bp.product_name, bp.brand_name, bp.color ,
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bo.order_id ELSE NULL END) AS nb_commandes_Green,
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bp.product_id ELSE NULL END) AS nb_produits_commandes_Green,
	sum(CASE WHEN bp.greenable = 'OUI' THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Green,
	CA_Green/nb_commandes_Green AS PM_Green
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code 
	AND bs.brand_id != '940'
where
	bo.created_at >= '2022-11-24'
	and bo.created_at <= '2022-11-30'
Group by bp.product_name, bp.brand_name,bp.color
order by CA_Green desc


select distinct bp.brand_name, --bp.ref_co,
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bo.order_id ELSE NULL END) AS nb_commandes_Green,
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bp.product_id ELSE NULL END) AS nb_produits_commandes_Green,
	sum(CASE WHEN bp.greenable = 'OUI' THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Green,
	CA_Green/nb_commandes_Green AS PM_Green
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_countries bc 
on
	bc.country_id = bo.delivery_country_id 
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code 
	AND bs.brand_id != '940'
where
	bo.created_at >= '2022-11-24'
	and bo.created_at <= '2022-11-30'
Group by bp.brand_name--, bp.ref_co 
order by CA_Green desc

-------------------------------------Période A-1 -------------------------------------------
select
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bo.order_id ELSE NULL END) AS nb_commandes_Green,
	count(DISTINCT bo.order_id) AS nb_commandes_Global,
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bp.product_id ELSE NULL END) AS nb_produits_commandes_Green,
	count(DISTINCT bp.product_id) AS nb_produits_commandes_Global,
	sum(CASE WHEN bp.greenable = 'OUI' THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Green,
	sum(bop.billing_product_ht / 100) AS CA_Global,
	CA_Green/nb_commandes_Green AS PM_Green,
	CA_Global/nb_commandes_Global AS PM_Global
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code 
	AND bs.brand_id != '940'
where
	bo.created_at >= '2021-11-25'
	and bo.created_at <= '2021-12-01'
	

----------------------------------- Pays / Zone ------------------------------------
select distinct bc.country_name ,
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bo.order_id ELSE NULL END) AS nb_commandes_Green,
	count(DISTINCT bo.order_id) AS nb_commandes_Global,
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bp.product_id ELSE NULL END) AS nb_produits_commandes_Green,
	count(DISTINCT bp.product_id) AS nb_produits_commandes_Global,
	sum(CASE WHEN bp.greenable = 'OUI' THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Green,
	sum(bop.billing_product_ht / 100) AS CA_Global,
	CA_Green/nb_commandes_Green AS PM_Green,
	CA_Global/nb_commandes_Global AS PM_Global
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_countries bc 
on
	bc.country_id = bo.delivery_country_id 
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code 
	AND bs.brand_id != '940'
where
	bo.created_at >= '2022-11-24'
	and bo.created_at <= '2022-11-30'
Group by bc.country_name
order by CA_Green desc


select distinct bc.zone_code ,
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bo.order_id ELSE NULL END) AS nb_commandes_Green,
	count(DISTINCT bo.order_id) AS nb_commandes_Global,
	sum(CASE WHEN bp.greenable = 'OUI' THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Green,
	sum(bop.billing_product_ht / 100) AS CA_Global
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_countries bc 
on
	bc.country_id = bo.delivery_country_id 
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code 
	AND bs.brand_id != '940'
where
	bo.created_at >= '2022-11-24'
	and bo.created_at <= '2022-11-30'
Group by bc.zone_code
order by CA_Green desc

----------------------------------- Secteur ------------------------------------
select distinct bp.sml_team,
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bo.order_id ELSE NULL END) AS nb_commandes_Green,
	count(DISTINCT bo.order_id) AS nb_commandes_Global,
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bp.product_id ELSE NULL END) AS nb_produits_commandes_Green,
	count(DISTINCT bp.product_id) AS nb_produits_commandes_Global,
	sum(CASE WHEN bp.greenable = 'OUI' THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Green,
	sum(bop.billing_product_ht / 100) AS CA_Global,
	CA_Green/nb_commandes_Green AS PM_Green,
	CA_Global/nb_commandes_Global AS PM_Global
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code 
	AND bs.brand_id != '940'
where
	bo.created_at >= '2022-11-24'
	and bo.created_at <= '2022-11-30'
Group by bp.sml_team 
order by CA_Green desc
	
	
--------------------------------------------- Univers ------------------------------
select distinct bp.product_type_N5_refco , bp.sml_team, 
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bo.order_id ELSE NULL END) AS nb_commandes_Green,
	count(DISTINCT bo.order_id) AS nb_commandes_Global,
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bp.product_id ELSE NULL END) AS nb_produits_commandes_Green,
	count(DISTINCT bp.product_id) AS nb_produits_commandes_Global,
	sum(CASE WHEN bp.greenable = 'OUI' THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Green,
	sum(bop.billing_product_ht / 100) AS CA_Global,
	CA_Green/nb_commandes_Green AS PM_Green,
	CA_Global/nb_commandes_Global AS PM_Global
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code 
	AND bs.brand_id != '940'
where
	bo.created_at >= '2022-11-24'
	and bo.created_at <= '2022-11-30'
Group by bp.product_type_N5_refco , bp.sml_team  
order by CA_Green desc


--------------------------------------------- Typologie ------------------------------
select distinct bs.product_type_N4  , bp.sml_team, 
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bo.order_id ELSE NULL END) AS nb_commandes_Green,
	count(DISTINCT bo.order_id) AS nb_commandes_Global,
	count(DISTINCT CASE WHEN bp.greenable = 'OUI' THEN bp.product_id ELSE NULL END) AS nb_produits_commandes_Green,
	count(DISTINCT bp.product_id) AS nb_produits_commandes_Global,
	sum(CASE WHEN bp.greenable = 'OUI' THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Green,
	sum(bop.billing_product_ht / 100) AS CA_Global,
	CA_Green/nb_commandes_Green AS PM_Green,
	CA_Global/nb_commandes_Global AS PM_Global
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code 
	AND bs.brand_id != '940'
where
	bo.created_at >= '2022-11-24'
	and bo.created_at <= '2022-11-30'
Group by bs.product_type_N4, bp.sml_team  
order by CA_Green desc


