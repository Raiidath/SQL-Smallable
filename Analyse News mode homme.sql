SELECT bt.campaign as campagne, count(bt.traffic_id) as Nb
from smallable2_datawarehouse.b_traffic bt 
where bt.ref_date = '2022-04-05'
group by campagne ---- campagne 274
order by Nb desc 

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
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bs.product_id 
where
	bt.campaign ilike '274%'
--	and bp.sml_team = 'mode'
	--and bp.gender = 'man'
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
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bs.product_id 
where
	bp.sml_team = 'mode'
	and bp.gender = 'man'
    and bo.created_at >= '2022-03-12'
    and bo.created_at <= '2022-04-12'
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
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bs.product_id 
where
	bt.campaign ilike '274%'
	and bp.sml_team = 'mode'
	and bp.gender = 'man'
group by
	bop.order_product_id,
	date,
	type 
	

------------------------------------Nb cmd campagne / type -------------------------
	
select
	bs.product_type_N4 as type,
	sum(bop.billing_product_ht)/ 100 as CA,
	sum(bop.qty_ordered) as Nb_cmd
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
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bs.product_id 
where
	bt.campaign ilike '274%'
	and bp.sml_team = 'mode'
	and bp.gender = 'man'
group by
	type 

-------------------------- Nb cmd global / type  -------------------------
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
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bs.product_id 
where
	bp.sml_team = 'mode'
	and bp.gender = 'man'
    and bo.created_at > '2022-04-04'
    and bo.created_at < '2022-04-13'
group by
	type
order by
	CA desc

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
	and bp.sml_team = 'mode'
	and bp.gender = 'man'
    and bo.created_at > '2022-04-04'
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
    and bo.created_at > '2022-04-04'
    --and bo.created_at < '2022-04-13'
inner join smallable2_datawarehouse.b_skus bs
on
	bs.sku_code = bop.sku_code
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
	and bp.sml_team = 'mode'
	and bp.gender = 'man'
