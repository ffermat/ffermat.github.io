##大区片区发件量
SELECT smr.`name` as '大区',smp.`name` as '片区',date_format(pi.`created_at`,'%Y-%m')as '月份',COUNT(*) as '发件量'
from `parcel_info` pi
LEFT JOIN `sys_store` ss on pi.`ticket_pickup_store_id` =ss.`id` 
LEFT JOIN `sys_manage_piece` smp on ss.`manage_piece`  =smp.`id` 
LEFT JOIN `sys_manage_region` smr on ss.`manage_region` =smr.`id` 
WHERE pi.`created_at`>'2019-05-31 17:00:00' and pi.`created_at` <'2019-10-31 17:00:00' and `manage_piece` IS NOT NULL 
GROUP BY ss.`manage_region` ,ss.`manage_piece`,date_format(pi.`created_at`,  '%Y-%m')
ORDER BY 
ss.`manage_piece`,date_format(pi.`created_at`,  '%Y-%m')


##回款率分网点######################################
SELECT `store_id`as storeid ,date_format(CONVERT_TZ(sr.`created_at`, '+00:00','+07:00'),  '%Y-%m') as month,SUM(sr. `receivable_amount`/100) as shouldrece,a.shouldrece as received
from `store_receivable_bill_detail` sr
LEFT JOIN (

SELECT `store_id`as storeid,date_format(CONVERT_TZ(sr.`created_at`, '+00:00','+07:00'),  '%Y-%m') as month,SUM(sr. `receivable_amount`/100) as shouldrece
from `store_receivable_bill_detail` sr
WHERE  sr.`created_at`>'2019-05-31 17:00:00' and sr.`created_at` <'2019-10-31 17:00:00' and	`state` in (1)
GROUP BY `store_id`,date_format(CONVERT_TZ(sr.`created_at`, '+00:00','+07:00'),  '%Y-%m')

）a on sr.`store_id` =a.storeid and date_format(CONVERT_TZ(sr.`created_at`, '+00:00','+07:00'),  '%Y-%m')=a.month
WHERE  sr.`created_at`>'2019-05-31 17:00:00' and sr.`created_at` <'2019-10-31 17:00:00' and	`state` in (1,2)
GROUP BY `store_id`,date_format(CONVERT_TZ(sr.`created_at`, '+00:00','+07:00'),  '%Y-%m')

##回款率不分网点################################################
SELECT date_format(CONVERT_TZ(sr.`created_at`, '+00:00','+07:00'),  '%Y-%m') as month,SUM(sr. `receivable_amount`/100) as shouldrece,a.shouldrece as received
from `store_receivable_bill_detail` sr
LEFT JOIN (

SELECT date_format(CONVERT_TZ(sr.`created_at`, '+00:00','+07:00'),  '%Y-%m') as month,SUM(sr. `receivable_amount`/100) as shouldrece
from `store_receivable_bill_detail` sr
WHERE  sr.`created_at`>'2019-05-31 17:00:00' and sr.`created_at` <'2019-10-31 17:00:00' and	`state` in (1)
GROUP by date_format(CONVERT_TZ(sr.`created_at`, '+00:00','+07:00'),  '%Y-%m')

）a on date_format(CONVERT_TZ(sr.`created_at`, '+00:00','+07:00'),  '%Y-%m')=a.month
WHERE  sr.`created_at`>'2019-05-31 17:00:00' and sr.`created_at` <'2019-10-31 17:00:00' and	`state` in (1,2)
GROUP by date_format(CONVERT_TZ(sr.`created_at`, '+00:00','+07:00'),  '%Y-%m')