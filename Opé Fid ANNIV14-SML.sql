---------------------------------- Nombre de produits soldés, CA et PM  avec code ANNIV14- SML --------------------------------------------------------
	
select
	distinct bp.product_name  as code, bp.brand_name  as marque, bp.sml_team as univers,
	count(distinct bop.order_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bo.billing_country_id  = bc.country_id  
inner join smallable2_datawarehouse.b_products bp 
on bop.product_id = bp.product_id 
where bop.code_promo 
     in ('ANNIV50-EUR','ANNIV100-EUR', 'ANNIV150-EUR', 'ANNIV100-EUR | ANNIV150-EUR', 'ANNIV100-EUR | ANNIV50-EUR', 'ANNIV100-EUR | ANNIV150-EUR | ANNIV50-EUR')
	or bop.code_promo in ('ANNIV50-GBP' ,'ANNIV100-GBP' ,'ANNIV150-GBP')   
	or bop.code_promo ilike 'ANNIV14-SML' 
	or bop.code_promo in ('ANNIV50-USD','ANNIV100-USD','ANNIV150-USD','ANNIV50-CAD','ANNIV100-CAD','ANNIV150-CAD')  
	or bop.code_promo in ('ANNIV50-EUR','ANNIV100-EUR', 'ANNIV150-EUR', 'ANNIV100-EUR | ANNIV150-EUR', 'ANNIV100-EUR | ANNIV50-EUR', 'ANNIV100-EUR | ANNIV150-EUR | ANNIV50-EUR') 
	or bop.code_promo in ('ANNIV50-CHF','ANNIV100-CHF','ANNIV150-CHF')
	--and bo.datetime_created_at <= '2022-09-24 06:34:29'
	--and bo.datetime_created_at >= '2022-09-19 18:00:00'
	--and bc.zone_code in ('ROE', 'DE', 'IT', 'ES') --- ASIA  UK   US
	--and bop.sml_team = 'design'
group by
	code ,univers, marque
order by order desc
	
	
select
	distinct bop.sml_team  as code,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
	--bop.code_promo  in ('ANNIV50-CHF','ANNIV100-CHF','ANNIV150-CHF') 
	--and
	bo.datetime_created_at <= '2022-10-18 23:59:00'
	and bo.datetime_created_at >= '2022-10-09 18:00:00'
	and bc.country_iso_code  = 'CH'
group by
	code
	

	
select
	distinct bop.sml_team  as code,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
  --  bop.code_promo  ilike 'ANNIV14-SML' 	and 
	bo.datetime_created_at  <= '2022-09-20 23:59:00'
	and bo.datetime_created_at  >= '2022-09-11 23:55:00'
	and bc.regroup_zone  = 'ASIA'  --in ('ROE', 'DE', 'IT', 'ES')   --!= 'FR' --  in ('ROE', 'DE', 'IT', 'ES')   -- 
group by
	bop.sml_team 
	
	
	
select
	distinct bop.sml_team  as code,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
	--bop.code_promo in ('ANNIV50-USD','ANNIV100-USD','ANNIV150-USD','ANNIV50-CAD','ANNIV100-CAD','ANNIV150-CAD')    and 
	bo.datetime_created_at <= '2022-09-21 23:59:00'
	and bo.datetime_created_at >= '2022-09-13 14:30:00'
	and bc.zone_code  = 'US' -- in ('ROE', 'DE', 'IT', 'ES')  -- = 'FR'  = 'CH' 
group by
	code  
	

	

select
	distinct bop.sml_team  as code,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
	--bop.code_promo in ('ANNIV50-GBP' ,'ANNIV100-GBP' ,'ANNIV150-GBP')  and
	bo.datetime_created_at <= '2022-09-21 23:59:00'
	and bo.datetime_created_at >= '2022-09-13 14:12:00'
	and bc.zone_code  = 'UK' -- 'UK' 'CA'
group by
	bop.sml_team 
	
	
	
-------------------------------------------------------- J --------------------------------------------------------------	
	
select bop.sml_team ,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 	
where
	bo.datetime_created_at <= '2022-09-28 23:59:00'
	and bo.datetime_created_at >= '2022-10-13 14:30:00'
	and bc.zone_code  = 'UK'
group by bop.sml_team 



	
select bop.sml_team ,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
	bo.datetime_created_at <= '2022-09-21 12:00:00'
	and bo.datetime_created_at >= '2022-09-11 23:55:00'
	and bc.regroup_zone = 'ASIA'
group by bop.sml_team 

		

	
select bop.sml_team ,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
	bo.datetime_created_at <= '2022-10-28 23:59:00'
	and bo.datetime_created_at >= '2022-10-18 13:50:00'
	--and bc.zone_code  = 'ROE'  -- US
    and bc.country_iso_code = 'CH'
group by bop.sml_team 




	
select bop.sml_team ,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
	bo.datetime_created_at <= '2022-10-24 06:34:29'
	and bo.datetime_created_at >= '2022-10-17 18:00:00'
	and bc.country_iso_code  = 'CH' -- in ('ROE', 'DE', 'IT', 'ES') -- = 'FR'  --  US
group by bop.sml_team 

-------------------------------------------------------- J-1 --------------------------------------------------------------	
	
select bop.sml_team ,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
	bo.datetime_created_at <= '2022-10-11 06:42:13'
	and bo.datetime_created_at >= '2022-10-03 17:25:00'
	and bc.regroup_zone = 'ME'
group by bop.sml_team 




select bop.sml_team ,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
	bo.datetime_created_at <= '2022-10-12 06:42:13'
	and bo.datetime_created_at >= '2022-10-06 14:30:00'
	and bc.zone_code  = 'UK'
group by bop.sml_team 


	
select bop.sml_team ,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
	bo.datetime_created_at <= '2022-10-11 06:21:21'
	and bo.datetime_created_at >= '2022-10-09 17:25:00'
	and bc.regroup_zone = 'UK' --'US'
group by bop.sml_team 


select bop.sml_team ,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
	bo.datetime_created_at <= '2022-10-13 06:43:39'
	and bo.datetime_created_at >= '2022-10-11 13:50:00'
	and bc.regroup_zone = 'FR' --'US'
group by bop.sml_team 


select bop.sml_team ,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
	bo.datetime_created_at <= '2022-10-13 06:43:39'
	and bo.datetime_created_at >= '2022-10-12 18:00:00'
	and bc.zone_code  in ('ROE', 'DE', 'IT', 'ES')
group by bop.sml_team 


select bop.sml_team ,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
	bo.datetime_created_at <= '2022-10-19 06:43:39'
	and bo.datetime_created_at >= '2022-10-18 18:00:00'
	and bc.country_iso_code  = 'CH' --'US'
group by bop.sml_team 
------------------------------------------------------- S-1 -----------------------------------------------------------------
	
select bop.sml_team ,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
	bo.datetime_created_at <= '2022-10-10 06:27:10'
	and bo.datetime_created_at >= '2022-10-04 17:25:00'
	and bc.regroup_zone = 'ME'
group by bop.sml_team 



	
select bop.sml_team ,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
	bo.datetime_created_at <= '2022-10-10 06:27:10'
	and bo.datetime_created_at >= '2022-10-04 23:55:00'
	and bc.regroup_zone = 'ASIA'
group by bop.sml_team 




	
select bop.sml_team ,
	count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc 
on  bop.delivery_country_iso = bc.country_iso_code 
where
	bo.datetime_created_at <= '2022-10-10 06:27:10'
	and bo.datetime_created_at >= '2022-10-06 14:12:00'
	and bc.zone_code  = 'US'  --'US'
group by bop.sml_team 

---------------------------------------------------------------------------------------------------------------------------
	

select
	bop.order_id as order, bo.created_at,  bop.billing_product_ht /100, bo.datetime_created_at, bop.delivery_country_iso  
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
where
	bop.code_promo in ('ANNIV50-USD','ANNIV100-USD','ANNIV150-USD','ANNIV50-CAD','ANNIV100-CAD','ANNIV150-CAD')-- in ('ANNIV50-GBP' ,'ANNIV100-GBP' ,'ANNIV150-GBP')

	
select max(bo.datetime_created_at)
from smallable2_datawarehouse.b_orders bo
WHERE bo.is_valid = 1
AND bo.is_ca_ht_not_zero = 1



	
----------------------------- Discount fait sur chaque produit ------------------------------------------------------
select
	bop.product_id,
	bop.billing_product_ht / 100 as CA, bop.billing_discount_product_ht/100 as apres,
	apres/ CA as discount
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
where
	bop.code_promo ilike 'ANNIV14-SML'
group by
	bop.product_id, CA, apres
	
select
	bop.product_id,
	bop.billing_product_ht / 100 as CA, bop.billing_discount_product_ht/100 as apres,
	apres/ CA as discount
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
where
	bop.code_promo ilike 'ANNIV14-SML'
group by
	bop.product_id, CA, apres


------------------------------- Rep pays ------------------------------------

select
	bc.country_name,
	bop.carrier_name_theo,
	sum(bop.billing_product_ht / 100) as ca, 
	sum(bop.billing_shipping_product_ht)/ 100 as ca_fdp,
	sum(bop.cost_product_ht / 100) as cout_marchandise,
	count(distinct bo.order_id) as commandes,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen,
	sum(bop.billing_shipping_product_ht / 100)/ count(distinct bo.order_id) as fdp_moyen
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc on
	bo.delivery_country_id = bc.country_id
where
	bop.code_promo ilike 'ANNIV14-SML'
group by
	bc.country_name ,
	carrier_name_theo
	

------------------------------- Rep panier ------------------------------------
	
	
select
	bop.order_id, sum(bop.billing_product_ht / 100) as ca
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc on
	bo.delivery_country_id = bc.country_id
where
	bop.code_promo in ('ANNIV100-EUR | ANNIV150-EUR', 'ANNIV100-EUR | ANNIV50-EUR', 'ANNIV100-EUR | ANNIV150-EUR | ANNIV50-EUR')
group by bop.order_id 