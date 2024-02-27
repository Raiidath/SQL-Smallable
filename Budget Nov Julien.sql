--Dans ce contexte est ce que tu pourrais nous sortir les données suivantes en vision
  -- Mois par mois depuis Août 22 à Oct 23 (au 24/10/23) et par regroupement de zones pays finance (FR, DE, UK, US etc)
--Mode : CA produits net  + Ventes nettes + PVP moyen HT Mode + Nb articles par panier
  -- + TMB + taux de discount moyen avec le split AH / PE /Perm / Outlet et le split Enfant / Adulte

SELECT 
	--toStartOfMonth(bo.created_at) as week, 
	bc.zone_code AS ZONE,
	sum(bop.billing_product_ht)/ 100 AS CA,
	count(distinct bo.order_id) as ventes, 
	sum(bop.qty_ordered) as Nb,
	CA/ventes AS PM, 
	Nb/ventes AS Nb_pan
FROM
		smallable2_datawarehouse.b_orders bo
	inner join smallable2_datawarehouse.b_countries bc
	on
	bc.country_id = bo.delivery_country_id 
	INNER JOIN smallable2_datawarehouse.b_order_products bop ON
	bop.order_id = bo.order_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	inner join smallable2_datawarehouse.b_skus bs 
	on
	bs.sku_code = bop.sku_code 
	inner join smallable2_datawarehouse.b_products bp 
	on
	bp.product_id = bs.product_id 
	AND bp.sml_team = 'mode'
WHERE
	bo.created_at BETWEEN '2022-08-01' AND '2023-10-24' 
GROUP BY-- week,
ZONE
	
	
--Design : CA produits + Ventes nettes + PVP moyen HT + Nb articles par panier + TMB + 
  --taux de discount moyen avec le split par famille de produit (Déco, Jouets, ...) et le split Enfant / Adulte

