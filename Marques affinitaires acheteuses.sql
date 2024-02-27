SELECT
    marque1,
    rang,
    concat(marque1,
    toString(rang)) AS marque_rang,
    marque2,
    nb_commandes,
    ca_ht
FROM
    (
    SELECT
        *,
        ROW_NUMBER(a.ca_ht) OVER (PARTITION BY a.marque1 ORDER BY a.ca_ht DESC) AS rang
    FROM
        (WITH marques AS (
        SELECT
            bs.sku_id AS sku_id,
            bp.brand_name AS marque
        FROM
            smallable2_datawarehouse.b_products bp
        INNER JOIN smallable2_datawarehouse.b_skus bs ON
            bp.product_id = bs.product_id)      -- sous requ�te pour sortir la marque de chaque sku, plus simple (et rapide que de faire des jointures sur skus et products dans les 2 sous requ�tes d'en dessous)
        SELECT
            o1.marque AS marque1,
            o2.marque AS marque2,
            sum(o2.ca2 / 100) AS ca_ht,
            count(DISTINCT o2.order2) AS nb_commandes
        FROM
            (
            SELECT
                bop.order_id AS order1,
                m.marque AS marque,
                bop.billing_product_ht AS ca1
            FROM
                smallable2_datawarehouse.b_orders bo
            INNER JOIN smallable2_datawarehouse.b_order_products bop ON
                bop.order_id = bo.order_id
            INNER JOIN marques m ON
                bop.sku_id = m.sku_id
            WHERE
                bo.is_valid = 1
                AND bo.is_ca_ht_not_zero = 1
                AND bop.basket_line_type_id = 2
                AND bo.created_at >= '2023-10-01'
    			AND bo.created_at <= '2024-01-21') o1 -- sous requ�te pour sortir tous les paniers, avec l'info du CA par marque
        INNER JOIN (
            SELECT
                bop2.order_id AS order2,
                m2.marque AS marque,
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
                AND bo2.created_at >= '2023-10-01'
   				AND bo2.created_at <= '2024-01-21'
                AND bop2.basket_line_type_id = 2) o2 ON     -- 2�me sous requ�te qui sort la m�me chose
            o1.order1 = o2.order2   -- ON joint les 2 sous requ�tes via l'ORDER ID : �a veut dire que chaque ligne de chaque panier va �tre d�dupliqu�e. Si j'ai une commande avec 3 lignes, �a va me sortir 9 lignes dans cette requ�te
        GROUP BY
            marque1,
            marque2
        ORDER BY
            nb_commandes DESC,
            ca_ht DESC) a
    GROUP BY
        marque1,
        marque2,
        ca_ht,
        nb_commandes) a2
        
        
        
        
select DISTINCT bp.brand_name 
from smallable2_datawarehouse.b_products bp 
--where bp.sml_team = 'design'
--where bp.brand_name ilike 'garbo%'
order by bp.brand_name  asc 
