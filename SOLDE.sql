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
    p.gender as genre,
    p.product_type_N4_refco  as categorie,
    mel.date_mel as date_mel,
    case
        when mel.date_mel>'2022-04-28' then 1
        else 0
    end as enligne_depuis_2804,
    sum(t.qty_sold)+sum(t.qty_returned) as ventes_nettes,
    p.qty_usable as stock,
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
        when sd.last_sold_date<'2023-03-01' then 1
        else 0
    end as sans_vente_3mois
from
    smallable2_datawarehouse.b_products p
left join smallable2_datawarehouse.b_skus s on
    s.product_id = p.product_id
left join 
(
    select
        distinct product_id,
        case
            when is_product_active_day = 1 then 1
            when is_product_active_day = 0 then 0
        end as actif_inactif
    from
        smallable2_datawarehouse.b_skus_x_days
    where
        ref_date = '2022-05-31' )pv on
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
        tr.ref_date_2 between '2021-11-01' and '2022-05-31'
    group by
        sku_id) t on
    t.sku_id = s.sku_id
left join (
    select
        distinct product_id,
        sum(is_product_active_day) as nb_jour_vendable
    from
        (
        select
            distinct product_id,
            ref_date ,
            is_product_active_day
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
        min(case when is_product_active_day = 1 then ref_date end) as date_mel
    from
        (
        select
            distinct product_id,
            ref_date ,
            is_product_active_day
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
    sans_vente_3mois
order by
    ca_ht desc