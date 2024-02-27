------------------ Table Wishlist ----------------------------------
DROP TABLE IF EXISTS smallable2_playground.wishlist;
​
CREATE TABLE smallable2_playground.wishlist
    Engine = MergeTree()
        ORDER BY tuple()
AS
SELECT customer_id, product_id FROM (	
	SELECT
		customer_id,
		toInt32(product_id_s) AS product_id,
		row_number() OVER (ORDER BY 1) AS row_num
	FROM
		(
		SELECT
			w.customer_id,
			arrayJoin(
				  splitByChar(';', 
									regexp_replace(
													regexp_replace(w.products,
																				'^[^{]*', ---# supprime tout ce qui se trouve avant le { pour supprimer le premier nombre qui se trouve dans le champ
																				''),
													'[^0-9;]',                            ---# garde uniquement les chiffres et les points virgules 
													'')))                                 ---# splitByChar() transforme ces chiffres séparés par des points virgules en array
				AS product_id_s                                                           ---# arrayJoin() duplique chaque ligne pour que chaque élément de l'ARRAY devienne une ligne
		FROM
			smallable2_front.wishlist w		
			) w1
	WHERE
		LENGTH(product_id_s) >= 1) wl                                                     ---# supprime les lignes vides 
WHERE row_num % 2 = 0																	  ---# supprimer les lignes impaires, qui correspondent aux positions des produits dans les wishlist, pour ne garder que les id produits
	
​
​
​
SELECT
	bp.product_id,
	bp.ref_co,
	bp.product_public_price_ht * 1.2 AS prix,
	bp.brand_name AS marque,
	bp.html_photo1,
	sum(CASE WHEN bs.quantity_type_id = 1 THEN bs.stock_delta ELSE 0 END) - sum(CASE WHEN bs.quantity_type_id IN (4, 5, 6) THEN bs.stock_delta ELSE 0 END) AS stock
FROM
	smallable2_playground.wishlist w
INNER JOIN smallable2_datawarehouse.b_products bp ON
	bp.product_id = w.product_id
	AND w.customer_id = 1668489 --1255766 --73279 --renseigner ID de la personne pour checker la WL
INNER JOIN smallable2_datawarehouse.b_stocks bs ON
	bs.product_id = bp.product_id 
GROUP BY
	bp.product_id,
	bp.ref_co,
	bp.product_public_price_ht * 1.2 AS prix,
	bp.brand_name AS marque,
	bp.html_photo1