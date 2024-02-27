-------------------------------------le panier moyen et le panier des top clients? DE, AT et CH? et aussi worldwide! ---------------------------------------
select
	bc.country_name,
	count(distinct bo.order_id) as cmd,
	count(distinct bo.customer_id) as client,
	sum(bop.billing_product_ht)/ 100 as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyeN
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
inner join smallable2_datawarehouse.b_countries bc 
on
	bc.country_id = bo.delivery_country_id
where
	bo.created_at between '2008-06-01' AND '2023-05-31'
	and bc.country_iso_code in ('DE', 'AT', 'CH')
group by
	bc.country_name 

	
	
select
	distinct bo.customer_id as Villes,
	count(distinct bo.order_id) as cmd,
	count(distinct bo.customer_id) as client,
	sum(bop.billing_product_ht)/ 100 as CA,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyeN
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_order_address coa
on
	coa.id = bo.delivery_address_id
	AND bo.created_at between '2008-06-01' AND '2023-05-31'
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
where
	 bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	--and left(trim( ' ' ,coa.city), 2)
group by
	Villes
Order by
	CA desc		
	

-------------------------------------------les 10 pays les plus importants pour Smallable --------------------
select
	distinct bc.country_name  as Villes,
	sum(bop.billing_product_ht / 100) as Nb
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_countries bc 
on
	bc.country_id = bo.delivery_country_id 
	AND bo.created_at between '2008-06-01' AND '2023-05-31'
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
where
	 bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	--and left(trim( ' ' ,coa.city), 2)
group by
	Villes
Order by
	Nb desc	
	

select
	distinct trim(lower(coa.city)) as Villes,
	sum(bop.billing_product_ht / 100) as Nb
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_order_address coa
on
	coa.id = bo.delivery_address_id
	AND bo.created_at between '2008-06-01' AND '2023-05-31'
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
where
	 bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	--and left(trim( ' ' ,coa.city), 2)
group by
	Villes
Order by
	Nb desc	