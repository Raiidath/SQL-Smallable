SELECT
 s.selection AS selection, 
 --bp.brand_name as selection, 
sum(CASE WHEN bo.created_at between '2023-04-27' AND '2023-05-10' THEN bop.billing_product_ht ELSE NULL END)/100 AS ceremonie_days,
count(distinct CASE WHEN bo.created_at between '2023-04-27' AND '2023-05-10' THEN bo.order_id ELSE NULL END) as n_commandes,
sum(CASE WHEN bo.created_at between '2023-04-27' AND '2023-05-10' THEN bop.qty_ordered  ELSE NULL END) AS vn_ceremonie
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bo.created_at between '2023-04-27' AND '2023-05-10'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
    INNER join (select DISTINCT pv.`_root_code` AS refco, pva.value AS selection from smallable2_akeneo.productModels_values pv
left join smallable2_akeneo.productModels_values_attributes pva on pv.id=pva._parent_id
where  pv.name ='tags' 
	AND (pva.value ilike '%tenues%' OR pva.value ilike '%outfits%' OR pva.value ilike '%ceremoni%')) s ON s.refco = bp.ref_co 
	--AND bp.brand_name in ('Pèpè', 'Ulla Johnson', 'Donsje', 'Tartine et Chocolat', 'JoSephine', 'Collégien' )
	--AND bp.brand_name in ('Louisiella','Magali Pascal','Flattered','Forte Forte','Xirena','Bonpoint','Komono','Roseanna','Norse Projects','Frangin Frangine','PDenim','Aymara','Favorite People','Louis Louise','We Are Kids')
GROUP BY selection
ORDER BY ceremonie_days DESC


SELECT
 --s.selection AS selection, 
 bp.product_name  as selection, bp.brand_name,  
sum(CASE WHEN bo.created_at between '2023-04-27' AND '2023-05-10' THEN bop.billing_product_ht ELSE NULL END)/100 AS ceremonie_days,
count(distinct CASE WHEN bo.created_at between '2023-04-27' AND '2023-05-10' THEN bo.order_id ELSE NULL END) as n_commandes,
sum(CASE WHEN bo.created_at between '2023-04-27' AND '2023-05-10' THEN bop.qty_ordered  ELSE NULL END) AS vn_ceremonie
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bo.created_at between '2023-04-27' AND '2023-05-10'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
    INNER join (select DISTINCT pv.`_root_code` AS refco, pva.value AS selection from smallable2_akeneo.productModels_values pv
left join smallable2_akeneo.productModels_values_attributes pva on pv.id=pva._parent_id
where  pv.name ='tags' 
	AND (pva.value ilike '%tenues%' OR pva.value ilike '%outfits%' OR pva.value ilike '%ceremoni%')) s ON s.refco = bp.ref_co 
	--AND bp.brand_name in ('Pèpè', 'Ulla Johnson', 'Donsje', 'Tartine et Chocolat', 'JoSephine', 'Collégien' )
	--AND bp.brand_name in ('Louisiella','Magali Pascal','Flattered','Forte Forte','Xirena','Bonpoint','Komono','Roseanna','Norse Projects','Frangin Frangine','PDenim','Aymara','Favorite People','Louis Louise','We Are Kids')
GROUP BY selection, bp.brand_name 
ORDER BY  n_commandes DESC



select distinct bb.brand_name, brand_id, bp.sml_team  from smallable2_datawarehouse.b_brands bb 
inner join smallable2_datawarehouse.b_products bp 
on bp.brand_name = bb.brand_name 
where bp.brand_name ilike 'We Are Kids%'


-------------------------------------------------------------------------

SELECT
 s.selection AS selection, 
 --bp.brand_name as selection, 
sum(CASE WHEN bo.created_at between '2023-04-13' AND '2023-04-26' THEN bop.billing_product_ht ELSE NULL END)/100 AS ceremonie_days,
count(distinct CASE WHEN bo.created_at between '2023-04-13' AND '2023-04-26' THEN bo.order_id ELSE NULL END) as n_commandes,
sum(CASE WHEN bo.created_at between '2023-04-13' AND '2023-04-26' THEN bop.qty_ordered  ELSE NULL END) AS vn_ceremonie
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bo.created_at between '2023-04-13' AND '2023-04-26'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
    INNER join (select DISTINCT pv.`_root_code` AS refco, pva.value AS selection from smallable2_akeneo.productModels_values pv
left join smallable2_akeneo.productModels_values_attributes pva on pv.id=pva._parent_id
where  pv.name ='tags' 
	AND (pva.value ilike '%tenues%' OR pva.value ilike '%outfits%' OR pva.value ilike '%ceremoni%')) s ON s.refco = bp.ref_co 
	--AND bp.brand_name in ('Pèpè', 'Ulla Johnson', 'Donsje', 'Tartine et Chocolat', 'JoSephine', 'Collégien' )
	AND bp.brand_name in ('Louisiella','Magali Pascal','Flattered','Forte Forte','Xirena','Bonpoint','Komono','Roseanna','Norse Projects','Frangin Frangine','PDenim','Aymara','Favorite People','Louis Louise','We Are Kids')
GROUP BY selection
ORDER BY ceremonie_days DESC


--------------------------------- GLOBAL ---------------------------------------------

SELECT
 bp.brand_name as selection, 
sum(CASE WHEN bo.created_at between '2023-04-13' AND '2023-04-26' THEN bop.billing_product_ht ELSE NULL END)/100 AS ceremonie_days,
count(distinct CASE WHEN bo.created_at between '2023-04-13' AND '2023-04-26' THEN bo.order_id ELSE NULL END) as n_commandes,
sum(CASE WHEN bo.created_at between '2023-04-13' AND '2023-04-26' THEN bop.qty_ordered  ELSE NULL END) AS vn_ceremonie
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bo.created_at between '2023-04-13' AND '2023-04-26'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
where 
	--AND bp.brand_name in ('Pèpè', 'Ulla Johnson', 'Donsje', 'Tartine et Chocolat', 'JoSephine', 'Collégien' )
	bp.brand_name in ('Louisiella','Magali Pascal','Flattered','Forte Forte','Xirena','Bonpoint','Komono','Roseanna','Norse Projects','Frangin Frangine','PDenim','Aymara','Favorite People','Louis Louise','We Are Kids')
GROUP BY selection
ORDER BY ceremonie_days DESC



SELECT
 bp.brand_name as selection, 
sum(CASE WHEN bo.created_at between '2023-04-27' AND '2023-05-10' THEN bop.billing_product_ht ELSE NULL END)/100 AS ceremonie_days,
count(distinct CASE WHEN bo.created_at between '2023-04-27' AND '2023-05-10' THEN bo.order_id ELSE NULL END) as n_commandes,
sum(CASE WHEN bo.created_at between '2023-04-27' AND '2023-05-10' THEN bop.qty_ordered  ELSE NULL END) AS vn_ceremonie
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
        AND bo.created_at between '2023-04-27' AND '2023-05-10'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
where 
	--bp.brand_name in ('Pèpè', 'Ulla Johnson', 'Donsje', 'Tartine et Chocolat', 'JoSephine', 'Collégien' )
	bp.brand_name in ('Louisiella','Magali Pascal','Flattered','Forte Forte','Xirena','Bonpoint','Komono','Roseanna','Norse Projects','Frangin Frangine','PDenim','Aymara','Favorite People','Louis Louise','We Are Kids')
GROUP BY selection
ORDER BY ceremonie_days DESC