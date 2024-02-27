SELECT
	co.id AS ID_Commande, 
	bl.sku AS SKU,
	p2.name AS Libelle,
	m.id AS ID_Marque, 
	m.name AS Marques,
	d.taille_pointure_frs AS Taille,
	bl.unit_selling_amount AS Prix_vente,
	d.paht AS Prix_Achat,
	toDate(co.validated) AS Date_Commande,
	coa.firstname AS Prenom,
	coa.lastname AS Nom,-- coa.street1, coa.city,
	c2.name AS Pays_destinataire,
	c.email AS Initiateur_Commande
FROM
	smallable2_front.customer_order co
INNER JOIN smallable2_front.customer c ON
	c.id = co.customer_id
INNER JOIN smallable2_front.basket_line bl ON
	co.basket_id = bl.basket_id
INNER JOIN smallable2_front.customer_order_address coa ON
	co.delivery_address_id = coa.id
INNER JOIN smallable2_descriptor.country c2 ON
	c2.id = coa.country_id
INNER JOIN smallable2_descriptor.declinaison d ON
	d.reference = bl.sku
INNER JOIN smallable2_descriptor.product p ON
	d.id_product = p.id
INNER JOIN smallable2_descriptor.productlang p2 ON
	p2.id_product = p.id
INNER JOIN smallable2_descriptor.manufacturer m ON
	m.id = p.id_manufacturer
WHERE
	Date_Commande  >= toDate(today() - 7)
	AND Date_Commande  <= toDate(today())
	AND c.email IN ('l.coello-freeorder@smallable.com',  'c.sanchez-freeorder@smallable.com', 'f.bock-freeorder@smallable.com',  'i.grzimek-freeorder@smallable.com',  'a.rinconmartinez-freeorder@smallable.com',  'z.topic-freeorder@smallable.com')
	AND p2.id_lang = 2
ORDER BY Date_Commande, Nom asc
	
	



SELECT
	co.id AS ID_Commande, 
	bl.sku AS SKU,
	p2.name AS Libelle,
	m.id AS ID_Marque, 
	m.name AS Marques,
	d.taille_pointure_frs AS Taille,
	bl.unit_selling_amount AS Prix_vente,
	d.paht AS Prix_Achat,
	toDate(co.validated) AS Date_Commande,
	coa.firstname AS Prenom,
	coa.lastname AS Nom,  --coa.street1, coa.city,
	c2.name AS Pays_destinataire,
	c.email AS Initiateur_Commande
FROM
	smallable2_front.customer_order co
INNER JOIN smallable2_front.customer c ON
	c.id = co.customer_id
INNER JOIN smallable2_front.basket_line bl ON
	co.basket_id = bl.basket_id
INNER JOIN smallable2_front.customer_order_address coa ON
	co.delivery_address_id = coa.id
INNER JOIN smallable2_front.country c3 ON
	c3.id = coa.country_id
INNER JOIN smallable2_descriptor.country c2 ON
	c3.iso_code = c2.iso 
INNER JOIN smallable2_descriptor.declinaison d ON
	d.reference = bl.sku
INNER JOIN smallable2_descriptor.product p ON
	d.id_product = p.id
INNER JOIN smallable2_descriptor.productlang p2 ON
	p2.id_product = p.id
INNER JOIN smallable2_descriptor.manufacturer m ON
	m.id = p.id_manufacturer
WHERE
	Date_Commande  >= '2024-02-01' --'2022-01-01'
	AND Date_Commande <= '2024-02-18'
	AND c.email IN ('l.coello-freeorder@smallable.com',  'c.sanchez-freeorder@smallable.com', 'f.bock-freeorder@smallable.com',  'i.grzimek-freeorder@smallable.com',  'a.rinconmartinez-freeorder@smallable.com', 'z.topic-freeorder@smallable.com')
	AND p2.id_lang = 2
ORDER BY Date_Commande, Nom ASC



SELECT
	co.id AS ID_Commande, 
	bl.sku AS SKU,
	p2.name AS Libelle,
	m.id AS ID_Marque, 
	m.name AS Marques,
	d.taille_pointure_frs AS Taille,
	bl.unit_selling_amount AS Prix_vente,
	d.paht AS Prix_Achat,
	toDate(co.validated) AS Date_Commande,
	coa.firstname AS Prenom,
	coa.lastname AS Nom,
	c2.name AS Pays_destinataire,
	c.email AS Initiateur_Commande
FROM
	front.customer_order co
INNER JOIN front.customer c ON
	c.id = co.customer_id
INNER JOIN front.basket_line bl ON
	co.basket_id = bl.basket_id
INNER JOIN front.customer_order_address coa ON
	co.delivery_address_id = coa.id
INNER JOIN front.country c3 ON
	c3.id = coa.country_id
INNER JOIN descriptor.country c2 ON
	c3.iso_code = c2.iso 
INNER JOIN descriptor.declinaison d ON
	d.reference = bl.sku
INNER JOIN descriptor.product p ON
	d.id_product = p.id
INNER JOIN descriptor.productlang p2 ON
	p2.id_product = p.id
INNER JOIN descriptor.manufacturer m ON
	m.id = p.id_manufacturer
WHERE
	Date_Commande  >= toDate(today() - 7)
	AND Date_Commande <= toDate(today())
	AND c.email IN ('l.coello-freeorder@smallable.com',  'c.sanchez-freeorder@smallable.com', 'f.bock-freeorder@smallable.com',  'i.grzimek-freeorder@smallable.com',  'a.rinconmartinez-freeorder@smallable.com', 'z.topic-freeorder@smallable.com')
	AND p2.id_lang = 2
ORDER BY Date_Commande, Nom ASC









SELECT
	co.id AS ID_Commande, 
	bl.sku AS SKU,
	p2.name AS Libelle,
	m.id AS ID_Marque, 
	m.name AS Marques,
	d.taille_pointure_frs AS Taille,
	bl.unit_selling_amount AS Prix_vente,
	d.paht AS Prix_Achat,
	toDate(co.validated) AS Date_Commande,
	coa.firstname AS Prenom,
	coa.lastname AS Nom,
	c2.name AS Pays_destinataire,
	c.email AS Initiateur_Commande
FROM
	front.customer_order co
INNER JOIN front.customer c ON
	c.id = co.customer_id
INNER JOIN front.basket_line bl ON
	co.basket_id = bl.basket_id
INNER JOIN front.customer_order_address coa ON
	co.delivery_address_id = coa.id
INNER JOIN descriptor.country c2 ON
	c2.id = coa.country_id
INNER JOIN descriptor.declinaison d ON
	d.reference = bl.sku
INNER JOIN descriptor.product p ON
	d.id_product = p.id
INNER JOIN descriptor.productlang p2 ON
	p2.id_product = p.id
INNER JOIN descriptor.manufacturer m ON
	m.id = p.id_manufacturer
WHERE
	co.validated >= toDate(today() - 7)
	AND co.validated <= toDate(today())
	AND c.email IN ('l.coello-freeorder@smallable.com',  'c.sanchez-freeorder@smallable.com ', 'f.bock-freeorder@smallable.com',  'i.grzimek-freeorder@smallable.com',  'a.rinconmartinez-freeorder@smallable.com')
	AND p2.id_lang = 2
ORDER BY Date_Commande, Nom asc



	
	

SELECT * FROM smallable2_static.tmp_traffic_eulerian


SELECT * FROM smallable2_datawarehouse.b_traffic bt 



SELECT c2.iso, c2.name  FROM  smallable2_front.customer_order co 
INNER JOIN smallable2_front.customer_order_address coa ON
	co.delivery_address_id = coa.id
INNER JOIN smallable2_front.country c ON
	c.id = coa.country_id
INNER JOIN smallable2_descriptor.country c2 ON
	c.iso_code = c2.iso 



SELECT * FROM  smallable2_front.basket_line bl 


SELECT * FROM smallable2_descriptor.productlang p where id_lang = 2


SELECT * FROM  smallable2_descriptor.product p


SELECT * FROM  smallable2_descriptor.country c 


SELECT * FROM smallable2_descriptor.declinaison d 


SELECT * FROM smallable2_front.customer_order_address coa


SELECT * FROM smallable2_front.country c  