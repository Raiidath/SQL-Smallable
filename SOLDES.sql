SELECT
	DISTINCT
    p.product_id AS id_product,
	p.ref_co AS ref_co,
	ifNull(pv.actif_inactif,
	0) AS actif_inactif,
	p.sml_team AS secteur,
	p.saison_achat AS saison,
	p.outlet AS outlet,
	p.is_reconduit AS reconduit,
	p.flag AS flag,
	p.buyer AS acheteur,
	p.brand_name AS marque,
	concat(marque,
	acheteur) AS concat_marque_acheteur,
	p.product_name AS libelle,
	max(s.ref_fournisseur) AS ref_fournisseur,
	max(s.color_fournisseur) AS coul_fournisseur,
	p.color AS couleur_SML,
	p.persons AS personnes,
	p.gender AS genre,
	s.cible,
	p.product_type_N4_refco AS typo_N4,
	p.product_type_N1_refco AS typo_N1,
	mel.date_mel AS date_mel,
	CASE
		WHEN mel.date_mel>'2023-10-01' THEN 1
		ELSE 0
	END AS enligne_depuis_1er_oct,
	sum(t.qty_sold)+ sum(t.qty_returned) AS ventes_nettes,
	p.qty_usable_refco AS stock,
	round(ventes_nettes /(ventes_nettes + stock),
	4) AS sell_out,
	round(s.paht / 10000,
	2) AS pa_ht,
	round(avg(s.price_ht_euro),
	2) AS pvp_ht,
	round(sum(t.ca_net_ht),
	2) AS ca_ht,
	round(stock * pvp_ht,
	2) AS valo_stock,
	jv.nb_jour_vendable AS nb_jour_vendable,
	round(ventes_nettes / nb_jour_vendable,
	2) AS velocite,
	round(stock / velocite,
	2) AS couverture,
	round(avg(t.taux_marge_brute),
	2) AS tx_marge_brute,
	CASE
		WHEN sd.last_sold_date<toDate(NOW()-92*86400) THEN 1
		ELSE 0
	END AS sans_vente_3mois,
	p.value_discount AS discount_actuel,
	pmax.remise_max AS histo_remise_max,
	s_ge.discount AS discount_ge,
	s_fr.discount AS discount_fr,
	s_eu.discount AS discount_eu
FROM
	smallable2_datawarehouse.b_products p
LEFT JOIN smallable2_datawarehouse.b_skus s ON
	s.product_id = p.product_id
LEFT JOIN 
(
	SELECT
		DISTINCT product_id,
		CASE
			WHEN is_active_day = 1 THEN 1
			WHEN is_active_day = 0 THEN 0
		END AS actif_inactif
	FROM
		smallable2_datawarehouse.b_skus_x_days
	WHERE
		ref_date = toDate(NOW()-86400) )pv ON
	pv.product_id = p.product_id
LEFT JOIN (
	SELECT
		tr.sku_id AS sku_id,
		sumIf(tr.billing_ht,
		tr.transaction_type_id != 0
			AND tr.item_type_id = 100)/ 100 AS ca_net_ht,
		sumIf ( cost_ht,
		transaction_type_id != 0
			AND item_type_id = 100)/ 100 AS camv_net,
		sumIf(tr.qty,
		tr.transaction_type_id = 1
			AND item_type_id = 100
			AND is_partner_web = 1) AS qty_sold,
		sumIf(tr.qty,
		tr.transaction_type_id = 1
			AND item_type_id = 100
			AND is_partner_web = 0) AS qty_sold_shop,
		sumIf (tr.qty,
		tr.transaction_type_id = 2
			AND tr.item_type_id = 100
			AND tr.refund_product_type = 'return') AS qty_returned,
		(((sumIf(billing_ht,
		transaction_type_id != 0
			AND item_type_id = 100)/ 100)+
    (sumIf(billing_ht,
		transaction_type_id != 0
			AND item_subtype_id = 302)/ 100))+
    (sumIf(- cost_ht,
		transaction_type_id != 0
			AND item_type_id = 100)/ 100))/
    ((sumIf(billing_ht,
		transaction_type_id != 0
			AND item_type_id = 100)/ 100) +
    (sumIf(billing_ht,
		transaction_type_id != 0
			AND item_subtype_id = 302)/ 100)) AS taux_marge_brute,
		(((sumIf(billing_ht,
		transaction_type_id != 0
			AND item_type_id = 100)/ 100)+
    (sumIf(billing_ht,
		transaction_type_id != 0
			AND item_subtype_id = 302)/ 100))+
    (sumIf(- cost_ht,
		transaction_type_id != 0
			AND item_type_id = 100)/ 100)) AS marge,
		((sumIf(billing_ht,
		transaction_type_id != 0
			AND item_type_id = 100)/ 100)-
    (sumIf(catalog_price_ht * qty,
		transaction_type_id != 0
			AND item_type_id = 100)/ 100))/
    (sumIf(catalog_price_ht * qty,
		transaction_type_id != 0
			AND item_type_id = 100)/ 100) AS tx_discount_net_ht
	FROM
		smallable2_datawarehouse.b_transactions tr
	WHERE
		tr.ref_date_2 BETWEEN '2023-04-14' AND toDate(NOW()-1)
	GROUP BY
		sku_id) t ON
	t.sku_id = s.sku_id
LEFT JOIN (
	SELECT
		DISTINCT product_id,
		sum(is_active_day) AS nb_jour_vendable
	FROM
		(
		SELECT
			DISTINCT product_id,
			ref_date ,
			is_active_day
		FROM
			smallable2_datawarehouse.b_skus_x_days
		WHERE
			ref_date BETWEEN '2023-04-14' AND toDate(NOW()-1))
	GROUP BY
		product_id
	ORDER BY
		nb_jour_vendable DESC) jv ON
	jv.product_id = p.product_id
LEFT JOIN (
	SELECT
		DISTINCT product_id,
		min(CASE WHEN is_active_day = 1 THEN ref_date END) AS date_mel
	FROM
		(
		SELECT
			DISTINCT product_id,
			ref_date ,
			is_active_day
		FROM
			smallable2_datawarehouse.b_skus_x_days
		WHERE
			ref_date BETWEEN '2020-04-30' AND toDate(NOW()))
	GROUP BY
		product_id) mel ON
	mel.product_id = p.product_id
LEFT JOIN (
	SELECT
		bs.product_id AS product_id ,
		max(bop.invoiced_at) AS last_sold_date
	FROM
		smallable2_datawarehouse.b_order_products bop
	LEFT JOIN smallable2_datawarehouse.b_skus bs ON
		bs.sku_id = bop.sku_id
	GROUP BY
		bs.product_id ) sd ON
	sd.product_id = p.product_id
LEFT JOIN (
	SELECT
		DISTINCT bp.ref_co AS ref_co,
		max(CASE WHEN isNaN(bop.discount_product_rate) THEN NULL ELSE bop.discount_product_rate END) AS remise_max
	FROM
		smallable2_datawarehouse.b_order_products bop
	LEFT JOIN smallable2_datawarehouse.b_skus bs ON
		bs.sku_id = bop.sku_id
	LEFT JOIN smallable2_datawarehouse.b_products bp ON
		bs.product_id = bp.product_id
	LEFT JOIN smallable2_datawarehouse.b_orders bo ON
		bo.order_id = bop.order_id
	LEFT JOIN smallable2_datawarehouse.b_customers bc ON
		bo.customer_id = bc.customer_id
	WHERE
		bo.is_valid = 1
		AND bo.is_ca_ht_not_zero = 1
		AND bc.is_mail_smallable = 'NON'
		AND bop.is_contribution = 0
	GROUP BY
		bp.ref_co
	ORDER BY
		remise_max DESC		
		) pmax ON
	p.ref_co = pmax.ref_co
LEFT JOIN (SELECT dp.id_product AS pid, dp.value AS discount FROM smallable2_descriptor.discount_product dp WHERE dp.id_discount = 56) s_ge ON s_ge.pid = p.product_id
LEFT JOIN (SELECT dp.id_product AS pid, dp.value AS discount FROM smallable2_descriptor.discount_product dp WHERE dp.id_discount = 58) s_fr ON s_fr.pid = p.product_id
LEFT JOIN (SELECT dp.id_product AS pid, dp.value AS discount FROM smallable2_descriptor.discount_product dp WHERE dp.id_discount = 57) s_eu ON s_eu.pid = p.product_id
WHERE
    --s.cible in ('Adulte','Homme', 'Femme') AND
	p.outlet = 'NON'
	AND saison != 'PE24'
	-- Des produits achetés par des acheteuses mode peuvent être ratachés au Design, dans le cas d'une extraction produit exacte, ne pas prendre la colonne "secteur"
	AND acheteur IN ('SERPIL','LAURA', 'BEATRICE', 'LOUISE', 'MARYSE', 'KATIA', 'TASSIANA', 'EMILIE' , 'HSIAO-ANNE', 'ALICE', 'AURELIE', 'LUCIE', 'MAYSE', 'VALENTINE', 'ELODIE', 'PAULINE', 'PAULINE M', 'LEA', 'MARINE G', 'ELENA B', 'MARLENE', 'MARLèNE', 'OPHELIE', 'ELENA', 'IRIS')
	--AND pv.actif_inactif = 1
	AND p.product_id NOT IN (
	SELECT
		s.p
	FROM
		(
		SELECT
			bs.product_id AS p,
			sum(CASE WHEN bs.quantity_type_id = 1 THEN bs.stock_delta ELSE 0 END) -
	sum(CASE WHEN bs.quantity_type_id IN (4, 5, 6) THEN bs.stock_delta ELSE 0 END) AS stock,
			sum(CASE WHEN bs.ref_date <= toDate(NOW()-31*86400) AND bs.quantity_type_id = 1 THEN bs.stock_delta ELSE 0 END) -
	sum(CASE WHEN bs.ref_date <= toDate(NOW()-31*86400) AND bs.quantity_type_id IN (4, 5, 6) THEN bs.stock_delta ELSE 0 END) AS stock_1m_ago,
			sum(CASE WHEN bs.ref_date > toDate(NOW()-31*86400) AND bs.quantity_type_id = 1 THEN bs.stock_delta ELSE 0 END) -
	sum(CASE WHEN bs.ref_date > toDate(NOW()-31*86400) AND bs.quantity_type_id IN (4, 5, 6) THEN bs.stock_delta ELSE 0 END) AS var_stock_1m
		FROM
			smallable2_datawarehouse.b_stocks bs
		GROUP BY
			p
		) s
	WHERE
		s.stock_1m_ago <= 0
		AND s.var_stock_1m = 0)
GROUP BY
	id_product,
	ref_co,
	actif_inactif,
	secteur,
	saison,
	outlet,
	reconduit,
	flag,
	acheteur,
	cible,
	marque,
	concat_marque_acheteur,
	libelle,
	--ref_fournisseur,
	--coul_fournisseur,
	couleur_SML,
	personnes,
	genre,
	typo_N1,
	typo_N4,
	date_mel,
	enligne_depuis_1er_oct,
	stock,
	pa_ht,
	nb_jour_vendable,
	sans_vente_3mois,
	value_discount,
	histo_remise_max,
	discount_ge,
	discount_eu,
	discount_fr
ORDER BY
	ca_ht DESC
	
	
	
	
	
	
	
SELECT DISTINCT id_discount  --p.value_discount, p.disc 
	FROM  smallable2_descriptor.discount_product dp
	--smallable2_datawarehouse.b_products p
	--WHERE dp.id_discount = 44
	

SELECT DISTINCT discount_id, discount_type  
FROM smallable2_datawarehouse.tmp_agg_discount_product tadp 
	
	
	
	
SELECT s.pah FROM smallable2_datawarehouse.b_skus s 

	
	
	SELECT DISTINCT bp.buyer FROM smallable2_datawarehouse.b_products bp 
	
	SELECT * FROM smallable2_descriptor.discount d 
	
	SELECT DISTINCT s.cible--, s.sku_code  
	FROM smallable2_datawarehouse.b_skus s
	
	AND  s.cible in ('BB/Enf/Ado','Bébé', 'Enfant', 'Adolescent')
	
	
	SELECT 	p.persons AS personnes,p.brand_name AS marque, p.buyer AS acheteur,
	FROM
		smallable2_datawarehouse.b_order_products bop
	LEFT JOIN smallable2_datawarehouse.b_skus bs ON
		bs.sku_id = bop.sku_id
	LEFT JOIN smallable2_datawarehouse.b_products bp ON
		bs.product_id = bp.product_id
	LEFT JOIN smallable2_datawarehouse.b_orders bo ON
		bo.order_id = bop.order_id
	LEFT JOIN smallable2_datawarehouse.b_customers bc ON
		bo.customer_id = bc.customer_id
	WHERE
		bo.is_valid = 1
		AND bo.is_ca_ht_not_zero = 1
		AND bc.is_mail_smallable = 'NON'
		AND bop.is_contribution = 0
	GROUP BY