select count(distinct basket_id)
from smallable2_front.customer_product_list cpl  

where cpl.created  >= '2022-03-01'

select * 
from smallable2_playground.soldes s 

select count(distinct basket_id)
from  smallable2_front.basket_line bl
inner join smallable2_front.customer_product_list cpl 
on cpl.basket_id = bl.basket_id 
--where bl.class = 'CustomerProductList'
--and bl.status_id ='402'



select count(distinct basket_id), count(distInct bl.id)
from smallable2_front.basket_line bl 
inner join smallable2_datawarehouse.b_order_products bop 
on bop.sku_code = bl.sku 
--inner join smallable2_datawarehouse.b_products bp 
--on bop.product_id = bp.product_id 
where bl.class = 'CustomerProductList'
and  bop.product_id  in  ('188482','188483','188484','188485','188486','188487','188488','188489','188490','188491','188492','188493','188494','188495','188496'
,'188497','188498','188499','188500','188501','188502','188503','188504','188505','188506','188507','188508','188509'
,'188510','188511','188512','188513','188514','188515','188516','188517','188518','188519','188520','188521','188522','188523'
,'188524','188525','188526','188527','188528','188529','188530','188531','188532','188533','188534','188535','197537','197538','197539','197540','197541','197542','197543','197544','197545'
,'197546','197547','197548','197549','197550','197551','197552','197553','197554','197555','197556','197557','197558','197559','197560'
,'197561','197562','197563','197564','197565','197566','197567','197568','197569','197570','197571','197572')

select *
from smallable2_datawarehouse.b_products bp 
where bp.product_name like '%Poussette YOYO%'