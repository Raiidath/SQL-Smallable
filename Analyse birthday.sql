select
	count(distinct bop.order_id) as Cmd , sum(bop.billing_product_ht)/100 as CA_global,
	count(distinct case when bop.code_promo ilike 'BIRTHDAY%' then bop.order_id else null end) as code_promo,
	sum(case when bop.code_promo ilike 'BIRTHDAY%' then bop.billing_product_ht / 100 else null end) as ca,
	code_promo * 100 / Cmd as pourcentage_cmd_avec_code, ca * 100 / CA_global as pourcentage_ca_avec_code,
	count(distinct case when bop.code_promo ilike 'BIRTHDAY%' and bo.first_order_vs_repeat = '1ère Commande' then bop.order_id else null end) as 1er_cmd,
	1er_cmd* 100 / code_promo  as pourcentage_1ere_cmd,
	count(distinct case when bop.code_promo ilike 'BIRTHDAY%' and bo.first_order_vs_repeat = 'Réachat' then bop.order_id else null end) as Reachat,
	Reachat * 100 / code_promo  as pourcentage_cmd_Reachat
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2	
 --and  bop.invoiced_at   >= '2022-01-01'
   -- and  bop.invoiced_at   <= '2021-12-31'
	

select
	bop.sml_team as univers, count(distinct bop.order_id) as Nb_cmd
from
	smallable2_datawarehouse.b_order_products bop
inner join smallable2_datawarehouse.b_orders bo
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2	
    and  bo.created_at   <= '2022-06-01'
	--bo.first_order_vs_repeat = 'Réachat'
	and bop.code_promo ilike 'BIRTHDAY%'
group by univers

select * --count(cv.id) 
from smallable2_front.commercial_voucher cv
where cv.code ilike 'BIRTHDAY%'
and cv.created  >= '2021-01-01' and cv.created  <= '2021-12-31' 
--and cv.voucher_scope = 2

select count(distinct cv.id) , count(distinct cv.customer_id), count(distinct cv.customerChild_id) 
from smallable2_front.commercial_voucher cv
where cv.code ilike 'BIRTHDAY%'
and cv.created  >= '2021-01-01' and cv.created  <= '2021-12-31' 

-----------------------Nb de code créés et Nb de code utilisé par clients, ca, ca moyen par panier  --------------------------------------------------------------------------------
select
	distinct bo.customer_id as clients, bc.email as email,
	count(DISTINCT case when bop.code_promo ilike '%BIRTH%' then bo.order_id else null end) AS commandes,
sum(case when bc.customer_id = bo.customer_id then bop.billing_product_ht else null end)/ 100 AS ca, ca/commandes as ca_moyen_panier
from
	smallable2_datawarehouse.b_orders bo
inner join smallable2_datawarehouse.b_customers bc 
on bc.customer_id = bo.customer_id 	
inner join smallable2_datawarehouse.b_order_products bop 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
where
	bop.code_promo ilike 'BIRTHDAY%'
group by
	clients, email
order by
	commandes desc
	
select 	distinct cv.customer_id as clients,
	count(distinct cv.id) as Nb_code
from smallable2_front.commercial_voucher cv 
where cv.code  ilike 'BIRTH%'
group by clients
order by Nb_code desc	
	

--------------Clients, mail, Nb_enfants et Nb de code envoyés---------------------------------------------
select
	bc.customer_id as clients,
	bc.email as email,
	--count(distinct cc.customer_id ) as Nb_enfants,
	--count(distinct bo.customer_id) as Nb_code,
	count(distinct case when bo.customer_id = bc.customer_id then bop.order_id else null end) AS commandes,
	sum(distinct case when bo.customer_id = bc.customer_id then bop.billing_product_ht else null end)/ 100 AS ca
from
--	smallable2_front.commercial_voucher cv
--inner join smallable2_front.customer_child cc 
--on
--	cc.customer_id = cv.customer_id
--inner join 
smallable2_datawarehouse.b_customers bc 
--on bc.customer_id = cv.customer_id
inner join smallable2_datawarehouse.b_orders bo	
on
	bo.customer_id = bc.customer_id
inner join smallable2_datawarehouse.b_order_products bop 
on
	bo.order_id = bop.order_id
	and bo.basket_id = bop.basket_id
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2
where
	bop.code_promo ilike 'BIRTH%'
group by
	clients,
	bc.email	
--order by
--Nb_enfants desc	
	
	
-------------------------------------------------------------------------
select toStartOfYear(bop.invoiced_at) as Month,
--bop.invoiced_at, 
count( distinct case when bop.code_promo ilike 'BIRTHDAY%' then bop.order_id else null end) 
from smallable2_datawarehouse.b_orders bo 
inner join smallable2_datawarehouse.b_order_products bop 
on bo.order_id = bop.order_id 
and bo.basket_id = bop.basket_id 
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2	
where bop.code_promo ilike 'BIRTHDAY%'
group by Month 

	
select toStartOfMonth(bop.invoiced_at) as Month,
--bop.invoiced_at, 
count( distinct case when bop.code_promo ilike 'BIRTHDAY%' then bop.order_id else null end) 
from smallable2_datawarehouse.b_orders bo 
inner join smallable2_datawarehouse.b_order_products bop 
on bo.order_id = bop.order_id 
and bo.basket_id = bop.basket_id 
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2	
where bop.code_promo ilike 'BIRTHDAY%'
and  bop.invoiced_at   >= '2021-01-01'
and  bop.invoiced_at   <= '2021-12-31' 
group by Month 


select bo.customer_id as Month,
--bop.invoiced_at, 
count( distinct case when bop.code_promo ilike 'BIRTHDAY%' then bop.order_id else null end) as nb
from smallable2_datawarehouse.b_orders bo 
inner join smallable2_datawarehouse.b_order_products bop 
on bo.order_id = bop.order_id 
and bo.basket_id = bop.basket_id 
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	AND bop.basket_line_type_id = 2	
where bop.code_promo ilike 'BIRTHDAY%'
--and  bop.invoiced_at   >= '2022-01-01'
--and  bop.invoiced_at   <= '2021-12-31' 
group by Month 
order by nb desc

select toStartOfMonth(cv.created) as Month, count(distinct cv.customer_id),  count(distinct cv.code) --,count(distinct cv.customerChild_id) 
from smallable2_front.commercial_voucher cv
where cv.code ilike 'BIRTHDAY%'
and cv.created  >= '2022-01-01' --and cv.created  <= '2021-12-31' 
group by Month


select toStartOfYear(cv.created) as Month, count(distinct cv.customer_id),  count(distinct cv.code) --,count(distinct cv.customerChild_id) 
from smallable2_front.commercial_voucher cv
where cv.code ilike 'BIRTHDAY%'
--and cv.created  >= '2022-01-01' --and cv.created  <= '2021-12-31' 
group by Month

-----------------------------------------------------------COMMERCIAL VOUCEHR --------------------------------------------------------------------------------------
select * --count(cv.id) 
from smallable2_front.commercial_voucher cv
where cv.code ilike 'BIRTHDAY%'
and cv.created  >= '2021-01-01' and cv.created  <= '2021-12-31' 
--and cv.voucher_scope = 2

select count(distinct cv.id) , count(distinct cv.customer_id), count(distinct cv.customerChild_id) 
from smallable2_front.commercial_voucher cv
where cv.code ilike 'BIRTHDAY%'
and cv.created  >= '2021-01-01' and cv.created  <= '2021-12-31' 


select  count(distinct cc.customer_id) as clients, count(distinct bc.customer_id) as clients_global, clients*100/clients_global as pourcentage
from smallable2_front.customer_child cc 	
right join smallable2_datawarehouse.b_customers bc 
on bc.customer_id = cc.customer_id 
and bc.created_at  >= '2021-01-01' and bc.created_at  <= '2021-12-31' 


select count(distinct cc.customer_id) as clients, clients*100/1142374 as pourcentage
from smallable2_front.customer_child cc 	
right join smallable2_datawarehouse.b_customers bc 
on bc.customer_id = cc.customer_id 
AND bc.created_at = cc.created 
and cc.created  >= '2021-01-01' and cc.created  <= '2021-12-31' 


--------------------------------Nb d'enfants pas clients------------------------------------------
select distinct cc.customer_id as clients, bc.email , count(id) as Nb
from smallable2_front.customer_child cc
left join smallable2_datawarehouse.b_customers bc 
on bc.customer_id = cc.customer_id
group by clients, bc.email
order by Nb desc 


	
--------------Clients, mail, id_enfants et Nb de code envoyés/enfant---------------------------------------------	
select
	bc.customer_id as clients,
	bc.email as email,
	--cv.customerChild_id as id_enfant,
	count(distinct cv.id) as Nb_code
from
	smallable2_front.commercial_voucher cv
inner join smallable2_front.customer_child cc 
on
	cc.customer_id = cv.customer_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bc.customer_id = cv.customer_id
where
	cv.code ilike 'BIRTHDAY%'
	--and cv.created  >= '2022-01-01' 
	--and cv.created  <= '2021-12-31' 
group by
	clients,
	--id_enfant,
	bc.email
order by
	Nb_code desc
	

Select cv.customer_id as clients,
	--cv.customerChild_id as id_enfant,
	count(distinct cv.id) as Nb_code
from
	smallable2_front.commercial_voucher cv
where
	cv.code ilike 'BIRTHDAY%'
	and cv.created  >= '2021-01-01' 
	and cv.created  <= '2021-12-31' 
group by
	clients
	--id_enfant,
	--bc.email
order by
	Nb_code desc



select count(distinct id) as Nb_code_2021, count(distinct cv.customer_id) as Nb_clients_distincts 
from smallable2_front.commercial_voucher cv
where cv.code ilike 'BIRTH%'
and cv.created  >= '2021-01-01' and cv.created  <= '2021-12-31' 
	
	
	-------------------------------------------------------------------------------------------------

select cv.customer_id as clients, cv.customerChild_id as enfants, cv.description, count(distinct cv.id) as Nb_code
from smallable2_front.commercial_voucher cv
inner join smallable2_datawarehouse.b_customers bc 
on bc.customer_id = cv.customer_id 
where cv.code ilike '%BIRTH%'
group by description, customer_id, customerChild_id
order by Nb_code desc

select * 
from smallable2_front.commercial_voucher cv
where cv.code ilike '%BIRTH%'
and customer_id = '778639'

select customer_id as clients, count(id) as Nb_par_clients 
from smallable2_front.commercial_voucher cv
where cv.code ilike '%BIRTH%'
group by customer_id 
order by Nb_par_clients desc

select customerChild_id as enfants, count(id) as Nb_par_enfants
from smallable2_front.commercial_voucher cv
where cv.code ilike '%BIRTH%'
and customer_id = '191994'
group by customerChild_id
order by Nb_par_enfants desc

select count(distinct bo.order_id)
from smallable2_datawarehouse.b_orders bo 
inner join smallable2_datawarehouse.b_order_products bop
on bo.order_id = bop.order_id 
where bop.code_promo  ilike '%BIRTH%'
and bo.customer_id = '191994'


