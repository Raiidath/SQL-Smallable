------------------------------------------------------ Clients CHRURNER ET RISK -------------------------------------------------------------------------------
SELECT
	*
FROM
	(
	SELECT
		rfm.name,
		rfm.email AS email_casse,
		lower(rfm.email) AS email_minuscule,
		lower(hex(MD5(lower(rfm.email)))) AS md5,
		CASE
			WHEN rfm."R" = 'risk' THEN rfm."R"
			WHEN rfm."R" = 'churner' THEN rfm."R"
			WHEN rfm."R" = 'churner3years' THEN rfm."R"
			WHEN rfm."F" >= 2
			AND rfm."M" = 'gros' THEN 'top'
			WHEN rfm."F" >= 2
			AND rfm."M2" = 'top' THEN 'top'
			WHEN rfm."F" >= 2
			AND rfm."M" = 'petit'
			AND rfm."M2" IS NULL THEN 'reg_petit'
			WHEN rfm."R" = 'new' THEN rfm."R"
			WHEN rfm."F" < 2
			AND rfm."M" = 'gros' THEN 'irreg_gros'
			WHEN rfm."F" < 2
			AND rfm."M" = 'petit' THEN 'depannage'
		END AS seg,
		rfm.currency AS devise,
		rfm.langue AS langue,
		rfm.opt_in AS opt_in,
		rfm.cid FROM (
		SELECT
			DISTINCT bc.email AS email,
			concat(bc.firstname,
			' ',
			bc.lastname) AS name,
			bc.customer_id AS cid,
			CASE
				WHEN (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.first_order_date)))/ 86400 < 180 THEN 'new'
				WHEN (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.last_order_date)))/ 86400 < 365 THEN 'R'
				WHEN (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.last_order_date)))/ 86400 > 365
				AND(toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.last_order_date)))/ 86400 < 548 THEN 'risk'
				WHEN (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.last_order_date)))/ 86400 >= 548
				AND(toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.last_order_date)))/ 86400 < 1096 THEN 'churner'
				WHEN (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.last_order_date)))/ 86400 >= 1096 THEN 'churner3years'
				ELSE 'old'
			END AS "R",
			CASE
				WHEN (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.first_order_date)))/ 86400 < 365 THEN nb_commandes_nettes * 1.0
				WHEN bc.first_order_date = bc.last_order_date THEN 1.0
				ELSE nb_commandes_nettes / (NULLIF(toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.first_order_date)),
				0)/ 31536000.0)
			END AS "F",
			CASE
				WHEN bc.LTV / bc.nb_commandes_nettes > 20000 THEN 'gros'
				ELSE 'petit'
			END AS "M",
			CASE
				WHEN bc.LTV > 150000 THEN 'top'
			END AS "M2",
			bc.LTV / 100 AS ltv,
			bc.LTV / (bc.nb_commandes_nettes * 100) AS pm,
			bc.first_order_date,
			bc.last_order_date,
			bc.nb_commandes_nettes ,
			bo.currency AS currency,
			l.name AS langue,
			CASE
				WHEN ns.email IS NULL THEN 0
				ELSE 1
			END AS opt_in
		FROM
			smallable2_datawarehouse.b_customers bc
		INNER JOIN smallable2_datawarehouse.b_orders bo ON
			bc.last_order_id = bo.order_id
		INNER JOIN smallable2_front.customer c ON
			bc.customer_id = c.id
		INNER JOIN smallable2_front.`language` l ON
			l.id = c.language_id
		LEFT JOIN smallable2_front.newsletter_subscription ns ON
			ns.email = c.email
			AND ns.enabled = 1
		WHERE
			bc.nb_commandes_nettes > 0) rfm) cp
WHERE
	cp.seg IN ('churner', 'risk')
	AND cp.opt_in = 1
	AND cp.cid NOT IN (
	SELECT
		cv.customer_id
	FROM
		smallable2_front.commercial_voucher cv
	WHERE
		cv.code ilike '%JUST4YOU%')
			
		

	
		
----------------------------------------- STATUS RFM GLOBAL SITE ----------------------------------------------------------------------------------		
			
WITH ancien_code AS (
	SELECT
		cv.customer_id AS cid, cv.code AS code
	FROM
		smallable2_front.commercial_voucher cv
	WHERE
		cv.code ilike '%JUST4YOU%')
SELECT
	rfm.name, 
	rfm.email AS email_casse,
	lower(rfm.email) AS email_minuscule,
	lower(hex(MD5(lower(rfm.email)))) AS md5,
	CASE
		WHEN rfm."R" = 'risk' THEN rfm."R"
		WHEN rfm."R" = 'churner' THEN rfm."R"
		WHEN rfm."R" = 'churner3years' THEN rfm."R"
		WHEN rfm."F" >= 2
		AND rfm."M" = 'gros' THEN 'top'
		WHEN rfm."F" >= 2
		AND rfm."M2" = 'top' THEN 'top'
		WHEN rfm."F" >= 2
		AND rfm."M" = 'petit'
		AND rfm."M2" IS NULL THEN 'reg_petit'
		WHEN rfm."R" = 'new' THEN rfm."R"
		WHEN rfm."F" < 2
		AND rfm."M" = 'gros' THEN 'irreg_gros'
		WHEN rfm."F" < 2
		AND rfm."M" = 'petit' THEN 'depannage'
	END AS seg,
	rfm.currency AS devise,
	rfm.langue AS langue,
	rfm.opt_in AS opt_in,
	rfm.cid,
	ac.code
FROM
	(
	SELECT
		DISTINCT bc.email AS email,
		concat(bc.firstname,' ',bc.lastname) AS name,
		bc.customer_id AS cid,
		CASE
			WHEN (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.first_order_date)))/ 86400 < 180 THEN 'new'
			WHEN (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.last_order_date)))/ 86400 < 365 THEN 'R'
			WHEN (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.last_order_date)))/ 86400 > 365
			AND
(toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.last_order_date)))/ 86400 < 548 THEN 'risk'
			WHEN (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.last_order_date)))/ 86400 >= 548
			AND
(toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.last_order_date)))/ 86400 < 1096 THEN 'churner'
			WHEN (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.last_order_date)))/ 86400 >= 1096 THEN 'churner3years'
			ELSE 'old'
		END AS "R",
		CASE
			WHEN (toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.first_order_date)))/ 86400 < 365 THEN nb_commandes_nettes * 1.0
			WHEN bc.first_order_date = bc.last_order_date THEN 1.0
			ELSE nb_commandes_nettes / (NULLIF(toUnixTimestamp(now())-toUnixTimestamp(toDateTime(bc.first_order_date)),
			0)/ 31536000.0)
		END AS "F",
		CASE
			WHEN bc.LTV  / bc.nb_commandes_nettes > 20000 THEN 'gros'
			ELSE 'petit'
		END AS "M",
		CASE
			WHEN bc.LTV > 150000 THEN 'top'
		END AS "M2",
		bc.LTV / 100 AS ltv,
		bc.LTV / (bc.nb_commandes_nettes * 100) AS pm,
		bc.first_order_date,
		bc.last_order_date,
		bc.nb_commandes_nettes ,
		bo.currency AS currency,
		l.name AS langue,
		CASE
			WHEN ns.email IS NULL THEN 0
			ELSE 1
		END AS opt_in
	FROM
		smallable2_datawarehouse.b_customers bc
	INNER JOIN smallable2_datawarehouse.b_orders bo ON
		bc.last_order_id = bo.order_id
	INNER JOIN smallable2_front.customer c ON
		bc.customer_id = c.id
	INNER JOIN smallable2_front.`language` l ON
		l.id = c.language_id
	LEFT JOIN smallable2_front.newsletter_subscription ns ON
		ns.email = c.email AND ns.enabled = 1
	WHERE
		bc.nb_commandes_nettes  > 0
) rfm  LEFT JOIN (SELECT * FROM ancien_code) ac ON ac.cid = rfm.cid
WHERE seg != 'churner3years'