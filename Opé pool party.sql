-------------------------------------------------- selection et Brand pool party / split free and paid ------------------
SELECT
-- s.selection AS selection, 
 bp.brand_name as selection, 
sum(CASE WHEN bo.created_at between '2023-05-25' AND '2023-06-14' THEN bop.billing_product_ht ELSE NULL END)/100 AS Pool_party,
count(distinct CASE WHEN bo.created_at between '2023-05-25' AND '2023-06-14' THEN bo.order_id ELSE NULL END) as n_commandes,
sum(CASE WHEN bo.created_at between '2023-05-25' AND '2023-06-14' THEN bop.qty_ordered  ELSE NULL END) AS vn_pool
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bo.created_at between '2023-05-25' AND '2023-06-14'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
    INNER join (select DISTINCT pv.`_root_code` AS refco, pva.value AS selection from smallable2_akeneo.productModels_values pv
left join smallable2_akeneo.productModels_values_attributes pva on pv.id=pva._parent_id
where  pv.name ='tags' 
	AND (pva.value ilike '%SUNNY_SWIM_KIDS%' OR pva.value ilike '%PALMA_POOL_PARTY_MEN%' OR pva.value ilike '%MONACO_PRIVATE_POOL_WOMAN%' OR pva.value ilike '%IBIZA_POOL_PARTY_WOMAN%' OR pva.value ilike '%FRENCH_RIVIERA_PARTY_DESIGN%')) s ON s.refco = bp.ref_co 
	--AND bp.brand_name in ('Liewood', 'Quut', 'Konges Sløjd', 'Eres', 'Fella Swim', 'Munsterkids', 'Khaven', 'American Vintage', 'Petites Pommes', 'We Are Kids', 'Salt Water', 'Petit Lem')
	AND bp.brand_name in ('Alemais', 'Boteh','OAS','She Made Me','Anaak','The Simple Folk','Sunchild','Aya Label','Icone','Atalaye','Bather','Ina Swim','Lison Paris','Beach & Bandits', 'Minnow','Lorna Murray', 'Cream', 'Romualda', 'Mr Boho', 'BIRKENSTOCK', 'Meduse', 'Havaianas', 'Mayde', 'Business & Pleasure Co.', 'Miasun', 'Polarbox', 'Louise Misha', 'Crosley','Houe','Nobodinoz','The Nice Fleet','garbo&friends','Mimitika','Naïf Natural Skincare','Standard Procedure','We Are Feel Good Inc.')
GROUP BY selection
ORDER BY Pool_party DESC

-------------------------------------------------- P-1 ------------------------------------------------------------

SELECT
 --s.selection AS selection, 
 bp.brand_name as selection, 
sum(CASE WHEN bo.created_at between '2023-05-04' AND '2023-05-24' THEN bop.billing_product_ht ELSE NULL END)/100 AS Pool_party,
count(distinct CASE WHEN bo.created_at between '2023-05-04' AND '2023-05-24' THEN bo.order_id ELSE NULL END) as n_commandes,
sum(CASE WHEN bo.created_at between '2023-05-04' AND '2023-05-24' THEN bop.qty_ordered  ELSE NULL END) AS vn_pool
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bo.created_at between '2023-05-04' AND '2023-05-24'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
    INNER join (select DISTINCT pv.`_root_code` AS refco, pva.value AS selection from smallable2_akeneo.productModels_values pv
left join smallable2_akeneo.productModels_values_attributes pva on pv.id=pva._parent_id
where  pv.name ='tags' 
	AND (pva.value ilike '%SUNNY_SWIM_KIDS%' OR pva.value ilike '%PALMA_POOL_PARTY_MEN%' OR pva.value ilike '%MONACO_PRIVATE_POOL_WOMAN%' OR pva.value ilike '%IBIZA_POOL_PARTY_WOMAN%' OR pva.value ilike '%FRENCH_RIVIERA_PARTY_DESIGN%')) s ON s.refco = bp.ref_co 
	AND bp.brand_name in ('Liewood', 'Quut', 'Konges Sløjd', 'Eres', 'Fella Swim', 'Munsterkids', 'Khaven', 'American Vintage', 'Petites Pommes', 'We Are Kids', 'Salt Water', 'Petit Lem')
	--AND bp.brand_name in ('Alemais', 'Boteh','OAS','She Made Me','Anaak','The Simple Folk','Sunchild','Aya Label','Icone','Atalaye','Bather','Ina Swim','Lison Paris','Beach & Bandits', 'Minnow','Lorna Murray', 'Cream', 'Romualda', 'Mr Boho', 'BIRKENSTOCK', 'Meduse', 'Havaianas', 'Mayde', 'Business & Pleasure Co.', 'Miasun', 'Polarbox', 'Louise Misha', 'Crosley','Houe','Nobodinoz','The Nice Fleet','garbo&friends','Mimitika','Naïf Natural Skincare','Standard Procedure','We Are Feel Good Inc.')
GROUP BY selection
ORDER BY Pool_party DESC

-------------------------------------------------------------------Top Marques/ produits ------------------

SELECT
 --s.selection AS selection, 
 bp.product_name  as selection, 
 bp.brand_name,  
sum(CASE WHEN bo.created_at between '2023-05-25' AND '2023-06-14' THEN bop.billing_product_ht ELSE NULL END)/100 AS Pool_party,
count(distinct CASE WHEN bo.created_at between '2023-05-25' AND '2023-06-14' THEN bo.order_id ELSE NULL END) as n_commandes,
sum(CASE WHEN bo.created_at between '2023-05-25' AND '2023-06-14' THEN bop.qty_ordered  ELSE NULL END) AS vn_pool
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bo.created_at between '2023-05-25' AND '2023-06-14'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
    INNER join (select DISTINCT pv.`_root_code` AS refco, pva.value AS selection from smallable2_akeneo.productModels_values pv
left join smallable2_akeneo.productModels_values_attributes pva on pv.id=pva._parent_id
where  pv.name ='tags' 
	AND (pva.value ilike '%SUNNY_SWIM_KIDS%' OR pva.value ilike '%PALMA_POOL_PARTY_MEN%' OR pva.value ilike '%MONACO_PRIVATE_POOL_WOMAN%' OR pva.value ilike '%IBIZA_POOL_PARTY_WOMAN%' OR pva.value ilike '%FRENCH_RIVIERA_PARTY_DESIGN%')) s ON s.refco = bp.ref_co 
	--AND bp.brand_name in ('Liewood', 'Quut', 'Konges Sløjd', 'Eres', 'Fella Swim', 'Munsterkids', 'Khaven', 'American Vintage', 'Petites Pommes', 'We Are Kids', 'Salt Water', 'Petit Lem')
	--AND bp.brand_name in ('Alemais', 'Boteh','OAS','She Made Me','Anaak','The Simple Folk','Sunchild','Aya Label','Icone','Atalaye','Bather','Ina Swim','Lison Paris','Beach & Bandits', 'Minnow','Lorna Murray', 'Cream', 'Romualda', 'Mr Boho', 'BIRKENSTOCK', 'Meduse', 'Havaianas', 'Mayde', 'Business & Pleasure Co.', 'Miasun', 'Polarbox', 'Louise Misha', 'Crosley','Houe','Nobodinoz','The Nice Fleet','garbo&friends','Mimitika','Naïf Natural Skincare','Standard Procedure','We Are Feel Good Inc.')
GROUP BY selection, bp.brand_name 
ORDER BY  n_commandes DESC


-------------------------------------------------- P-1 ------------------------------------------------------------

SELECT
 --s.selection AS selection, 
 bp.product_name  as selection, 
 bp.brand_name,  
sum(CASE WHEN bo.created_at between '2023-05-04' AND '2023-05-24' THEN bop.billing_product_ht ELSE NULL END)/100 AS Pool_party,
count(distinct CASE WHEN bo.created_at between '2023-05-04' AND '2023-05-24' THEN bo.order_id ELSE NULL END) as n_commandes,
sum(CASE WHEN bo.created_at between '2023-05-04' AND '2023-05-24' THEN bop.qty_ordered  ELSE NULL END) AS vn_pool
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bo.created_at between '2023-05-04' AND '2023-05-24'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
    INNER join (select DISTINCT pv.`_root_code` AS refco, pva.value AS selection from smallable2_akeneo.productModels_values pv
left join smallable2_akeneo.productModels_values_attributes pva on pv.id=pva._parent_id
where  pv.name ='tags' 
	AND (pva.value ilike '%SUNNY_SWIM_KIDS%' OR pva.value ilike '%PALMA_POOL_PARTY_MEN%' OR pva.value ilike '%MONACO_PRIVATE_POOL_WOMAN%' OR pva.value ilike '%IBIZA_POOL_PARTY_WOMAN%' OR pva.value ilike '%FRENCH_RIVIERA_PARTY_DESIGN%')) s ON s.refco = bp.ref_co 
	--AND bp.brand_name in ('Liewood', 'Quut', 'Konges Sløjd', 'Eres', 'Fella Swim', 'Munsterkids', 'Khaven', 'American Vintage', 'Petites Pommes', 'We Are Kids', 'Salt Water', 'Petit Lem')
	--AND bp.brand_name in ('Alemais', 'Boteh','OAS','She Made Me','Anaak','The Simple Folk','Sunchild','Aya Label','Icone','Atalaye','Bather','Ina Swim','Lison Paris','Beach & Bandits', 'Minnow','Lorna Murray', 'Cream', 'Romualda', 'Mr Boho', 'BIRKENSTOCK', 'Meduse', 'Havaianas', 'Mayde', 'Business & Pleasure Co.', 'Miasun', 'Polarbox', 'Louise Misha', 'Crosley','Houe','Nobodinoz','The Nice Fleet','garbo&friends','Mimitika','Naïf Natural Skincare','Standard Procedure','We Are Feel Good Inc.')
GROUP BY selection, bp.brand_name 
ORDER BY  n_commandes DESC



select distinct bb.brand_name, brand_id, bp.sml_team  from smallable2_datawarehouse.b_brands bb 
inner join smallable2_datawarehouse.b_products bp 
on bp.brand_name = bb.brand_name 
where bp.brand_name ilike 'Beach%'


------------------------------------- Top Marques et Produits -------------------------------
SELECT
 --s.selection AS selection, 
 --bp.product_name  as selection, 
 bp.brand_name as selection,  
sum(CASE WHEN bo.created_at between '2023-05-04' AND '2023-05-24' THEN bop.billing_product_ht ELSE NULL END)/100 AS Pool_party,
count(distinct CASE WHEN bo.created_at between '2023-05-04' AND '2023-05-24' THEN bo.order_id ELSE NULL END) as n_commandes,
sum(CASE WHEN bo.created_at between '2023-05-04' AND '2023-05-24' THEN bop.qty_ordered  ELSE NULL END) AS vn_pool
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bo.created_at between '2023-05-04' AND '2023-05-24'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
    INNER join (select DISTINCT pv.`_root_code` AS refco, pva.value AS selection from smallable2_akeneo.productModels_values pv
left join smallable2_akeneo.productModels_values_attributes pva on pv.id=pva._parent_id
where  pv.name ='tags' 
	AND (pva.value ilike '%SUNNY_SWIM_KIDS%' OR pva.value ilike '%PALMA_POOL_PARTY_MEN%' OR pva.value ilike '%MONACO_PRIVATE_POOL_WOMAN%' OR pva.value ilike '%IBIZA_POOL_PARTY_WOMAN%' OR pva.value ilike '%FRENCH_RIVIERA_PARTY_DESIGN%')) s ON s.refco = bp.ref_co 
	--AND bp.brand_name in ('Liewood', 'Quut', 'Konges Sløjd', 'Eres', 'Fella Swim', 'Munsterkids', 'Khaven', 'American Vintage', 'Petites Pommes', 'We Are Kids', 'Salt Water', 'Petit Lem')
	--AND bp.brand_name in ('Alemais', 'Boteh','OAS','She Made Me','Anaak','The Simple Folk','Sunchild','Aya Label','Icone','Atalaye','Bather','Ina Swim','Lison Paris','Beach & Bandits', 'Minnow','Lorna Murray', 'Cream', 'Romualda', 'Mr Boho', 'BIRKENSTOCK', 'Meduse', 'Havaianas', 'Mayde', 'Business & Pleasure Co.', 'Miasun', 'Polarbox', 'Louise Misha', 'Crosley','Houe','Nobodinoz','The Nice Fleet','garbo&friends','Mimitika','Naïf Natural Skincare','Standard Procedure','We Are Feel Good Inc.')
GROUP BY selection, bp.brand_name
ORDER BY Pool_party DESC



SELECT
 --s.selection AS selection, 
 bp.product_name  as selection, bp.brand_name,  
sum(CASE WHEN bo.created_at between '2023-05-25' AND '2023-06-14' THEN bop.billing_product_ht ELSE NULL END)/100 AS Pool_party,
count(distinct CASE WHEN bo.created_at between '2023-05-25' AND '2023-06-14' THEN bo.order_id ELSE NULL END) as n_commandes,
sum(CASE WHEN bo.created_at between '2023-05-25' AND '2023-06-14' THEN bop.qty_ordered  ELSE NULL END) AS vn_pool
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bo.created_at between '2023-05-25' AND '2023-06-14'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
    INNER join (select DISTINCT pv.`_root_code` AS refco, pva.value AS selection from smallable2_akeneo.productModels_values pv
left join smallable2_akeneo.productModels_values_attributes pva on pv.id=pva._parent_id
where  pv.name ='tags' 
	AND (pva.value ilike '%SUNNY_SWIM_KIDS%' OR pva.value ilike '%INDIAN_SWIM%' OR pva.value ilike '%PALMA_POOL_PARTY_MEN%' OR pva.value ilike '%MONACO_PRIVATE_POOL_WOMAN%' OR pva.value ilike '%IBIZA_POOL_PARTY_WOMAN%' OR pva.value ilike '%FRENCH_RIVIERA_PARTY_DESIGN%')) s ON s.refco = bp.ref_co 
	--AND bp.brand_name in ('Liewood', 'Quut', 'Konges Sløjd', 'Eres', 'Fella Swim', 'Munsterkids', 'Khaven', 'American Vintage', 'Petites Pommes', 'We Are Kids', 'Salt Water', 'Petit Lem')
	--AND bp.brand_name in ('Alemais', 'Boteh','OAS','She Made Me','Anaak','The Simple Folk','Sunchild','Aya Label','Icone','Atalaye','Bather','Ina Swim','Lison Paris','Beach & Bandits', 'Minnow','Lorna Murray', 'Cream', 'Romualda', 'Mr Boho', 'BIRKENSTOCK', 'Meduse', 'Havaianas', 'Mayde', 'Business & Pleasure Co.', 'Miasun', 'Polarbox', 'Louise Misha', 'Crosley','Houe','Nobodinoz','The Nice Fleet','garbo&friends','Mimitika','Naïf Natural Skincare','Standard Procedure','We Are Feel Good Inc.')
GROUP BY selection, bp.brand_name
ORDER BY Pool_party DESC


--------------------------------------------- GLOBAL Marques Paid et Free  ------------------------------

SELECT
 bp.brand_name as selection, 
sum(CASE WHEN bo.created_at between '2023-05-25' AND '2023-06-14' THEN bop.billing_product_ht ELSE NULL END)/100 AS Pool_party,
count(distinct CASE WHEN bo.created_at between '2023-05-25' AND '2023-06-14' THEN bo.order_id ELSE NULL END) as n_commandes,
sum(CASE WHEN bo.created_at between '2023-05-25' AND '2023-06-14' THEN bop.qty_ordered  ELSE NULL END) AS vn_pool
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bo.created_at between '2023-05-25' AND '2023-06-14'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
where 
	--bp.brand_name in ('Liewood', 'Quut', 'Konges Sløjd', 'Eres', 'Fella Swim', 'Munsterkids', 'Khaven', 'American Vintage', 'Petites Pommes', 'We Are Kids', 'Salt Water', 'Petit Lem')
	bp.brand_name in ('Alemais', 'Boteh','OAS','She Made Me','Anaak','The Simple Folk','Sunchild','Aya Label','Icone','Atalaye','Bather','Ina Swim','Lison Paris','Beach & Bandits', 'Minnow','Lorna Murray', 'Cream', 'Romualda', 'Mr Boho', 'BIRKENSTOCK', 'Meduse', 'Havaianas', 'Mayde', 'Business & Pleasure Co.', 'Miasun', 'Polarbox', 'Louise Misha', 'Crosley','Houe','Nobodinoz','The Nice Fleet','garbo&friends','Mimitika','Naïf Natural Skincare','Standard Procedure','We Are Feel Good Inc.')
GROUP BY selection
ORDER BY Pool_party DESC




SELECT
 bp.brand_name as selection, 
sum(CASE WHEN bo.created_at between '2023-05-04' AND '2023-05-24' THEN bop.billing_product_ht ELSE NULL END)/100 AS Pool_party,
count(distinct CASE WHEN bo.created_at between '2023-05-04' AND '2023-05-24' THEN bo.order_id ELSE NULL END) as n_commandes,
sum(CASE WHEN bo.created_at between '2023-05-04' AND '2023-05-24' THEN bop.qty_ordered  ELSE NULL END) AS vn_pool
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bo.created_at between '2023-05-04' AND '2023-05-24'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
where 
	--bp.brand_name in ('Liewood', 'Quut', 'Konges Sløjd', 'Eres', 'Fella Swim', 'Munsterkids', 'Khaven', 'American Vintage', 'Petites Pommes', 'We Are Kids', 'Salt Water', 'Petit Lem')
	bp.brand_name in ('Alemais', 'Boteh','OAS','She Made Me','Anaak','The Simple Folk','Sunchild','Aya Label','Icone','Atalaye','Bather','Ina Swim','Lison Paris','Beach & Bandits', 'Minnow','Lorna Murray', 'Cream', 'Romualda', 'Mr Boho', 'BIRKENSTOCK', 'Meduse', 'Havaianas', 'Mayde', 'Business & Pleasure Co.', 'Miasun', 'Polarbox', 'Louise Misha', 'Crosley','Houe','Nobodinoz','The Nice Fleet','garbo&friends','Mimitika','Naïf Natural Skincare','Standard Procedure','We Are Feel Good Inc.')
GROUP BY selection
ORDER BY Pool_party DESC


SELECT
 bp.brand_name as selection, 
sum(CASE WHEN bo.created_at between '2023-05-25' AND '2023-06-14' THEN bop.billing_product_ht ELSE NULL END)/100 AS Pool_party,
count(distinct CASE WHEN bo.created_at between '2023-05-25' AND '2023-06-14' THEN bo.order_id ELSE NULL END) as n_commandes,
sum(CASE WHEN bo.created_at between '2023-05-25' AND '2023-06-14' THEN bop.qty_ordered  ELSE NULL END) AS vn_pool
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
        AND bo.created_at between '2023-05-25' AND '2023-06-14'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
where 
	 bp.brand_name in ('Liewood', 'Quut', 'Konges Sløjd', 'Eres', 'Fella Swim', 'Munsterkids', 'Khaven', 'American Vintage', 'Petites Pommes', 'We Are Kids', 'Salt Water', 'Petit Lem')
	-- bp.brand_name in ('Alemais', 'Boteh','OAS','She Made Me','Anaak','The Simple Folk','Sunchild','Aya Label','Icone','Atalaye','Bather','Ina Swim','Lison Paris','Beach & Bandits', 'Minnow','Lorna Murray', 'Cream', 'Romualda', 'Mr Boho', 'BIRKENSTOCK', 'Meduse', 'Havaianas', 'Mayde', 'Business & Pleasure Co.', 'Miasun', 'Polarbox', 'Louise Misha', 'Crosley','Houe','Nobodinoz','The Nice Fleet','garbo&friends','Mimitika','Naïf Natural Skincare','Standard Procedure','We Are Feel Good Inc.')
GROUP BY selection
ORDER BY Pool_party DESC





SELECT
 bp.brand_name as selection, 
sum(CASE WHEN bo.created_at between '2023-05-04' AND '2023-05-24' THEN bop.billing_product_ht ELSE NULL END)/100 AS Pool_party,
count(distinct CASE WHEN bo.created_at between '2023-05-04' AND '2023-05-24' THEN bo.order_id ELSE NULL END) as n_commandes,
sum(CASE WHEN bo.created_at between '2023-05-04' AND '2023-05-24' THEN bop.qty_ordered  ELSE NULL END) AS vn_pool
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
        AND bo.created_at between '2023-05-04' AND '2023-05-24'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
where 
	 bp.brand_name in ('Liewood', 'Quut', 'Konges Sløjd', 'Eres', 'Fella Swim', 'Munsterkids', 'Khaven', 'American Vintage', 'Petites Pommes', 'We Are Kids', 'Salt Water', 'Petit Lem')
	-- bp.brand_name in ('Alemais', 'Boteh','OAS','She Made Me','Anaak','The Simple Folk','Sunchild','Aya Label','Icone','Atalaye','Bather','Ina Swim','Lison Paris','Beach & Bandits', 'Minnow','Lorna Murray', 'Cream', 'Romualda', 'Mr Boho', 'BIRKENSTOCK', 'Meduse', 'Havaianas', 'Mayde', 'Business & Pleasure Co.', 'Miasun', 'Polarbox', 'Louise Misha', 'Crosley','Houe','Nobodinoz','The Nice Fleet','garbo&friends','Mimitika','Naïf Natural Skincare','Standard Procedure','We Are Feel Good Inc.')
GROUP BY selection
ORDER BY Pool_party DESC
