select count (case when cv.validated = 1 then cv.id else null end)--, count(distinct cv.)
from smallable2_front.commercial_voucher cv	
where cv.code in ('JUST4YOU000001', 'JUST4YOU065804')


select *
from smallable2_front.commercial_voucher cv 

select 
	count(distinct case when bl.sku like ('SALE0722') then bl.basket_id else null end) as Churn,
	sum(distinct case when bl.sku like ('SALE0722') then bo.billing_product_ht/100 else null end) as CA_Churn, 	
	count(distinct case when bl.sku like ('SALE0721') then bl.basket_id else null end) as Churn1,
	sum(distinct case when bl.sku like ('SALE0721') then bo.billing_product_ht/100 else null end) as CA_Churn1
from
	smallable2_front.basket_line bl
inner join smallable2_datawarehouse.b_orders bo 
on bo.basket_id = bl.basket_id 
	and bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
 INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
    bc.country_id = bo.delivery_country_id



select bc.country_name , 	
	count(distinct bl.basket_id) as Churn
from
	smallable2_front.basket_line bl
inner join smallable2_datawarehouse.b_orders bo 
on bo.basket_id = bl.basket_id 
	and bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
 INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
    bc.country_id = bo.delivery_country_id
where bl.sku like ('JUST4YOU4%')
group by bc.country_name 


select bc.zone_code  , 	
	count(distinct bl.basket_id) as Churn
from
	smallable2_front.basket_line bl
inner join smallable2_datawarehouse.b_orders bo 
on bo.basket_id = bl.basket_id 
	and bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
 INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
    bc.country_id = bo.delivery_country_id
where bl.sku like ('JUST4YOU4%')
group by bc.zone_code  


select
	sum(distinct case when bl.sku like ('JUST4YOU4%') then bo.billing_product_ht/100 else null end) as Churn
FROM
	smallable2_front.basket_line bl
inner join smallable2_datawarehouse.b_orders bo 
on bo.basket_id = bl.basket_id 
	and bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
    