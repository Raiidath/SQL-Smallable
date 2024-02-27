select bo.basket_id , bp.product_id, bp.product_name , count(distinct bo.order_id), sum(bop.billing_product_ht/100)
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.order_id = bo.order_id
	AND bop.basket_id = bo.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
inner join smallable2_datawarehouse.b_skus bs 
on
	bop.sku_code = bs.sku_code
inner join smallable2_datawarehouse.b_products bp 
on
	bp.product_id = bs.product_id
where bp.brand_id  = '734'
and bo.created_at >= '2021-05-09' and bo.created_at <= '2021-05-30'
group by bp.product_id , bp.product_name, bo.basket_id  