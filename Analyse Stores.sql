
Filtres pour trouver clients de r�gion parisienne :

FROM smallable2_front.customer_order_address coa
WHERE
       coa.country_id = 7
       AND LEFT(trim(coa.postcode), 2) IN ('75', '77', '78', '91', '92', '93', '94', '95')


Si tu veux Paris seulement c�est juste 75, et � petite couronne � c�est � 75, 92, 93, 94 �

Family store = partner = shop 1 = 7
Woman store = partner = shop 2 = 8


select *
FROM smallable2_front.partner p 

select bo.first_order_vs_repeat 
FROM smallable2_datawarehouse.b_orders bo 

-------------------------------------------------- store = 7+8 ------------------------------------
select
	count(distinct bo.customer_id) as clients,
	count(distinct case when bo.first_order_vs_repeat = 'R�achat' then bo.customer_id else null end) as repeat,
	repeat * 100 / clients as Pourcent_repeat,
	count(distinct case when bo.first_order_vs_repeat = '1�re Commande' then bo.customer_id else null end) as nv_client,
	nv_client * 100 / clients as Pourcent_nv
from
	smallable2_datawarehouse.b_orders bo
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.partner_id in ('8')
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1


select	
	count(distinct bo.order_id) as Commandes,
	count(distinct bo.customer_id) as Nb_clients,
	Commandes / Nb_clients as Frequence,
	sum(bo.billing_product_ht)/ 100 as CA
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('7', '8')
	and bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.first_order_vs_repeat = 'R�achat'
	--'1�re Commande'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1


With c as (
select
	*
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('7', '8')
	and bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.first_order_vs_repeat = '1�re Commande'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1)
select
	count(distinct c.customer_id),
	sum(c.billing_product_ht)/ 100 as CA
from
	c
inner join smallable2_datawarehouse.b_orders bo2
on
	bo2.customer_id = c.customer_id
	and bo2.is_valid = 1
	and bo2.is_ca_ht_not_zero = 1
where
	bo2.first_order_vs_repeat = 'R�achat'
	and bo2.partner_id in ('7', '8')
	-- Not in
	and bo2.created_at >= '2021-09-01'
	and bo2.created_at <= '2022-12-31'
	
		
---------------- Analyse comportement clients -------------------------------------------
	
With c_boutique as (
select
	*
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('7', '8')
	and bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	),
c_web as (
select
	*
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id not in ('7', '8')
		and bo.created_at >= '2021-09-01'
		and bo.created_at <= '2022-12-31'
		and bo.is_valid = 1
		and bo.is_ca_ht_not_zero = 1)
select
	count(distinct c_boutique.customer_id)as cmd
from
	c_boutique
inner join smallable2_datawarehouse.b_orders bo2
on
	bo2.customer_id = c_boutique.customer_id
	and bo2.is_valid = 1
	and bo2.is_ca_ht_not_zero = 1
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo2.order_id
	and bop.basket_id = bo2.basket_id
where
	bo2.customer_id in (
	select
		c_web.customer_id
	from
		c_web)
	and bo2.partner_id in ('7', '8')
	--NOT IN
	

---------------------------- nv client Stores/ Woman only ( in '8') => repeat ---------------------------
With c_web as (
select
	*
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id not in ('7', '8')
	and bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.first_order_vs_repeat = '1�re Commande'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1)
select
	count(distinct c_web.customer_id),
	sum(c_web.billing_product_ht)/ 100 as CA
from
	c_web
inner join smallable2_datawarehouse.b_orders bo2
on
	bo2.customer_id = c_web.customer_id
	and bo2.is_valid = 1
	and bo2.is_ca_ht_not_zero = 1
where
	bo2.first_order_vs_repeat = 'R�achat'
	and bo2.partner_id in ('7', '8')
	-- Not in
	and bo2.created_at >= '2021-09-01'
	and bo2.created_at <= '2022-12-31'


----------------------------------------WOMAN Store = 8 ---------------------------------------------
select
	count(distinct case when bo.first_order_vs_repeat = 'R�achat' then bo.customer_id else null end) as repeat,
	repeat * 100 / cmd as Pourcent_repeat,
	count(distinct case when bo.first_order_vs_repeat = '1�re Commande' then bo.customer_id else null end) as nv_client,
	nv_client * 100 / cmd as Pourcent_nv,
	count(distinct bo.customer_id) as cmd
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('8')
	and bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1

	
	
------------------------------------- % d�j� client Smallable (Family ? web / web mode femme ?  mixte Family / Web)-----------------------

With c_concept as (
select
	*,
	bo.created_at AS cat
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('7')
	and bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1),
c_web as (
select
	*,
	bo.created_at AS cat
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id not in ('7', '8')
		and bo.created_at >= '2021-09-01'
		and bo.created_at <= '2022-12-31'
		and bo.is_valid = 1
		and bo.is_ca_ht_not_zero = 1),
c_woman as (
select
	*,
	bo.created_at AS cat
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('8')
		and bo.created_at >= '2021-09-01'
		and bo.created_at <= '2022-12-31'
		and bo.is_valid = 1
		and bo.is_ca_ht_not_zero = 1)
select
	distinct c_woman.customer_id, 
	case
		when min(c_woman.cat) > min(c_web.cat) then 'client web first'
	end as web_first
from  
	c_woman
inner join smallable2_datawarehouse.b_orders bo
on 
	bo.customer_id = c_woman.bo.customer_id
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
left join c_web 
on 
	c_web.bo.customer_id = bo.customer_id
where
	bo.customer_id in (
	select
		c_web.customer_id
	from
		c_web)
GROUP BY
	c_woman.customer_id

---------------------------------------Fr�quence d�achat--------------------------------------------------------
select
	distinct bo.customer_id,
	count(bo.first_order_vs_repeat) as nb,
	case
		when nb = 1 then 'One shot'
		when nb < 20 then 'repeater'
		else 'Clients recurents'
	end as Frequence_achat
from
	smallable2_datawarehouse.b_orders bo
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
group by
	bo.customer_id 


with c as (
select
	distinct bo.customer_id,
	count(bo.order_id) as nb,
	case
		when nb = 1 then 'One shot'
		when nb > 5 then 'repeater'
		else 'Recurents'
	end as Frequence_achat
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('8', '7')
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
group by
	bo.customer_id)
select
	count(case when c.Frequence_achat = 'One shot' then c.customer_id else null end) as one_shot,
	count(case when c.Frequence_achat = 'One shot' then c.customer_id else null end)/ count(distinct customer_id) as Pourcent_oneshot,
	count(case when c.Frequence_achat = 'repeater' then c.customer_id else null end) as repeaters,
	count(case when c.Frequence_achat = 'repeater' then c.customer_id else null end)/ count(distinct customer_id) as Pourcent_repeaters,
	count(case when c.Frequence_achat = 'Recurents' then c.customer_id else null end) as Recurents,
	count(case when c.Frequence_achat = 'Recurents' then c.customer_id else null end)/ count(distinct customer_id) as Pourcent_recurents
from
	c

------------------------------- Fr�quence d'achat R�gion parisienne ---------------------------------------------
with c as (
select
	distinct bo.customer_id as id,
	count(bo.order_id) as nb,
	case
		when nb = 1 then 'One shot'
		when nb < 5 then 'repeater'
		else 'Recurents'
	end as Frequence_achat
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
and bo.partner_id in ('8', '7')
and bo.is_valid = 1
and bo.is_ca_ht_not_zero = 1
inner join smallable2_front.customer_order_address coa
on
	coa.id = bo.delivery_address_id
	and coa.country_id = 7
where
	bo.created_at >= '2021-09-01' 
	and bo.created_at <= '2022-12-31'
	and left(trim(coa.postcode), 2) IN ('75', '77', '78', '91', '92', '93', '94', '95')
group by
	id)
select
count(case when c.Frequence_achat = 'One shot' then c.id else null end) as one_shot,
	count(case when c.Frequence_achat = 'One shot' then c.id else null end)/count(distinct id) as Pourcent_oneshot,
	count(case when c.Frequence_achat = 'repeater' then c.id else null end) as repeaters,
	count(case when c.Frequence_achat = 'repeater' then c.id else null end)/count(distinct id) as Pourcent_repeaters,
	count(case when c.Frequence_achat = 'Recurents' then c.id else null end) as Recurents,
	count(case when c.Frequence_achat = 'Recurents' then c.id else null end)/count(distinct id) as Pourcent_recurents
from
	c
	
SELECT * from	
smallable2_front.customer_order_address coa
	
------------------- Localisation des clients  ----------------------------------------------------------------
select *
from smallable2_front.customer_order_address coa
where coa.country_id = 7
	--AND LEFT(trim(coa.postcode), 2) IN ('75', '77', '78', '91', '92', '93', '94', '95')
	

--------------------------------------- Top Arrondissement ---------------------------------------

select
	distinct coa.postcode as Arrondissement,
	count(distinct bo.customer_id) as Nb
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_order_address coa
on
	coa.id = bo.delivery_address_id
	and coa.country_id = 7
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('7', '8')
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and left(trim(coa.postcode),
	2) IN ('75')
group by
	Arrondissement
Order by
	Nb desc


------------------------------- Top Departement -----------------------------
select
	left(trim(coa.postcode),2) as Departement,
	count(distinct bo.customer_id) as Nb--, 
	--Nb/sum(Nb) as Pourcent
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_order_address coa
on
	coa.id = bo.delivery_address_id
	and coa.country_id = 7
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('8')
where
	bo.created_at >= '2021-09-01' 
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
group by
	Departement
Order by
	Nb desc
	
-------------------------------- Rive droite vs Rive Gauche ------------------------------------
select
	case
		when coa.postcode in ('75001',
		'75002',
		'75003',
		'75004',
		'75008',
		'75009',
		'75010',
		'75011',
		'75012',
		'750016',
		'75017',
		'75018',
		'75019',
		'75020') then 'Rive_droite'
		when coa.postcode not in ('75001',
		'75002',
		'75003',
		'75004',
		'75008',
		'75009',
		'75010',
		'75011',
		'75012',
		'750016',
		'75017',
		'75018',
		'75019',
		'75020') then 'Rive_gauche'
		else 'Rive_g'
	end as Rive,
	count(distinct bo.customer_id) as Nb_clients
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_order_address coa
on
	coa.id = bo.delivery_address_id
	and coa.country_id = 7
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('8')
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and left(trim(coa.postcode),
	2) IN ('75')
group by
	Rive
	
	
select
	case
		when coa.postcode in ('75001', '75002', '75003', '75004', '75008', '75009', '75010', '75011', '75012', '750016', '75017', '75018', '75019', '75020') then 'Rive_droite'
		else 'Rive_gauche'
	end as Rive,
	count(distinct bo.customer_id) as id
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_order_address coa
on
	coa.id = bo.delivery_address_id
	and coa.country_id = 7
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('8', '7')
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and left(trim(coa.postcode),
	2) IN ('75')
group by
	Rive
	
--------------------------------------P�rim�tre : identifier le % de pays / ville non renseign�------------------
select
	case
		when coa.postcode is null then 'ville non dispo'
		else 'ville dispo'
	end as ville,
	count(distinct bo.customer_id) as Nb_clients
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('8', '7')
left join smallable2_front.customer_order_address coa -- left join 
on
	coa.id = bo.delivery_address_id
	and coa.country_id = 7
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
group by
	ville

select count(distinct bo.customer_id) as Nb_clients
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_order_address coa
on
	coa.id = bo.delivery_address_id
	and coa.country_id = 7
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('8', '7')
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and coa.postcode is not null
	
------------------------------------------ Analyse comportement clients - WOMAN STORE------------------------------------------------------------	
select
	distinct bp.brand_name as Brand,
	count(distinct bo.customer_id) as Nb_clients,
	count(distinct bo.order_id) as Nb_cmd,
	round(count(distinct bo.order_id)/ count(distinct bo.customer_id), 2) as recurrence
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
inner join smallable2_datawarehouse.b_products bp 
on
	bop.product_id = bp.product_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bo.customer_id = bc.customer_id
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.partner_id in ('8')
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bc.email NOT LIKE '%boutique%@smallable.com%'
group by
	Brand
order by
	Nb_clients desc	
	
select
	distinct bp.sml_team  as secteur,
	count(distinct bo.customer_id) as Nb_clients,
	count(distinct bo.order_id) as Nb_cmd,
	round(count(distinct bo.order_id)/ count(distinct bo.customer_id), 2) as recurrence
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
inner join smallable2_datawarehouse.b_products bp 
on
	bop.product_id = bp.product_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bo.customer_id = bc.customer_id
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.partner_id in ('8')
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bc.email NOT LIKE '%boutique%@smallable.com%'
group by
	secteur
order by
	Nb_clients desc	
	
	
select
	distinct bs.personne  as person,
	count(distinct bo.customer_id) as Nb_clients,
	count(distinct bo.order_id) as Nb_cmd,
	round(count(distinct bo.order_id)/ count(distinct bo.customer_id), 2) as recurrence
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.product_id = bs.product_id 
inner join smallable2_datawarehouse.b_customers bc 
on
	bo.customer_id = bc.customer_id
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.partner_id in ('8')
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bc.email NOT LIKE '%boutique%@smallable.com%'
group by
	person
order by
	Nb_clients desc	
	

select distinct bp.gender  as Gender,
	count(distinct bo.customer_id) as Nb_clients,
	count(distinct bo.order_id) as Nb_cmd,
	round(count(distinct bo.order_id)/ count(distinct bo.customer_id), 2) as recurrence
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
inner join smallable2_datawarehouse.b_products bp 
on
	bop.product_id = bp.product_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bo.customer_id = bc.customer_id
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.partner_id in ('8')
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bc.email NOT LIKE '%boutique%@smallable.com%'
group by
	Gender
order by
	Nb_clients desc	
	
	
	
select
	distinct bs.univers  as Univers,
	count(distinct bo.customer_id) as Nb_clients,
	count(distinct bo.order_id) as Nb_cmd,
	round(count(distinct bo.order_id)/ count(distinct bo.customer_id), 2) as recurrence
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
inner join smallable2_datawarehouse.b_products bp 
on
	bop.product_id = bp.product_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bo.customer_id = bc.customer_id
inner join smallable2_datawarehouse.b_skus bs 
on bs.product_id = bp.product_id 
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.partner_id in ('8')
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bc.email NOT LIKE '%boutique%@smallable.com%'
group by
	Univers
order by
	Nb_clients desc	


	
select *
from smallable2_front.customer_address ca 

-----------------------------------------Langue----------------------------------------------	
	
select
	count(distinct bo.customer_id  as cid)
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bo.customer_id = bc.customer_id
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.partner_id in ('7', '8')
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bc.email NOT LIKE '%boutique%@smallable.com%'
	

select
	cc.customer_id as clients,
	bc.email as email,
	count(distinct cc.id) as child
from smallable2_datawarehouse.b_customers bc 
inner join	 smallable2_front.customer_child cc 
on
	bc.customer_id = cc.customer_id
where
	bc.email NOT LIKE '%boutique%@smallable.com%'
group by
	clients,
	bc.email
order by
	child desc
	
-------------------------- Age moyen clients et tranches d'�ge ----------------------------------	
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
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.partner_id in ('7', '8')
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
group by
	sexe

	
select *
from smallable2_front.customer_order_address coa 

select
	case
		when (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(c.date_of_birth)))/(86400*365.25) < 20 then 'Jeune'
		when (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(c.date_of_birth)))/(86400*365.25) < 40 then 'Age moyen'
		else 'Age adulte'
	end as Tranche,
	count(distinct c.id) as Nb
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer c 
on
	bo.customer_id = c.id
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.partner_id in ('7', '8')
	and c.date_of_birth is not null
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and c.email NOT LIKE '%boutique%@smallable.com%'
group by Tranche
order by Nb desc


select
	case
		when (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400 * 365.25) < 4 then 'B�b�'
		when (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400 * 365.25) < 12 then 'Enfant'
		when (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400 * 365.25) < 18 then 'Ado'
		else 'Adulte'
	end as Tranche,
	count(distinct cc.id) as Nb
from
	smallable2_front.customer_child cc
group by
	Tranche
order by
	Nb desc
	
	

select
	distinct c.id as Nb, c.email, c.date_of_birth, (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(c.date_of_birth)))/(86400 * 365.25) as age,
	age('unit', c.date_of_birth, now())
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer c 
on
	bo.customer_id = c.id
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.partner_id in ('7', '8')
	and c.date_of_birth is not null
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and c.email NOT LIKE '%boutique%@smallable.com%'
order by age asc



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
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.partner_id in ('7', '8')
	and c.date_of_birth is not null
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and c.email NOT LIKE '%boutique%@smallable.com%'	
	
---------------------------- Age moyen des enfants (dont parents = clients store) -----------
select
	count(distinct cc.id) as Nb_child, Nb_child/count(distinct bc.customer_id) as Nb_child_par_client,
	Round(avg((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400 * 365.25)),
	0) as Moyenne,
	Round(stddevPop((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400 * 365.25)),
	2) as Etype
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_child cc 
on
	cc.customer_id = bo.customer_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bc.customer_id = cc.customer_id
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.partner_id in ('7', '8')
	and cc.date_of_birth is not null
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bc.email NOT LIKE '%boutique%@smallable.com%'
	
	
select
	DISTINCT cc.sex as sexe,
	count(distinct cc.id) as Nb,
	Round(avg((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400 * 365.25)),0) as Moyenne, 
	Round(stddevPop((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(cc.date_of_birth)))/(86400 * 365.25)),1) as Etype
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_child cc 
on
	cc.customer_id = bo.customer_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bc.customer_id = cc.customer_id
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.partner_id in ('7', '8')
	and cc.date_of_birth is not null
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bc.email NOT LIKE '%boutique%@smallable.com%'
group by
	sex
order by
	Nb desc 

--------------------------------- Top Clients -----------------------------		
	
select
	distinct bo.customer_id  as cid, bc.email,
	count(distinct bo.order_id) as Nb_cmd
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bo.customer_id = bc.customer_id
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.partner_id in ('7', '8')
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bc.email NOT LIKE '%boutique%@smallable.com%'
group by
	cid, email
order by
	Nb_cmd desc	
	
------------------- Anciennet� clients boutique --------------
select
	distinct bo.customer_id  as cid, bc.email, bc.first_order_date,
	Round(((toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.first_order_date)))/(86400 * 365.25)),0) as Anciennete
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bo.customer_id = bc.customer_id
where
	bo.created_at >= '2021-09-01'
	and bo.created_at <= '2022-12-31'
	and bo.partner_id in ('7', '8')
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	and bc.email NOT LIKE '%boutique%@smallable.com%'
order by Anciennete desc
	
	
	
---------------------------- Rep commandes par d�partement -----------------
	
select
	left(trim(coa.postcode),2) as Departement,
	count(distinct bo.order_id) as Nb
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_order_address coa
on
	coa.id = bo.delivery_address_id
	and coa.country_id = 7
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('8', '7')
inner join smallable2_datawarehouse.b_customers bc2 
on
	bo.customer_id = bc2.customer_id
where
	bo.created_at >= '2020-08-01' 
	and bo.created_at <= '2021-07-31'
	--bo.created_at >= '2022-08-01' 
	--and bo.created_at <= '2022-12-31'
	and Departement like ('75')
	and bo.is_valid = 1
	and bo.is_ca_net_ht_not_zero  = 1
	and bc2.email LIKE '%boutique%@smallable.com%'
group by
	Departement
Order by
	Nb desc

	
	
select
	left(trim(coa.postcode),2) as Departement,
	count(distinct bo.order_id) as Nb
	--Nb/sum(Nb) as Pourcent
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_order_address coa
on
	coa.id = bo.delivery_address_id
	and coa.country_id = 7
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('8', '7')
where
	bo.created_at >= '2022-08-01' 
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_net_ht_not_zero  = 1
group by
	Departement
Order by
	Nb desc
	
--------------------- Clients �trangers --------------------
select
bc.country_name as pays,
	count(distinct bo.order_id) as Nb_cmd
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_order_address coa
on
	coa.id = bo.delivery_address_id
inner join smallable2_datawarehouse.b_countries bc 
on bc.country_id = coa.country_id 
inner join smallable2_front.partner p 
on
	p.id = bo.partner_id_raw
	and bo.partner_id in ('8', '7')
where
	bo.created_at >= '2020-08-01' 
	and bo.created_at <= '2021-07-31'
	and bo.is_valid = 1
	and bo.is_ca_net_ht_not_zero  = 1
group by
	 pays
Order by
	Nb_cmd desc
