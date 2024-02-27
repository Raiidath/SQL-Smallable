---------------------------------------------Nb d'exemplaire achetée par sku Linge de maison- ----------------------------
select
	*
from
	smallable2_datawarehouse.b_products bp
where
	bp.product_type_N5_refco = 'maison'
	and bp.buyer = 'MARINE'
	and bp.brand_name = 'Autumn'
	
	
With Linge as (
select
	distinct case
		when bp.product_name like 'Housse de couette%' then 'Housse de couette'
		when bp.product_name ilike 'Taie%' then 'Taie d\' oreiller' 
when bp.product_name ilike 'Drap_housse%' then 'Drap housse' else null end as categ, bp.product_id as pid, bp.color as color, bp.brand_name as marque 
from smallable2_datawarehouse.b_products bp )
--where bp.brand_id in (1123, 455, 965, 1191))
select count(distinct h) as nb_housses,
count(distinct case when t is not null then h end) clients_housses_taie,
count(distinct case when h = t then h end) clients_housses_taie_meme_couleur,
count(distinct case when d is not null then h end) clients_housses_drap,
count(distinct case when h = d then h end) clients_housses_drap_meme_couleur,
count(distinct case when t is not null and d is not null then h end) clients_housses_taie_drap,
count(distinct case when h = t and h = d then h end) clients_housses_taie_drap_meme_couleur
from (select oid, max(housse) as h , max(taie) as t , max(drap) as d from (select distinct bo.order_id as oid, 
case when l.categ = 'Housse de couette' then toString(oid) || l.color else null end as housse,
case when l.categ = 'Taie d\' oreiller'  then toString(oid) || l.color else null end as taie,
case when l.categ = 'Drap housse' then toString(oid) ||  l.color else null end as drap
from smallable2_datawarehouse.b_orders bo 
inner join smallable2_datawarehouse.b_order_products bop 
on bo.order_id = bop.order_id 
and bo.is_valid = 1
and bo.is_ca_ht_not_zero = 1
		AND bo.created_at >= '2022-01-01'
--		AND bo.created_at <= '2021-12-31'
inner join Linge l on l.pid = bop.product_id
and l.categ is not null
order by oid desc) group by oid order by oid desc)



With Linge as (
select
	distinct case
		when bp.product_name like 'Housse de couette%' then 'Housse de couette'
		when bp.product_name ilike 'Taie%' then 'Taie d\' oreiller' 
when bp.product_name ilike 'Drap_housse%' then 'Drap housse' else null end as categ, bp.product_id as pid, bp.color as color, bp.brand_name as marque 
from smallable2_datawarehouse.b_products bp 
where bp.brand_id = '965' ) --in (1123, 455, 965, 1191)) 
select nb_housse as nb, count(1), count(1)/sum(count(1)) over() from
(select count(distinct housse) as nb_housse -- modifier housse en taie ou drap 
from (select distinct bo.order_id as oid, 
case when l.categ = 'Housse de couette' then toString(oid) || l.color else null end as housse,
case when l.categ = 'Taie d\' oreiller'  then toString(oid) || l.color else null end as taie,
case when l.categ = 'Drap housse' then toString(oid) ||  l.color else null end as drap
from smallable2_datawarehouse.b_orders bo 
inner join smallable2_datawarehouse.b_order_products bop 
on bo.order_id = bop.order_id 
and bo.is_valid = 1
and bo.is_ca_ht_not_zero = 1
		AND bo.created_at >= '2021-01-01'
		AND bo.created_at <= '2021-12-31'
inner join Linge l on l.pid = bop.product_id
and l.categ is not null
order by oid desc) group by oid order by oid desc) where nb_housse > 0  group by nb_housse order by nb asc



SELECT
	categ,
	qty,
	count(DISTINCT bo.order_id)
FROM
	(
	SELECT
		DISTINCT CASE
			WHEN bp.product_name LIKE 'Housse de couette%' THEN 'Housse de couette'
			WHEN bp.product_name ilike 'Taie%' THEN 'Taie doreiller'
			WHEN bp.product_name ilike 'Drap_housse%' THEN 'Drap housse'
			ELSE NULL
		END AS categ,
		bp.product_id AS pid,
		bp.color AS color,
		bp.brand_name AS marque,
		bo.order_id,
		sum(bop.qty_ordered) AS qty
	FROM
		smallable2_datawarehouse.b_orders bo
	INNER JOIN smallable2_datawarehouse.b_order_products bop ON
		bo.order_id = bop.order_id
		AND bop.is_valid = 1
		AND bo.is_ca_ht_not_zero = 1
		AND bo.created_at BETWEEN '2022-01-01' AND '2023-01-01'
	INNER JOIN smallable2_datawarehouse.b_products bp ON
		bop.product_id = bp.product_id
		--AND bp.brand_id in (1123, 455, 965, 1191)
	GROUP BY
		categ,
		bp.product_id AS pid,
		bp.color AS color,
		bp.brand_name AS marque,
		bo.order_id)
WHERE
	categ IS NOT NULL
GROUP BY
	categ,
	qty
ORDER BY
	categ ASC,
	qty ASC
	

	
------------------------------------- Analyse linge de maison Stage -----------------------------------------
SELECT
	marque,-- bid,
	pan, col,
	categorie,
	sum(v.qty) AS q,
	count(DISTINCT v.oid) AS nb_commandes,
	sum(v.qty)/ count(DISTINCT v.oid) AS nb_par_commande,
	count(CASE WHEN qty = 1 THEN v.ligne ELSE NULL END)/ count(v.ligne) AS 1_unit,
	count(CASE WHEN qty = 2 THEN v.ligne ELSE NULL END)/ count(v.ligne) AS 2_units,
	count(CASE WHEN qty = 3 THEN v.ligne ELSE NULL END)/ count(v.ligne) AS 3_units,
	count(CASE WHEN qty = 4 THEN v.ligne ELSE NULL END)/ count(v.ligne) AS 4_units,
	count(CASE WHEN qty = 5 THEN v.ligne ELSE NULL END)/ count(v.ligne) AS 5_units,
	count(CASE WHEN qty = 6 THEN v.ligne ELSE NULL END)/ count(v.ligne) AS 6_units,
	count(CASE WHEN qty > 6 THEN v.ligne ELSE NULL END)/ count(v.ligne) AS plus6_units
FROM
	(
	SELECT
		bp.brand_name AS marque,
		bp.brand_id AS bid,
		bp.product_id AS pid,
		bp.product_name as pan,
		bp.product_type_N1_refco  AS categorie,
		bp.color as col,
		bop.qty_ordered AS qty,
		bop.order_id AS oid,
		bop.order_product_id AS ligne
	FROM
		smallable2_datawarehouse.b_orders bo
	INNER JOIN smallable2_datawarehouse.b_order_products bop ON
		bop.order_id = bo.order_id
		AND bo.is_valid = 1
		AND bo.is_ca_net_ht_not_zero = 1
		AND bo.created_at >= '2021-01-01'
		AND bo.created_at <= '2021-12-31'
	INNER JOIN smallable2_datawarehouse.b_skus bs ON
		bop.sku_id = bs.sku_id
		AND bs.univers_marine  = 'Textile'
	INNER JOIN smallable2_datawarehouse.b_products bp ON
		bp.product_id = bs.product_id
		AND bp.product_type_N5_refco = 'maison'
		AND bp.buyer = 'MARINE' 
		WHERE bp.brand_name in ('Haomy', 'La cerise sur le gâteau', 'Communauté de biens', 'Autumn')
		) v
GROUP BY
	marque, --bid,
	categorie, pan, col
ORDER BY marque, col asc
	

-------------------------------------KPI LINGE DE MAISON  --------------------------------------------------

SELECT
	avg(CASE WHEN v.nb_housses > 0 THEN v.nb_housses ELSE null end) AS avg_housses,
	avg(CASE WHEN v.nb_taie > 0 THEN v.nb_taie ELSE null end) AS avg_taie,
	avg(CASE WHEN v.nb_taies > 0 THEN v.nb_taies ELSE null end) AS avg_taies,
	avg(CASE WHEN v.nb_drap > 0 THEN v.nb_drap ELSE null end) AS avg_drap,
	avg(CASE WHEN v.nb_draps > 0 THEN v.nb_draps ELSE null end) AS avg_draps,
		stddevPop
	(CASE
		WHEN v.nb_housses > 0 THEN v.nb_housses
		ELSE null
	end) AS stddev_housses,
	stddevPop
	(CASE
		WHEN v.nb_taie > 0 THEN v.nb_taie
		ELSE null
	end) AS stddev_taie,
	stddevPop
	(CASE
		WHEN v.nb_taies > 0 THEN v.nb_taies
		ELSE null
	end) AS stddev_taies,
		stddevPop
	(CASE
		WHEN v.nb_drap > 0 THEN v.nb_drap
		ELSE null
	end) AS stddev_drap,
	stddevPop
	(CASE
		WHEN v.nb_draps > 0 THEN v.nb_draps
		ELSE null
	end) AS stddev_draps
FROM
	(
	SELECT
		bo.order_id AS oid,
		sum(CASE WHEN bs.categories_N1 like 'Housse%' AND bo.order_id = bo.order_id then bop.qty_ordered else null end) AS nb_housses,
		sum(CASE WHEN bs.categories_N1 like 'Taie%' AND bo.order_id = (select bop2.order_id 
																   from smallable2_datawarehouse.b_order_products bop2	
																   inner join smallable2_datawarehouse.b_skus bs 
																   			  on bop2.sku_id = bs.sku_id
																   where bs.categories_N1 like 'Housse%') then bop.qty_ordered else null end) AS nb_taie,
		sum(CASE WHEN bs.categories_N1 like 'Taie%' AND bo.order_id = bo.order_id AND bp.color = bp.color then bop.qty_ordered else null end) AS nb_taies,
		sum(CASE WHEN bs.categories_N1 like 'Drap%' AND bo.order_id = bo.order_id then bop.qty_ordered else null end) AS nb_drap,
		sum(CASE WHEN bs.categories_N1 like 'Drap%' AND bo.order_id = bo.order_id AND bp.color = bp.color then bop.qty_ordered else null end) AS nb_draps
	FROM
		smallable2_datawarehouse.b_orders bo
	INNER JOIN smallable2_datawarehouse.b_order_products bop ON
		bop.order_id = bo.order_id
		AND bo.is_valid = 1
		AND bo.is_ca_net_ht_not_zero = 1
		AND bo.created_at >= '2021-01-01'
		AND bo.created_at <= '2022-07-31'
	INNER JOIN smallable2_datawarehouse.b_skus bs ON
		bop.sku_id = bs.sku_id
		AND bs.univers_marine = 'Textile'
	INNER JOIN smallable2_datawarehouse.b_products bp ON
		bp.product_id = bs.product_id
		AND bp.product_type_N5_refco = 'maison'
		AND bp.buyer = 'MARINE'
	GROUP BY
		bo.order_id) v
		
		
--------------- Marques affinitaires / produits affinitaires -----------------------
		
WITH paniers AS (
SELECT
	DISTINCT bo.order_id AS oid
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	AND bo.created_at >= '2021-01-01'
	AND bo.created_at <= '2021-12-31'-- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
	AND bs.univers_marine  = 'Textile'
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	--AND bp.brand_id = 455 
	AND bp.product_name like '%housse%' -- changer id marque ici
	AND bp.product_type_N5_refco = 'maison'
	AND bp.brand_name = 'Haomy'
	--AND bp.color ='Blush'
	AND bp.buyer = 'MARINE' 
	)
SELECT (case when bp.product_name like 'Taie%' then bp.product_name else null end) as Taies,
(case when bp.product_name like '%Housse%' then bp.product_name else null end) as couverture, 
(case when bp.product_name like '%Drap-housse%' then bp.product_name else null end) as drap, 
bp.brand_name, bp.product_name, bp.color, count(DISTINCT bo.order_id) AS commandes, sum(bop.qty_ordered) as Q_vendues,
sum(bop.billing_product_ht)/100 AS ca
FROM
	smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	AND bo.created_at >= '2021-01-01'
	AND bo.created_at <= '2021-12-31'-- changer plage de date ici
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
INNER JOIN smallable2_datawarehouse.b_skus bs ON
	bs.sku_id = bop.sku_id
	AND bs.univers_marine  = 'Textile'
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bs.product_id = bp.product_id
	AND bp.buyer = 'MARINE' 
	--AND bp.brand_name = 'Haomy'
--	AND bp.color ='Blush'
	WHERE bo.order_id IN (SELECT oid FROM paniers)
	GROUP BY  --Taies, couverture,
	bp.product_id, bp.brand_name, bp.color , bp.product_name 
	ORDER BY commandes desc
	
	
----------------- Produits affinitaires global -----------------------------------
	
	
SELECT
	marques1,
    produit1,
    color1,
    concat(marques1, produit1, color1) as con,
    rang,
    concat(con,
    toString(rang)) AS marque_rang,
    marques2,
    produit2,
    color2,
    nb_commandes,
    ca_ht
FROM
    (
    SELECT
        *,
        ROW_NUMBER(a.ca_ht) OVER (PARTITION BY a.produit1 ORDER BY a.ca_ht DESC) AS rang
    FROM
        (WITH marques AS (
        SELECT
            bs.sku_id AS sku_id,
            bp.brand_name AS marques,
            bp.product_id as pid, bp.product_name as produit, bp.color as color
        FROM 
            smallable2_datawarehouse.b_products bp
        INNER JOIN smallable2_datawarehouse.b_skus bs ON
            bp.product_id = bs.product_id
            AND bs.univers_marine  = 'Textile'
            AND bp.product_type_N5_refco = 'maison'
			AND bp.buyer = 'MARINE' 
			WHERE bp.brand_name in ('Haomy', 'La cerise sur le gâteau', 'Communauté de biens', 'Autumn')
            )      -- sous requête pour sortir la marque de chaque sku, plus simple (et rapide que de faire des jointures sur skus et products dans les 2 sous requêtes d'en dessous)
        SELECT
            distinct o1.produit AS produit1,
            o1.marques AS marques1,
            o2.produit AS produit2,
            o2.marques AS marques2,
            o1.color AS color1,
            o2.color AS color2,
            sum(o2.ca2 / 100) AS ca_ht,
            count(DISTINCT o2.order2) AS nb_commandes
        FROM
            (
            SELECT
                bop.order_id AS order1,
                m.produit AS produit,
                m.marques AS marques,
                m.color as color,
                bop.billing_product_ht AS ca1
            FROM
                smallable2_datawarehouse.b_orders bo
            INNER JOIN 
    smallable2_datawarehouse.b_order_products bop ON
                bop.order_id = bo.order_id
            INNER JOIN marques m ON
                bop.sku_id = m.sku_id
            WHERE
                bo.is_valid = 1
                AND bo.is_ca_ht_not_zero = 1
                AND bo.created_at >= '2022-01-01'
               -- AND bo.created_at <= '2021-12-31'
                ) o1 -- sous requête pour sortir tous les paniers, avec l'info du CA par marque
        INNER JOIN (
            SELECT
                bop2.order_id AS order2,
                m2.produit AS produit,
                m2.marques AS marques,
                m2.color as color,
                bop2.billing_product_ht AS ca2
            FROM
                smallable2_datawarehouse.b_orders bo2
            INNER JOIN 
    smallable2_datawarehouse.b_order_products bop2 ON
                bop2.order_id = bo2.order_id
            INNER JOIN marques m2 ON
                bop2.sku_id = m2.sku_id
            WHERE
                bo2.is_valid = 1
                AND bo2.is_ca_ht_not_zero = 1
                AND bo2.created_at >= '2022-01-01'
               -- AND bo2.created_at <= '2021-12-31'
                ) o2 ON     -- 2ème sous requête qui sort la même chose
            o1.order1 = o2.order2   -- ON joint les 2 sous requêtes via l'ORDER ID : ça veut dire que chaque ligne de chaque panier va être dédupliquée. Si j'ai une commande avec 3 lignes, ça va me sortir 9 lignes dans cette requête
        GROUP BY
            produit1,
            produit2, marques1, marques2, color1, color2
        ORDER BY
            nb_commandes DESC,
            ca_ht DESC) a
    --WHERE bp.brand_name in ('Haomy', 'La cerise sur le gâteau', 'Communauté de biens', 'Autumn')
    GROUP BY
        produit1,
        produit2, marques1, marques2, color1, color2, ca_ht,
        nb_commandes) a2
        
        
        
        
select
	distinct bp.color
from
	smallable2_datawarehouse.b_skus bs
inner join smallable2_datawarehouse.b_products bp
on
	bp.product_id = bs.product_id
	AND bs.univers_marine = 'Textile'
	AND bp.product_type_N5_refco = 'maison'
	AND bp.buyer = 'MARINE'
inner join smallable2_datawarehouse.b_order_products bop 
on
	bs.sku_id = bop.sku_id
inner join smallable2_datawarehouse.b_orders bo 
on
	bop.order_id = bo.order_id
	AND bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bo.created_at > '2021-07-01'
	AND bo.created_at <= '2022-06-30'
	
	
----------------------------------------------------------------------------------------------------------------
	
SELECT
	count(CASE WHEN bs.categories_N1 like 'Housse%' AND bo.order_id = bo.order_id then bo.order_id else null end),
	count(CASE WHEN bs.categories_N1 like 'Taie%' AND bo.order_id = bo.order_id then bo.order_id else null end),
	count(CASE WHEN bs.categories_N1 like 'Taie%' AND bo.order_id = bo.order_id AND bp.color  = bp.color then bo.order_id else null end),
	count(CASE WHEN bs.categories_N1 like 'Drap%' AND bo.order_id = bo.order_id then bo.order_id else null end),
	count(CASE WHEN bs.categories_N1 like 'Drap%' AND bo.order_id = bo.order_id AND bp.color  = bp.color then bo.order_id else null end)
FROM
		smallable2_datawarehouse.b_orders bo
	INNER JOIN smallable2_datawarehouse.b_order_products bop ON
		bop.order_id = bo.order_id
		AND bo.is_valid = 1
		AND bo.is_ca_net_ht_not_zero = 1
		AND bo.created_at >= '2021-01-01'
		AND bo.created_at <= '2021-12-31'
		INNER JOIN smallable2_datawarehouse.b_skus bs ON
		bop.sku_id = bs.sku_id
		AND bs.univers_marine = 'Textile'
	INNER JOIN smallable2_datawarehouse.b_products bp ON
		bp.product_id = bs.product_id
		AND bp.product_type_N5_refco = 'maison'
		AND bp.buyer = 'MARINE'
		
		
SELECT
	count(CASE WHEN bs.categories_N1 like 'Housse%' AND bo.order_id = bo.order_id then bo.order_id else null end),
	count(CASE WHEN bs.categories_N1 like 'Taie%' AND bo.order_id = bo.order_id then bo.order_id else null end),
	count(CASE WHEN bs.categories_N1 like 'Taie%' AND bo.order_id = bo.order_id AND bp.color  = bp.color then bo.order_id else null end),
	count(CASE WHEN bs.categories_N1 like 'Drap%' AND bo.order_id = bo.order_id then bo.order_id else null end),
	count(CASE WHEN bs.categories_N1 like 'Drap%' AND bo.order_id = bo.order_id AND bp.color  = bp.color then bo.order_id else null end)
FROM
		smallable2_datawarehouse.b_orders bo
	INNER JOIN smallable2_datawarehouse.b_order_products bop ON
		bop.order_id = bo.order_id
		AND bo.is_valid = 1
		AND bo.is_ca_net_ht_not_zero = 1
		AND bo.created_at >= '2022-01-01'
		AND bo.created_at <= '2022-12-31'
		INNER JOIN smallable2_datawarehouse.b_skus bs ON
		bop.sku_id = bs.sku_id
		AND bs.univers_marine = 'Textile'
	INNER JOIN smallable2_datawarehouse.b_products bp ON
		bp.product_id = bs.product_id
		AND bp.product_type_N5_refco = 'maison'
		AND bp.buyer = 'MARINE'