SELECT 
pi.`client_id` ,
sum(if(ss.`category`  in (1,2),1,0)) 十月DC发件量,
sum(if(ss.`category`  in (1,2) and pi.`upcountry`=1,1,0)) 十月DC发件偏远地区量,
sum(if(ss.`category`  in (4),1,0)) 十月shop发件量,
sum(if(ss.`category`  in (4) and pi.`upcountry`=1 ,1,0)) 十月shop发件偏远地区量
from `parcel_info` pi
LEFT JOIN `sys_store` ss on pi.`ticket_pickup_store_id` =ss.`id`
WHERE pi.`created_at`>'2019-09-30 17:00:00' and pi.`created_at` <'2019-10-31 17:00:00'
GROUP BY pi.`client_id`
ORDER BY 十月shop发件量 DESC 