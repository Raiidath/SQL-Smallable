select
    distinct
 	p.product_id as id_product,
    p.ref_co as ref_co,
    ifNull(pv.actif_inactif,
    0) as actif_inactif,
    p.sml_team as secteur,
    p.saison_achat as saison,
    p.outlet as outlet,
    p.is_permanent as permanent,
    p.buyer as acheteur,
    p.brand_name  as marque,
    concat(marque,
    acheteur) as concat_marque_acheteur,
    p.product_name as libelle,
    max(s.ref_fournisseur) as ref_fournisseur,
    max(s.color_fournisseur) as coul_fournisseur,
    p.color as couleur_SML,
    p.persons as personnes,
   -- p.gender as genre,
    p.gender_mixte AS genre,
    p.product_type_N4_refco  as categorie,
    mel.date_mel as date_mel,
    case
        when mel.date_mel>'2022-04-28' then 1
        else 0
    end as enligne_depuis_2804,
    sum(t.qty_sold)+sum(t.qty_returned) as ventes_nettes,
    p.qty_usable_refco  as stock,
    round(ventes_nettes /(ventes_nettes + stock),
    4) as sell_out,
    round(p.paht_refco / 100,
    2) as pa_ht,
    round(avg(s.price_ht_euro),
    2) as pvp_ht,
    round(sum(t.ca_net_ht),
    2) as ca_ht,
    round(stock * pvp_ht,
    2) as valo_stock,
    jv.nb_jour_vendable as nb_jour_vendable,
    round(ventes_nettes / nb_jour_vendable,
    2) as velocite,
    round(stock / velocite,
    2) as couverture,
    round(avg(t.taux_marge_brute),
    2) as tx_marge_brute,
    case
        when sd.last_sold_date<'2022-04-24' then 1
        else 0
    end as sans_vente_3mois,
    p.value_discount
from
    smallable2_datawarehouse.b_products p
left join smallable2_datawarehouse.b_skus s on
    s.product_id = p.product_id
left join 
(
    select
        distinct product_id,
        case
            when is_active_day = 1 then 1
            when is_active_day = 0 then 0
        end as actif_inactif
    from
        smallable2_datawarehouse.b_skus_x_days
    where
        ref_date = '2022-08-30' )pv on
    pv.product_id = p.product_id
left join (
    select
        tr.sku_id as sku_id,
        sumIf(tr.billing_ht,
        tr.transaction_type_id != 0
            AND tr.item_type_id = 100)/ 100 as ca_net_ht,
        sumIf ( cost_ht,
        transaction_type_id != 0
            and item_type_id = 100)/ 100 as camv_net,
        sumIf(tr.qty,
        tr.transaction_type_id = 1
            AND item_type_id = 100
            and is_partner_web = 1) as qty_sold,
        sumIf(tr.qty,
        tr.transaction_type_id = 1
            AND item_type_id = 100
            and is_partner_web = 0) as qty_sold_shop,
        sumIf (tr.qty,
        tr.transaction_type_id = 2
            and tr.item_type_id = 100
            and tr.refund_product_type = 'return') as qty_returned,
        (((sumIf(billing_ht,
        transaction_type_id != 0
            and item_type_id = 100)/ 100)+
    (sumIf(billing_ht,
        transaction_type_id != 0
            and item_subtype_id = 302)/ 100))+
    (sumIf(- cost_ht,
        transaction_type_id != 0
            and item_type_id = 100)/ 100))/
    ((sumIf(billing_ht,
        transaction_type_id != 0
            and item_type_id = 100)/ 100) +
    (sumIf(billing_ht,
        transaction_type_id != 0
            and item_subtype_id = 302)/ 100)) as taux_marge_brute,
                    (((sumIf(billing_ht,
        transaction_type_id != 0
            and item_type_id = 100)/ 100)+
    (sumIf(billing_ht,
        transaction_type_id != 0
            and item_subtype_id = 302)/ 100))+
    (sumIf(- cost_ht,
        transaction_type_id != 0
            and item_type_id = 100)/ 100)) AS marge,
        ((sumIf(billing_ht,
        transaction_type_id != 0
            and item_type_id = 100)/ 100)-
    (sumIf(catalog_price_ht * qty,
        transaction_type_id != 0
            and item_type_id = 100)/ 100))/
    (sumIf(catalog_price_ht * qty,
        transaction_type_id != 0
            and item_type_id = 100)/ 100) as tx_discount_net_ht
    from
        smallable2_datawarehouse.b_transactions tr
    where
        tr.ref_date_2 between '2021-11-01' and '2022-08-30'
    group by
        sku_id) t on
    t.sku_id = s.sku_id
left join (
    select
        distinct product_id,
        sum(is_active_day) as nb_jour_vendable
    from
        (
        select
            distinct product_id,
            ref_date ,
            is_active_day
        from
            smallable2_datawarehouse.b_skus_x_days
        where
            ref_date between '2021-11-01' and toDate(NOW()-1))
    group by
        product_id
    order by
        nb_jour_vendable desc) jv on
    jv.product_id = p.product_id
left join (
    select
        distinct product_id,
        min(case when is_active_day = 1 then ref_date end) as date_mel
    from
        (
        select
            distinct product_id,
            ref_date ,
            is_active_day
        from
            smallable2_datawarehouse.b_skus_x_days
        where
            ref_date between '2020-05-31' and toDate(NOW()))
    group by
        product_id) mel on
    mel.product_id = p.product_id
left JOIN 
(
    SELECT
        bs.product_id as product_id ,
        max(bop.invoiced_at) as last_sold_date
    from
        smallable2_datawarehouse.b_order_products bop
    left join smallable2_datawarehouse.b_skus bs on
        bs.sku_id = bop.sku_id
    group by
        bs.product_id ) sd on
    sd.product_id = p.product_id
where
    p.outlet = 'NON'
    -- Des produits achetés par des acheteuses mode peuvent être ratachés au Design, dans le cas d'une extraction produit exacte, ne pas prendre la colonne "secteur"
    and acheteur in ('LAURA', 'BEATRICE', 'LOUISE', 'MARYSE', 'KATIA', 'TASSIANA', 'EMILIE' , 'HSIAO-ANNE', 'ALICE', 'AURELIE', 'LUCIE', 'MAYSE', 'VALENTINE', 'ELODIE', 'PAULINE', 'LEA', 'MARINE G')
    --('Aurélie','Beatrice','Emilie','Hsiao-Anne','Katia','Laura','Louise','Maryse','Valentine')
    --and p.manufacturer= 'Anaak'
    --and id_product='40190'
group by
    id_product,
    ref_co,
    actif_inactif,
    secteur,
    saison,
    outlet,
    permanent,
    acheteur,
    marque,
    concat_marque_acheteur,
    libelle,
    --ref_fournisseur,
    --coul_fournisseur,
    couleur_SML,
    personnes,
    genre,
    categorie,
    date_mel,
    enligne_depuis_2804,
    stock,
    pa_ht,
    nb_jour_vendable,
    sans_vente_3mois,
    value_discount 
order by
    ca_ht desc
    
    
  ----------------------------------------------------------------------------------------------------
    
    SELECT
	DISTINCT
    p.product_id AS id_product,
	p.ref_co AS ref_co,
	ifNull(pv.actif_inactif,
	0) AS actif_inactif,
	p.sml_team AS secteur,
	p.saison_achat AS saison,
	p.outlet AS outlet,
	p.is_permanent AS permanent,
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
	p.gender  AS genre,
	p.product_type_N4_refco AS typo_N4,
	p.product_type_N1_refco AS typo_N1,
	mel.date_mel AS date_mel,
	CASE
		WHEN mel.date_mel>'2022-10-01' THEN 1
		ELSE 0
	END AS enligne_depuis_1001,
	sum(t.qty_sold)+ sum(t.qty_returned) AS ventes_nettes,
	p.qty_usable_refco AS stock,
	round(ventes_nettes /(ventes_nettes + stock),
	4) AS sell_out,
	round(p.paht_refco / 100,
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
		WHEN sd.last_sold_date<'2022-09-18' THEN 1
		ELSE 0
	END AS sans_vente_3mois,
	p.value_discount AS discount_actuel,
	pmax.remise_max AS histo_remise_max
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
		ref_date = '2022-12-18' )pv ON
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
		tr.ref_date_2 BETWEEN '2022-04-30' AND toDate(NOW()-1)
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
			ref_date BETWEEN '2022-04-30' AND toDate(NOW()-1))
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
WHERE
	p.outlet = 'NON'
	-- Des produits achetés par des acheteuses mode peuvent être ratachés au Design, dans le cas d'une extraction produit exacte, ne pas prendre la colonne "secteur"
	AND acheteur IN ('LAURA', 'BEATRICE', 'LOUISE', 'MARYSE', 'KATIA', 'TASSIANA', 'EMILIE' , 'HSIAO-ANNE', 'ALICE', 'AURELIE', 'LUCIE', 'MAYSE', 'VALENTINE', 'ELODIE', 'PAULINE', 'LEA', 'MARINE G', 'ELENA B')
	AND p.product_id NOT IN (
	SELECT
		s.p
	FROM
		(
		SELECT
			bs.product_id AS p,
			sum(CASE WHEN bs.quantity_type_id = 1 THEN bs.stock_delta ELSE 0 END) -
	sum(CASE WHEN bs.quantity_type_id IN (4, 5, 6) THEN bs.stock_delta ELSE 0 END) AS stock,
			sum(CASE WHEN bs.ref_date <= '2022-11-18' AND bs.quantity_type_id = 1 THEN bs.stock_delta ELSE 0 END) -
	sum(CASE WHEN bs.ref_date <= '2022-11-18' AND bs.quantity_type_id IN (4, 5, 6) THEN bs.stock_delta ELSE 0 END) AS stock_1m_ago,
			sum(CASE WHEN bs.ref_date > '2022-11-18' AND bs.quantity_type_id = 1 THEN bs.stock_delta ELSE 0 END) -
	sum(CASE WHEN bs.ref_date > '2022-11-18' AND bs.quantity_type_id IN (4, 5, 6) THEN bs.stock_delta ELSE 0 END) AS var_stock_1m
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
	permanent,
	flag,
	acheteur,
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
	enligne_depuis_1001,
	stock,
	pa_ht,
	nb_jour_vendable,
	sans_vente_3mois,
	value_discount,
	histo_remise_max
ORDER BY
	ca_ht DESC
