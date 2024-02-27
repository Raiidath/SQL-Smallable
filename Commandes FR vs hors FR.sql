--On saurait ça fait combien d’adhérent en % sur le nb de client unique ayant passé cmd depuis le lancement grand public ?



SELECT
		bo.basket_id AS bid,
		 bo.customer_id AS cid, bo.billing_product_ht / 100
	FROM
		smallable2_datawarehouse.b_orders bo 
	WHERE
	 bo.created_at BETWEEN '2022-10-10' AND '2022-12-31'
	AND bo.order_id = '9288775'
	
	
--Je vais devoir revoir mes hypothèses d'asilage. Maybe on va finalement l'asiler par vagues cad un peu maintenant, puis un peu après catalogue de jouets...
--Par conséquent, pourrais-tu me dire par semaine à partir du lundi 10 octobre 2022 jusqu'au 31 décembre 2022 :
--combien nous avons eu de commandes en N-1 > 0€ en livraison France vs Autres pays ?
--combien nous avons eu de commandes en N-1 > 50€ en livraison France vs Autres pays ?
--combien nous avons eu de commande en N-1 > 100€ en livraison France vs Autres pays ?
--combien nous avons eu de commande en N-1  > 150€ en livraison France vs Autres pays ?
--combien nous avons eu de commande en N-1  > 200€ en livraison France vs Autres pays ?
--combien nous avons eu de commande en N-1  > 250€ en livraison France vs Autres pays ?
--==> si possible avec filtre clients uniques sur toute cette période vu que je limiterai à 1 exemplaire par personne.
--==> ça me permettra de voir à partir de combien je l'offre en France VS International pour qu'il y ai une couverture ni trop longue ni trop courte
	
	
--count(DISTINCT CASE WHEN bo.delivery_country_id  = 'France' THEN bo.order_id END AS f) AS bid
	
with com as (select
	  bo.order_id) AS bid,
	  bo.billing_product_ht/100 AS ca
from
	smallable2_datawarehouse.b_orders bo
where
	bo.created_at >= '2022-10-10' 
	and bo.created_at <= '2022-12-31'
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1)
select
	count(DISTINCT bo.order_id) as cmd,
	sum(bo.billing_product_hc  / 100) AS CA_
from
	smallable2_datawarehouse.b_orders bo
where
	bo.order_id  in (select bid from hp)
	and bo.is_valid = 1
	and bo.is_ca_ht_not_zero = 1	
	
	
	
	
SELECT
		count(DISTINCT CASE WHEN (bo.billing_product_ht/100) >'0' THEN bo.order_id AS C0
		CASE
		WHEN c9."client running %" < 1 THEN 'top 1%'
		WHEN c9."client running %" < 8 THEN 'top 1 - 8%'
		WHEN c9."client running %" < 15 THEN 'top 8 - 15%'
		WHEN c9."client running %" < 20 THEN 'top 20%'
		WHEN c9."client running %" < 50 THEN 'top 50%'
		WHEN c9."client running %" IS NULL THEN 'nc'
		ELSE 'top 51+'
	END AS top_clients as cmd
		--count(DISTINCT CASE WHEN (bo.billing_product_ht/100) >'50' THEN bo.order_id else null end) as cmd,
		--count(DISTINCT CASE WHEN (bo.billing_product_ht/100) >'100' THEN bo.order_id else null end) as cmd
FROM
		smallable2_datawarehouse.b_orders bo
WHERE bo.created_at >= '2022-10-10'
	AND bo.created_at <= '2022-12-31'
	AND bo.is_valid = 1
	AND bo.is_ca_ht_not_zero = 1
	
	
	

SELECT 
	    c9."client running %", 
	CASE
		WHEN c9."running %" > 0 THEN 'top 1%'
		WHEN c9."running %" > 50 THEN 'top 1 - 8%'
		WHEN c9."running %" > 100 THEN 'top 8 - 15%'
		WHEN c9."running %" > 150 THEN 'top 20%'
		WHEN c9."running %" > 200 THEN 'top 50%'
		WHEN c9."running %" > 250 THEN 'nc'
		ELSE 'Commande'
	END AS top_clients
FROM (
	SELECT
		c2.cid,
		nb AS "client running %",
		--100 * c2.ca / c2.total AS "%",
		total AS "running %"
	FROM
		(
		SELECT
			*,
			sum(c1.ca) OVER() AS total,
			count(c1.cid) OVER() AS nb
		FROM
			(
			SELECT
				bo.order_id AS cid,
				sum(bo.billing_product_ht / 100) AS ca
			FROM
				smallable2_datawarehouse.b_orders bo
			WHERE
				bo.is_valid = 1
				AND bo.is_ca_net_ht_not_zero = 1
				AND bo.created_at BETWEEN '2022-10-10' AND '2022-12-31'
				--AND bo.delivery_country_iso  IN ('SE') -- ,'DK'--('AE','SA', 'QA', 'KW', 'BH', 'IL' )
			GROUP BY
				cid) c1
		GROUP BY
			cid,
			ca
		ORDER BY
			ca DESC) c2) c9 
			
			
SELECT 
	   CASE
			WHEN c1.ca > 0 THEN 'sup_0'
			WHEN c1.ca > 50 THEN 'sup_50'
			WHEN c1.ca > 100 THEN 'sup_100'
			WHEN c1.ca > 150 THEN 'sup_150'
			WHEN c1.ca > 200 THEN 'sup_200'
			WHEN c1.ca > 250 THEN 'sup_250'
			ELSE 'autre'
	END AS commande,
	count(c1.cid)
		FROM
			(SELECT
				bo.order_id AS cid,
				sum(bo.billing_product_ht / 100) AS ca
			FROM
				smallable2_datawarehouse.b_orders bo
			WHERE
				bo.is_valid = 1
				AND bo.is_ca_net_ht_not_zero = 1
				AND bo.created_at BETWEEN '2022-10-10' AND '2022-12-31'
				--AND bo.delivery_country_iso  IN ('SE') -- ,'DK'--('AE','SA', 'QA', 'KW', 'BH', 'IL' )
			GROUP BY
				cid) c1
				
				
				
select
	case
		when e.created < '2021-01-31' then 'Janvier'
		when e.created < '2021-02-31' then 'F�vrier'
		when e.created < '2021-03-31' then 'Mars'
		when e.created < '2021-04-31' then 'Avril'
		when e.created < '2021-05-31' then 'Mai'
		when e.created < '2021-06-31' then 'Juin'
		when e.created < '2021-07-31' then 'Juillet'
		when e.created < '2021-08-31' then 'Ao�t'
		when e.created < '2021-09-31' then 'Septembre'
		when e.created < '2021-10-31' then 'Octobre'
		when e.created < '2021-11-31' then 'Novembre'
		else 'D�cembre'
	end as Mois,
	count(distinct e.email) as distinct_clients,
	count(e.email) as nb
from
		smallable2_front.availability_alert e
where
	e.created > '2021-01-01'
	and e.created < '2021-12-31'
	
	
SELECT 
	   CASE
		WHEN c1.ca > '0' THEN 'sup_0'
		WHEN c1.ca > '50' THEN 'sup_50'
		WHEN c1.ca > '100' THEN 'sup_100'
		WHEN c1.ca > '150' THEN 'sup_150'
		WHEN c1.ca > '200' THEN 'sup_200'
		WHEN c1.ca > '250' THEN 'sup_250'
		ELSE 'autre'
	END AS commande,
	sum(c1.bid)
FROM
			(
	SELECT
				bo.order_id AS cid,
				sum(bo.billing_product_ht / 100) AS ca,
				count(bo.order_id) AS bid
	FROM
				smallable2_datawarehouse.b_orders bo
	WHERE
				bo.is_valid = 1
		AND bo.is_ca_net_ht_not_zero = 1
		AND bo.created_at BETWEEN '2022-10-10' AND '2022-12-31'
		--AND bo.delivery_country_iso  IN ('SE') -- ,'DK'--('AE','SA', 'QA', 'KW', 'BH', 'IL' )
	GROUP BY
				cid) c1
			
				
				
				
SELECT 
	   distinct c1.commande, c1.week,
	sum(c1.bid)
	FROM				
(SELECT 
		toStartOfWeek(bo.created_at) as week,
		--bo.order_id AS cid,
		bo.billing_product_ht / 100 AS ca,
		count(bo.order_id) AS bid,
	    CASE
		--WHEN ca > '0' THEN 'sup_0'
		WHEN ca > '50' THEN 'sup_50'
		WHEN ca > '100' THEN 'sup_100'
		WHEN ca > '150' THEN 'sup_150'
		WHEN ca > '200' THEN 'sup_200'
		WHEN ca > '250' THEN 'sup_250'
		ELSE 'autre'
	END AS commande
	FROM
				smallable2_datawarehouse.b_orders bo
	WHERE
				bo.is_valid = 1
		AND bo.is_ca_net_ht_not_zero = 1
		AND bo.created_at BETWEEN '2022-10-10' AND '2022-12-31'
		AND bo.delivery_country_iso  IN ('FR') -- ,'DK'--('AE','SA', 'QA', 'KW', 'BH', 'IL' )
	GROUP BY
				week, bo.billing_product_ht)c1
GROUP BY commande


SELECT 
		toStartOfWeek(bo.created_at) as week,
		count(DISTINCT CASE WHEN bo.billing_product_ht/100 > '0' THEN bo.customer_id ELSE NULL END) AS sup_0,
		count(DISTINCT CASE WHEN bo.billing_product_ht/100 > '50' THEN bo.customer_id ELSE NULL END) AS sup_50,
		count(DISTINCT CASE WHEN bo.billing_product_ht/100 > '100' THEN bo.customer_id ELSE NULL END) AS sup_100,
		count(DISTINCT CASE WHEN bo.billing_product_ht/100 > '150' THEN bo.customer_id ELSE NULL END) AS sup_150,
		count(DISTINCT CASE WHEN bo.billing_product_ht/100 > '200' THEN bo.customer_id ELSE NULL END) AS sup_200,
		count(DISTINCT CASE WHEN bo.billing_product_ht/100 > '250' THEN bo.customer_id ELSE NULL END) AS sup_250
	FROM
		smallable2_datawarehouse.b_orders bo
	WHERE
		bo.is_valid = 1
		AND bo.is_ca_net_ht_not_zero = 1
		AND bo.created_at BETWEEN '2022-10-10' AND '2022-12-31'
		--AND bo.delivery_country_iso  IN ('FR')
	GROUP BY week


SELECT 
		--toStartOfWeek(bo.created_at) as week,
		count(CASE WHEN bo.billing_product_ht/100 > '0' THEN bo.order_id ELSE NULL END) AS sup_0,
		count(CASE WHEN bo.billing_product_ht/100 > '50' THEN bo.order_id ELSE NULL END) AS sup_50,
		count(CASE WHEN bo.billing_product_ht/100 > '100' THEN bo.order_id ELSE NULL END) AS sup_100,
		count(CASE WHEN bo.billing_product_ht/100 > '150' THEN bo.order_id ELSE NULL END) AS sup_150,
		count(CASE WHEN bo.billing_product_ht/100 > '200' THEN bo.order_id ELSE NULL END) AS sup_200,
		count(CASE WHEN bo.billing_product_ht/100 > '250' THEN bo.order_id ELSE NULL END) AS sup_250
	FROM
		smallable2_datawarehouse.b_orders bo
	WHERE
		bo.is_valid = 1
		AND bo.is_ca_net_ht_not_zero = 1
		AND bo.created_at BETWEEN '2022-10-10' AND '2022-12-31'
		--AND bo.delivery_country_iso  NOT IN ('FR')
	--GROUP BY week