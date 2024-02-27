
select
	bp.product_name,
	bp.brand_name,
	bp.ref_co ,
	bs.product_type_N2
from
	smallable2_datawarehouse.b_products bp
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.product_id = bp.product_id
where
	bs.sml_team = 'design'
	and bp.season_id  = '28'


select
	--bp.product_name,
	--bp.brand_name,
	count(bp.ref_co) as Total_refco -- ,
	--bs.product_type_N5
from
	smallable2_datawarehouse.b_products bp
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.product_id = bp.product_id
where
	bs.sml_team = 'design'
	and 
	bp.season_id  = '31'
	and bp.persons  = 'adult'
	
	
select
	--bp.product_name,
	--bp.brand_name,
	count(bp.ref_co) as Total_refco -- ,
	--bs.product_type_N5
from
	smallable2_datawarehouse.b_products bp
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.product_id = bp.product_id
where
	--bs.sml_team = 'design'
	--and 
	bp.season_id  = '31'
	and bs.product_type_N5  = 'Jouets'
	
	
	
select *
from smallable2_datawarehouse.b_season bs 

select *
from smallable2_datawarehouse.b_skus bs 
where  bs.product_type_N5 <> 'Soins et Beauté' 

select *
from
	smallable2_datawarehouse.b_products bp
where bp.season_id  = '31'


-----------------------------------Grouper par marque et nb de refco ------------------------------------------
select
	--bp.product_name,
	bp.brand_name as Marque,
	count(bp.ref_co) as Nb_refco -- ,
	--bs.product_type_N5
from
	smallable2_datawarehouse.b_products bp
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.product_id = bp.product_id
where
	bs.sml_team = 'design'
	and 
	bp.season_id  = '31'
	and bs.personne  = 'Adulte'
	and  bs.product_type_N5 <> 'Soins et Beauté' 
group by Marque	
order by Marque asc


select
	--bp.product_name,
	bp.brand_name as Marque,
	count(bp.ref_co) as Nb_refco -- ,
	--bs.product_type_N5
from
	smallable2_datawarehouse.b_products bp
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.product_id = bp.product_id
where
	bs.sml_team = 'design'
	and 
	bp.season_id  = '31'
	and bs.personne  = 'Enfant'
	and  bs.product_type_N5 <> 'Jouets' 
group by Marque	
order by Marque asc


select
	--bp.product_name,
	bp.brand_name as Marque,
	count(bp.ref_co) as Nb_refco -- ,
	--bs.product_type_N5
from
	smallable2_datawarehouse.b_products bp
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.product_id = bp.product_id
where
	--bs.sml_team = 'design'
	--and 
	bp.season_id  = '31'
	and bs.product_type_N5  = 'Jouets'
group by Marque	
order by Marque asc


select
	--bp.product_name,
	bp.brand_name as Marque,
	count(bp.ref_co) as Nb_refco -- ,
	--bs.product_type_N5
from
	smallable2_datawarehouse.b_products bp
inner join smallable2_datawarehouse.b_skus bs 
on
	bs.product_id = bp.product_id
where
	--bs.sml_team = 'design'
	--and 
	bp.season_id  = '31'
	and bs.product_type_N5  = 'Soins et Beauté'
group by Marque	
order by Marque asc