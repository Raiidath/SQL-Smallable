select
	toStartOfMonth(br.refund_created_at) as Status_remboursement,
	count(distinct br.refund_id) as Nombre_remboursements,
	sum(bt.billing_ht)/ 100 as Montant
from
	smallable2_datawarehouse.b_transactions bt
inner join smallable2_datawarehouse.b_refund_products brp 
on
	bt.order_id = brp.order_id
inner join smallable2_datawarehouse.b_refunds br
on
	br.refund_id = brp.refund_id
where
	br.refund_created_at <= '2022-06-30'
	and br.refund_created_at >= '2020-07-01'
group by
	Status_remboursement 
	
	
select
	 br.cancel_status  as raison_remboursement,
	count(distinct br.refund_id) as Nombre_remboursements,
	sum(bt.billing_ht)/ 100 as Montant
from
	smallable2_datawarehouse.b_transactions bt
inner join smallable2_datawarehouse.b_refund_products brp 
on
	bt.order_id = brp.order_id
inner join smallable2_datawarehouse.b_refunds br
on
	br.refund_id = brp.refund_id
where
	br.refund_created_at <= '2022-06-30'
	and br.refund_created_at >= '2020-07-01'
group by
	raison_remboursement
ORDER BY
	Nombre_remboursements desc
	
select
	count(distinct br.comment)   as raison_remboursement--,
	--count(distinct br.refund_id) as Nombre_remboursements,
	--sum(bt.billing_ht)/ 100 as Montant
from
	smallable2_datawarehouse.b_transactions bt
inner join smallable2_datawarehouse.b_refund_products brp 
on
	bt.order_id = brp.order_id
inner join smallable2_datawarehouse.b_refunds br
on
	br.refund_id = brp.refund_id
where
	br.refund_created_at <= '2022-06-30'
	and br.refund_created_at >= '2020-07-01'
	
group by
	raison_remboursement
ORDER BY
	Nombre_remboursements desc
	
	----------------------------------------------------------------------------------
select
	 brp.global_reason  as Status_annulation,
	count(distinct br.refund_id) as Nombre_remboursements,  sum(bt.billing_ht)/100 as Montant
from
	smallable2_datawarehouse.b_transactions bt
inner join smallable2_datawarehouse.b_refund_products brp 
on
	bt.order_id = brp.order_id
inner join smallable2_datawarehouse.b_refunds br
on
	br.refund_id = brp.refund_id
where
	br.refund_created_at <= '2022-06-30'
	and br.refund_created_at >= '2020-07-01'
	and br.cancel_status = 'Error'
group by
	Status_annulation 
	--------------------------------------------------------------------------------------------------------
	
	
	and br.cancel_status = 'Error'

	
	
select
	br.refund_id  ,br.refund_created_at , br.refunded_at, bt.ref_date_2 ,br.refunded_at- bt.ref_date_2
from
	smallable2_datawarehouse.b_transactions bt
inner join smallable2_datawarehouse.b_refund_products brp 
on
	bt.order_id = brp.order_id
inner join smallable2_datawarehouse.b_refunds br
on
	br.refund_id = brp.refund_id
where
	br.refund_created_at <= '2022-06-29'
	and br.refund_created_at >= '2020-06-29'
	
	
	
Select	count(distinct br.refund_id) as nombre,
	avg(toUnixTimestamp(br.refunded_at)- toUnixTimestamp(bt.ref_date_2)) as moyenne,
	stddevPop(toUnixTimestamp(br.refunded_at)-toUnixTimestamp(bt.ref_date_2)) as etype
from
	smallable2_datawarehouse.b_transactions bt
inner join smallable2_datawarehouse.b_refund_products brp 
on
	bt.order_id = brp.order_id
inner join smallable2_datawarehouse.b_refunds br
on
	br.refund_id = brp.refund_id
where
	br.refund_created_at <= '2022-06-29'
	and br.refund_created_at >= '2020-06-29'


select
	distinct br.refund_id ,
	br.ordered_at,
	br.refund_created_at ,
	br.refunded_at,
	br.refunded_at- br.refund_created_at  as diff
from
	smallable2_datawarehouse.b_transactions bt
inner join smallable2_datawarehouse.b_refund_products brp 
on
	bt.order_id = brp.order_id
inner join smallable2_datawarehouse.b_refunds br
on
	br.refund_id = brp.refund_id
where
where
	br.refund_created_at <= '2022-06-30'
	and br.refund_created_at >= '2020-07-01'
	and br.refunded_at >= '2020-07-01'
	--and bt.ref_date_2 <> '1970-01-01'
order by
	diff desc
	
	
Select	count(distinct br.refund_id) as Nb_remboursement,
	avg(br.refunded_at-br.refund_created_at) as moyenne,
	stddevPop(br.refunded_at-br.refund_created_at) as etype
from
	smallable2_datawarehouse.b_transactions bt
inner join smallable2_datawarehouse.b_refund_products brp 
on
	bt.order_id = brp.order_id
inner join smallable2_datawarehouse.b_refunds br
on
	br.refund_id = brp.refund_id
where
	br.refund_created_at <= '2022-06-30'
	and br.refund_created_at >= '2020-07-01'
	and br.refunded_at >= '2020-07-01'
	
	select * from smallable2_datawarehouse.b_transactions bt 