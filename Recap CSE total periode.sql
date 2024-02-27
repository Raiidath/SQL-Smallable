select
	r1.partenaire as partenaire,
	r1.client AS client,
	case
		when bc.is_repeater = 1 then 'non'
		when bc.is_repeater = 0 then 'oui'
	end as nouveau_client,
	--attention aux commandes ordinateurs boutiques (Personnal shopper par ex)	
	case
		when r1.country = 7 then 'France'
		when r1.country = 1 then 'Allemagne'
	end as pays_livraison,
	r1.order as commande,
	r1.date as date,
	r1.statut as statut,
	round(sum(bop.billing_product_ht)/ 100,
	2) AS CA_brut,
	CASE WHEN bo2.is_valid = 1 AND bo2.is_ca_ht_not_zero = 1 THEN 1 ELSE 0 END AS valid
from
	smallable2_datawarehouse.b_orders bo2
inner join smallable2_datawarehouse.b_order_products bop 
on
	bo2.order_id = bop.order_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bo2.customer_id = bc.customer_id
inner join
	(
	select
		distinct bo.order_id as order, 
		bo.customer_id as client,
		bo.delivery_country_id as country,
		bo.created_at as date,
		bo.order_status as statut,
			case
				when bl.sku = 'CSEGXSML21' THEN 'Google'
				when bl.sku = 'SMB881363108' THEN 'Dresscode'
				when bl.sku = 'SMBSELOGER3008' THEN 'Se Loger'
				when bl.sku = 'MCXSML2021' THEN 'Myconcierge'	
				when bl.sku = 'CSE-SML-AVI-09'
				or bl.sku = 'CSE-SML-AVI-12'
				or bl.sku = 'CSE-SML-AVI-10' THEN 'Avis vérifiés'
				when bl.sku = 'PS-SML-SON-19'
				or bl.sku = 'PS-SML-SON-02' THEN 'Sonja Pastor'
				when bl.sku = 'PS-SML-ADE-22' THEN 'Adele Leung
'				when bl.sku = 'PS-SML-NIC-20'
				or bl.sku = 'PS-SML-NIC-12'
				or bl.sku = 'PS-SML-NIC-15'
				or bl.sku = 'PS-SML-NIC-04'
				OR bl.sku = 'PS-SML-NIC-22' THEN 'Nicola Reinkens'
				when bl.sku = 'PS-SML-MIR-11'
				or bl.sku = 'PS-SML-MIR-02'
				or bl.sku = 'PS-SML-MIR-07'
				or bl.sku = 'PS-SML-MIR-09'
				or bl.sku = 'PS-SML-MIR-03'
				or bl.sku = 'PS-SML-MIR-04'
				or bl.sku = 'PS-SML-MIR-78'
				or bl.sku = 'PS-SML-MIR-24'
				or bl.sku = 'SMB1650589194' THEN 'Miriam Lasserre'
				when bl.sku LIKE 'PS-SML-LIZ%' THEN 'Liz Teich'
				when bl.sku LIKE 'PS-SML-KIS%' THEN 'The Kismet Collective'
				when bl.sku LIKE 'HPALXSML%' THEN 'Happy Pal'
				when bl.sku = 'CSE-SML-ACC-11' THEN 'Accor'
				when bl.sku = 'PRO-SML-CIN-21' THEN 'Cinétévé'
				when bl.sku = 'PS-SML-COL-21' THEN 'Le Collectionist'
				when bl.sku = 'CSE-SML-BETC-21'
				or bl.sku = 'CSE-SML-BETC-12'
				or bl.sku = 'SMB1771438465' OR bl.sku = 'CSE-SML-BETC-22' THEN 'BETC'
				when bl.sku = 'PRO-SML-CRI-12' THEN 'DG Crillon'
				when bl.sku = 'CSE-SML-QON-10' THEN 'Qonto'
				when bl.sku = 'PRO-SML-ICO-22' THEN 'Iconic House'
				when bl.sku = 'PRO-SML-HOX-22' THEN 'The Hoxton'
				when bl.sku = 'SMB2034863811' THEN 'Gastronomica'
				when bl.sku = 'CSE-SML-GWS-22' THEN 'William Sinclair'
			END AS partenaire
		from
			smallable2_datawarehouse.b_orders bo
		inner join smallable2_datawarehouse.b_transactions bt
	on
			bo.order_id = bt.order_id
			and bt.item_type_id in (900, 300)
		inner join smallable2_front.basket_line bl 
on
			bo.basket_id = bl.basket_id
		where
			bo.created_at >= '2022-01-01'
			and bo.created_at <= '2022-06-30'
			and (bl.sku LIKE  'HPALXSML%' -- 'PS-SML-LIZ%' bl.sku LIKE 'HPALXSML%' 'PS-SML-KIS%'
				or bl.sku IN ('PS-SML-MIR-78','PS-SML-MIR-04','PS-SML-NIC-04','MCXSML2021','PS-SML-ADE-22','PRO-SML-ICO-22','PRO-SML-HOX-22','SMB2034863811','CSE-SML-GWS-22','CSE-SML-BETC-22', 'SMB881363108','PS-SML-NIC-22','CSE-SML-QON-10', 'SMB1771438465', 'CSE-SML-AVI-10', 'SMB1650589194', 'CSE-SML-AVI-12', 'PS-SML-NIC-12', 'PS-SML-MIR-24', 'PS-SML-MIR-03', 'PRO-SML-CRI-12', 'PS-SML-MIR-09', 'PS-SML-SON-02', 'PS-SML-MIR-11', 'PS-SML-MIR-02', 'PS-SML-MIR-07', 'CSE-SML-BETC-12', 'CSE-SML-BETC-21', 'PS-SML-COL-21', 'PRO-SML-CIN-21', 'CSE-SML-ACC-11', 'CSEGXSML21', 'SMBSELOGER3008', 'CSE-SML-AVI-09', 'PS-SML-SON-19', 'PS-SML-NIC-20', 'CSE-SML-ACC-11', 'PRO-SML-CIN-21')))r1 on
	r1.order = bo2.order_id
group by
	partenaire,
	client,
	commande,
	date,
	statut,
	nouveau_client,
	pays_livraison, valid
order by
	partenaire,
	statut,
	date desc
	
	
	
	
	
select
	r1.partenaire as partenaire,
	r1.client AS client,
	case
		when bc.is_repeater = 1 then 'non'
		when bc.is_repeater = 0 then 'oui'
	end as nouveau_client,
	--attention aux commandes ordinateurs boutiques (Personnal shopper par ex)	
	case
		when r1.country = 7 then 'France'
		when r1.country = 1 then 'Allemagne'
	end as pays_livraison,
	r1.order as commande,
	r1.date as date,
	r1.statut as statut,
	(r2.contribution - r2.discount)/ 100 as contribution
from
	smallable2_datawarehouse.b_orders bo2
inner join smallable2_datawarehouse.b_order_products bop 
on
	bo2.order_id = bop.order_id
inner join smallable2_datawarehouse.b_customers bc 
on
	bo2.customer_id = bc.customer_id
inner join
	(
	select
		distinct bo.order_id as order, 
		bo.customer_id as client,
		bo.delivery_country_id as country,
		bo.created_at as date,
		bo.order_status as statut,
			case
				when bl.sku = 'CSEGXSML21' THEN 'Google'
				when bl.sku = 'SMB881363108' THEN 'Dresscode'
				when bl.sku = 'SMBSELOGER3008' THEN 'Se Loger'
				when bl.sku = 'MCXSML2021' THEN 'Myconcierge'	
				when bl.sku = 'CSE-SML-AVI-09'
				or bl.sku = 'CSE-SML-AVI-12'
				or bl.sku = 'CSE-SML-AVI-10' THEN 'Avis vérifiés'
				when bl.sku = 'PS-SML-SON-19'
				or bl.sku = 'PS-SML-SON-02' THEN 'Sonja Pastor'
				when bl.sku = 'PS-SML-ADE-22' THEN 'Adele Leung
'				when bl.sku = 'PS-SML-NIC-20'
				or bl.sku = 'PS-SML-NIC-12'
				or bl.sku = 'PS-SML-NIC-15'
				or bl.sku = 'PS-SML-NIC-04'
				OR bl.sku = 'PS-SML-NIC-22' THEN 'Nicola Reinkens'
				when bl.sku = 'PS-SML-MIR-11'
				or bl.sku = 'PS-SML-MIR-02'
				or bl.sku = 'PS-SML-MIR-07'
				or bl.sku = 'PS-SML-MIR-09'
				or bl.sku = 'PS-SML-MIR-03'
				or bl.sku = 'PS-SML-MIR-04'
				or bl.sku = 'PS-SML-MIR-78'
				or bl.sku = 'PS-SML-MIR-24'
				or bl.sku = 'SMB1650589194' THEN 'Miriam Lasserre'
				when bl.sku LIKE 'PS-SML-LIZ%' THEN 'Liz Teich'
				when bl.sku LIKE 'PS-SML-KIS%' THEN 'The Kismet Collective'
				when bl.sku LIKE 'HPALXSML%' THEN 'Happy Pal'
				when bl.sku = 'CSE-SML-ACC-11' THEN 'Accor'
				when bl.sku = 'PRO-SML-CIN-21' THEN 'Cinétévé'
				when bl.sku = 'PS-SML-COL-21' THEN 'Le Collectionist'
				when bl.sku = 'CSE-SML-BETC-21'
				or bl.sku = 'CSE-SML-BETC-12'
				or bl.sku = 'SMB1771438465' OR bl.sku = 'CSE-SML-BETC-22' THEN 'BETC'
				when bl.sku = 'PRO-SML-CRI-12' THEN 'DG Crillon'
				when bl.sku = 'CSE-SML-QON-10' THEN 'Qonto'
				when bl.sku = 'PRO-SML-ICO-22' THEN 'Iconic House'
				when bl.sku = 'PRO-SML-HOX-22' THEN 'The Hoxton'
				when bl.sku = 'SMB2034863811' THEN 'Gastronomica'
				when bl.sku = 'CSE-SML-GWS-22' THEN 'William Sinclair'
			END AS partenaire
		from
			smallable2_datawarehouse.b_orders bo
		inner join smallable2_front.basket_line bl 
on
			bo.basket_id = bl.basket_id
		where
			bo.created_at >= '2022-01-01'
			and bo.created_at <= '2022-06-30'
			and (bl.sku LIKE  'HPALXSML%' -- 'PS-SML-LIZ%' bl.sku LIKE 'HPALXSML%' 'PS-SML-KIS%'
				or bl.sku IN ('PS-SML-MIR-78','PS-SML-MIR-04','PS-SML-NIC-04','MCXSML2021','PS-SML-ADE-22','PRO-SML-ICO-22','PRO-SML-HOX-22','SMB2034863811','CSE-SML-GWS-22','CSE-SML-BETC-22', 'SMB881363108','PS-SML-NIC-22','CSE-SML-QON-10', 'SMB1771438465', 'CSE-SML-AVI-10', 'SMB1650589194', 'CSE-SML-AVI-12', 'PS-SML-NIC-12', 'PS-SML-MIR-24', 'PS-SML-MIR-03', 'PRO-SML-CRI-12', 'PS-SML-MIR-09', 'PS-SML-SON-02', 'PS-SML-MIR-11', 'PS-SML-MIR-02', 'PS-SML-MIR-07', 'CSE-SML-BETC-12', 'CSE-SML-BETC-21', 'PS-SML-COL-21', 'PRO-SML-CIN-21', 'CSE-SML-ACC-11', 'CSEGXSML21', 'SMBSELOGER3008', 'CSE-SML-AVI-09', 'PS-SML-SON-19', 'PS-SML-NIC-20', 'CSE-SML-ACC-11', 'PRO-SML-CIN-21')))r1 on
	r1.order = bo2.order_id
inner join (
	select
		bop2.order_id as order,
		case
			when bop2.is_contribution = 1 then bop2.billing_contribution_ht
		end as contribution,
		bop2.billing_discount_product_ht as discount
	from
		smallable2_datawarehouse.b_order_products bop2
	group by
		order,
		contribution,
		discount) r2 on
	r2.order = bo2.order_id
group by
	partenaire,
	client,
	commande,
	date,
	statut,
	nouveau_client,
	pays_livraison,
	contribution
order by
	partenaire,
	statut,
	date desc
	

	
select bop.contri
from smallable2_datawarehouse.b_order_products bop


SELECT
	r1.partenaire AS partenaire,
	count(DISTINCT bo2.order_id) AS nb_commandes,
	round(sum(bop.billing_product_ht)/ 100,
	0) AS CA_brut,
	round(sum(bop.billing_product_ht/100)/ count(DISTINCT bop.order_id),
	0) AS Panier_moyen_brut
FROM
	smallable2_datawarehouse.b_orders bo2
INNER JOIN smallable2_datawarehouse.b_order_products bop 
ON
	bo2.order_id = bop.order_id
INNER JOIN
	(
	SELECT
		DISTINCT bo.order_id AS o_id,
		case
				when bl.sku = 'CSEGXSML21' THEN 'Google'
				when bl.sku = 'SMB881363108' THEN 'Dresscode'
				when bl.sku = 'SMBSELOGER3008' THEN 'Se Loger'
				when bl.sku = 'MCXSML2021' THEN 'Myconcierge'	
				when bl.sku = 'CSE-SML-AVI-09'
				or bl.sku = 'CSE-SML-AVI-12'
				or bl.sku = 'CSE-SML-AVI-10' THEN 'Avis vérifiés'
				when bl.sku = 'PS-SML-SON-19'
				or bl.sku = 'PS-SML-SON-02' THEN 'Sonja Pastor'
				when bl.sku = 'PS-SML-ADE-22' THEN 'Adele Leung
'				when bl.sku = 'PS-SML-NIC-20'
				or bl.sku = 'PS-SML-NIC-12'
				or bl.sku = 'PS-SML-NIC-15'
				or bl.sku = 'PS-SML-NIC-04'
				OR bl.sku = 'PS-SML-NIC-22' THEN 'Nicola Reinkens'
				when bl.sku = 'PS-SML-MIR-11'
				or bl.sku = 'PS-SML-MIR-02'
				or bl.sku = 'PS-SML-MIR-07'
				or bl.sku = 'PS-SML-MIR-09'
				or bl.sku = 'PS-SML-MIR-03'
				or bl.sku = 'PS-SML-MIR-04'
				or bl.sku = 'PS-SML-MIR-78'
				or bl.sku = 'PS-SML-MIR-24'
				or bl.sku = 'SMB1650589194' THEN 'Miriam Lasserre'
				when bl.sku LIKE 'PS-SML-LIZ%' THEN 'Liz Teich'
				when bl.sku LIKE 'PS-SML-KIS%' THEN 'The Kismet Collective'
				when bl.sku LIKE 'HPALXSML%' THEN 'Happy Pal'
				when bl.sku = 'CSE-SML-ACC-11' THEN 'Accor'
				when bl.sku = 'PRO-SML-CIN-21' THEN 'Cinétévé'
				when bl.sku = 'PS-SML-COL-21' THEN 'Le Collectionist'
				when bl.sku = 'CSE-SML-BETC-21'
				or bl.sku = 'CSE-SML-BETC-12'
				or bl.sku = 'SMB1771438465' OR bl.sku = 'CSE-SML-BETC-22' THEN 'BETC'
				when bl.sku = 'PRO-SML-CRI-12' THEN 'DG Crillon'
				when bl.sku = 'CSE-SML-QON-10' THEN 'Qonto'
				when bl.sku = 'PRO-SML-ICO-22' THEN 'Iconic House'
				when bl.sku = 'PRO-SML-HOX-22' THEN 'The Hoxton'
				when bl.sku = 'SMB2034863811' THEN 'Gastronomica'
				when bl.sku = 'CSE-SML-GWS-22' THEN 'William Sinclair'
			END AS partenaire
		FROM
			smallable2_datawarehouse.b_orders bo
		INNER JOIN smallable2_front.basket_line bl 
ON
			bo.basket_id = bl.basket_id
		WHERE
			bo.created_at >= '2022-01-01'
			AND bo.created_at <= '2022-06-30'
			AND bo.is_valid = 1
			AND bo.is_ca_ht_not_zero = 1
			and (bl.sku LIKE 'PS-SML-KIS%' -- 'PS-SML-LIZ%' bl.sku LIKE 'HPALXSML%'
				or bl.sku IN ('PS-SML-MIR-78','PS-SML-MIR-04','PS-SML-NIC-04','MCXSML2021','PS-SML-ADE-22','PRO-SML-ICO-22','PRO-SML-HOX-22','SMB2034863811','CSE-SML-GWS-22','CSE-SML-BETC-22', 'SMB881363108','PS-SML-NIC-22','CSE-SML-QON-10', 'SMB1771438465', 'CSE-SML-AVI-10', 'SMB1650589194', 'CSE-SML-AVI-12', 'PS-SML-NIC-12', 'PS-SML-MIR-24', 'PS-SML-MIR-03', 'PRO-SML-CRI-12', 'PS-SML-MIR-09', 'PS-SML-SON-02', 'PS-SML-MIR-11', 'PS-SML-MIR-02', 'PS-SML-MIR-07', 'CSE-SML-BETC-12', 'CSE-SML-BETC-21', 'PS-SML-COL-21', 'PRO-SML-CIN-21', 'CSE-SML-ACC-11', 'CSEGXSML21', 'SMBSELOGER3008', 'CSE-SML-AVI-09', 'PS-SML-SON-19', 'PS-SML-NIC-20', 'CSE-SML-ACC-11', 'PRO-SML-CIN-21')))r1 on
	r1.o_id = bo2.order_id
GROUP BY
	r1.partenaire
ORDER BY
	nb_commandes DESC,
	CA_brut DESC
	
	
select *
from smallable2_datawarehouse.b_orders bo 
where bo.order_id = '7353597'


select distinct bop.basket_id, sum(bop.billing_product_ht/100)
from smallable2_datawarehouse.b_order_products bop 
inner join smallable2_datawarehouse.b_skus bs 
on bop.sml_team =bs.sml_team 
and bop.sku_code = bs.sku_code 
where bs.sku_code  = 'GCA0314999'
group by bop.basket_id 