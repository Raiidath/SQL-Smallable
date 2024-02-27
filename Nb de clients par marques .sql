select
	distinct bo.customer_id as clients_global, concat(bc.lastname, ' ', bc.firstname), bc.email as email
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_customers bc 
on bo.customer_id = bc.customer_id 
where
	bp.brand_name IN ('garbo&friends',
'Liewood',
'Konges Sløjd',
'1+ in the family',
'Petit Bateau',
'Nobodinoz',
'Búho',
'Louise Misha',
'Emile et Ida',
'Quincy Mae',
'Tartine et Chocolat',
'Poudre Organic',
'Cam Cam',
'Gray Label',
'Smallable',
'Numero 74',
'Studio Bohème',
'FUB',
'Gabrielle Paris',
'SMALLABLE BASICS'
)
and bo.created_at >= '2023-11-01'
	and bo.created_at <= '2024-02-05' 
	--and bp.sml_team = 'design
and	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	
	
	
	
SELECT
	DISTINCT bop.order_id AS commande,
	bop.nb_produits_vendus_net AS nb_produits, toDate(bo.validated) AS date,
	concat(bc.lastname,' ',bc.firstname) AS nom,
	bc.email AS email
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bop.order_id = bo.order_id
INNER JOIN smallable2_datawarehouse.b_products bp 
ON
	bp.product_id = bop.product_id
INNER JOIN smallable2_datawarehouse.b_customers bc 
ON
	bo.customer_id = bc.customer_id
WHERE
	bop.sku_code IN ('AAA0973853', 'AAA0669225',  'AAA0596257')
	AND
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND commande IS NOT NULL 

	
	
	
	
SELECT * FROM smallable2_datawarehouse.b_orders bo 	
	
	
select
	distinct CASE WHEN bop.sku_code like 'AAA0835489' THEN bop.order_id ELSE NULL END as commande, bop.nb_produits_vendus_net  
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
WHERE
	bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
AND commande IS NOT NULL 
	
	
	

and bo.created_at >= '2023-08-01'
	and bo.created_at <= '2023-11-08' 
	--and bp.sml_team = 'design	
	
	
	
	
	
	 AAA0835489
	
	
	
	
select distinct bb.brand_name, brand_id, bp.sml_team  from smallable2_datawarehouse.b_brands bb 
inner join smallable2_datawarehouse.b_products bp 
on bp.brand_name = bb.brand_name 
where bp.brand_name ilike 'young soles%'
	


select
	distinct bo.customer_id as clients_global, concat(bc.lastname, ' ', bc.firstname), bc.email as email
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
--inner join smallable2_datawarehouse.b_products bp 
--on
--	bp.product_id = bop.product_id
	--AND bp.persons IN ('child', 'teenager')
inner join smallable2_datawarehouse.b_customers bc 
on bo.customer_id = bc.customer_id 
INNER JOIN smallable2_datawarehouse.b_skus s
ON bop.sku_code = s.sku_code
where
    bo.created_at >= '2013-12-06'
	and bo.created_at <= '2023-12-06' 
	--and bp.sml_team = 'mode'
	--AND s.cible IN ('femme')   --'Enfant', 'Adolescent')

SELECT DISTINCT bp.persons 
FROM  smallable2_datawarehouse.b_products bp 
WHERE bp.persons IN ('child', 'teenager')

--Stella Mckarteney------------------------ KPIs sur les clients ayant re�u la campagn et ayant command� ensuite------------------------	
with clients as (
select
	distinct bo.customer_id as clients_global,
	concat(bc.lastname,' ',bc.firstname),
	bc.email as email
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bo.customer_id = bc.customer_id
where
	bp.brand_name in ('Stella McCartney Kids','Bobo Choses','Finger in the Nose','Hundred Pieces','The Animals Observatory','Bellerose','Mini Rodini','Rylee + Cru','Scotch & Soda','Piupiuchick')
	and bo.created_at >= '2022-11-15'
	and bo.created_at <= '2023-03-15')
select 	
	sum(bop.billing_product_ht/100) AS CA,
	count(DISTINCT bo.order_id) AS Cmd,
	CA/Cmd as PM,	
	sum(bop.qty_ordered) as N_produits,
	N_produits/Cmd as N_ProduitsMoyen
from smallable2_datawarehouse.b_orders bo 
inner join smallable2_datawarehouse.b_order_products bop 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bc.customer_id = bo.customer_id
inner join smallable2_datawarehouse.b_traffic bt 
on bt.traffic_id = bo.traffic_id 
	and bt.Vis_date >= '2023-03-24' 
	and bt.Vis_date <= '2023-04-13'
where bt.campaign  ilike 'STELLAMCK%'
 	and bc.email in (select email from clients)


select *
from smallable2_datawarehouse.b_traffic bt 
 	
 select bt.campaign 
 from smallable2_datawarehouse.b_traffic bt 
 where bt.Vis_date = '2023-03-24'
 and bt.campaign ilike '%stellamck%' 	

select 	
	sum(bop.billing_product_ht/100) AS CA,
	count(DISTINCT bo.order_id) AS Cmd,
	CA/Cmd as PM,	
	sum(bop.qty_ordered) as N_produits,
	N_produits/Cmd as N_ProduitsMoyen
from smallable2_datawarehouse.b_orders bo 
inner join smallable2_datawarehouse.b_order_products bop 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	and bo.created_at >= '2023-03-24' and bo.created_at <= '2023-04-13'
inner join smallable2_datawarehouse.b_traffic bt 
on bt.traffic_id = bo.traffic_id 
where bt.campaign ilike '%stellamck%'
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1



--Petit Nord--------------------- KPIs sur les clients ayant re�u la campagn et ayant command� ensuitz------------------------	
with clients as (
select
	distinct bo.customer_id as clients_global,
	concat(bc.lastname,' ',bc.firstname),
	bc.email as email
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bo.customer_id = bc.customer_id
where
	bp.brand_name in ('Petit Nord','Angulus','P�p�','Donsje','Young Soles','Coll�gien','Liewood','Babywalker','Ten Is')
	--and bp.brand.id = ('219')
	and bo.created_at >= '2022-11-15' 
	and bo.created_at <= '2023-03-15')
select 	
	sum(bop.billing_product_ht/100) AS CA,
	count(DISTINCT bo.order_id) AS Cmd,
	CA/Cmd as PM,	
	sum(bop.qty_ordered) as N_produits,
	N_produits/Cmd as N_ProduitsMoyen
from smallable2_datawarehouse.b_orders bo 
inner join smallable2_datawarehouse.b_order_products bop 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bc.customer_id = bo.customer_id
inner join smallable2_datawarehouse.b_traffic bt 
on bt.traffic_id = bo.traffic_id 
	and bt.Vis_date  >= '2023-03-28' 
	and bt.Vis_date <= '2023-04-17'
where bt.campaign ilike 'BRAND_PETITNORD%'
 	and bc.email in (select email from clients)
 	
 	
 	
 select bt.campaign 
 from smallable2_datawarehouse.b_traffic bt 
 where bt.Vis_date = '2023-03-28'
 and bt.campaign ilike '%PetitNord%'

 
 select 	
	sum(bop.billing_product_ht/100) AS CA,
	count(DISTINCT bo.order_id) AS Cmd,
	CA/Cmd as PM,	
	sum(bop.qty_ordered) as N_produits,
	N_produits/Cmd as N_ProduitsMoyen
from smallable2_datawarehouse.b_orders bo 
inner join smallable2_datawarehouse.b_order_products bop 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	and bo.created_at  >= '2023-03-28' and bo.created_at <= '2023-04-17'
inner join smallable2_datawarehouse.b_traffic bt 
on	bo.traffic_id = bt.traffic_id
where bt.campaign in (select bt.campaign
					  from smallable2_datawarehouse.b_traffic bt 
  					  where bt.campaign ilike 'BRAND_petitnord%')
