------------------------------------------2022---------------------------------------------------
-------------------------Générés ----------------------------------------------------------------
select
	count(case when cv.code like ('BIRTHDAY%') then cv.code else null end) as Kids_birthday,
	count(case when cv.code like ('JUST4YOU______') then cv.id else null end) as Churn,
	count(case when cv.code like ('WELCOME________') then cv.id else null end) as Welcome_pack,
	count(case when cv.code like ('DELIVERY%') then cv.id else null end) as FDP,
	count(case when cv.code like ('SMB%') then cv.id else null end) as FDP1,
	count(case when cv.code like ('SPRING%') then cv.id else null end) as Abandon_panier,
	count(case when cv.code like ('ASB%') then cv.id else null end) as Abandon_panier1,
	count(case when cv.code like ('GIFT%') then cv.id else null end) as Abandon_panier2,
	count(case when cv.code like ('ENJOY%') then cv.id else null end) as Abandon_panier3
from
	smallable2_front.commercial_voucher cv
where
	cv.created >= '2022-01-01'
	and cv.created <= '2022-06-21'
	
select
	count(case when cv.code like ('JUST4YOU4%') then cv.id else null end) as Chun
from
	smallable2_front.commercial_voucher cv	

	
--------------------Utilisés--------------------------------------------------------------------
select bc.zone_code ,
	count(distinct case when bl.sku like ('BIRTHDAY%') then bl.basket_id else null end) as Kids_birthday, 
	count(distinct case when bl.sku like ('JUST4YOU______') then bl.basket_id else null end) as Churn,
	count(distinct case when bl.sku like ('WELCOME________') then bl.basket_id else null end) as Welcome_pack,
	count(distinct case when bl.sku like ('DELIVERY%') then bl.basket_id else null end) as FDP,
	count(distinct case when bl.sku like ('SMB%') then bl.basket_id else null end) as FDP1,
	count(distinct case when bl.sku like ('SPRING%') then bl.basket_id else null end) as Abandon_panier,
	count(distinct case when bl.sku like ('ASB%') then bl.basket_id else null end) as Abandon_panier1,
	count(distinct case when bl.sku like ('GIFT%') then bl.basket_id else null end) as Abandon_panier2,
	count(distinct case when bl.sku like ('ENJOY%') then bl.basket_id else null end) as Abandon_panier3
from
	smallable2_front.basket_line bl
inner join smallable2_datawarehouse.b_orders bo 
on bo.basket_id = bl.basket_id 
	and bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
   INNER JOIN smallable2_datawarehouse.b_countries bc 
ON
    bc.country_id = bo.delivery_country_id
where bl.created >= '2021-01-01'
and bl.created <= '2021-06-21'
group by bc.zone_code  

------------------------------------CA----------------------------------------------------------------
select
	sum(distinct case when bl.sku like ('BIRTHDAY%') then bo.billing_product_ht/100 else null end) as Kids_birthday, 
	sum(distinct case when bl.sku like ('JUST4YOU______') then bo.billing_product_ht/100 else null end) as Churn,
	sum(distinct case when bl.sku like ('WELCOME________') then bo.billing_product_ht/100 else null end) as Welcome_pack,
	sum(distinct case when bl.sku like ('DELIVERY%') then bo.billing_product_ht/100 else null end) as FDP,
	sum(distinct case when bl.sku like ('SMB%') then bo.billing_product_ht/100 else null end) as FDP1,
	sum(distinct case when bl.sku like ('SPRING%') then bo.billing_product_ht/100 else null end) as Abandon_panier,
	sum(distinct case when bl.sku like ('ASB%') then bo.billing_product_ht/100 else null end) as Abandon_panier1,
	sum(distinct case when bl.sku like ('GIFT%') then bo.billing_product_ht/100 else null end) as Abandon_panier2,
	sum(distinct case when bl.sku like ('ENJOY%') then bo.billing_product_ht/100 else null end) as Abandon_panier3
from
	smallable2_front.basket_line bl
inner join smallable2_datawarehouse.b_orders bo 
on bo.basket_id = bl.basket_id 
	and bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
where bl.created >= '2022-01-01'
and bl.created <= '2022-06-21'


select
	bc.nb_commandes_nettes,
	count(bc.customer_id)
from
	smallable2_datawarehouse.b_customers bc
inner join smallable2_datawarehouse.b_orders bo 
on
	bo.customer_id = bc.customer_id
inner join smallable2_datawarehouse.b_order_products bop 
on
	bop.basket_id = bo.basket_id
	and bo.order_id = bop.order_id
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1
group by
	bc.nb_commandes_nettes
order by
	nb_commandes_nettes asc

------------------------------------------2021---------------------------------------------------
-------------------------Générés ----------------------------------------------------------------
select 
	count(case when cv.code like ('BIRTHDAY%') then cv.id else null end) as Kids_birthday,
	count(case when cv.code like ('JUST4YOU______') then cv.id else null end) as Churn,
	count(case when cv.code like ('WELCOME________') then cv.id else null end) as  Welcome_pack,
	count(case when cv.code like ('DELIVERY%') then cv.id else null end) as FDP,
	count(case when cv.code like ('SMB%') then cv.id else null end) as FDP1,
	count(case when cv.code like ('SPRING%') then cv.id else null end) as Abandon_panier,
	count(case when cv.code like ('ASB%') then cv.id else null end) as Abandon_panier1,
	count(case when cv.code like ('GIFT%') then cv.id else null end) as Abandon_panier2,
	count(case when cv.code like ('ENJOY%') then cv.id else null end) as Abandon_panier3
from
	smallable2_front.commercial_voucher cv
where
	cv.created >= '2021-01-01'
	and cv.created <= '2021-06-21'

--------------------Utilisés--------------------------------------------------------------------

select
	count(distinct case when bl.sku like ('BIRTHDAY%') then bl.basket_id else null end) as Kids_birthday, 
	count(distinct case when bl.sku like ('JUST4YOU______') then bl.basket_id else null end) as Churn,
	count(distinct case when bl.sku like ('WELCOME________') then bl.basket_id else null end) as Welcome_pack,
	count(distinct case when bl.sku like ('DELIVERY%') then bl.basket_id else null end) as FDP,
	count(distinct case when bl.sku like ('SMB%') then bl.basket_id else null end) as FDP1,
	count(distinct case when bl.sku like ('SPRING%') then bl.basket_id else null end) as Abandon_panier,
	count(distinct case when bl.sku like ('ASB%') then bl.basket_id else null end) as Abandon_panier1,
	count(distinct case when bl.sku like ('GIFT%') then bl.basket_id else null end) as Abandon_panier2,
	count(distinct case when bl.sku like ('ENJOY%') then bl.basket_id else null end) as Abandon_panier3
from
	smallable2_front.basket_line bl
inner join smallable2_datawarehouse.b_orders bo 
on bo.basket_id = bl.basket_id 
	and bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
where bl.created >= '2021-01-01'
and bl.created <= '2021-06-21'

------------------------------------------------------------------CA-----------------------------------
select
	sum(distinct case when bl.sku like ('BIRTHDAY%') then bo.billing_product_ht/100 else null end) as Kids_birthday, 
	sum(distinct case when bl.sku like ('JUST4YOU______') then bo.billing_product_ht/100 else null end) as Churn,
	sum(distinct case when bl.sku like ('WELCOME________') then bo.billing_product_ht/100 else null end) as Welcome_pack,
	sum(distinct case when bl.sku like ('DELIVERY%') then bo.billing_product_ht/100 else null end) as FDP,
	sum(distinct case when bl.sku like ('SMB%') then bo.billing_product_ht/100 else null end) as FDP1,
	sum(distinct case when bl.sku like ('SPRING%') then bo.billing_product_ht/100 else null end) as Abandon_panier,
	sum(distinct case when bl.sku like ('ASB%') then bo.billing_product_ht/100 else null end) as Abandon_panier1,
	sum(distinct case when bl.sku like ('GIFT%') then bo.billing_product_ht/100 else null end) as Abandon_panier2,
	sum(distinct case when bl.sku like ('ENJOY%') then bo.billing_product_ht/100 else null end) as Abandon_panier3
from
	smallable2_front.basket_line bl
inner join smallable2_datawarehouse.b_orders bo 
on bo.basket_id = bl.basket_id 
	and bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
where bl.created >= '2021-01-01'
and bl.created <= '2021-06-21'

----------------------------------------------------------------------------------------------------


select bc.nb_commandes_nettes, count(distinct bo.customer_id)
from
	smallable2_front.basket_line bl
right join smallable2_datawarehouse.b_orders bo 
on bo.basket_id = bl.basket_id 
	and bo.is_valid = 1
    AND bo.is_ca_ht_not_zero = 1
right JOIN smallable2_datawarehouse.b_customers bc 
ON
    bc.customer_id = bo.customer_id 
where bl.created >= '2021-01-01'
and bl.created <= '2021-12-31'
and bl.sku = 'WELCOME________'
group by bc.nb_commandes_nettes  


select
	bc.nb_commandes_nettes,
	count(bc.customer_id)
from
	smallable2_datawarehouse.b_customers bc
group by
	bc.nb_commandes_nettes
order by
	nb_commandes_nettes asc

---------------------------------------------------------------- détails Zone -----------------------------------
select
	bl.sku,
	count(DISTINCT bl.basket_id)
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_order_products bop
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
inner join smallable2_front.basket_line bl
on
	bl.basket_id = bo.basket_id
where
	bl.created  >= '2022-01-01'
	and bl.created  <= '2022-06-21'
	and bl.sku like ('ENJOY%')
	or bl.sku like ('SPRING%')
	or bl.sku like ('GIFT%')
	or bl.sku like ('ASB%')
group by
	bl.sku 
	
	
select
	bl.sku,
	count(DISTINCT bl.basket_id), count(distinct bl.sku)
from
	smallable2_front.basket_line bl
where
	bl.created  >= '2022-01-01'
	and bl.created  <= '2022-06-21'
	and bl.sku like ('ENJOY%')
	or bl.sku like ('SPRING%')
	or bl.sku like ('GIFT%')
	or bl.sku like ('ASB%')
group by
	bl.sku
	
	
select *
from smallable2_front.commercial_voucher cv 
	
