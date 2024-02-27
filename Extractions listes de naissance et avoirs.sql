------------------ CONTRIBUTIONS 
SELECT * FROM smallable2_datawarehouse.b_export_contributions bec
--WHERE bec.created < '2024-01-01'



------------------ VOUCHERS
SELECT
     type,
     voucher_id,
     rest_amount,
     code,
     comment,
     customer,
     status,
     reason_id,
     businessGesture,
     expiration_date,
     created,
     voucher_amount_euro,
     CASE WHEN use_date > '2024-01-01' THEN 0 ELSE montant_utilise_euro END AS montant_utilise_euro ,
     CASE WHEN use_date > '2024-01-01' THEN date('1970-01-01') ELSE use_date END AS use_date ,
     CASE WHEN use_date > '2024-01-01' THEN 0 ELSE voucher_amount_local END AS voucher_amount_local ,
     CASE WHEN use_date > '2024-01-01' THEN 0 ELSE initial_amount_local END AS initial_amount_local ,
     CASE WHEN use_date > '2024-01-01' THEN 0 ELSE change_voucher_amount END AS change_voucher_amount 
FROM
     smallable2_datawarehouse.b_export_vouchers bev
WHERE
     bev.created < '2024-01-01'
     
     
SELECT * 
FROM smallable2_datawarehouse.b_export_vouchers bev