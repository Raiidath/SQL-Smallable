-----------------------------D�lais date alerte vs date mail -----------------------------------------------------
SELECT
	count(aa.id) as nombre,
	avg((toUnixTimestamp(aa.updated)-toUnixTimestamp(aa.created))/ 86400) as moyenne,
	stddevPop((toUnixTimestamp(aa.updated)-toUnixTimestamp(aa.created))/ 86400) as etype
from
	smallable2_front.availability_alert aa
where
	aa.done = 1
	and aa.created > '2021-01-01'
	and aa.created < '2021-12-31'

select
	toStartOfMonth(aa.created) as Mois,
	count(aa.id)
from
	smallable2_front.availability_alert aa
group by
	Mois
	
-----------------------D�lais date mail vs date cmd -------------------------------------------------------------------
With orders as (
select
	bo.order_id as oid,
	bc.email as email,
	bop.sku_code as sku,
	bo.created_at as c_at,
	bop.billing_product_ht as billing
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
inner join smallable2_datawarehouse.b_customers bc
on
	bc.customer_id = bo.customer_id)
select
	count(distinct e.id) as nombre,
	avg(e.commande-e.reception_email) as moyenne,
	stddevPop(e.commande-e.reception_email) as etype
from 
	(
	select
		aa.id,
		o.billing,
		case
			when o.sku = aa.sku then 1
			else 0
		end as purchased_product,
		date(aa.updated) as reception_email,
		o.c_at as commande
	from
		smallable2_front.availability_alert aa
	left join orders o on
		o.email = aa.email
	where
		aa.done = 1
		and aa.created > '2021-01-01' 
		and aa.created < '2021-12-31' 
		and o.c_at > aa.created) e
where
	e.purchased_product = 1
		
	
select
	date(aa.updated) as date,
	count(aa.id) as Nb_mail,
	aa.sku as sku
from
	smallable2_front.availability_alert aa
group by
	date,
	sku
order by
	Nb_mail desc 

select bs.sku_id, sum(bs.) from smallable2_datawarehouse.b_stocks bs where bs.ref_date = '2021-12-21'

----------------------------------------	alertes par univers ------------------------------------------------------------
select
	bp.sml_team as univers,
	count(bp.sml_team)
from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
left join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	univers 

----------------------------------------	D�lais alertes-Mail par univers ------------------------------------------------------------

select
	bp.sml_team as univers,
	count(bp.sml_team),
	avg((toUnixTimestamp(aa.updated)-toUnixTimestamp(aa.created))/ 86400) as moyenne,
	stddevPop((toUnixTimestamp(aa.updated)-toUnixTimestamp(aa.created))/ 86400) as etype
from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
left join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
	aa.done = 1
	and aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	univers 

----------------------------------------------D�lais alertes-Commandes par univers--------------------------------------------------------------------
WITH orders AS (
SELECT
	bo.order_id AS oid,
	bc.email AS email,
	bop.sku_code AS sku,
	bo.created_at AS c_at,
	bop.billing_product_ht AS billing,
	bop.sml_team AS z
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bop.order_id = bo.order_id
	AND bop.basket_id = bo.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_customers bc
ON
	bc.customer_id = bo.customer_id
INNER JOIN smallable2_datawarehouse.b_countries bc2 ON
	bc2.country_id = bo.delivery_country_id
INNER JOIN smallable2_datawarehouse.b_country_zone bcz ON
	bc2.country_iso_code = bcz.country_iso_code
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id )
SELECT
	e.z,
	count(DISTINCT e.id) AS nombre,
	avg(e.commande-e.reception_email) AS moyenne,
	stddevPop(e.commande-e.reception_email) AS etype
FROM
		(
	SELECT
		aa.id,
		o.billing,
		o.z,
		CASE
			WHEN o.sku = aa.sku THEN 1
			ELSE 0
		END AS purchased_product,
		date(aa.updated) AS reception_email,
		o.c_at AS commande
	FROM
		smallable2_front.availability_alert aa
	LEFT JOIN orders o ON
		o.email = aa.email
	WHERE
		aa.done = 1
		AND aa.created > '2021-01-01'
		AND aa.created < '2021-12-31'
		AND o.c_at > aa.created) e
WHERE
	e.purchased_product = 1
GROUP BY
	e.z
ORDER BY
	nombre DESC

	
--------------------------- D�lais par semaine -------------------------------------------------------------
With orders as (
select
	bo.order_id as oid,
	bc.email as email,
	bop.sku_code as sku,
	bo.created_at as c_at
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
    bop.order_id = bo.order_id
    AND bop.basket_id = bo.basket_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_customers bc
ON
    bc.customer_id = bo.customer_id
INNER JOIN smallable2_datawarehouse.b_countries bc2 ON
    bc2.country_id = bo.delivery_country_id
INNER JOIN smallable2_datawarehouse.b_country_zone bcz ON
    bc2.country_iso_code = bcz.country_iso_code 
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code 
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id)
select
	*
from 
	(
	select
		aa.id,
		case
			when o.sku = aa.sku then 1
			else 0
		end as purchased_product,
		date(aa.updated) as reception_email,
		o.c_at as commande,
		o.c_at-date(aa.updated) as delais
	from
		smallable2_front.availability_alert aa
	left join orders o on
		o.email = aa.email
	where
		aa.done = 1
		and aa.created > '2021-01-01'
		and aa.created < '2021-12-31'
		and o.c_at > aa.created) e
where
	e.purchased_product = 1
	
	
With orders as (
select
	bo.order_id as oid,
	bc.email as email,
	bop.sku_code as sku,
	bo.created_at as c_at
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
inner join smallable2_datawarehouse.b_customers bc
on
	bc.customer_id = bo.customer_id)
select
	count(alert) 
from 
	(
	select
		aa.id,
		case
			when o.sku = aa.sku then 1
			else 0
		end as purchased_product,
		(date(aa.updated)) as reception_email,
		(date(aa.created)) as alert,
		(date(aa.updated))-(date(aa.created)) as delais
	from
		smallable2_front.availability_alert aa
	left join orders o on
		o.email = aa.email
	where
		aa.done = 1
		and aa.created > '2021-01-01'
		and aa.created < '2021-12-31'
		--and o.c_at > aa.create
		) e
where
	e.purchased_product = 1
	
select --count(date(aa.created)),
		(date(aa.created)) as alert,(date(aa.updated))-(date(aa.created)) as delais
from
	smallable2_front.availability_alert aa
where aa.done = 1	
	and aa.created > '2021-01-01'
	and aa.created < '2021-12-31'

----------------------------------------	alertes par univers ------------------------------------------------------------
select
	bp.sml_team as univers,
	count(bp.sml_team) as alertes,
	count(distinct aa.email) as clients_distincts,
	count(distinct aa.sku) as produits_distincts,
	count(case when aa.done = 0 then aa.id else null end) as Nb_aletres_sans_mails
from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
left join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
	aa.created >= '2022-11-01'
		AND aa.created < '2022-12-01'
group by
	univers 

----------------------------------------------D�lais alertes-Mail-Commandes par univers--------------------------------------------------------------------
select
	bp.sml_team as univers,
	count(bp.sml_team),
	avg((toUnixTimestamp(aa.updated)-toUnixTimestamp(aa.created))/ 86400) as moyenne,
	stddevPop((toUnixTimestamp(aa.updated)-toUnixTimestamp(aa.created))/ 86400) as etype
from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
left join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
	aa.done = 1
	and  aa.created >= '2022-11-01'
		AND aa.created < '2022-12-01'
			--	and bp.season = 'PE22'
group by
	univers 
	
	
WITH orders AS (
SELECT
	bo.order_id AS oid,
	bc.email AS email,
	bop.sku_code AS sku,
	bo.created_at AS c_at,
	bop.billing_product_ht AS billing,
	bop.sml_team AS z
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bop.order_id = bo.order_id
	AND bop.basket_id = bo.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_customers bc
ON
	bc.customer_id = bo.customer_id
INNER JOIN smallable2_datawarehouse.b_countries bc2 ON
	bc2.country_id = bo.delivery_country_id
INNER JOIN smallable2_datawarehouse.b_country_zone bcz ON
	bc2.country_iso_code = bcz.country_iso_code
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id )
SELECT
	e.z,
	count(DISTINCT e.id) AS nombre,
	avg(e.commande-e.reception_email) AS moyenne,
	stddevPop(e.commande-e.reception_email) AS etype
FROM
		(
	SELECT
		aa.id,
		o.billing,
		o.z,
		CASE
			WHEN o.sku = aa.sku THEN 1
			ELSE 0
		END AS purchased_product,
		date(aa.updated) AS reception_email,
		o.c_at AS commande
	FROM
		smallable2_front.availability_alert aa
	LEFT JOIN orders o ON
		o.email = aa.email
	WHERE
		aa.done = 1
		AND aa.created >= '2022-11-01'
		AND aa.created < '2022-12-01'
		AND o.c_at > aa.created) e
WHERE
	e.purchased_product = 1
GROUP BY
	e.z
ORDER BY
	nombre DESC

----------------------------------------	D�lais Sku-Refco-Marques par univers ------------------------------------------------------------

select
	--bp.ref_co as Refco,
	--bs.sku_code as sku,
	--bp.product_name as Nom_produit,  
	bp.brand_name as Marques, 
	--bs.color_fournisseur as Couleurs,
	--	bs.`size` AS taille, 	
	--bp.season as saison,
	bp.buyer as Acheteuses,
	count(distinct aa.id) as Nb,
	count(distinct case when aa.done = 0 then aa.id else null end) as Nb_sans_mails
from
	smallable2_front.availability_alert aa
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
	aa.created >= '2022-11-01'
	AND aa.created < '2022-12-01'
	and bp.sml_team = 'mode'
	--and bp.brand_name = 'Alma Deia'
group by
	--Nom_produit, 
	--Refco,
	--sku,
	Marques, 
	--saison, --taille,
	--Couleurs, 
	Acheteuses
order by
	Nb desc
	
	
select
	--bp.ref_co as Refco,
	bs.sku_code as sku,
	bp.product_name as Nom_produit,  
	bp.brand_name as Marques,
	--bs.color_fournisseur as Couleurs,
	bp.buyer as Acheteuses,
	count(distinct case when aa.created >= '2021-02-01' and aa.created <= '2021-07-31' then aa.id else null end) as Nb_alerte_PE21,
	count(distinct case when aa.created >= '2021-08-01' and aa.created <= '2022-01-31' then aa.id else null end) as Nb_alerte_AH21,
	count(distinct case when aa.created >= '2022-02-01' and aa.created < '2022-05-23' then aa.id else null end) as Nb_alerte_PE22
from
 smallable2_front.availability_alert aa 
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id 
and bp.sml_team = 'mode'
group by
	Nom_produit, 
	--Refco,
	sku,
	Marques, 
	 --Couleurs, 
	Acheteuses
order by
	Nb_alerte_PE21 desc
	
--------------------------------------------------------------- Evolution par jour -----------------------------------------------------------------------------
select
	toDate(aa.created) as Mois,
	count(aa.id) as Nb
from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
left join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where	aa.created >= '2022-11-01'
	AND aa.created < '2022-12-01'
		and bp.sml_team = 'mode'
group by
	Mois
	order by Nb desc
	
----------------------------------------------------Skus avec envois de mails r�cents -------------------------------------------------------------
select
	date(aa.updated) as date,
	aa.sku as sku, bp.product_name as Produits, bp.brand_name as Marques, 	count(aa.id) as Nb_mail--, bp.ref_co as Refco
from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
left join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where aa.created >= '2022-11-01'
	AND aa.created < '2022-12-01'
	and bs.sml_team = 'mode'
group by
	date,sku, Produits, Marques--, Refco
order by
	Nb_mail desc 

-------------------------------------------------------- Enfants des clients ------------------------------------------------------------
select * 
from smallable2_front.customer_child cc 

-------------------------Customer child global site 

select  count(distinct cc.customer_id) as clients
from smallable2_front.customer_child cc 

select count(distinct customer_id)
from smallable2_datawarehouse.b_customers bc 

select customer_id , sex, firstname, date_of_birth, created, expected_date_of_birth,  (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400*365.25) as age
from smallable2_front.availability_alert aa 
inner join smallable2_front.customer_child cc 
on cc.customer_id = aa.customer_id 
where age > 0
	and aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
order by age asc 

-------------------------------- Total child avec moyenne --------------------------------------------------------

select count(distinct aa.email) as client
from smallable2_front.availability_alert aa 
inner join smallable2_datawarehouse.b_customers bc 
on aa.email = bc.email
inner join smallable2_front.customer_child cc 
on aa.customer_id = cc.customer_id 
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'

------------------------- Regroupement par customer ----------------------------------------------------

select cc.customer_id, count(cc.id) as Nb
from smallable2_front.customer_child cc 
group by cc.customer_id
order by Nb desc 


---------------------------Regroupement par customer et alertes 

select cc.customer_id  as customer,aa.email , count(distinct cc.id) as Nb, avg((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400*365.25)) as Moyenne, 
	   stddevPop((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400*365.25)) as Etype
from smallable2_front.customer_child cc
right join smallable2_front.availability_alert aa 
on cc.customer_id = aa.customer_id 
group by customer, email
order by Nb desc



select cc.customer_id, count(distinct cc.id) as Nb 
from smallable2_front.customer_child cc
right join smallable2_front.availability_alert aa 
on cc.customer_id = aa.customer_id 
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by customer_id 
order by Nb desc

------------------------ Regroupement par SEXE et alertes 

select DISTINCT cc.sex as sexe, count(distinct cc.id) as Nb, avg((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400*365.25)) as Moyenne, 
	   stddevPop((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400*365.25)) as Etype
from smallable2_front.availability_alert aa 
inner join smallable2_front.customer_child cc 
on cc.customer_id = aa.customer_id 
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by sex
order by Nb desc 

select DISTINCT cc.sex as sexe, count(distinct cc.id) as Nb, avg((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400*365.25)) as Moyenne, 
	   stddevPop((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400*365.25)) as Etype
from  smallable2_front.customer_child cc 
group by sex
order by Nb desc 

------------------------------------ Nb alert avec vs sans commande -------------------------------------------------------------------
With orders as (
select
	bo.order_id as oid,
	bc.email as email,
	bop.sku_code as sku,
	bo.created_at as c_at
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
left join smallable2_datawarehouse.b_customers bc
on
	bc.customer_id = bo.customer_id)
select
	--count(distinct aa.id) as nb_alert,
	--nb_alert-nb_alert_avec_commande as nb_alert_sans_commande,
	count(distinct case when o.sku = aa.sku then aa.id else null end) as nb_alert_avec_commande
from
		smallable2_front.availability_alert aa
left join orders o on
	o.email = aa.email
where
		aa.done = 1
		and aa.created > '2021-01-01' 
		and aa.created < '2021-12-31' 
	    --and o.c_at > aa.updated
		and o.c_at > aa.created
	

---------------------------------- Nb commande par clients vs global site ------------------------------------------------------------------
		
		
select
	count(distinct bo.order_id)/ count(distinct bo.customer_id) as Moyenne,
	count(distinct bo.customer_id) as Nb_clients_log
from
	smallable2_datawarehouse.b_orders bo
where
	bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.customer_id in (
	select
		aa.customer_id
	from
		smallable2_front.availability_alert aa
	where
		aa.created > '2021-01-01'
		and aa.created < '2021-12-31' )
						
		
		
						
select
	count(distinct bo.order_id)/ count(distinct bc.email) as Moyenne,
	count(distinct bc.email) as Nb_clients_inscrit
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_customers bc 
on
	bc.customer_id = bo.customer_id
where
	bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bc.email in (
	select
		aa.email
	from
		smallable2_front.availability_alert aa
	where
		aa.created > '2021-01-01'
		and aa.created < '2021-12-31' 
		)
	
		
		
		
select
	count(distinct bo.order_id)/ count(distinct bo.customer_id) as Moyenne,
	count(distinct bo.customer_id) as Nb_global_site
from
	smallable2_datawarehouse.b_orders bo
where
	bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	
	
	
	
----------------------------REPEAT-------------------------------------------------------------
	
	
select
count(distinct bo.customer_id) as Nb_clients_log_rep
from
	smallable2_datawarehouse.b_orders bo
where
	bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.first_order_vs_repeat = 'Réachat'
	and bo.customer_id in (
	select
		aa.customer_id
	from
		smallable2_front.availability_alert aa
	where
		aa.created > '2021-01-01'
		and aa.created < '2021-12-31' )
		
		
						
select
	count(distinct bc.email) as Nb_clients_inscrit_repeat
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_customers bc 
on
	bc.customer_id = bo.customer_id
where
	bo.is_valid = 1
	and bo.first_order_vs_repeat = 'Réachat'
	and bo.is_ca_ht_not_zero = 1
	and bc.email in (
	select
		aa.email
	from
		smallable2_front.availability_alert aa
	where
		aa.created > '2021-01-01'
		and aa.created < '2021-12-31' )
		
		
		
select
	count(distinct bo.customer_id) as Nb_global_site
from
	smallable2_datawarehouse.b_orders bo
where
	bo.first_order_vs_repeat = 'Réachat'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	
	
------------------------------------------------Nb total email vs Nb distinct email ------------------------------------------------------------
------------------------------------------------Pourcentage clients distincts/ Nb d'alertes annuel ---------------------------------
SELECT
	count(distinct email)/(count(email) as nombre)*100,
	avg((toUnixTimestamp(aa.updated)-toUnixTimestamp(aa.created))/ 86400) as moyenne,
	stddevPop((toUnixTimestamp(aa.updated)-toUnixTimestamp(aa.created))/ 86400) as etype
from
	smallable2_front.availability_alert aa
where
	aa.done = 1
	and aa.created > '2021-01-01'
	and aa.created < '2021-12-31'

--------------------------------------------------------TOP 20 clients avec le plus d'alertes annuelles ------------------------------
	
SELECT top 10
	count(email) as nombre,
	aa.email as email
from
	smallable2_front.availability_alert aa
--left join smallable2_datawarehouse.b_customers bc 
--on bc.customer_id = aa.customer_id 
where
	 aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by email 
order by nombre desc

------------------------------------------------------Nb alertes et nb clients distincts / mois---------------------------------------
select toStartOfMonth(ee.created_at)


select
	case
		when e.created < '2021-01-31' then 'Janvier'
		when e.created < '2021-02-31' then 'F�vrier'
		when e.created < '2021-03-31' then 'Mars'
		when e.created < '2021-04-31' then 'Avril'
		when e.created < '2021-05-31' then 'Mai'
		when e.created < '2021-06-31' then 'Juin'
		when e.created < '2021-07-31' then 'Juillet'
		when e.created < '2021-08-31' then 'Ao�t'
		when e.created < '2021-09-31' then 'Septembre'
		when e.created < '2021-10-31' then 'Octobre'
		when e.created < '2021-11-31' then 'Novembre'
		else 'D�cembre'
	end as Mois,
	count(distinct e.email) as distinct_clients,
	count(e.email) as nb
from
		smallable2_front.availability_alert e
where
	e.created > '2021-01-01'
	and e.created < '2021-12-31'
	
	
---------------------------------------------------------------------------------------------------------------------------------------------------
	
select toStartOfMonth(e.created_at)


select
	toStartOfMonth(e.created) as Mois,
	count(distinct e.email) as distinct_clients,
	count(e.email) as nb
from
		smallable2_front.availability_alert e
group by
	Mois
group by
	Mois

----------------------------------------------------- Age du client -----------------------------------------------------------------
select
	c.firstname,
	c.lastname,
	c.email,
	c.date_of_birth,
	(toUnixTimestamp(now())-toUnixTimestamp(toDateTime(c.date_of_birth)))/(86400 * 365.25) as Age
from
	smallable2_front.availability_alert aa
inner join smallable2_front.customer c 
on
	aa.email = c.email
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
	and c.date_of_birth < '2010-01-01'


select
	case
		when Age < 14 then 'Enfants'
		when Age < 24 then 'Ados'
		else 'Adultes'
	end as Groupe_age,
	c.date_of_birth,
	(toUnixTimestamp(now())-toUnixTimestamp(toDateTime(c.date_of_birth)))/(86400 * 365.25) as Age, 
	count(c.date_of_birth) as Nb
from
	smallable2_front.availability_alert aa
inner join smallable2_front.customer c 
on
	aa.email = c.email
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
	and c.date_of_birth < '2010-01-01'
group by
	Age ,
	c.date_of_birth
order by
	Nb desc

	
	
select
	case
		when Age < 14 then 'Enfants'
		when Age < 24 then 'Ados'
		else 'Adultes'
	end as Groupe_age,
	count(birth) as Nb,
	avg(Age) as Moyenne
from 
	(
	select
		c.id,
		c.date_of_birth as birth,
		(toUnixTimestamp(now())-toUnixTimestamp(toDateTime(c.date_of_birth)))/(86400 * 365.25) as Age
	from
		smallable2_front.availability_alert aa
	inner join smallable2_front.customer c 
	on
		aa.email = c.email
	where
		aa.created > '2021-01-01'
		and aa.created < '2021-12-31'
		and c.date_of_birth < '2010-01-01')
group by
	Groupe_age
order by
	Nb desc
	
select
	case
		when Age < 14 then 'Enfants'
		when Age < 24 then 'Ados'
		else 'Adultes'
	end as Groupe_age,
	count(birth) as Nb,
	avg(Age) as Moyenne
from 
	(
	select
		c.id,
		c.date_of_birth as birth,
		(toUnixTimestamp(now())-toUnixTimestamp(toDateTime(c.date_of_birth)))/(86400 * 365.25) as Age
	from smallable2_front.customer c 
	where
		c.date_of_birth < '2010-01-01')
group by
	Groupe_age
order by
	Nb desc

------------------------------------------  Regrouper par saison ---------------------------------------
select
	distinct bp.season_group  as Group_season,
	count(bp.season_group) as Nb,
	avg((toUnixTimestamp(aa.updated)-toUnixTimestamp(aa.created))/ 86400) as moyenne,
	stddevPop((toUnixTimestamp(aa.updated)-toUnixTimestamp(aa.created))/ 86400) as etype
from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
left join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	Group_season  
order by Nb desc

select
	distinct bp.season_group  as Group_season,
	count(bp.season_group) as Nb,
	avg((toUnixTimestamp(aa.updated)-toUnixTimestamp(aa.created))/ 86400) as moyenne,
	stddevPop((toUnixTimestamp(aa.updated)-toUnixTimestamp(aa.created))/ 86400) as etype
from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
left join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
	aa.done = 1
	and aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	Group_season  
order by Nb desc


WITH orders AS (
SELECT
    bo.order_id AS oid,
    bc.email AS email,
    bop.sku_code AS sku,
    bo.created_at AS c_at,
    bop.billing_product_ht AS billing,
    bp.season_group AS z
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
    bop.order_id = bo.order_id
    AND bop.basket_id = bo.basket_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_customers bc
ON
    bc.customer_id = bo.customer_id
INNER JOIN smallable2_datawarehouse.b_countries bc2 ON
    bc2.country_id = bo.delivery_country_id
INNER JOIN smallable2_datawarehouse.b_country_zone bcz ON
    bc2.country_iso_code = bcz.country_iso_code 
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id )
SELECT
    e.z,
    count(DISTINCT e.id) AS nombre,
    avg(e.commande-e.reception_email) AS moyenne,
    stddevPop(e.commande-e.reception_email) AS etype
FROM
    (
    SELECT
        aa.id,
        o.billing,
        o.z,
        CASE
            WHEN o.sku = aa.sku THEN 1
            ELSE 0
        END AS purchased_product,
        date(aa.updated) AS reception_email,
        o.c_at AS commande
    FROM
        smallable2_front.availability_alert aa
    LEFT JOIN orders o ON
        o.email = aa.email
    WHERE
        aa.done = 1
        AND aa.created > '2021-01-01'
        AND aa.created < '2021-12-31'
        AND o.c_at > aa.created) e
WHERE
    e.purchased_product = 1
GROUP BY
    e.z
ORDER BY nombre DESC


select bp.product_type_N4_refco  as univers, count(aa.id) as Nb
from smallable2_front.availability_alert aa 
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_code  = aa.sku
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
where
		aa.created > '2021-01-01' 
		and aa.created < '2021-12-31'
		and bp.season_group = 'Permanent'
		and bp.sml_team = 'design'
		and bp.gender = 'woman'
group by univers 
order by Nb desc

-------------------------------------PERSONS : Child, Teen, Adult pour design mode--------------------------------------------------------
select bs.product_type_N4  as persons , count(bp.persons) as Nb
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
where bp.sml_team = 'mode'
and bp.persons = 'adult'
and bp.gender = 'woman'
group by persons 
order by Nb desc



select
	distinct bp.product_type_N4_refco  as persons ,
	count(bp.persons) as Nb
from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
left join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
	and bp.sml_team = 'mode'
	and bp.persons = 'adult'
	and bp.gender = 'woman'
	and aa.done = 1
group by
	persons  
order by Nb desc

select
	bp.gender as univers,
	count(aa.id) as Nb
from
	smallable2_front.availability_alert aa
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_code = aa.sku
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
where
		aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
	and aa.done = 1
	and bp.sml_team = 'mode'
	and bp.persons = 'adult'
	and bp.gender = 'woman'
group by
	univers
order by
	Nb desc



With orders as (
select
	bo.order_id as oid,
	bc.email as email,
	bop.sku_code as sku,
	bo.created_at as c_at,
	bop.sml_team as univers,
	bp.product_type_N4_refco  as persons
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id 
		and bp.sml_team = 'mode'
		and bp.persons = 'baby'
inner join smallable2_datawarehouse.b_customers bc
on bc.customer_id = bo.customer_id
)
select
	e.persons ,
	count(DISTINCT e.id) as Nb
from 
	(
	select
		o.persons,
		aa.id,
		case
			when o.sku = aa.sku then 1
			else 0
		end as purchased_product,
		date(aa.updated) as alert,
		o.c_at as commande
	from
		smallable2_front.availability_alert aa
	left join orders o on
		o.email = aa.email
	where
		aa.done = 1
		and univers = 'mode'
	    and aa.created > '2021-01-01'  
		and aa.created < '2021-12-31' 
		and o.c_at > aa.created) e
where
	e.purchased_product = 1
group by
	e.persons
order by Nb desc


-------------------------------Panier moyen des clients demandant l'alerte dispo ------------------------------------
With panier as (
select
	bo.order_id as oid,
	bc.email as email,
	bo.created_at as c_at,
	bo.billing_product_ht as billing
from
	smallable2_datawarehouse.b_orders bo
left join smallable2_datawarehouse.b_customers bc
on
	bc.customer_id = bo.customer_id
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1)
select
avg(e.billing)/100 as panier_moyen,
	count(distinct e.id) as nombre
from 
	(
	select
		aa.id,
		o.billing
	from
		smallable2_front.availability_alert aa
	left join panier o on
		o.email = aa.email
	where
		aa.done = 1
		and aa.created > '2021-01-01' 
		and aa.created < '2021-12-31'
		and o.c_at > aa.created
		) e

		
select
	avg(bo.billing_product_ht)/ 100 as panier_moyen_alert
from
	smallable2_datawarehouse.b_orders bo
left join smallable2_datawarehouse.b_customers bc
on
	bc.customer_id = bo.customer_id
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
left join smallable2_front.availability_alert aa
on
	bc.email = aa.email
where
	aa.done = 1
	and aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
	and bo.created_at > aa.created
	
	
	
select
	avg(bo.billing_product_ht)/ 100 as panier_moyen_total
from
	smallable2_datawarehouse.b_orders bo
where
	bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bo.created_at > '2021-01-01'
	and bo.created_at < '2021-12-31'
	
	
-------------------------------------- Pourcentage clients inscrits ------------------------------------------------
select
	count(aa.id),
	count(distinct bc.email),
	count(case when bc.email is not null then bc.email else null end) as nb,
	(count(distinct case when bc.email is not null then bc.email else null end)*100/count(aa.id)) as percent_clients_inscrit,
	100-percent_clients_inscrit as percent_clients_non_inscrits
from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_customers bc 
on
	aa.email = bc.email
where
		aa.created > '2021-01-01' 
		and aa.created < '2021-12-31'
		
select
bp.sml_team,
	count(aa.id),
	count(distinct bc.email),
	(count(distinct case when bc.email is not null then bc.email else null end)*100/count(aa.id)) as percent_clients_inscrit,
	100-percent_clients_inscrit as percent_clients_non_inscrits
from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_customers bc 
on
	aa.email = bc.email
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
		aa.created > '2021-01-01' 
		and aa.created < '2021-12-31'
group by bp.sml_team 


select bs.univers as Univers, count(distinct aa.email) as Nb--, bp.brand_name as Marques--, aa.sku as sku
from 	smallable2_front.availability_alert aa
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
left join smallable2_datawarehouse.b_customers bc 
on
	aa.email = bc.email
where
		aa.created > '2021-01-01' 
		and aa.created < '2021-12-31'
		and bc.email is null
group by Univers 
order by Nb desc


select bp.brand_name as Marques, count(aa.email) as Nb--, bp.brand_name as Marques--, aa.sku as sku
from 	smallable2_front.availability_alert aa
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
left join smallable2_datawarehouse.b_customers bc 
on
	aa.email = bc.email
where
		aa.created > '2021-01-01' 
		and aa.created < '2021-12-31'
		and bc.email is not null
group by Marques
order by Nb desc

-------------------------------------- Pourcentage clients logg�s ------------------------------------------------
select
	count(aa.id),
	count (distinct
	case
		when aa.customer_id is not null then aa.customer_id
		else null
	end) as log,
	(100 - percent_log as percent_no_log),
	count (distinct
	case
		when aa.customer_id is not null then aa.customer_id
		else null
	end)* 100 / count(aa.id) as percent_log
from
	smallable2_front.availability_alert aa
where
		aa.created > '2021-01-01' 
		and aa.created < '2021-12-31'

		
------------------------------------- Pourcentage R�achat vs First order ----------------------------------------
select
	count(distinct aa.customer_id) as total
	from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_orders bo 
on
	aa.customer_id = bo.customer_id
left join smallable2_datawarehouse.b_customers bc 
on
	aa.email = bc.email
left join smallable2_datawarehouse.b_skus bs 
on bs.sku_code = aa.sku 
where
	aa.done = 1
	and aa.created > '2021-01-01' 
	and aa.created < '2021-12-31'
	and bo.created_at > aa.created 
	
select
	count(distinct case when bc.email is not null then bc.email else null end) as repeat
	from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_orders bo 
on
	aa.customer_id = bo.customer_id
left join smallable2_datawarehouse.b_customers bc 
on
	aa.email = bc.email
left join smallable2_datawarehouse.b_skus bs 
on bs.sku_code = aa.sku 
where
	aa.done = 1
	and bo.first_order_vs_repeat = 'Réachat'
	and aa.created > '2021-01-01' 
	and aa.created < '2021-12-31'
	and bo.created_at > aa.created 
	
	
select
	count(distinct case when bc.email is not null then bc.email else null end) as first_order
	from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_orders bo 
on
	aa.customer_id = bo.customer_id
left join smallable2_datawarehouse.b_customers bc 
on
	aa.email = bc.email
left join smallable2_datawarehouse.b_skus bs 
on bs.sku_code = aa.sku 
where
	aa.done = 1
	and bo.first_order_vs_repeat = '1ère Commande'
	and aa.created > '2021-01-01' 
	and aa.created < '2021-12-31'
	and bo.created_at > aa.created 
	
------------------------------------------ Regroupement par langue ------------------------------------------------------------------
-------------------------------------Global site--------------------------

select l.name as langue, count(l.id) as Nb
from
	smallable2_front.customer c
inner join smallable2_front.`language` l 
on l.id = c.language_id 
group by langue
order by Nb desc


--------------------ALERTES-----------------------------------------
select
	DISTINCT bc2.country_name  as langue,
	-- currency_id 
	count(aa.id) as Nb
from
	smallable2_datawarehouse.b_customers bc 
inner join smallable2_front.availability_alert aa 
on
	aa.email = bc.email
	--and aa.customer_id =bc.customer_id 
inner join smallable2_datawarehouse.b_countries bc2 
on
bc2.country_id = bc.country_id 
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	langue
	Order by Nb desc
	-----------------------MAILS-----------------------------------------

select
	DISTINCT l.name as langue,
	-- currency_id 
	count(aa.id)
from
	smallable2_front.customer c
inner join smallable2_front.availability_alert aa 
on
	aa.email = c.email
inner join smallable2_front.`language` l
on
	l.id = c.language_id
where
	aa.done = 1
	and aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	langue
	---------------------------------COMMANDES-----------------------------------------

With orders as (
	select
		bo.order_id as oid,
		bc.email as email,
		bop.sku_code as sku,
		bo.created_at as c_at,
		bop.sml_team as univers,
		l.name as langue
	from
		smallable2_datawarehouse.b_orders bo
	inner join smallable2_datawarehouse.b_order_products bop 
on
		bop.order_id = bo.order_id
		and bop.basket_id = bo.basket_id
		and bo.is_valid = 1
		and bo.is_ca_ht_not_zero = 1
	inner join smallable2_datawarehouse.b_skus bs ON
		bs.sku_id = bop.sku_id
	inner join smallable2_datawarehouse.b_products bp ON
		bs.product_id = bp.product_id
	inner join smallable2_datawarehouse.b_customers bc
on
		bc.customer_id = bo.customer_id
	inner join smallable2_front.customer c 
on
		bc.email = c.email
	inner join smallable2_front.`language` l
on
		l.id = c.language_id 
)
select
	e.langue ,
	count(e.langue) as Nb
from 
	(
	select
		distinct o.langue,
		aa.id,
		case
			when o.sku = aa.sku then 1
			else 0
		end as purchased_product,
		date(aa.updated) as alert,
		o.c_at as commande
	from
		smallable2_front.availability_alert aa
	left join orders o on
		o.email = aa.email
	where
		aa.done = 1
		and univers = 'mode'
		and aa.created > '2021-01-01'
		and aa.created < '2021-12-31'
		and o.c_at > aa.created) e
where
	e.purchased_product = 1
group by
	e.langue
	
---------------------------------- Regroupement par zone -----------------------------------------------------------------
----------------------------------------------------------------PAYS--------------------------------------------------------------------------------
-----------------------------------------------------------Top alertes ---------------------------------------------------------------------------
select
	bc2.country_name as zone,  
				count(aa.id) as Nb
from
	smallable2_datawarehouse.b_customers bc
inner join smallable2_front.availability_alert aa 
on
	aa.email = bc.email
inner join smallable2_datawarehouse.b_countries bc2 
on
	bc2.country_id = bc.country_id
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	zone
order by
	Nb desc

-----------------------------------------------------------Top alertes/univers ---------------------------------------------------------------------
select
	bc2.country_name as zone, 
				count(distinct aa.id) as Nb,
	bop.sml_team as univers
from
	smallable2_datawarehouse.b_customers bc
inner join smallable2_front.availability_alert aa 
on
	aa.email = bc.email
inner join smallable2_datawarehouse.b_countries bc2 
on
	bc2.country_id = bc.country_id
inner join smallable2_datawarehouse.b_order_products bop 
on
	aa.sku = bop.sku_code
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
	and bop.sml_team = 'mode'
group by
	zone,
	univers
order by
	Nb desc 


select
	bc2.country_name as zone, 
				count(distinct aa.id) as Nb,
	bop.sml_team as univers
from
	smallable2_datawarehouse.b_customers bc
inner join smallable2_front.availability_alert aa 
on
	aa.email = bc.email
inner join smallable2_datawarehouse.b_countries bc2 
on
	bc2.country_id = bc.country_id
inner join smallable2_datawarehouse.b_order_products bop 
on
	aa.sku = bop.sku_code
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
	and bop.sml_team = 'design'
group by
	zone,
	univers
order by
	Nb desc

------------------------------------------------------ D�tails skus (mode) pour Allemagne, Pays-Bas et Cor�e du Sud ---------------------------------------------
select
	--distinct aa.sku as Skus,
	bp.product_name as Produits,
	bp.brand_name as Marques,
	count(distinct aa.id) as Nb
from
	smallable2_datawarehouse.b_customers bc
left join smallable2_front.availability_alert aa 
on
	aa.email = bc.email
left join smallable2_datawarehouse.b_countries bc2 
on
	bc2.country_id = bc.country_id
left join smallable2_datawarehouse.b_order_products bop 
on
	aa.sku = bop.sku_code
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
	and bop.sml_team = 'mode'
	and bc2.country_name ilike 'Allemagne%' --'Pays-Bas%' --'Cor�e du Sud'
group by
	--Skus,
	Produits,
	Marques
order by
	Nb desc

-----------------------------------------------------------------------Top mail -------------------------------------------------------------------

select
	bc.country_name as Zone,
	count(bc.regroup_zone) as Nb_mail
from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
left join smallable2_datawarehouse.b_customers bc2 
on
	bc2.email = aa.email
left join smallable2_datawarehouse.b_countries bc 
on
	bc.country_id = bc2.country_id
where
	aa.done = 1
	and aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	Zone
order by
	Nb_mail desc

------------------------------------------------------------------------Top commandes ----------------------------------------------------------------

WITH orders AS (
SELECT
	bo.order_id AS oid,
	bc.email AS email,
	bop.sku_code AS sku,
	bo.created_at AS c_at,
	bop.billing_product_ht AS billing,
	bc2.country_name AS z
	--,
	-- bc2.country_name as iso
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bop.order_id = bo.order_id
	AND bop.basket_id = bo.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_customers bc
ON
	bc.customer_id = bo.customer_id
INNER JOIN smallable2_datawarehouse.b_countries bc2 ON
	bc2.country_id = bo.delivery_country_id
INNER JOIN smallable2_datawarehouse.b_country_zone bcz ON
	bc2.country_iso_code = bcz.country_iso_code )
SELECT
	e.z,
	count(DISTINCT e.id) AS nombr
FROM
	(
	SELECT
		aa.id,
		o.billing,
		o.z,
		CASE
			WHEN o.sku = aa.sku THEN 1
			ELSE 0
		END AS purchased_product,
		date(aa.updated) AS reception_email,
		o.c_at AS commande
	FROM
		smallable2_front.availability_alert aa
	LEFT JOIN orders o ON
		o.email = aa.email
	WHERE
		aa.done = 1
		AND aa.created > '2021-01-01'
		AND aa.created < '2021-12-31'
		AND o.c_at > aa.created) e
WHERE
	e.purchased_product = 1
GROUP BY
	e.z
ORDER BY
	nombre DESC

-----------------------------------------------------------Top commandes global site----------------------------------------------------------------

select
	bc.country_name as Zone,
	count(bc.regroup_zone) as Nb_cmd_globalsite
from
	smallable2_datawarehouse.b_orders bo
left join smallable2_datawarehouse.b_customers bc2 
on
	bc2.customer_id = bo.customer_id
left join smallable2_datawarehouse.b_countries bc 
on
	bc.country_id = bc2.country_id
group by
	Zone
order by
	Nb_cmd_globalsite desc
	
	
---------------------------------------------------------------------ZONE--------------------------------------------------------------------------------
-------------------------------------------------------------------Top alertes -------------------------------------------------------------------------
select
	bc2.zone_code as zone,  
				count(aa.id) as Nb
from
	smallable2_datawarehouse.b_customers bc
inner join smallable2_front.availability_alert aa 
on
	aa.email = bc.email
inner join smallable2_datawarehouse.b_countries bc2 
on
	bc2.country_id = bc.country_id
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	zone
order by
	Nb desc

--------------------------------------------------------------------Top alertes/univers -------------------------------------------------------------------
select
	bc2.zone_code as zone, 
				count(distinct aa.id) as Nb,
	bop.sml_team as univers
from
	smallable2_datawarehouse.b_customers bc
inner join smallable2_front.availability_alert aa 
on
	aa.email = bc.email
inner join smallable2_datawarehouse.b_countries bc2 
on
	bc2.country_id = bc.country_id
inner join smallable2_datawarehouse.b_order_products bop 
on
	aa.sku = bop.sku_code
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
	and bop.sml_team = 'mode'
group by
	zone,
	univers
order by
	Nb desc 


select
	bc2.zone_code as zone, 
				count(distinct aa.id) as Nb,
	bop.sml_team as univers
from
	smallable2_datawarehouse.b_customers bc
inner join smallable2_front.availability_alert aa 
on
	aa.email = bc.email
inner join smallable2_datawarehouse.b_countries bc2 
on
	bc2.country_id = bc.country_id
inner join smallable2_datawarehouse.b_order_products bop 
on
	aa.sku = bop.sku_code
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
	and bop.sml_team = 'design'
group by
	zone,
	univers
order by
	Nb desc

--------------------------------------------------------------------------Top mail -------------------------------------------------------------------

select
	bc.zone_code as Zone,
	count(bc.regroup_zone) as Nb_mail
from
	smallable2_front.availability_alert aa
left join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
left join smallable2_datawarehouse.b_customers bc2 
on
	bc2.email = aa.email
left join smallable2_datawarehouse.b_countries bc 
on
	bc.country_id = bc2.country_id
where
	aa.done = 1
	and aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	Zone
order by
	Nb_mail desc


WITH orders AS (
SELECT
	bc.email AS email,
	bc2.zone_code AS z
from
	smallable2_datawarehouse.b_customers bc
INNER JOIN smallable2_datawarehouse.b_countries bc2 ON
	bc2.country_id = bc.country_id
INNER JOIN smallable2_datawarehouse.b_country_zone bcz ON
	bc2.country_iso_code = bcz.country_iso_code )
SELECT
	e.z,
	count(DISTINCT e.id) AS nombre,
	avg(e.mail-e.alert) AS moyenne,
	stddevPop(e.mail-e.alert) AS etype
FROM
	(
	SELECT
		aa.id,
		o.z,
		date(aa.created) AS alert,
		date(aa.updated) AS mail
	FROM
		smallable2_front.availability_alert aa
	LEFT JOIN orders o ON
		o.email = aa.email
	WHERE
		aa.done = 1
		AND aa.created > '2021-01-01'
		AND aa.created < '2021-12-31'
		AND aa.updated > aa.created) e
GROUP BY
	e.z
ORDER BY
	nombre DESC

-------------------------------------------------------------------------Top commandes ----------------------------------------------------------------------

WITH orders AS (
SELECT
	bo.order_id AS oid,
	bc.email AS email,
	bop.sku_code AS sku,
	bo.created_at AS c_at,
	bop.billing_product_ht AS billing,
	bc2.zone_code AS z
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bop.order_id = bo.order_id
	AND bop.basket_id = bo.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_customers bc
ON
	bc.customer_id = bo.customer_id
INNER JOIN smallable2_datawarehouse.b_countries bc2 ON
	bc2.country_id = bo.delivery_country_id
INNER JOIN smallable2_datawarehouse.b_country_zone bcz ON
	bc2.country_iso_code = bcz.country_iso_code )
SELECT
	e.z,
	count(DISTINCT e.id) AS nombre,
	avg(e.commande-e.reception_email) AS moyenne,
	stddevPop(e.commande-e.reception_email) AS etype
FROM
	(
	SELECT
		aa.id,
		o.billing,
		o.z,
		CASE
			WHEN o.sku = aa.sku THEN 1
			ELSE 0
		END AS purchased_product,
		date(aa.updated) AS reception_email,
		o.c_at AS commande
	FROM
		smallable2_front.availability_alert aa
	LEFT JOIN orders o ON
		o.email = aa.email
	WHERE
		aa.done = 1
		AND aa.created > '2021-01-01'
		AND aa.created < '2021-12-31'
		AND o.c_at > aa.created) e
WHERE
	e.purchased_product = 1
GROUP BY
	e.z
ORDER BY
	nombre DESC

----------------------------------------------------------------------Top commandes global site------------------------------------------------------------------

select
	bc.zone_code as Zone,
	count(bc.regroup_zone) as Nb_cmd_globalsite
from
	smallable2_datawarehouse.b_orders bo
left join smallable2_datawarehouse.b_customers bc2 
on
	bc2.customer_id = bo.customer_id
left join smallable2_datawarehouse.b_countries bc 
on
	bc.country_id = bc2.country_id
group by
	Zone
order by
	Nb_cmd_globalsite desc
	

------------------------------TOP 150 PRODUITS ALERTES  Mode vs Design -----------------------------------------------------
-------------------------------------------- Mode / MARQUES ----------------------------------------------------------------------------------------
select 
	bp.brand_name as Marques,
				count(aa.id) as Nb
from
	smallable2_datawarehouse.b_customers bc
inner join smallable2_front.availability_alert aa 
on
	aa.email = bc.email
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
AND bp.sml_team = 'mode'
where 
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	 Marques
order by
	Nb desc

	
select 
	bp.brand_name as Marques,
				count(aa.id) as Nb
from
	smallable2_datawarehouse.b_customers bc
inner join smallable2_front.availability_alert aa 
on
	aa.email = bc.email
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where aa.done = 1
	and bp.sml_team = 'mode'
	and aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	 Marques
order by
	Nb desc	
	
	
WITH orders AS (
SELECT
    bo.order_id AS oid,
    bc.email AS email,
    bop.sku_code AS sku,
    bo.created_at AS c_at,
    bp.brand_name as z,
    bop.billing_product_ht AS billing,
    bcz.country_iso_code  
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
    bop.order_id = bo.order_id
    AND bop.basket_id = bo.basket_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_customers bc
ON
    bc.customer_id = bo.customer_id
INNER JOIN smallable2_datawarehouse.b_countries bc2 ON
    bc2.country_id = bo.delivery_country_id
INNER JOIN smallable2_datawarehouse.b_country_zone bcz ON
    bc2.country_iso_code = bcz.country_iso_code 
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code 
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id 
	AND bp.sml_team = 'mode'
)
SELECT
    e.z, 
    count(DISTINCT e.id) AS nombre
FROM
    (
    SELECT
        aa.id,
        o.billing,
        o.z,
        CASE
            WHEN o.sku = aa.sku THEN 1
            ELSE 0
        END AS purchased_product,
        date(aa.updated) AS reception_email,
        o.c_at AS commande
    FROM
        smallable2_front.availability_alert aa
    LEFT JOIN orders o ON
        o.email = aa.email
    WHERE
        aa.done = 1
        AND aa.created > '2021-01-01'
        AND aa.created < '2021-12-31'
        AND o.c_at > aa.created) e
WHERE
    e.purchased_product = 1
GROUP BY
    e.z
ORDER BY nombre DESC

-------------------------------------------- Design / MARQUES ----------------------------------------------------------------------------------------
select 
	bp.brand_name as Marques,
				count(aa.id) as Nb
from
	smallable2_datawarehouse.b_customers bc
inner join smallable2_front.availability_alert aa 
on
	aa.email = bc.email
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where bp.sml_team = 'design'
	and aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	 Marques
order by
	Nb desc

	
select 
	bp.brand_name as Marques,
				count(aa.id) as Nb
from
	smallable2_datawarehouse.b_customers bc
inner join smallable2_front.availability_alert aa 
on
	aa.email = bc.email
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where aa.done = 1
	and bp.sml_team = 'design'
	and aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	 Marques
order by
	Nb desc	
	
	
WITH orders AS (
SELECT
    bo.order_id AS oid,
    bc.email AS email,
    bop.sku_code AS sku,
    bo.created_at AS c_at,
    bp.brand_name as z,
    bop.billing_product_ht AS billing,
    bcz.country_iso_code  
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
    bop.order_id = bo.order_id
    AND bop.basket_id = bo.basket_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_customers bc
ON
    bc.customer_id = bo.customer_id
INNER JOIN smallable2_datawarehouse.b_countries bc2 ON
    bc2.country_id = bo.delivery_country_id
INNER JOIN smallable2_datawarehouse.b_country_zone bcz ON
    bc2.country_iso_code = bcz.country_iso_code 
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code 
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id 
	AND bp.sml_team = 'design'
)
SELECT
    e.z, 
    count(DISTINCT e.id) AS nombre
FROM
    (
    SELECT
        aa.id,
        o.billing,
        o.z,
        CASE
            WHEN o.sku = aa.sku THEN 1
            ELSE 0
        END AS purchased_product,
        date(aa.updated) AS reception_email,
        o.c_at AS commande
    FROM
        smallable2_front.availability_alert aa
    LEFT JOIN orders o ON
        o.email = aa.email
    WHERE
        aa.done = 1
        AND aa.created > '2021-01-01'
        AND aa.created < '2021-12-31'
        AND o.c_at > aa.created) e
WHERE
    e.purchased_product = 1
GROUP BY
    e.z
ORDER BY nombre DESC
		
---------------------------------- Top produits -------------------------------------------------------------
select bp.product_id as p,
	bp.product_name as Nom_produit,
	bp.brand_name as Marques,
				count(aa.id) as Nb
from
	smallable2_datawarehouse.b_customers bc
inner join smallable2_front.availability_alert aa 
on
	aa.email = bc.email
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	Nom_produit, Marques, p
order by
	Nb desc

-----------------------------FAIRE UNE CORRECTION ----------------------------------------
		
select bp.product_id as p,
	bp.product_name as Nom_produit,
	bp.brand_name as Marques,
				count(aa.id) as Nb
from smallable2_front.availability_alert aa 
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	Nom_produit, Marques, p
order by
	Nb desc
	
	____________________________________________________________________________________________________________________
	
select
	bp.product_name as Nom_produit,  
	bp.brand_name  as Marques,
				count(aa.id) as Nb
from
	smallable2_datawarehouse.b_customers bc
inner join smallable2_front.availability_alert aa 
on
	aa.email = bc.email
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = aa.sku
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id 
where aa.done = 0
	and aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
group by
	Nom_produit, Marques
order by
	Nb desc
	
WITH orders AS (
SELECT
    bo.order_id AS oid,
    bc.email AS email,
    bop.sku_code AS sku,
    bo.created_at AS c_at,
    bp.product_name as z,
	bp.brand_name as Marques,
    bop.billing_product_ht AS billing,
    bcz.country_iso_code  
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
    bop.order_id = bo.order_id
    AND bop.basket_id = bo.basket_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_customers bc
ON
    bc.customer_id = bo.customer_id
INNER JOIN smallable2_datawarehouse.b_countries bc2 ON
    bc2.country_id = bo.delivery_country_id
INNER JOIN smallable2_datawarehouse.b_country_zone bcz ON
    bc2.country_iso_code = bcz.country_iso_code 
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code 
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id )
SELECT
    e.z, e.Marques,
    count(DISTINCT e.id) AS nombre
FROM
    (
    SELECT
        aa.id,
        o.billing,
        o.Marques,
        o.z,
        CASE
            WHEN o.sku = aa.sku THEN 1
            ELSE 0
        END AS purchased_product,
        date(aa.updated) AS reception_email,
        o.c_at AS commande
    FROM
        smallable2_front.availability_alert aa
    LEFT JOIN orders o ON
        o.email = aa.email
    WHERE
        aa.done = 
        AND aa.created > '2021-01-01'
        AND aa.created < '2021-12-31'
        AND o.c_at > aa.created) e
WHERE
    e.purchased_product = 1
GROUP BY
    e.z,e.Marques
ORDER BY nombre DESC


------------------------------------------ VENTILATION D�lais Mail-Cmd (Semaine) ----------------------------------------------
With orders as (
select
	bo.order_id as oid,
	bc.email as email,
	bop.sku_code as sku,
	bo.created_at as c_at
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
inner join smallable2_datawarehouse.b_customers bc
on
	bc.customer_id = bo.customer_id)
select
	case
		when e.delais < 7 then '-7j'
		when e.delais < 30 then '-30j'
		else '+30j'
	end as groupe_delais,
	count(e.id) as nb
from 
	(
	select
		aa.id,
		case
			when o.sku = aa.sku then 1
			else 0
		end as purchased_product,
		date(aa.updated) as reception_email,
		o.c_at as commande,
		o.c_at-date(aa.updated) as delais
	from
		smallable2_front.availability_alert aa
	left join orders o on
		o.email = aa.email
	where
		aa.done = 1
		and aa.created > '2021-01-01'
		and aa.created < '2021-12-31'
		and o.c_at > aa.updated) e
where
	e.purchased_product = 1
group by
	groupe_delais