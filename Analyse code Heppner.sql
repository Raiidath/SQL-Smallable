select
	distinct bop.code_promo  as code, count(distinct bop.order_id) as order, sum(bop.billing_product_ht/100)
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
	bop.code_promo in ('PANIER15', 'CART30', 'KORB30', 'BASKET30')  --'MONDIALRELAY100'  --'FREEDELIVERY0%'
group by bop.code_promo  



select
	count(distinct bop.order_id), 
	-- bc.country_name,-- bop.code_promo , 
	 --bop.carrier_name_theo, 
	 sum(bop.billing_product_ht / 100) as ca, 
	sum(bop.billing_shipping_product_ht)/ 100 as ca_fdp,
	sum(bop.cost_product_ht/100) as cout_marchandise,
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
--bop.code_promo ilike 'FREEDELIVERY%' and
bo.created_at >= '2022-06-03'
and bo.created_at <= '2022-11-07'
and bop.carrier_name_theo  ilike 'Heppner%'

group by --bop.order_id, bop.billing_product_ht , 
bc.country_name  , carrier_name_theo --, bop.code_promo 


select
	--distinct bop.order_id, 
	 bc.country_name,-- bop.code_promo , 
	 bop.carrier_name_theo, sum(bop.billing_product_ht / 100) as ca, 
	sum(bop.billing_shipping_product_ht)/ 100 as ca_fdp,
	sum(bop.cost_product_ht/100) as cout_marchandise,
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
--bop.code_promo ilike 'FREEDELIVERY%' and
bo.created_at >= '2021-06-03'
and bo.created_at <= '2021-11-07'
and bop.carrier_name_theo  ilike 'Heppner%'
group by --bop.order_id, bop.billing_product_ht , 
bc.country_name  , carrier_name_theo --, bop.code_promo 



select
	bop.code_promo as code_heppner, count(distinct bop.order_id) as order, sum( case when bop.code_promo ilike 'FREEDELIVERY0%' then bop.billing_product_ht / 100 else null end) as ca,
ca/order as Panier_moyen,
	count(distinct case when bop.code_promo ilike 'FREEDELIVERY0%' and bo.first_order_vs_repeat = '1�re Commande' then bop.order_id else null end) as 1er_cmd,
		1er_cmd / order  as pourcentage_1ere_cmd,
count(distinct case when bop.code_promo ilike 'FREEDELIVERY0%' and bo.first_order_vs_repeat = 'R�achat' then bop.order_id else null end) as Reachat,
	Reachat / order  as pourcentage_cmd_Reachat
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2	
	AND bop.code_promo ilike 'FREEDELIVERY0%'
group by bop.code_promo  




with paniers as (
select
	bo2.order_id as oid,
	sum(bo2.billing_product_ht)/ 100 as ca
from
	smallable2_datawarehouse.b_orders bo2
where
	bo2.is_valid = 1
	and bo2.is_ca_ht_not_zero = 1
group by
	oid)
select
	bc.country_name ,
	bop.carrier_name_theo as transp,
	sum (case when bo.created_at >= '2022-06-03' and bo.created_at <= '2022-07-24' then bop.billing_product_ht/ 100 else null end) as ca_pe22,
	sum (case when bo.created_at >= '2021-06-03' and bo.created_at <= '2021-07-24' then bop.billing_product_ht/ 100 else null end) as ca_pe21,
	count (distinct case when bo.created_at >= '2022-06-03' and bo.created_at <= '2022-07-24' then bo.order_id else null end) as cmd_pe22,
	count (distinct case when bo.created_at >= '2021-06-03' and bo.created_at <= '2021-07-24' then bo.order_id else null end) as cmd_pe21,
	sum (case when bo.created_at >= '2022-06-03' and bo.created_at <= '2022-07-24' then bop.billing_shipping_product_ht/ 100 else null end) as fdp_pe22,
	sum (case when bo.created_at >= '2021-06-03' and bo.created_at <= '2021-07-24' then bop.billing_shipping_product_ht/ 100 else null end) as fdp_pe21
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_countries bc on
	bo.delivery_country_id = bc.country_id
inner join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id
where
	bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bop.carrier_name_theo  ilike 'Heppner%'
--	and bc.zone_code  = 'FR'
group by
	bc.country_name ,
	transp
order by
	count(1) desc

	
	
with paniers as (
select
	bo2.order_id as oid,
	sum(bo2.billing_product_ht)/ 100 as ca
from
	smallable2_datawarehouse.b_orders bo2
where
	bo2.is_valid = 1
	and bo2.is_ca_ht_not_zero = 1
group by
	oid)
select
	bc.country_name, 
	bop.carrier_name_theo  as transp, --bop.code_promo, 
	sum(bop.billing_product_ht)/ 100 as ca_produits,
	--sum(bop.cost_product_ht/100) as cout_marchandise,
	count(distinct bo.order_id) as commandes,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen,
		sum(bop.billing_shipping_product_ht)/ 100 as ca_fdp
	--sum(bop.billing_shipping_product_ht / 100)/ count(distinct bo.order_id) as fdp_moyen	
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_countries bc on
	bo.delivery_country_id = bc.country_id
inner join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id
where
	bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bop.code_promo ilike 'FREEDELIVERY0%'
	--and bop.carrier_name_theo ilike 'Heppner%'
	and bo.created_at <= '2022-11-07'  
	and bo.created_at >= '2022-06-03'
	and bc.country_name  in ('France', 'Allemagne','Espagne','Belgique','Roumanie','Suisse','Gr�ce','Pays-Bas','Portugal','Autriche','Italie','Irlande''Lituanie','Luxembourg','Finlande','Lettonie','Pologne',
'Estonie','Hongrie','Bulgarie','Croatie','Turquie','Su�de','Slovaquie','R�publique Tch�que','Danemark','Royaume-Uni','Norv�ge','Slov�nie')
group by
	bc.country_name,transp   --bop.code_promo,	
order by
	count(1) desc	
	
	
with paniers as (
select
	bo2.order_id as oid,
	sum(bo2.billing_product_ht)/ 100 as ca
from
	smallable2_datawarehouse.b_orders bo2
where
	bo2.is_valid = 1
	and bo2.is_ca_ht_not_zero = 1
group by
	oid)
select
	bc.country_name  ,-- bo.order_id,
	--bc.regroup_zone  , 
	bop.carrier_name_theo  as transp, 
	sum(bop.billing_product_ht)/ 100 as ca_produits,
	sum(bop.billing_shipping_product_ht)/ 100 as ca_fdp,
	sum(bop.cost_product_ht/100) as cout_marchandise,
	count(distinct bo.order_id) as commandes,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen,
	sum(bop.billing_shipping_product_ht / 100)/ count(distinct bo.order_id) as fdp_moyen	
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_countries bc on
	bo.delivery_country_id = bc.country_id
inner join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id
where
	bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bop.code_promo ilike 'FREEDELIVERY0%'
	and bo.created_at >= '2022-06-03' 
	--and bo.created_at >= '2022-04-30'
	--and bc.regroup_zone  in ('EU', 'FR')
group by
	bc.country_name  , --bo.order_id,  
	transp
order by
	count(1) desc

	
	---------------------------Abandon Panier ---------------------------------------------------	
	
select count(case when bdp.nb_paniers >= 1 then 1 else null end) as Panier,
count(case when bdp.nb_commandes_brutes >= 1 then 1 else null end) as Cmd
from smallable2_datawarehouse.b_desirabilite_produits bdp 
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bdp.product_id 
where bdp.zone_code in ('EU', 'FR')
and bp.fragile = '3'
and ref_date >= '2022-06-03'
--and ref_date <= '2022-07-05'
--and ref_date >= '2022-04-30'
--and ref_date <= '2022-06-02'
--group by bdp.country_iso_code, bdp.ref_date, product_id 


select
	count(case when bdp.nb_paniers >= 1 then 1 else null end) as Panier,
	count(case when bdp.nb_commandes_brutes >= 1 then 1 else null end) as Cmd
from
	smallable2_datawarehouse.b_desirabilite_produits bdp
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bdp.product_id
where
	bdp.zone_code in ('EU', 'FR')
	and bp.fragile = '3'
	and ref_date >= '2022-04-30'
	and ref_date <= '2022-06-02'


select *
from smallable2_datawarehouse.b_desirabilite_produits bdp 
