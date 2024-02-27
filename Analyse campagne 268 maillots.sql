------------- cmd et ca camapagne /jour ------------------------------------------------------------------------------------
select
	bt.ref_date as date,
	sum(bop.qty_ordered) as Nb_cmd,
	sum(bop.billing_product_ht)/ 100 as CA
from
	smallable2_datawarehouse.b_traffic bt
inner join smallable2_datawarehouse.b_orders bo on
	bo.traffic_id = bt.traffic_id
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
where
	bt.campaign ilike '268%'
group by
	date

	
select
	bt.ref_date as date,
	sum(bop.qty_ordered) as Nb_cmd,
	sum(bop.billing_product_ht)/ 100 as CA
from
	smallable2_datawarehouse.b_traffic bt
inner join smallable2_datawarehouse.b_orders bo on
	bo.traffic_id = bt.traffic_id
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
where
	bs.product_type_N4 in ('Maillots de bain')
	--and bo.created_at < '2022-03-26'
    and bo.created_at > '2022-03-09'
group by
	date

	
----------------------------------produit commandé-----------------------------------
select
	 bop.order_product_id as produit,
	sum(bop.billing_product_ht)/ 100 as CA,
	sum(bop.qty_ordered) as Nb_cmd,
	bt.ref_date as date
	 ,
	bs.product_type_N4 as type
from
	smallable2_datawarehouse.b_traffic bt
inner join smallable2_datawarehouse.b_orders bo on
	bo.traffic_id = bt.traffic_id
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
where
	bt.campaign ilike '268%'
	and bs.product_type_N4 in ('Maillots de bain', 'Sandales, espadrilles')
group by
	bop.order_product_id,
	date,
	type 

------------------------------------Nb cmd maillots et sandalalles campagne ---------
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
	and ba.traffic_created_at  >= '2022-10-20' and ba.traffic_created_at  <= '2022-11-15'
	and bo.created_at  >=  '2022-10-20' and bo.created_at  <= '2022-11-15'
	and bp.brand_name = 'Petit Nord'
group by type, cat, bp.brand_name, bp.product_id 
order by Nb_cmd desc

	
select *
from smallable2_datawarehouse.b_acquisition ba 

select distinct bp.product_name, bp.brand_name  as type,
	count(distinct bo.order_id) as cmd,
	sum(bop.qty_ordered) as Nb_cmd,
	sum(bop.billing_product_ht)/ 100 as CA
from smallable2_datawarehouse.b_orders bo 
inner join smallable2_datawarehouse.b_order_products bop 
on bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bop.product_id 
where  bo.created_at  >=  '2022-10-25' and bo.created_at  <= '2022-11-15'
	and bp.brand_name = 'Liewood'
group by   bp.product_name , type
order by Nb_cmd desc


-------------------------- Nb cmd maillots et sandalalles global -------------------------
select
	 bs.product_type_N4 as type,
	sum(bop.qty_ordered) as Nb_cmd,
	sum(bop.billing_product_ht)/ 100 as CA
from
	smallable2_datawarehouse.b_traffic bt
inner join smallable2_datawarehouse.b_orders bo on
	bo.traffic_id = bt.traffic_id
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
where
	 bs.product_type_N4 in ('Maillots de bain', 'Sandales, espadrilles')
	and bo.created_at >= '2022-03-26'
	and bo.created_at <= '2022-04-10'
group by
	type

-------------------------------- Commande/produit global -------------------
select
	bs.product_type_N4 as type,
	sum(bop.qty_ordered) as Nb_cmd,
	sum(bop.billing_product_ht)/ 100 as CA
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
inner join smallable2_datawarehouse.b_orders bo 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
	and bo.created_at < '2022-03-26'
	and bo.created_at >= '2022-03-12'
group by
	type
order by
	CA desc

---------------------------------------------CA et Nb cmd global ----------------------
	select
	sum(bop.qty_ordered) as Nb_cmd,
	sum(bop.billing_product_ht)/ 100 as CA
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
	and bo.created_at >= '2022-03-26'
	and bo.created_at <= '2022-04-10'
inner join smallable2_datawarehouse.b_skus bs
on
	bs.sku_code = bop.sku_code


select * 
from smallable2_datawarehouse.b_traffic bt 
where  bt.Vis_date >= '2022-04-27' and bt.Vis_date <= '2022-05-18'
and 
bt.campaign like 'BRAND_LIEWOOD%'
