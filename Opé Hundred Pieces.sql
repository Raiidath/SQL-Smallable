		
with c as (
select 
	distinct bo.customer_id as cid,
	bc.last_order_id as lad,
	bc.email as mail,
	bc.lastname as last,
	bc.firstname as first,
	*,
	case
		when (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.last_order_date)))/ 86400 > 180
		and bc.last_order_id in 
		(
		select
			bo3.order_id
		from
			smallable2_datawarehouse.b_orders bo3
		inner join smallable2_datawarehouse.b_order_products bop
					  on
			bop.order_id = bo3.order_id
		inner join smallable2_datawarehouse.b_products bp
					  on
			bop.product_id = bp.product_id
		inner join smallable2_datawarehouse.b_customers bc
					  on
			bo3.customer_id = bc.customer_id
		where
			bp.brand_name ilike 'Hundred pieces') then 'HP'
		else 'not HP'
	end as "Hundred",
	case
		when ns.email is null then 0
		else 1
	end as opt_in
from
	smallable2_datawarehouse.b_customers bc
inner join smallable2_datawarehouse.b_orders bo
on
	bo.customer_id = bc.customer_id
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
left join smallable2_front.newsletter_subscription ns 
on
	ns.email = bc.email
	and ns.enabled = 1
where
	bc.nb_commandes_nettes > 0)
select
	distinct
	--c.lad,
	concat(c.first,
	' ',
	c.last) AS name,
	c.mail AS email,
	lower(c.mail) AS email_minuscule,
		lower(hex(MD5(lower(c.mail)))) AS md5,
	l.name AS langue,
	c.opt_in as opt_in,
	c.cid as cid
from
	c
INNER JOIN smallable2_front.customer c1 ON
			bc.customer_id = c1.id
INNER JOIN smallable2_front.`language` l ON
			l.id = c1.language_id
where
	c.Hundred = 'HP'
	and c.opt_in = 1
order by
	cid asc

	
select *
from smallable2_datawarehouse.b_customers bc 
	