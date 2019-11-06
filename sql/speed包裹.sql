SELECT 
pi.`pno`as '运单号',
pi.`client_id` ,
(pi.`store_parcel_amount`/100) as '运费',
(`exhibition_weight`/1000) as '重量kg',
case pi.`state` 
WHEN 1 THEN '已揽收'
when 2 then '运输中'
when 3 then '派送中'
when 4 then '已滞留'
when 5 then '已签收'
when 6 then '疑难件处理中'
when 7 then '已退件'
when 8 then '异常关闭'
when 9 then '已撤销'
end as '运单状态',
pi.`ticket_pickup_store_id` as '揽件网点id',ss1.`name` as '揽件网点名',
date_format(CONVERT_TZ(pi.created_at, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') as '揽件时间', pi.`src_postal_code`as '寄件地邮编',pi.`dst_store_id`   as '目的地网点id',ss2.`name` as '目的地网点名',date_format(CONVERT_TZ(pi.`finished_at` , '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') as '妥投时间',pi.`dst_postal_code` as '目的地邮编'
from `parcel_info` pi 
LEFT JOIN `sys_store` ss1 on pi.`ticket_pickup_store_id` =ss1.`id` 
LEFT JOIN `sys_store` ss2 on pi.`dst_store_id`  =ss2.`id` 

WHERE
(pi.`client_id` in ('AA0227','AA0342','AA0339','AA0230','AA0233','CA9721','CA0564'))
and (pi.`state` not in (7,9))
and (date_format(CONVERT_TZ(pi.created_at, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') >'2019-10-01 00:00:01')
and (date_format(CONVERT_TZ(pi.created_at, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') <'2019-10-31 23:59:59')






########################
SELECT COUNT(pi.`pno`) as '总单量', SUM(pi.`store_parcel_amount`/100) as '总运费',sum(if(pi.`cod_enabled` =1,1,0)) as 'cod单量',sum(pi.`cod_poundage_amount`/100) as 'cod服务费'
FROM `parcel_info` pi
WHERE 

(date_format(CONVERT_TZ(pi.created_at, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') >'2019-09-01 00:00:01')
and (date_format(CONVERT_TZ(pi.created_at, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') <'2019-09-30 23:59:59')

and pi.`client_id` in (
'AA0227','BA0364','BA1168','BA1704','AA0306','AA0217','BA0428','BA1267','CB9731','AA0308','AA0312','AA0366','AA0339','AA0232','BA0263','BA0447','CA2264','CA3280','AA0204','AA0214','AA0317','BA0474','BA1708','AA0338','AA0298','AA0230','AA0274','AA0290','AA0212','BA0823','AA0007','AA0342','BA1268','CC8375','AA0233','BA2747','AA0289','BA5494','BA7970','AA0234','BA4088','AA0299','BA8070','AA0236','CC1145','AA0334','AA0309'
)

GROUP BY pi.`client_id` 






(date_format(CONVERT_TZ(pi.created_at, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') >'2019-10-01 00:00:01')
and (date_format(CONVERT_TZ(pi.created_at, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') <'2019-10-31 23:59:59')