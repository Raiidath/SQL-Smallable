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
				when bl.sku = 'SMBSELOGER3008' THEN 'Se Loger'
				when bl.sku = 'CSE-SML-AVI-09'
				or bl.sku = 'CSE-SML-AVI-12'
				or bl.sku = 'CSE-SML-AVI-10' THEN 'Avis vérifiés'
				when bl.sku = 'PS-SML-SON-19'
				or bl.sku = 'PS-SML-SON-02' THEN 'Sonja Pastor'
				when bl.sku = 'PS-SML-NIC-20'
				or bl.sku = 'PS-SML-NIC-12'
				OR bl.sku = 'PS-SML-NIC-22' THEN 'Nicola Reinkens'
				when bl.sku = 'PS-SML-MIR-11'
				or bl.sku = 'PS-SML-MIR-02'
				or bl.sku = 'PS-SML-MIR-07'
				or bl.sku = 'PS-SML-MIR-09'
				or bl.sku = 'PS-SML-MIR-03'
				or bl.sku = 'PS-SML-MIR-24'
				or bl.sku = 'SMB1650589194' THEN 'Miriam Lasserre'
				when bl.sku LIKE 'HPALXSML%' THEN 'Happy Pal'
				when bl.sku = 'CSE-SML-ACC-11' THEN 'Accor'
				when bl.sku = 'PRO-SML-CIN-21' THEN 'Cinétévé'
				when bl.sku = 'PS-SML-COL-21' THEN 'Le Collectionist'
				when bl.sku = 'CSE-SML-BETC-21'
				or bl.sku = 'CSE-SML-BETC-12'
				or bl.sku = 'SMB1771438465' THEN 'BETC'
				when bl.sku = 'PRO-SML-CRI-12' THEN 'DG Crillon'
				when bl.sku = 'CSE-SML-QON-10' THEN 'Qonto'
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
			bo.created_at < '2022-04-01'
			and (bl.sku LIKE 'HPALXSML%'
				or bl.sku IN ('SMB881363108','PS-SML-NIC-22','CSE-SML-QON-10', 'SMB1771438465', 'CSE-SML-AVI-10', 'SMB1650589194', 'CSE-SML-AVI-12', 'PS-SML-NIC-12', 'PS-SML-MIR-24', 'PS-SML-MIR-03', 'PRO-SML-CRI-12', 'PS-SML-MIR-09', 'PS-SML-SON-02', 'PS-SML-MIR-11', 'PS-SML-MIR-02', 'PS-SML-MIR-07', 'CSE-SML-BETC-12', 'CSE-SML-BETC-21', 'PS-SML-COL-21', 'PRO-SML-CIN-21', 'CSE-SML-ACC-11', 'CSEGXSML21', 'SMBSELOGER3008', 'CSE-SML-AVI-09', 'PS-SML-SON-19', 'PS-SML-NIC-20', 'CSE-SML-ACC-11', 'PRO-SML-CIN-21')))r1 on
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