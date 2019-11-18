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
and pi.`created_at` <'2019-11-17 17:00:00'
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

SELECT ss1.`sorting_no` as '揽件网点区域',ss1.`name`as '揽件网点名' ,ss2.`sorting_no`as '目的网点区域',date_format(CONVERT_TZ(pi.created_at, '+00:00', '+07:00'),'%Y-%m-%d') as '日期',count(*) as '件量'
from `parcel_info` pi
LEFT JOIN `sys_store` ss1 on ss1.`id` =pi.`ticket_pickup_store_id` #揽件网点
LEFT JOIN `sys_store` ss2 on ss2.`id` =pi.`ticket_delivery_store_id` #派件网点


WHERE ss1.`sorting_no` in ('NE','N') and ss1.`category` in (1,2)
and   ss2.`sorting_no` in ('NE','N') and ss2.`category` in (1,2)
and pi.`created_at` >'2019-10-31 17:00:00'
and pi.`created_at` <'2019-11-17 17:00:00'
GROUP BY ss1.`id` ,ss2.`sorting_no`,date_format(CONVERT_TZ(pi.created_at, '+00:00', '+07:00'),'%Y-%m-%d')
ORDER BY ss1.`id` ,date_format(CONVERT_TZ(pi.created_at, '+00:00', '+07:00'),'%Y-%m-%d')



####大区##########
SELECT smr.`id` ,smr.`name`,COUNT(*) as staffcount,COUNT(*)*16 as `taskvolumn`,if(r.完成量 IS NOT NULL  ,r.完成量 ,0) as `taskcompleted`, if(t.amount IS NOT NULL ,t.amount,0) as '新客户发件量'
from `hr_staff_info` hsi 
LEFT JOIN `sys_store` ss on hsi.`sys_store_id` =ss.`id`
LEFT JOIN `sys_manage_piece` smp on ss.`manage_piece` =smp.`id` 
LEFT JOIN `sys_manage_region` smr on ss.`manage_region` =smr.`id` 
LEFT JOIN 
(

SELECT smr.`id` ,smr.`name`,COUNT(*) as '完成量'
from `user_referer` ur
LEFT JOIN `hr_staff_info` hsi on ur.`staff_info_id` =hsi.`staff_info_id` 
LEFT JOIN `sys_store` ss on hsi.`sys_store_id` =ss.`id`
LEFT JOIN `sys_manage_piece` smp on ss.`manage_piece` =smp.`id` 
LEFT JOIN `sys_manage_region` smr on ss.`manage_region` =smr.`id`   
WHERE `created_day` >'2019-11-14' and `created_day` <'2019-11-18'
GROUP BY smr.`id`


) r on r.id=smr.`id`
LEFT JOIN 
(

SELECT smr.`id` ,smr.`name` ,SUM(urs.`amount` ) AS amount
from `user_referer_stat` urs 
LEFT JOIN `hr_staff_info` hsi on urs.`staff_info_id` =hsi.`staff_info_id` 
LEFT JOIN `sys_store` ss on hsi.`sys_store_id` =ss.`id`
LEFT JOIN `sys_manage_piece` smp on ss.`manage_piece` =smp.`id` 
LEFT JOIN `sys_manage_region` smr on ss.`manage_region` =smr.`id` 
WHERE urs.`stat_date` >'2019-11-14' and urs.`stat_date` <'2019-11-18'
and ss.`category` in (1,2)
GROUP BY smr.`id`


) t on t.id=smr.`id`

WHERE 
hsi.`formal` =1 
and hsi.`state`=1 
and hsi.`hire_date`<'2019-11-15'
and ss.`category` in (1,2)
GROUP BY smr.`id`




####片区##############
SELECT smp.`id`  ,smp.`name`,COUNT(*) as staffcount,COUNT(*)*16 as `taskvolumn`,if(r.完成量 IS NOT NULL  ,r.完成量 ,0) as `taskcompleted`, if(t.amount IS NOT NULL ,t.amount,0) as '新客户发件量'
from `hr_staff_info` hsi 
LEFT JOIN `sys_store` ss on hsi.`sys_store_id` =ss.`id`
LEFT JOIN `sys_manage_piece` smp on ss.`manage_piece` =smp.`id` 
LEFT JOIN `sys_manage_region` smr on ss.`manage_region` =smr.`id` 
LEFT JOIN 
(

SELECT smp.`id`  ,smp.`name`,COUNT(*) as '完成量'
from `user_referer` ur
LEFT JOIN `hr_staff_info` hsi on ur.`staff_info_id` =hsi.`staff_info_id` 
LEFT JOIN `sys_store` ss on hsi.`sys_store_id` =ss.`id`
LEFT JOIN `sys_manage_piece` smp on ss.`manage_piece` =smp.`id` 
LEFT JOIN `sys_manage_region` smr on ss.`manage_region` =smr.`id`   
WHERE `created_day` >'2019-11-14' and `created_day` <'2019-11-18'
GROUP BY smp.`id`


) r on r.id=smp.`id`
LEFT JOIN 
(

SELECT smp.`id`  ,smp.`name` ,SUM(urs.`amount` ) AS amount
from `user_referer_stat` urs 
LEFT JOIN `hr_staff_info` hsi on urs.`staff_info_id` =hsi.`staff_info_id` 
LEFT JOIN `sys_store` ss on hsi.`sys_store_id` =ss.`id`
LEFT JOIN `sys_manage_piece` smp on ss.`manage_piece` =smp.`id` 
LEFT JOIN `sys_manage_region` smr on ss.`manage_region` =smr.`id` 
WHERE urs.`stat_date` >'2019-11-14'and urs.`stat_date` <'2019-11-18'
and ss.`category` in (1,2)
GROUP BY smp.`id`


) t on t.id=smp.`id`

WHERE 
hsi.`formal` =1 
and hsi.`state`=1 
and hsi.`hire_date`<'2019-11-15'
and ss.`category` in (1,2)
GROUP BY smp.`id`



#####网点的##############

SELECT ss.`id` ,ss.`name`,COUNT(*) as staffcount,COUNT(*)*16 as `taskvolumn`,if(r.完成量 IS NOT NULL  ,r.完成量 ,0) as `taskcompleted`, if(t.amount IS NOT NULL ,t.amount,0) as '新客户发件量'
from `hr_staff_info` hsi 
LEFT JOIN `sys_store` ss on hsi.`sys_store_id` =ss.`id`
LEFT JOIN `sys_manage_piece` smp on ss.`manage_piece` =smp.`id` 
LEFT JOIN `sys_manage_region` smr on ss.`manage_region` =smr.`id` 
LEFT JOIN 
(

SELECT ss.`id` ,ss.`name` ,COUNT(*) as '完成量'
from `user_referer` ur
LEFT JOIN `hr_staff_info` hsi on ur.`staff_info_id` =hsi.`staff_info_id` 
LEFT JOIN `sys_store` ss on hsi.`sys_store_id` =ss.`id` 
WHERE `created_day` >'2019-11-14'  and `created_day` <'2019-11-18'
GROUP BY ss.`id` 


) r on r.id=ss.`id` 
LEFT JOIN 
(

SELECT ss.`id` ,ss.`name` ,SUM(urs.`amount` ) AS amount
from `user_referer_stat` urs 
LEFT JOIN `hr_staff_info` hsi on urs.`staff_info_id` =hsi.`staff_info_id` 
LEFT JOIN `sys_store` ss on hsi.`sys_store_id` =ss.`id`
WHERE urs.`stat_date` >'2019-11-14' and urs.`stat_date` <'2019-11-18'
and ss.`category` in (1,2)
GROUP BY ss.`id` 


) t on t.id=ss.`id` 

WHERE 
hsi.`formal` =1 
and hsi.`state`=1 
and hsi.`hire_date`<'2019-11-15'
and ss.`category` in (1,2)
GROUP BY ss.`id` 