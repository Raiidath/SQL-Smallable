
select 	count(distinct aa.sku)
from
	smallable2_front.availability_alert aa
where
	aa.created > '2021-01-01'
	and aa.created < '2021-12-31'
	--and aa.done = 1

select * from smallable2_front.customer_order_address coa
	
select * from smallable2_front.address_mr am 
	
select * from smallable2_front.customer_voucher cv 

select * from smallable2_datawarehouse.b_stocks bs 

select * from smallable2_datawarehouse.b_desirabilite_produits bdp 



SELECT
	--co.id AS ID_Commande, 
	--bl.sku AS SKU,
	--p2.name AS Libelle,
	--m.id AS ID_Marque, 
	--m.name AS Marques,
	--d.taille_pointure_frs AS Taille,
	sum(bl.total_selling_amount) AS Prix_vente,
	--sum(d.paht) AS Prix_Achat,
	toDate(co.validated) AS Date_Commande
	--coa.firstname AS Prenom,
	--coa.lastname AS Nom,-- coa.street1, coa.city,
	--c2.name AS Pays_destinataire,
	--c.email AS Initiateur_Commande
FROM
	smallable2_front.customer_order co
INNER JOIN smallable2_front.customer c ON
	c.id = co.customer_id
INNER JOIN smallable2_front.basket_line bl ON
	co.basket_id = bl.basket_id
INNER JOIN smallable2_front.customer_order_address coa ON
	co.delivery_address_id = coa.id
INNER JOIN smallable2_descriptor.country c2 ON
	c2.id = coa.country_id
INNER JOIN smallable2_descriptor.declinaison d ON
	d.reference = bl.sku
INNER JOIN smallable2_descriptor.product p ON
	d.id_product = p.id
INNER JOIN smallable2_descriptor.productlang p2 ON
	p2.id_product = p.id
INNER JOIN smallable2_descriptor.manufacturer m ON
	m.id = p.id_manufacturer
WHERE
	Date_Commande  = '2024-02-08'
	--AND Date_Commande  <= toDate(today())
	--AND c.email IN ('l.coello-freeorder@smallable.com',  'c.sanchez-freeorder@smallable.com', 'f.bock-freeorder@smallable.com',  'i.grzimek-freeorder@smallable.com',  'a.rinconmartinez-freeorder@smallable.com',  'z.topic-freeorder@smallable.com')
	AND p2.id_lang = 2
	AND bl.status_id NOT IN ('7', '10')
--ORDER BY Date_Commande ASC
GROUP BY Date_Commande
	

	
		

SELECT toDate(co.validated) AS Date_Commande, sum(bl.total_selling_amount) AS Prix_vente
FROM
	smallable2_front.customer_order co
INNER JOIN smallable2_front.customer c ON
	c.id = co.customer_id
INNER JOIN smallable2_front.basket_line bl ON
	co.basket_id = bl.basket_id	
WHERE Date_Commande = '2024-02-07'
GROUP BY Date_Commande
		
	 
							
							


select *from smallable2_datawarehouse.b_skus bs 
--WHERE bs.categories_N5 = 'Soins et Beauté | maison'

select * from smallable2_datawarehouse.b_order_products bop --billing_shipping_product_ht

select bop.sku_code  from smallable2_datawarehouse.b_order_products bop  where bop.sku_code  like 'SPRING%'

select * from smallable2_front.basket_line bl 

select * from smallable2_front.basket_line_type blt 

select * from smallable2_front.status_type st  



select bb.brand_id, brand_name, bb.origin  from smallable2_datawarehouse.b_brands bb 

select * from smallable2_datawarehouse.b_order_products bop 

select sum(bo.billing_product_ht)/100  from smallable2_datawarehouse.b_orders bo 
WHERE bo.date_commande  = '2024-01-21'

select * from smallable2_datawarehouse.b_countries bc 
where bc.country_iso_code  = 'SE'


select bc.customer_id, bc.email, bc.descriptor_country_name, bc.lastname, bc.firstname  
from smallable2_datawarehouse.b_customers bc 
where --bc.descriptor_country_name   in ('Allemagne', 'Belgique', 'Suisse', 'Pays-Bas', 'Royaume-Uni') 
bc.lastname ILIKE ('Blech')--AND


bc.customer_id  IN ('881801',
'885800',
'887137',
'887334',
'892251')


select bc.descriptor_country_name, bc.nb_commandes_nettes  
from smallable2_datawarehouse.b_customers bc 
where bc.customer_id  IN ('1196380',
'1205072',
'1205610')

SELECT
	bs.product_id AS p,
	sum(CASE WHEN bs.quantity_type_id = 1 then bs.stock_delta ELSE 0 END) -
	sum(CASE WHEN bs.quantity_type_id in (4,5,6) then bs.stock_delta ELSE 0 END) AS stock
FROM
	smallable2_datawarehouse.b_stocks bs
WHERE p in ('294669', '294667')
GROUP BY
	p 


select
	count(distinct bl.sku)
from
	smallable2_front.basket_line bl
	--inner join smallable2_datawarehouse.b_order_products bop  
	--on bl.basket_id = bop.basket_id 
	--and bl.sku = bop.code_promo 
where
	bl.sku like 'DELIVERY%'
	AND bl.created >= '2022-01-01'
	and bl.created <= '2022-06-21'

select distinct bp.brand_id, bp.brand_name, bp.sml_team  
from smallable2_datawarehouse.b_products bp
--where brand_name ilike 'Harvest %'
--Camomile London / Aden + Anais / The New Society	

select * from smallable2_datawarehouse.b_countries bc  

select bop.bloque  from smallable2_datawarehouse.b_order_products bop 


select * from smallable2_front.customer_child cc 

select * from smallable2_datawarehouse.b_traffic bt 

select * from smallable2_front.customer c 
where c.customer_type_id = '1416682'
--c.lastname ilike 'bouton'




select distinct bb.brand_name, brand_id, bp.sml_team  from smallable2_datawarehouse.b_brands bb 
inner join smallable2_datawarehouse.b_products bp 
on bp.brand_name = bb.brand_name 
where bp.brand_name ilike 'garbo%'




select bc.zone_code  as ZONE, 
count(DISTINCT bo.order_id) AS cmd_ah23,
	sum(bop.billing_product_ht / 100) AS ca_ah23  
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo.order_id = bop.order_id
	AND bo.basket_id = bop.basket_id
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.brand_name  = 'Bobo Choses'
INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
	bc.country_id = bo.delivery_country_id
WHERE bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND (bo.created_at >= '2023-08-02' AND bo.created_at <= '2024-01-21')
GROUP BY ZONE 
ORDER BY ca_ah23 DESC


SELECT bp.sku FROM  smallable2_datawarehouse.b_products bp 





select distinct bp.season, bp.brand_id, brand_name from smallable2_datawarehouse.b_products bp 
where bp.season = 'PE22'

select DISTINCT bs.personne_genre 
from smallable2_datawarehouse.b_skus bs 
WHERE bs.raw_gender  in ('boy', 'girl')


select DISTINCT title_id 
from smallable2_front.customer c 


select distinct zone_code, regroup_zone , country_name, country_id, country_iso_code  from smallable2_datawarehouse.b_countries bc
--where bc.regroup_zone  = 'UK'

select * from smallable2_datawarehouse.b_supply_order_products bsop 

select count(distinct bo.order_id) as Cmd , count(distinct case when bop.code_promo ilike 'BIRT%' then bo.order_id else null end) code_promo, code_promo*100/Cmd as percent_code
from smallable2_datawarehouse.b_order_products bop 
inner join smallable2_datawarehouse.b_orders bo
on bo.order_id = bop.order_id 
and bo.basket_id = bop.basket_id 


select
	count(DISTINCT bo.basket_id) as cmd,
	sum(bop.billing_product_ttc / 100) AS CA,
	CA / cmd AS PM_Green
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop
on
	bo.order_id = bop.order_id
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bop.product_id 
INNER JOIN smallable2_datawarehouse.b_products bs ON
	bs.product_id = bp.product_id
where
	bp.brand_name ilike 'pom%'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
	
	
with hp as (select
	 bo.basket_id as bid
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop
on
	bo.order_id = bop.order_id
inner join smallable2_datawarehouse.b_products bp 
on bp.product_id = bop.product_id 
INNER JOIN smallable2_datawarehouse.b_products bs ON
	bs.product_id = bp.product_id
where
	bp.brand_name ilike 'Hundred Pieces'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1)
select
	count(DISTINCT bo.basket_id) as cmd,
	sum(bo.billing_product_ttc  / 100) AS CA,
	CA / cmd AS PM_Green
from
	smallable2_datawarehouse.b_orders bo
where
	bo.basket_id in (select bid from hp)
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1

	
--------------------------------------------------------------
	
select
	sku
from
	smallable2_front.availability_alert aa
inner join smallable2_datawarehouse.b_order_products bop 
on
	aa.sku = bop.sku_code
inner join smallable2_datawarehouse.b_orders bo 
on
	bop.order_id = bo.order_id 

	
	
select
	bo.delivery_country_id 
from
	smallable2_datawarehouse.b_orders bo
WHERE bo.delivery_country_iso  = 'UA'
		

select
		coa.city 
FROM smallable2_front.customer_order_address coa
WHERE  coa.country_id = 
	--AND coa.city ilike 'lISBONNE'



select
		bc.zone_code 
from
	smallable2_datawarehouse.b_countries bc 
WHERE bc.country_name  = 'Autriche'


select
	bo.delivery_country_iso 
from
	smallable2_datawarehouse.b_orders bo	
inner join smallable2_front.customer_order_address coa
on
	coa.id = bo.delivery_address_id
	and coa.country_id = 11
where
	bo.created_at >= '2021-09-01' 
	and bo.created_at <= '2022-12-31'
	AND coa.city ilike 'london'
	
	
	and left(trim(coa.postcode), 2) IN ('75', '77', '78', '91', '92', '93', '94', '95')

	
	
	
	
		
select bs.sku_id, sum(bs.) from smallable2_datawarehouse.b_stocks bs where bs.ref_date = '2021-12-21'
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT
	now()

select
	toUnixTimestamp(now())

select
	toUnixTimestamp(now()) - toUnixTimestamp(1996-08-14)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select
	distinct bo.customer_id,
	bc.lastname,
	bc.firstname,
	bc.email,
	bop.delivery_country_iso
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	and bop.basket_id = bo.basket_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bop.product_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bc.customer_id = bo.customer_id
where
	bp.brand_name in ('Caramel', 'Bonpoint', 'Bonton', '1+ in the family', 'Emile et Ida', 'B�ho', 'Petit Bateau', 'Zhoe & Tobiah', 'FUB', 'Rylee + Cru')
	and bo.created_at >= '2022-08-15'
	and bo.created_at <= '2022-11-28'
	

select distinct bb.brand_name, brand_id, bp.sml_team  from smallable2_datawarehouse.b_brands bb 
inner join smallable2_datawarehouse.b_products bp 
on bp.brand_name = bb.brand_name 
where bp.brand_name ilike 'Babybj%'	
	
	
	
select DISTINCT bp.brand_name  ,bp.brand_id
from
	smallable2_datawarehouse.b_products bp 
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


OR brand_id = 219

	
select sum(case when bo.delivery_country_id = '7' then bop.billing_product_ht / 100 else null end) as CA, 
		CA / sum(bop.billing_product_ht / 100) as PourcentageCA_global,
		count(distinct case when bo.delivery_country_id = '7' then bop.order_id else null end) as Commandes, --, sum(bop.qty_ordered)
										CA / count(distinct bop.order_id) as PourcentageCmd_global
from
		smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
		bop.order_id = bo.order_id
		and bop.basket_id = bo.basket_id
		and bo.is_valid = 1
		and bo.is_ca_ht_not_zero = 1
		and bo.created_at >= '2022-01-01'
		and bo.created_at <= '2022-12-31'
		--and bo.delivery_country_id = '7'
	

inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code 
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id 
and bp.brand_name  = '1+in the family'



select bp.ref_co as Refco, bp.product_id as Id_produit, bp.product_name as produits, count(distinct bop.order_id) as commande, sum(bop.qty_ordered) as quantite, sum(bop.billing_product_ht)/100 as ca
from
		smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
		bop.order_id = bo.order_id
		and bop.basket_id = bo.basket_id
		and bo.is_valid = 1
		and bo.is_ca_ht_not_zero = 1
		--and bo.created_at >= '2022-02-15'
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.sku_code = bop.sku_code 
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id 
and bp.brand_name  = 'B�ho'
group by bp.product_name, Refco, Id_produit
order by commande desc



select bo.order_id, basket_id,  count(distinct bop.product_id) as order,
	sum(bop.billing_product_ht / 100) as CA--,sum(bop.billing_product_ht / 100)/ count(distinct bo.order_id) as panier_moyen
from smallable2_datawarehouse.b_orders bo 
inner join smallable2_datawarehouse.b_order_products bop 
on bo.order_id = bop.order_id  
and bo.basket_id =bop.basket_id 
where bo.created_at >= '2022-11-15' and bo.created_at <= '2022-11-20'
and bo.delivery_country_iso in (select bc.country_iso_code  from smallable2_datawarehouse.b_countries bc where bc.zone_code = 'ROW')
group by order_id, basket_id 
order by CA desc 

select *
from smallable2_datawarehouse.b_customers bc 
inner join smallable2_front.customer_order_address coa 
on bc.customer_id = coa.customer_id 
and coa.postcode = '06000'

-------------------------------- Clients parisiens Alma Deia ------------------------------------------

select 	sum(bop.billing_product_ht)/ 100 AS CA,
	count(distinct bo.order_id) as ventes, sum(bop.qty_ordered) as Nb
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_order_address coa
on
	coa.id = bo.delivery_address_id
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
	and bp.brand_id = 1635
where coa.country_id = 7
	and bo.created_at >= '2023-06-02'
	and bo.created_at <= '2023-06-05'
	AND LEFT(trim(coa.postcode), 2) IN ('75', '77', '78', '91', '92', '93', '94', '95')
	
	
	
select 	sum(bop.billing_product_ht)/ 100 AS CA,
	count(distinct bo.order_id) as ventes, sum(bop.qty_ordered) as Nb
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_front.customer_order_address coa
on
	coa.id = bo.delivery_address_id
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
	and bp.brand_id = 1635
where coa.country_id = 7
	and bo.created_at >= '2023-05-26'
	and bo.created_at <= '2023-05-29'
	AND LEFT(trim(coa.postcode), 2) IN ('75', '77', '78', '91', '92', '93', '94', '95')