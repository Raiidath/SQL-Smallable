------------------------------------ Charitable -------------------------------------
-------------------------------------Période N -------------------------------------------
select
	count(DISTINCT CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bo.order_id ELSE NULL END) AS nb_commandes_Char,
	count(DISTINCT bo.order_id) AS nb_commandes_Global,
	count(DISTINCT CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bp.product_id  ELSE NULL END) AS nb_produits_Char,
	count(DISTINCT bp.product_id) AS nb_produits_commandes_Global,
	sum(CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Char,
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
where bo.created_at >= '2022-11-18'

-------------------------------------Période N-1 -------------------------------------------
select
	count(DISTINCT CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bo.order_id ELSE NULL END) AS nb_commandes_Char,
	count(DISTINCT bo.order_id) AS nb_commandes_Global,
	count(DISTINCT CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bp.product_id  ELSE NULL END) AS nb_produits_Char,
	count(DISTINCT bp.product_id) AS nb_produits_commandes_Global,
	sum(CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Char,
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
where bo.created_at >= '2021-11-19'
	and bo.created_at < '2022-03-21'
	
-----------------------------------------Stocks ----------------------------------------------------------	
SELECT
	distinct bs.product_id AS p, bp.product_name as pn, bp.brand_name as bn, 
	sum(distinct CASE WHEN bs.quantity_type_id = 1 then bs.stock_delta ELSE 0 END) - sum(distinct CASE WHEN bs.quantity_type_id in (4,5,6) then bs.stock_delta ELSE 0 END) AS stock
FROM
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join	smallable2_datawarehouse.b_stocks bs
on bop.sku_id  = bs.sku_id 
WHERE bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') 	
and bo.created_at >= '2022-12-11'
GROUP BY
	p , bn, pn
order by stock desc

------------------------------- Top produits et marques ----------------------------
	
select distinct bp.product_name, bp.brand_name, bp.color,bs2.size,
	count(DISTINCT bo.order_id) AS nb_commandes_Green,
	--sum(distinct bo.qty_ordered) AS nb_produits_Green,
	sum(CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Char
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
inner join	smallable2_datawarehouse.b_stocks bs
on bop.sku_id  = bs.sku_id 
inner join smallable2_datawarehouse.b_skus bs2 
on
	bop.sku_code = bs2.sku_code 
where
	bo.created_at >= '2022-11-18'
	and bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') 	
	--and bo.created_at <= '2022-11-30'
Group by bp.product_name, bp.brand_name, bp.color ,  bs2.size 
order by CA_Char desc


select distinct bp.brand_name,  --bp.ref_co,
	count(DISTINCT bo.order_id) AS nb_commandes_Green,
	sum(bop.billing_product_ht / 100) AS CA_Green
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
where
	bo.created_at >= '2022-11-18'
	and bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') 	
Group by bp.brand_name
order by CA_Green desc

----------------------------------- Pays / Zone ------------------------------------
select distinct bc.country_name ,
	count(DISTINCT CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bo.order_id ELSE NULL END) AS nb_commandes_Char,
	count(DISTINCT bo.order_id) AS nb_commandes_Global,
	sum(CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Char,
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
	bo.created_at >= '2022-11-18'
Group by bc.country_name
order by CA_Char desc


select distinct bc.zone_code ,
	count(DISTINCT CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bo.order_id ELSE NULL END) AS nb_commandes_Char,
	count(DISTINCT bo.order_id) AS nb_commandes_Global,
	sum(CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Char,
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
	bo.created_at >= '2022-11-18'
Group by bc.zone_code
order by CA_Char desc

-------------------------------------------- Secteur ------------------------------------
select distinct bp.sml_team,
		count(DISTINCT CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bo.order_id ELSE NULL END) AS nb_commandes_Char,
	count(DISTINCT bo.order_id) AS nb_commandes_Global,
	sum(CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Char,
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
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code 
	AND bs.brand_id != '940'
where
	bo.created_at >= '2022-11-18'
	--and bo.created_at <= '2022-11-30'
Group by bp.sml_team 
order by CA_Char desc
	
	
--------------------------------------------- Univers ------------------------------
select distinct bp.product_type_N5_refco , bp.sml_team, 
		count(DISTINCT CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bo.order_id ELSE NULL END) AS nb_commandes_Char,
	count(DISTINCT bo.order_id) AS nb_commandes_Global,
	sum(CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Char,
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
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code 
	AND bs.brand_id != '940'
where
	bo.created_at >= '2022-11-18'
	--and bo.created_at <= '2022-11-30'
Group by bp.product_type_N5_refco , bp.sml_team  
order by CA_Char desc
  

----------------------------------------------- Typologie ------------------------------
select distinct bs.product_type_N4  , bp.sml_team, 
		count(DISTINCT CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bo.order_id ELSE NULL END) AS nb_commandes_Char,
	count(DISTINCT bo.order_id) AS nb_commandes_Global,
	sum(CASE WHEN bop.sku_code in ('AAA1221744','AAA1221746','AAA1221749','AAA1221750','AAA1222595','AAA1222596','AAA1222597','AAA1251111','AAA1251112','AAA1260745','AAA1260746','AAA1260747','AAA1260748','AAA1260749','AAA1261634','AAA1178267','AAA1252949','AAA1259475','AAA1241601','AAA1190155','AAA1190159','AAA1160001','AAA1236487','AAA1236488','AAA1265869','AAA1267710','AAA1267711','AAA1267715') THEN bop.billing_product_ht / 100 ELSE NULL END) AS CA_Char,
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
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code 
	AND bs.brand_id != '940'
where
	bo.created_at >= '2022-11-18'
	--and bo.created_at <= '2022-11-30'
Group by bs.product_type_N4, bp.sml_team  
order by CA_Char desc


