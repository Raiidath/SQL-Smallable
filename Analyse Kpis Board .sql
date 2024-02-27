------------------------------------------- SExe -------------------------------
select
	case
		when ca.title_id = 2 then 'Femme'
		else 'Homme'
	end as sexe,
	count(distinct ca.id) as Nb
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_address ca 
on
	bo.customer_id = ca.id
where
	bo.created_at >= '2022-08-01'
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
group by
	sexe
	
select
	count(distinct bo.order_id) as Nb
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_address ca 
on
	bo.customer_id = ca.id
where
	bo.created_at >= '2022-08-01'
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1

---------------------------------- Age moyen ------------------------------------------
	
select
	count(distinct c.id) as Nb,
	Round(avg((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(c.date_of_birth)))/(86400 * 365.25)),
	0) as Moyenne,
	Round(stddevPop((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(c.date_of_birth)))/(86400 * 365.25)),
	2) as Etype
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer c 
on
	bo.customer_id = c.id
where
	bo.created_at >= '2020-08-01'
	and bo.created_at <= '2021-07-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and c.date_of_birth is not null
	and c.email NOT LIKE '%boutique%@smallable.com%'	
	
	
select
	distinct c.id as Nb, c.date_of_birth  as date
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer c 
on
	bo.customer_id = c.id
where
	bo.created_at >= '2022-08-01'
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and c.date_of_birth is not null
	and c.email NOT LIKE '%boutique%@smallable.com%'
order by date desc

	
	group by c.date_of_birth 
order by Nb desc
	

SELECT
	*
FROM
	(
	SELECT
		DISTINCT bo.customer_id
	FROM
		smallable2_datawarehouse.b_orders bo
	WHERE
		bo.created_at >= '2020-08-01'
		AND bo.created_at <= '2021-07-31'
		AND bo.is_valid = 1
		AND bo.is_ca_net_ht_not_zero = 1) b
INNER JOIN (
	SELECT
		cf.date_of_birth,
		cf.id
	FROM
		smallable2_front.customer cf 
	WHERE cf.email NOT LIKE '%boutique%@smallable.com%'
	and cf.date_of_birth != '0001-01-01'
	and cf.date_of_birth is not null
	order by cf.date_of_birth desc) c ON
	c.id = b.customer_id 
	
	
------------------------------- Lieu de résidence -----------------------------
	
select
	distinct bc.zone_code  as Pays, 
	count(distinct c.id) as Nb
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer c 
on
	bo.customer_id = c.id
inner join smallable2_datawarehouse.b_countries bc 
on bc.country_id = bo.delivery_country_id 
where
	bo.created_at >= '2022-08-01'
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	--and c.email NOT LIKE '%boutique%@smallable.com%'	
group by Pays
order by Nb desc