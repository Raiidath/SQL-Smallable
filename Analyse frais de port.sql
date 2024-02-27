select billing_shipping_product_ht, billing_product_ht/100 as CA  from smallable2_datawarehouse.b_order_products bop --billing_shipping_product_ht

-------------------- regroupement par zone et clients/ global site	--------------------------------------------
SELECT
	case
		when b.CA > 500 THEN b.cid
		ELSE NULL
	END as mail,
	b.CA , b.livr,
	b.pays
FROM
	(
	select
		distinct(case
			when bc.email is not null then bc.email
			else null
		end) as cid,
		sum(bop.billing_product_ht)/100 as CA,
		sum(bop.billing_shipping_product_ht)/100 as livr,
		bc2.zone_code as pays
	from
		smallable2_datawarehouse.b_customers bc
	inner join smallable2_datawarehouse.b_countries bc2 
on
		bc.country_id = bc2.country_id
	left join smallable2_datawarehouse.b_orders bo
on
		bo.customer_id = bc.customer_id
	left join smallable2_datawarehouse.b_order_products bop 
on
		bo.basket_id = bop.basket_id
		and bo.order_id = bo.order_id
	group by
		bc.email,
		bc2.country_name ,
		pays
	order by
		pays asc) b
GROUP BY
	CA, cid, pays, livr
order by CA desc 

------------------------------------------ Mails, sum(CA), sum(FDP)/clients, Pays -------------------------------------
SELECT
	b.cid as mail,
	b.CA ,
	b.livr,
	b.pays
FROM
	(
	select
		distinct(case
			when bc.email is not null then bc.email
			else null
		end) as cid,
		sum(bop.billing_product_ht)/100 as CA,
		sum(bop.billing_shipping_product_ht)/100 as livr,
		bc2.zone_code as pays
	from
		smallable2_datawarehouse.b_customers bc
	inner join smallable2_datawarehouse.b_countries bc2 
		on
		bc.country_id = bc2.country_id
	left join smallable2_datawarehouse.b_orders bo
		on
		bo.customer_id = bc.customer_id
	left join smallable2_datawarehouse.b_order_products bop 
		on
		bo.basket_id = bop.basket_id
		and bo.order_id = bo.order_id
	where
		bo.created_at > '2020-10-20'
	group by
		bc.email,
		bc2.country_name,
		pays
	order by
		CA desc) b
where CA > 500
GROUP BY
	CA,
	cid,
	pays,
	livr
ORDER BY
	CA DESC 

-------------------------------------------------- CA et FDP /panier/pays ----------------------------------
WITH client as (select
		distinct(case
			when bop.basket_id  is not null then bop.basket_id 
			else null
		end) as cid
		,sum(bop.billing_product_ht)/100 as CA
		,sum(bop.billing_shipping_product_ht)/100 as livr
		,bc2.zone_code as pays
	from
		smallable2_datawarehouse.b_customers bc
	inner join smallable2_datawarehouse.b_countries bc2 
		on
		bc.country_id = bc2.country_id
	left join smallable2_datawarehouse.b_orders bo
		on
		bo.customer_id = bc.customer_id
	left join smallable2_datawarehouse.b_order_products bop 
		on
		bo.basket_id = bop.basket_id
		and bo.order_id = bo.order_id
	where
		bo.created_at > '2020-10-20'
	group by
		cid
		,bc2.country_name
		,pays
	order by
		CA desc)
select cid as mail
	,client.CA 
	,client.livr
	,client.pays
from client
where pays = 'ROA'
and CA > 500
GROUP BY
	CA
	,cid
	,pays
	,livr
ORDER BY
	CA ASC 

-------------------------------------------------- Moyenne CA et FDP /Panier/pays ----------------------------------
WITH client as (select
		distinct(case
			when bop.basket_id  is not null then bop.basket_id 
			else null
		end) as cid,
		sum(bop.billing_product_ht)/100 as CA
		,sum(bop.billing_shipping_product_ht)/100 as livr
		,bc2.zone_code as pays
	from
		smallable2_datawarehouse.b_customers bc
	inner join smallable2_datawarehouse.b_countries bc2 
		on
		bc.country_id = bc2.country_id
	left join smallable2_datawarehouse.b_orders bo
		on
		bo.customer_id = bc.customer_id
	left join smallable2_datawarehouse.b_order_products bop 
		on
		bo.basket_id = bop.basket_id
		and bo.order_id = bo.order_id
	where
		bo.created_at > '2020-10-20'
		and pays = 'ES'
	group by pays,cid)
select avg(CA) as M_ca, avg(livr) as M_fdp
from client
where CA > 500

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
	bc.zone_code,
	bop.carrier_name_reel as transp,
	sum(bop.billing_product_ht)/ 100 as ca_produits,
	sum(bop.billing_shipping_product_ht)/ 100 as ca_fdp,
	sum(bop.cost_product_ht/100) as cout_marchandise,
	count(distinct bo.order_id) as commandes,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen,
	sum(bop.billing_shipping_product_ht / 100)/ count(distinct bo.order_id) as fdp_moyen,
	sum(case when bo.order_id in (select oid from paniers where ca > 100) then bop.billing_product_ht  / 100 else null end) as ca_100,
	sum(case when bo.order_id in (select oid from paniers where ca > 100) then bop.cost_product_ht / 100 else null end) as cm_100,
	sum(case when bo.order_id in (select oid from paniers where ca > 100) then bop.billing_shipping_product_ht  / 100 else null end) as fdp_100,
	count(distinct case when bo.order_id in (select oid from paniers where ca > 100)  then bo.order_id else null end) as cmd_100,
	sum(case when bo.order_id in (select oid from paniers where ca > 100) then bop.billing_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 100) then bo.order_id else null end) as panier_moyen_100,
	sum(case when bo.order_id in (select oid from paniers where ca > 100) then bop.billing_shipping_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 100) then bo.order_id else null end) as fdp_moyen_100,
	sum(case when bo.order_id in (select oid from paniers where ca > 150) then bop.billing_product_ht  / 100 else null end) as ca_150,
	sum(case when bo.order_id in (select oid from paniers where ca > 150) then bop.cost_product_ht / 100 else null end) as cm_150,
	sum(case when bo.order_id in (select oid from paniers where ca > 150) then bop.billing_shipping_product_ht  / 100 else null end) as fdp_150,
	count(distinct case when bo.order_id in (select oid from paniers where ca > 150)  then bo.order_id else null end) as cmd_150,
	sum(case when bo.order_id in (select oid from paniers where ca > 150) then bop.billing_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 150) then bo.order_id else null end) as panier_moyen_150,
	sum(case when bo.order_id in (select oid from paniers where ca > 150) then bop.billing_shipping_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 150) then bo.order_id else null end) as fdp_moyen_150,
	sum(case when bo.order_id in (select oid from paniers where ca > 200) then bop.billing_product_ht  / 100 else null end) as ca_200,
	sum(case when bo.order_id in (select oid from paniers where ca > 200) then bop.cost_product_ht / 100 else null end) as cm_200,
	sum(case when bo.order_id in (select oid from paniers where ca > 200) then bop.billing_shipping_product_ht  / 100 else null end) as fdp_200,
	count(distinct case when bo.order_id in (select oid from paniers where ca > 200)  then bo.order_id else null end) as cmd_200,
	sum(case when bo.order_id in (select oid from paniers where ca > 200) then bop.billing_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 200) then bo.order_id else null end) as panier_moyen_200,
	sum(case when bo.order_id in (select oid from paniers where ca > 200) then bop.billing_shipping_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 200) then bo.order_id else null end) as fdp_moyen_200
	from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_countries bc on
	bo.delivery_country_id = bc.country_id
inner join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id
where
	bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2020-10-24'
group by
	bc.zone_code,
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
	bop.carrier_name_reel as transp,
	sum(bop.billing_product_ht)/ 100 as ca_produits,
	sum(bop.billing_shipping_product_ht)/ 100 as ca_fdp,
	sum(bop.cost_product_ht/100) as cout_marchandise,
	count(distinct bo.order_id) as commandes,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen,
	sum(bop.billing_shipping_product_ht / 100)/ count(distinct bo.order_id) as fdp_moyen,
	sum(case when bo.order_id in (select oid from paniers where ca > 100) then bop.billing_product_ht  / 100 else null end) as ca_100,
	sum(case when bo.order_id in (select oid from paniers where ca > 100) then bop.cost_product_ht / 100 else null end) as cm_100,
	sum(case when bo.order_id in (select oid from paniers where ca > 100) then bop.billing_shipping_product_ht  / 100 else null end) as fdp_100,
	count(distinct case when bo.order_id in (select oid from paniers where ca > 100)  then bo.order_id else null end) as cmd_100,
	sum(case when bo.order_id in (select oid from paniers where ca > 100) then bop.billing_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 100) then bo.order_id else null end) as panier_moyen_100,
	sum(case when bo.order_id in (select oid from paniers where ca > 100) then bop.billing_shipping_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 100) then bo.order_id else null end) as fdp_moyen_100,
	sum(case when bo.order_id in (select oid from paniers where ca > 150) then bop.billing_product_ht  / 100 else null end) as ca_150,
	sum(case when bo.order_id in (select oid from paniers where ca > 150) then bop.cost_product_ht / 100 else null end) as cm_150,
	sum(case when bo.order_id in (select oid from paniers where ca > 150) then bop.billing_shipping_product_ht  / 100 else null end) as fdp_150,
	count(distinct case when bo.order_id in (select oid from paniers where ca > 150)  then bo.order_id else null end) as cmd_150,
	sum(case when bo.order_id in (select oid from paniers where ca > 150) then bop.billing_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 150) then bo.order_id else null end) as panier_moyen_150,
	sum(case when bo.order_id in (select oid from paniers where ca > 150) then bop.billing_shipping_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 150) then bo.order_id else null end) as fdp_moyen_150,
	sum(case when bo.order_id in (select oid from paniers where ca > 200) then bop.billing_product_ht  / 100 else null end) as ca_200,
	sum(case when bo.order_id in (select oid from paniers where ca > 200) then bop.cost_product_ht / 100 else null end) as cm_200,
	sum(case when bo.order_id in (select oid from paniers where ca > 200) then bop.billing_shipping_product_ht  / 100 else null end) as fdp_200,
	count(distinct case when bo.order_id in (select oid from paniers where ca > 200)  then bo.order_id else null end) as cmd_200,
	sum(case when bo.order_id in (select oid from paniers where ca > 200) then bop.billing_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 200) then bo.order_id else null end) as panier_moyen_200,
	sum(case when bo.order_id in (select oid from paniers where ca > 200) then bop.billing_shipping_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 200) then bo.order_id else null end) as fdp_moyen_200,
	sum(case when bo.order_id in (select oid from paniers where ca > 300) then bop.billing_product_ht  / 100 else null end) as ca_300,
	sum(case when bo.order_id in (select oid from paniers where ca > 300) then bop.cost_product_ht / 100 else null end) as cm_300,
	sum(case when bo.order_id in (select oid from paniers where ca > 300) then bop.billing_shipping_product_ht  / 100 else null end) as fdp_300,
	count(distinct case when bo.order_id in (select oid from paniers where ca > 300)  then bo.order_id else null end) as cmd_300,
	sum(case when bo.order_id in (select oid from paniers where ca > 300) then bop.billing_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 300) then bo.order_id else null end) as panier_moyen_300,
	sum(case when bo.order_id in (select oid from paniers where ca > 300) then bop.billing_shipping_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 300) then bo.order_id else null end) as fdp_moyen_300
	from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_countries bc on
	bo.delivery_country_id = bc.country_id
inner join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id
where
	bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2020-10-24'
	and bc.country_name in ('Belgique')
group by
	bc.country_name,
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
	bc.zone_code,
	bop.carrier_name_reel as transp,
	sum(bop.billing_product_ht)/ 100 as ca_produits,
	sum(bop.billing_shipping_product_ht)/ 100 as ca_fdp,
	sum(bop.cost_product_ht/100) as cout_marchandise,
	count(distinct bo.order_id) as commandes,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen,
	sum(bop.billing_shipping_product_ht / 100)/ count(distinct bo.order_id) as fdp_moyen,
	sum(case when bo.order_id in (select oid from paniers where ca > 300) then bop.billing_product_ht  / 100 else null end) as ca_300,
	sum(case when bo.order_id in (select oid from paniers where ca > 300) then bop.cost_product_ht / 100 else null end) as cm_300,
	sum(case when bo.order_id in (select oid from paniers where ca > 300) then bop.billing_shipping_product_ht  / 100 else null end) as fdp_300,
	count(distinct case when bo.order_id in (select oid from paniers where ca > 300)  then bo.order_id else null end) as cmd_300,
	sum(case when bo.order_id in (select oid from paniers where ca > 300) then bop.billing_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 300) then bo.order_id else null end) as panier_moyen_300,
	sum(case when bo.order_id in (select oid from paniers where ca > 300) then bop.billing_shipping_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 300) then bo.order_id else null end) as fdp_moyen_300
	from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_countries bc on
	bo.delivery_country_id = bc.country_id
inner join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id
where
	bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2020-10-24'
group by
	bc.zone_code,
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
	bop.carrier_name_reel as transp,
	sum(bop.billing_product_ht)/ 100 as ca_produits,
	sum(bop.billing_shipping_product_ht)/ 100 as ca_fdp,
	sum(bop.cost_product_ht/100) as cout_marchandise,
	count(distinct bo.order_id) as commandes,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen,
	sum(bop.billing_shipping_product_ht / 100)/ count(distinct bo.order_id) as fdp_moyen,
	sum(case when bo.order_id in (select oid from paniers where ca > 100) then bop.billing_product_ht  / 100 else null end) as ca_100,
	sum(case when bo.order_id in (select oid from paniers where ca > 100) then bop.cost_product_ht / 100 else null end) as cm_100,
	sum(case when bo.order_id in (select oid from paniers where ca > 100) then bop.billing_shipping_product_ht  / 100 else null end) as fdp_100,
	count(distinct case when bo.order_id in (select oid from paniers where ca > 100)  then bo.order_id else null end) as cmd_100,
	sum(case when bo.order_id in (select oid from paniers where ca > 100) then bop.billing_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 100) then bo.order_id else null end) as panier_moyen_100,
	sum(case when bo.order_id in (select oid from paniers where ca > 100) then bop.billing_shipping_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 100) then bo.order_id else null end) as fdp_moyen_100,
	sum(case when bo.order_id in (select oid from paniers where ca > 150) then bop.billing_product_ht  / 100 else null end) as ca_150,
	sum(case when bo.order_id in (select oid from paniers where ca > 150) then bop.cost_product_ht / 100 else null end) as cm_150,
	sum(case when bo.order_id in (select oid from paniers where ca > 150) then bop.billing_shipping_product_ht  / 100 else null end) as fdp_150,
	count(distinct case when bo.order_id in (select oid from paniers where ca > 150)  then bo.order_id else null end) as cmd_150,
	sum(case when bo.order_id in (select oid from paniers where ca > 150) then bop.billing_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 150) then bo.order_id else null end) as panier_moyen_150,
	sum(case when bo.order_id in (select oid from paniers where ca > 150) then bop.billing_shipping_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 150) then bo.order_id else null end) as fdp_moyen_150,
sum(case when bo.order_id in (select oid from paniers where ca > 200) then bop.billing_product_ht  / 100 else null end) as ca_200,
	sum(case when bo.order_id in (select oid from paniers where ca > 200) then bop.cost_product_ht / 100 else null end) as cm_200,
	sum(case when bo.order_id in (select oid from paniers where ca > 200) then bop.billing_shipping_product_ht  / 100 else null end) as fdp_200,
	count(distinct case when bo.order_id in (select oid from paniers where ca > 200)  then bo.order_id else null end) as cmd_200,
	sum(case when bo.order_id in (select oid from paniers where ca > 200) then bop.billing_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 200) then bo.order_id else null end) as panier_moyen_200,
	sum(case when bo.order_id in (select oid from paniers where ca > 200) then bop.billing_shipping_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 200) then bo.order_id else null end) as fdp_moyen_200
	from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_countries bc on
	bo.delivery_country_id = bc.country_id
inner join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id
where
	bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2020-10-24'
	and bc.country_name in ('Allemagne', 'Italie', 'Espagne', 'France', 'Belgique')
group by
	bc.country_name,
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
	bc.zone_code,
	bop.carrier_name_reel as transp,
	sum(bop.billing_product_ht)/ 100 as ca_produits,
	sum(bop.billing_shipping_product_ht)/ 100 as ca_fdp,
	sum(bop.cost_product_ht/100) as cout_marchandise,
	count(distinct bo.order_id) as commandes,
	sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen,
	sum(bop.billing_shipping_product_ht / 100)/ count(distinct bo.order_id) as fdp_moyen,
	sum(case when bo.order_id in (select oid from paniers where ca > 500) then bop.billing_product_ht  / 100 else null end) as ca_500,
	sum(case when bo.order_id in (select oid from paniers where ca > 500) then bop.billing_shipping_product_ht  / 100 else null end) as fdp_500,
	count(distinct case when bo.order_id in (select oid from paniers where ca > 500)  then bo.order_id else null end) as cmd_500,
	sum(case when bo.order_id in (select oid from paniers where ca > 500) then bop.billing_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 500) then bo.order_id else null end) as panier_moyen_500,
	sum(case when bo.order_id in (select oid from paniers where ca > 500) then bop.billing_shipping_product_ht  / 100 else null end)/ count(distinct case when bo.order_id in (select oid from paniers where ca > 500) then bo.order_id else null end) as fdp_moyen_500
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_countries bc on
	bo.delivery_country_id = bc.country_id
inner join smallable2_datawarehouse.b_order_products bop on
	bo.order_id = bop.order_id
where
	bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2020-10-24'
	--and ca_produits > 500
group by
	bc.zone_code,
	transp
order by
	count(1) desc

-------------------------------------------------- RETOUR/CA RETOURS ----------------------------------	
select
	 as zone,
	avg(bop.billing_shipping_product_ht)/100 as FDP
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_customers bc 
on
	bc.customer_id = bo.customer_id
inner join smallable2_datawarehouse.b_order_products bop 
on
	bo.basket_id = bop.basket_id
	and bo.order_id = bo.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_datawarehouse.b_countries bc2 
on
	bc.country_id = bc2.country_id
where bo.created_at >  '2020-10-20'
group by
	zone
order by
	FDP desc
	
	
------------------------------------------------------------------------------------------
select * from 	smallable2_front.customer_return cr

	
select count(distinct cr.basket_id)
from
	smallable2_front.customer_return cr
inner join smallable2_datawarehouse.b_customers bc 
on cr.customer_id = bc.customer_id 
where cr.created > '2020-10-24'
and bc.descriptor_country_name = 'France'
	
select bop.carrier_name_reel as transp, 
count(distinct cr.basket_id),	sum(cr.total_amount)/ 100 as ca_produits
from
	smallable2_front.customer_return cr
RIGHT join smallable2_datawarehouse.b_orders bo 
on cr.customer_id = bo.customer_id 
inner join smallable2_datawarehouse.b_order_products bop 
on cr.order_id =bop.order_id 
and bo.basket_id = bop.basket_id 
where cr.created > '2020-10-24'
and bo.delivery_country_id  = '7'
group by 	bop.carrier_name_reel 

----------------------------------------------------------------------------------------
select
	bp.product_name as Nom_produit,  
from
 smallable2_front.availability_alert aa 
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id 
where 
order by
	Nb desc