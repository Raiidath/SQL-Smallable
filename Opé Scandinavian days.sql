SELECT
    s.selection AS selection, 
sum(CASE WHEN bo.created_at between '2023-03-14' AND '2023-03-28' THEN bop.billing_product_ht ELSE NULL END)/100 AS scandi_days,
sum(CASE WHEN bo.created_at between '2023-02-28' AND '2023-03-14' THEN bop.billing_product_ht ELSE NULL END)/100 AS s_1,
sum(CASE WHEN bo.created_at between '2022-03-14' AND '2022-03-28' THEN bop.billing_product_ht ELSE NULL END)/100 AS n_1, 
sum(CASE WHEN bo.created_at between '2023-03-14' AND '2023-03-28' THEN bop.qty_ordered  ELSE NULL END) AS vn_scandi_days,
sum(CASE WHEN bo.created_at between '2023-03-14' AND '2023-03-28' AND bop.code_promo_product ilike '%loyalty%' THEN bop.qty_ordered  ELSE NULL END) AS vn_scandi_days_ope,
sum(CASE WHEN bo.created_at between '2023-02-28' AND '2023-03-14' THEN bop.qty_ordered ELSE NULL END) AS vn_s_1,
sum(CASE WHEN bo.created_at between '2022-03-14' AND '2022-03-28' THEN bop.qty_ordered ELSE NULL END) AS vn_n_1
FROM
    smallable2_datawarehouse.b_orders bo
INNER JOIN smallable2_datawarehouse.b_order_products bop ON
    bop.order_id = bo.order_id
    AND bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    AND bo.created_at between '2022-03-14' AND '2023-03-28'
INNER JOIN smallable2_datawarehouse.b_skus bs ON
    bs.sku_id = bop.sku_id
INNER JOIN smallable2_datawarehouse.b_brands bb ON
    bs.brand_id = bb.brand_id
INNER JOIN smallable2_datawarehouse.b_products bp ON bp.product_id = bs.product_id 
    INNER join (select DISTINCT pv.`_root_code` AS refco, pva.value AS selection from smallable2_akeneo.productModels_values pv
left join smallable2_akeneo.productModels_values_attributes pva on pv.id=pva._parent_id
where  pv.name ='tags' AND pva.value ilike '%scandi%') s ON s.refco = bp.ref_co 
GROUP BY selection
ORDER BY scandi_days DESC