---- BDD Saison 
----récupère toutes les SKUS achetés dans chaque saison
WITH saison AS (SELECT
CASE
WHEN LEFT(trim(so.reference),4) = 'PE24' THEN 'PE24'
WHEN LEFT(trim(so.reference),4) = 'AH23' THEN 'AH23'
WHEN LEFT(trim(so.reference),4) = 'PE23' THEN 'PE23'
WHEN LEFT(trim(so.reference),4) = 'AH22' THEN 'AH22'
WHEN LEFT(trim(so.reference),4) = 'PE22' THEN 'PE22'
WHEN LEFT(trim(so.reference),4) = 'AH21' THEN 'AH21'
WHEN LEFT(trim(so.reference),4) = 'PE21' THEN 'PE21'
WHEN LEFT(trim(so.reference),3) = 'A24' THEN 'AH24'
WHEN LEFT(trim(so.reference),3) = 'P24' THEN 'PE24'
WHEN LEFT(trim(so.reference),3) = 'A23' THEN 'AH23'
WHEN LEFT(trim(so.reference),3) = 'P23' THEN 'PE23'
WHEN LEFT(trim(so.reference),3) = 'A22' THEN 'AH22'
WHEN LEFT(trim(so.reference),3) = 'P22' THEN 'PE22'
WHEN LEFT(trim(so.reference),3) = 'A21' THEN 'AH21'
WHEN LEFT(trim(so.reference),3) = 'P21' THEN 'PE21'
WHEN LEFT(trim(so.reference),3) = 'A20' THEN 'AH20'
WHEN LEFT(trim(so.reference),3) = 'P20' THEN 'PE20'
WHEN LEFT(trim(so.reference),3) = 'A19' THEN 'AH19'
WHEN LEFT(trim(so.reference),3) = 'P19' THEN 'PE19'
WHEN LEFT(trim(so.reference),3) = 'A18' THEN 'AH18'
WHEN LEFT(trim(so.reference),3) = 'P18' THEN 'PE18'
WHEN LEFT(trim(so.reference),3) = 'A17' THEN 'AH17'
WHEN LEFT(trim(so.reference),3) = 'P17' THEN 'PE17'
ELSE NULL END AS s,
sod.declinaison_id,
d.id_product AS pid,
d.reference,
so.reference
FROM
smallable2_descriptor.supply_order so
INNER JOIN smallable2_descriptor.supply_order_detail sod ON sod.supply_order_id = so.id
INNER JOIN smallable2_descriptor.declinaison d ON sod.declinaison_id = d.id
),
----- stock à date ----
stock_n AS (
SELECT
bs.sku_id AS s,
sum(CASE WHEN bs.quantity_type_id = 1 THEN bs.stock_delta ELSE 0 END) -
sum(CASE WHEN bs.quantity_type_id IN (4, 5, 6) THEN bs.stock_delta ELSE 0 END) AS stock_n
FROM
smallable2_datawarehouse.b_stocks bs
GROUP BY
s),
----- stocks n-1 -----
stock_n1 AS (
SELECT
bs.sku_id AS s,
sum(CASE WHEN bs.quantity_type_id = 1 THEN bs.stock_delta ELSE 0 END) -
sum(CASE WHEN bs.quantity_type_id IN (4, 5, 6) THEN bs.stock_delta ELSE 0 END) AS stock_n1
FROM
smallable2_datawarehouse.b_stocks bs
WHERE
bs.ref_date < date_sub(YEAR, 1, today())
GROUP BY
s),
----- stocks S-1 -----
stock_s1 AS (
SELECT
bs.sku_id AS s,
sum(CASE WHEN bs.quantity_type_id = 1 THEN bs.stock_delta ELSE 0 END) -
sum(CASE WHEN bs.quantity_type_id IN (4, 5, 6) THEN bs.stock_delta ELSE 0 END) AS stock_s1
FROM
smallable2_datawarehouse.b_stocks bs
WHERE
bs.ref_date < date_sub(week, 1, today())
GROUP BY
s)
------------------ REQUÊTE ------------------
SELECT
v.*, s.stock_pe23, s.stock_pe23_s1, s.stock_pe22, s.stock_residuel, s.stock_residuel_s1
FROM
----------- sous requête partie ventes ----------
(
SELECT
bs.personne_ordre AS personne,
bs.univers AS univers,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < today() THEN bop.qty_ordered - bop.qty_canceled ELSE NULL END) AS vn_PE23,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < date_sub(WEEK, 1, today()) THEN bop.qty_ordered - bop.qty_canceled ELSE NULL END) AS vn_PE23s1,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE23') AND bo.invoiced_at > '2022-10-15' AND bo.invoiced_at < date_sub(YEAR, 1, today()) THEN bop.qty_ordered - bop.qty_canceled ELSE NULL END) AS vn_pe22,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < today() THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_PE23,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < date_sub(WEEK, 1, today()) THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_PE23s1,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE23') AND bo.invoiced_at > '2022-10-15' AND bo.invoiced_at < date_sub(YEAR, 1, today()) THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_pe22,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < today() THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_PE23,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < date_sub(WEEK, 1, today()) THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_PE23s1,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE23') AND bo.invoiced_at > '2022-10-15' AND bo.invoiced_at < date_sub(YEAR, 1, today()) THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_pe22,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s != 'PE24' AND s IS NOT NULL) AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < today() THEN bop.qty_ordered - bop.qty_canceled ELSE NULL END) AS vn_residuel,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s != 'PE24' AND s IS NOT NULL) AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < date_sub(WEEK, 1, today()) THEN bop.qty_ordered - bop.qty_canceled ELSE NULL END) AS vn_residuels1,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s != 'PE24' AND s IS NOT NULL) AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < today() THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_residuel23,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s != 'PE24' AND s IS NOT NULL) AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < date_sub(WEEK, 1, today()) THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_residuels1,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s != 'PE24' AND s IS NOT NULL) AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < today() THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_residuel23,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s != 'PE24' AND s IS NOT NULL) AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < date_sub(WEEK, 1, today()) THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_residuels1
FROM
smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
bo.order_id = bop.order_id
AND bo.is_valid = 1
AND bo.is_ca_net_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_products bp ON
bop.product_id = bp.product_id
INNER JOIN smallable2_datawarehouse.b_skus bs ON
bs.sku_id = bop.sku_id
WHERE
bp.sml_team = 'mode'
AND bs.univers NOT IN ('Masques', 'na')
AND bs.personne_ordre != 'na'
GROUP BY
personne,
univers
ORDER BY
personne ASC,
univers ASC) v
----------- sous requête partie stock ----------
LEFT JOIN (
SELECT
bs.personne_ordre AS personne,
bs.univers AS univers,
sum(CASE WHEN bp.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') THEN sn.stock_n ELSE NULL END) AS stock_pe23,
sum(CASE WHEN bp.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') THEN ss1.stock_s1 ELSE NULL END) AS stock_pe23_s1,
sum(CASE WHEN bp.product_id IN (SELECT pid FROM saison WHERE s = 'PE23') THEN sn1.stock_n1 ELSE NULL END) AS stock_pe22,
sum(CASE WHEN bp.product_id IN (SELECT pid FROM saison WHERE s != 'PE24' AND s IS NOT NULL) AND bp.product_id NOT IN (SELECT pid FROM saison WHERE s = 'PE24') THEN sn.stock_n ELSE NULL END) AS stock_residuel,
sum(CASE WHEN bp.product_id IN (SELECT pid FROM saison WHERE s != 'PE24' AND s IS NOT NULL) AND bp.product_id NOT IN (SELECT pid FROM saison WHERE s = 'PE24') THEN ss1.stock_s1 ELSE NULL END) AS stock_residuel_s1
FROM
smallable2_datawarehouse.b_products bp
INNER JOIN smallable2_datawarehouse.b_skus bs ON
bs.product_id = bp.product_id
LEFT JOIN stock_n sn ON
sn.s = bs.sku_id
LEFT JOIN stock_n1 sn1 ON
sn1.s = bs.sku_id
LEFT JOIN stock_s1 ss1 ON
ss1.s = bs.sku_id
WHERE
bp.sml_team = 'mode'
AND bs.univers NOT IN ('Masques', 'na')
AND bs.personne_ordre != 'na'
GROUP BY
personne,
univers
ORDER BY
personne ASC,
univers ASC) s ON
v.personne || v.univers = s.personne || s.univers
---------------- requête pour les graphs ------------------




----BDD jour par jour
----récupère toutes les SKUS achetés dans chaque saison
WITH saison AS (SELECT
CASE
WHEN LEFT(trim(so.reference),4) = 'PE24' THEN 'PE24'
WHEN LEFT(trim(so.reference),4) = 'AH23' THEN 'AH23'
WHEN LEFT(trim(so.reference),4) = 'PE23' THEN 'PE23'
WHEN LEFT(trim(so.reference),4) = 'AH22' THEN 'AH22'
WHEN LEFT(trim(so.reference),4) = 'PE22' THEN 'PE22'
WHEN LEFT(trim(so.reference),4) = 'AH21' THEN 'AH21'
WHEN LEFT(trim(so.reference),4) = 'PE21' THEN 'PE21'
WHEN LEFT(trim(so.reference),3) = 'A24' THEN 'AH24'
WHEN LEFT(trim(so.reference),3) = 'P24' THEN 'PE24'
WHEN LEFT(trim(so.reference),3) = 'A23' THEN 'AH23'
WHEN LEFT(trim(so.reference),3) = 'P23' THEN 'PE23'
WHEN LEFT(trim(so.reference),3) = 'A22' THEN 'AH22'
WHEN LEFT(trim(so.reference),3) = 'P22' THEN 'PE22'
WHEN LEFT(trim(so.reference),3) = 'A21' THEN 'AH21'
WHEN LEFT(trim(so.reference),3) = 'P21' THEN 'PE21'
WHEN LEFT(trim(so.reference),3) = 'A20' THEN 'AH20'
WHEN LEFT(trim(so.reference),3) = 'P20' THEN 'PE20'
WHEN LEFT(trim(so.reference),3) = 'A19' THEN 'AH19'
WHEN LEFT(trim(so.reference),3) = 'P19' THEN 'PE19'
WHEN LEFT(trim(so.reference),3) = 'A18' THEN 'AH18'
WHEN LEFT(trim(so.reference),3) = 'P18' THEN 'PE18'
WHEN LEFT(trim(so.reference),3) = 'A17' THEN 'AH17'
WHEN LEFT(trim(so.reference),3) = 'P17' THEN 'PE17'
ELSE NULL END AS s,
sod.declinaison_id,
d.id_product AS pid,
d.reference,
so.reference
FROM
smallable2_descriptor.supply_order so
INNER JOIN smallable2_descriptor.supply_order_detail sod ON sod.supply_order_id = so.id
INNER JOIN smallable2_descriptor.declinaison d ON sod.declinaison_id = d.id )
SELECT
bs.personne_ordre AS personne,
bs.univers AS univers,
toStartOfWeek(bo.invoiced_at, 1) AS invoiced_at,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') THEN bop.qty_ordered - bop.qty_canceled ELSE NULL END) AS vn_pe23,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE23') THEN bop.qty_ordered - bop.qty_canceled ELSE NULL END) AS vn_pe22
FROM
smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
bo.order_id = bop.order_id
AND bo.is_valid = 1
AND bo.is_ca_net_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_products bp ON
bop.product_id = bp.product_id
INNER JOIN smallable2_datawarehouse.b_skus bs ON
bs.sku_id = bop.sku_id
WHERE
bp.sml_team = 'mode'
AND bs.univers NOT IN ('Masques', 'na')
AND bs.personne_ordre != 'na'
GROUP BY
personne,
univers,
invoiced_at
ORDER BY
vn_pe23 desc





----BDD Marque
----récupère toutes les SKUS achetés dans chaque saison
WITH saison AS (SELECT
CASE
WHEN LEFT(trim(so.reference),4) = 'PE24' THEN 'PE24'
WHEN LEFT(trim(so.reference),4) = 'AH23' THEN 'AH23'
WHEN LEFT(trim(so.reference),4) = 'PE23' THEN 'PE23'
WHEN LEFT(trim(so.reference),4) = 'AH22' THEN 'AH22'
WHEN LEFT(trim(so.reference),4) = 'PE22' THEN 'PE22'
WHEN LEFT(trim(so.reference),4) = 'AH21' THEN 'AH21'
WHEN LEFT(trim(so.reference),4) = 'PE21' THEN 'PE21'
WHEN LEFT(trim(so.reference),3) = 'A24' THEN 'AH24'
WHEN LEFT(trim(so.reference),3) = 'P24' THEN 'PE24'
WHEN LEFT(trim(so.reference),3) = 'A23' THEN 'AH23'
WHEN LEFT(trim(so.reference),3) = 'P23' THEN 'PE23'
WHEN LEFT(trim(so.reference),3) = 'A22' THEN 'AH22'
WHEN LEFT(trim(so.reference),3) = 'P22' THEN 'PE22'
WHEN LEFT(trim(so.reference),3) = 'A21' THEN 'AH21'
WHEN LEFT(trim(so.reference),3) = 'P21' THEN 'PE21'
WHEN LEFT(trim(so.reference),3) = 'A20' THEN 'AH20'
WHEN LEFT(trim(so.reference),3) = 'P20' THEN 'PE20'
WHEN LEFT(trim(so.reference),3) = 'A19' THEN 'AH19'
WHEN LEFT(trim(so.reference),3) = 'P19' THEN 'PE19'
WHEN LEFT(trim(so.reference),3) = 'A18' THEN 'AH18'
WHEN LEFT(trim(so.reference),3) = 'P18' THEN 'PE18'
WHEN LEFT(trim(so.reference),3) = 'A17' THEN 'AH17'
WHEN LEFT(trim(so.reference),3) = 'P17' THEN 'PE17'
ELSE NULL END AS s,
sod.declinaison_id,
d.id_product AS pid,
d.reference,
so.reference
FROM
smallable2_descriptor.supply_order so
INNER JOIN smallable2_descriptor.supply_order_detail sod ON sod.supply_order_id = so.id
INNER JOIN smallable2_descriptor.declinaison d ON sod.declinaison_id = d.id
),
----- stock à date ----
stock_n AS (
SELECT
bs.sku_id AS s,
sum(CASE WHEN bs.quantity_type_id = 1 THEN bs.stock_delta ELSE 0 END) -
sum(CASE WHEN bs.quantity_type_id IN (4, 5, 6) THEN bs.stock_delta ELSE 0 END) AS stock_n
FROM
smallable2_datawarehouse.b_stocks bs
GROUP BY
s),
----- stocks n-1 -----
stock_n1 AS (
SELECT
bs.sku_id AS s,
sum(CASE WHEN bs.quantity_type_id = 1 THEN bs.stock_delta ELSE 0 END) -
sum(CASE WHEN bs.quantity_type_id IN (4, 5, 6) THEN bs.stock_delta ELSE 0 END) AS stock_n1
FROM
smallable2_datawarehouse.b_stocks bs
WHERE
bs.ref_date < date_sub(YEAR, 1, today())
GROUP BY
s),
----- stocks S-1 -----
stock_s1 AS (
SELECT
bs.sku_id AS s,
sum(CASE WHEN bs.quantity_type_id = 1 THEN bs.stock_delta ELSE 0 END) -
sum(CASE WHEN bs.quantity_type_id IN (4, 5, 6) THEN bs.stock_delta ELSE 0 END) AS stock_s1
FROM
smallable2_datawarehouse.b_stocks bs
WHERE
bs.ref_date < date_sub(week, 1, today())
GROUP BY
s)
------------------ REQUÊTE ------------------
SELECT
v.*, s.stock_pe23, s.stock_pe23_s1, s.stock_pe22, s.stock_date_anciennes_saisons
FROM
----------- sous requête partie ventes ----------
(
SELECT
bs.personne_ordre AS personne,
bp.brand_name AS marque,
bp.buyer AS buyer,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < today() THEN bop.qty_ordered - bop.qty_canceled ELSE NULL END) AS vn_PE23,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < date_sub(WEEK, 1, today()) THEN bop.qty_ordered - bop.qty_canceled ELSE NULL END) AS vn_PE23s1,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE23') AND bo.invoiced_at > '2022-10-15' AND bo.invoiced_at < date_sub(YEAR, 1, today()) THEN bop.qty_ordered - bop.qty_canceled ELSE NULL END) AS vn_pe22,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < today() THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_PE23,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < date_sub(WEEK, 1, today()) THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_PE23s1,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE23') AND bo.invoiced_at > '2022-10-15' AND bo.invoiced_at < date_sub(YEAR, 1, today()) THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_pe22,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < today() THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_PE23,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') AND bo.invoiced_at > '2023-10-14' AND bo.invoiced_at < date_sub(WEEK, 1, today()) THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_PE23s1,
sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s = 'PE23') AND bo.invoiced_at > '2022-10-15' AND bo.invoiced_at < date_sub(YEAR, 1, today()) THEN (bop.billing_product_ht - bop.cost_product_ht) / 100 ELSE NULL END) AS marge_pe22
--,sum(CASE WHEN bop.product_id IN (SELECT pid FROM saison WHERE s != 'PE23') AND bo.invoiced_at > '2023-04-14' AND bo.invoiced_at < today() THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca_PE23_anciens_produits
FROM
smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
bo.order_id = bop.order_id
AND bo.is_valid = 1
AND bo.is_ca_net_ht_not_zero = 1
INNER JOIN smallable2_datawarehouse.b_products bp ON
bop.product_id = bp.product_id
INNER JOIN smallable2_datawarehouse.b_skus bs ON
bs.sku_id = bop.sku_id
WHERE
bp.sml_team = 'mode'
AND bs.univers NOT IN ('Masques', 'na')
AND bs.personne_ordre != 'na'
GROUP BY
personne,
marque,
buyer
ORDER BY
vn_PE23 desc) v
----------- sous requête partie stock ----------
LEFT JOIN (
SELECT
bs.personne_ordre AS personne,
bp.brand_name AS marque,
bp.buyer AS buyer,
sum(CASE WHEN bp.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') THEN sn.stock_n ELSE NULL END) AS stock_pe23,
sum(CASE WHEN bp.product_id IN (SELECT pid FROM saison WHERE s = 'PE24') THEN ss1.stock_s1 ELSE NULL END) AS stock_pe23_s1,
sum(CASE WHEN bp.product_id IN (SELECT pid FROM saison WHERE s = 'PE23') THEN sn1.stock_n1 ELSE NULL END) AS stock_pe22,
sum(CASE WHEN bp.product_id IN (SELECT pid FROM saison WHERE s != 'PE24' AND s IS NOT NULL) AND bp.product_id NOT IN (SELECT pid FROM saison WHERE s = 'AH23') THEN sn.stock_n ELSE NULL END) AS stock_date_anciennes_saisons
FROM
smallable2_datawarehouse.b_products bp
INNER JOIN smallable2_datawarehouse.b_skus bs ON
bs.product_id = bp.product_id
LEFT JOIN stock_n sn ON
sn.s = bs.sku_id
LEFT JOIN stock_n1 sn1 ON
sn1.s = bs.sku_id
LEFT JOIN stock_s1 ss1 ON
ss1.s = bs.sku_id
WHERE
bp.sml_team = 'mode'
AND bs.univers NOT IN ('Masques', 'na')
AND bs.personne_ordre != 'na'
GROUP BY
personne,
marque,
buyer
ORDER BY
personne ASC,
marque ASC) s ON
v.personne || v.marque || v.buyer = s.personne || s.marque || s.buyer