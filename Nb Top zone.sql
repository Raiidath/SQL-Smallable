select
	bc.country_name as Pays, --bop.delivery_country_iso as zone,
	count(DISTINCT CASE WHEN bo.created_at >= '2021-08-21' AND bo.created_at <= '2022-08-21' THEN bo.order_id ELSE NULL END) AS cmd,
	sum(CASE WHEN bo.created_at >= '2021-08-21' AND bo.created_at <= '2022-08-21' THEN bop.billing_product_ht / 100 ELSE NULL END) AS ca
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.product_id = bs.product_id
inner join smallable2_datawarehouse.b_orders bo 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
inner join smallable2_datawarehouse.b_countries bc 
on bop.delivery_country_iso = bc.country_iso_code 
where
	bs.brand_id  in ('933', '1341', '1446', '1293', '1169','1294', '732', '1292', '324', '75')
	AND bo.created_at >= '2021-08-21' AND bo.created_at <= '2022-08-21'
group by Pays
order by
	ca desc
	

select bop.delivery_country_iso ,sum(case when bop.basket_created_at  >= '2021-08-21' AND  bop.basket_created_at <= '2022-08-21' then bop.billing_product_ht/100 else null end), count(distinct order_id)
from smallable2_datawarehouse.b_order_products bop 
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.product_id = bs.product_id
where
	bs.brand_id in ('933', '1341', '1446', '1293', '1169','1294', '732', '1292', '324', '75')
	AND bop.basket_created_at  >= '2021-08-21' AND  bop.basket_created_at <= '2022-08-21'
group by bop.delivery_country_iso

	