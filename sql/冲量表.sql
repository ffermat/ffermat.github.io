#####冲量表1##################
SELECT ss1.`sorting_no` as '揽件网点区域',ss1.`name`as '揽件网点名' ,ss2.`sorting_no`as '目的网点区域',count(*) as '件量',r.件量 as '11月件量'
from `parcel_info` pi
LEFT JOIN `sys_store` ss1 on ss1.`id` =pi.`ticket_pickup_store_id` #揽件网点
LEFT JOIN `sys_store` ss2 on ss2.`id` =pi.`ticket_delivery_store_id` #派件网点
LEFT JOIN 
(
SELECT ss1.`sorting_no` as '揽件网点区域',ss1.`name`as '揽件网点名' ,ss2.`sorting_no`as '目的网点区域',count(*) as '件量'
from `parcel_info` pi
LEFT JOIN `sys_store` ss1 on ss1.`id` =pi.`ticket_pickup_store_id` #揽件网点
LEFT JOIN `sys_store` ss2 on ss2.`id` =pi.`ticket_delivery_store_id` #派件网点


WHERE ss1.`sorting_no` in ('NE','N') and ss1.`category` in (1,2)
and   ss2.`sorting_no` in ('NE','N') and ss2.`category` in (1,2)
and pi.`created_at` >'2019-10-31 17:00:00'
and pi.`created_at` <'2019-11-12 17:00:00'
GROUP BY ss1.`id` ,ss2.`sorting_no` 
ORDER BY ss1.`id` 
) r on ss1.`name`=r.揽件网点名 and ss2.`sorting_no`=r.目的网点区域

WHERE ss1.`sorting_no` in ('NE','N') and ss1.`category` in (1,2)
and   ss2.`sorting_no` in ('NE','N') and ss2.`category` in (1,2)
and pi.`created_at` >'2019-09-30 17:00:00'
and pi.`created_at` <'2019-10-31 17:00:00'
GROUP BY ss1.`id` ,ss2.`sorting_no` 
ORDER BY ss1.`id` 


####冲量表2每日明细##############
