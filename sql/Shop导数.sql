#Shop######################################################
-----------考勤---------------
SELECT att.`staff_info_id` as 员工工号 ,hjt.`job_name` as 职位名,hsi.`sys_store_id`  as 所属网点,ss.`name` as 网点名, att.`stat_date` as 统计日期,att.`display_data`as 出勤情况,(att.`attendance_time`/10) as 有效出勤时间,att.`attendance_started_at` as 上班打卡时间,att.`attendance_end_at` as 下班打卡时间
from `attendance_data_v2` as att 
LEFT JOIN `hr_staff_info` as hsi on att.staff_info_id =hsi.`staff_info_id`
left join `sys_store` as ss on hsi.`sys_store_id` =ss.`id` 
left join `hr_job_title` as hjt on hsi.`job_title` =hjt.`id` 
where att.stat_date >="2019-10-22" and att.stat_date <="2019-10-28" 
and ss.`category`=4
ORDER BY hsi.sys_store_id


--------单量-------------

SELECT 
pi.ticket_pickup_staff_info_id as staffid,
sijt.name as jobname,
max(ss.name) as store_name,
DATE(CONVERT_TZ(pi.created_at,'+00:00','+07:00')) as pickupdate,
COUNT(pi.pno) AS 'total',
COUNT(if(pi.`customer_type_category` = 2,true,null)) AS 'ka',
COUNT(if(pi.`customer_type_category` = 1,true,null)) AS 'user',
(COUNT(pi.pno)-COUNT(if(pi.`replacement_enabled`=1 or pi.`pno`!=pi.`recent_pno`,true,null))) as '不需换单的量',
(COUNT(if(pi.`customer_type_category` = 2,true,null))-COUNT(if(pi.`customer_type_category` = 2 and (pi.`replacement_enabled`=1 or pi.`pno`!=pi.`recent_pno`),true,null))) as '不需换单的ka量',
(COUNT(if(pi.`customer_type_category` = 1,true,null))-COUNT(if(pi.`customer_type_category` = 1 and (pi.`replacement_enabled`=1 or pi.`pno`!=pi.`recent_pno`),true,null))) as '不需换单的user量',
COUNT(if(pi.`replacement_enabled`=1 or pi.`pno`!=pi.`recent_pno`,true,null)) as'需换单总量',
COUNT(if(pi.`replacement_enabled`=1 ,true,null)) as '需换未换单量', 
COUNT(if(pi.`pno`!=pi.`recent_pno` ,true,null)) as '已换单量', 
COUNT(if(pi.`pno`!=pi.`recent_pno` and pi.`ticket_pickup_staff_info_id`=piv.`operator_id`,true,null)) as '换单操作人是自己的单量',
COUNT(if(pi.`pno`!=pi.`recent_pno` and pi.`ticket_pickup_staff_info_id`=piv.`operator_id`and pi.`customer_type_category` = 2,true,null)) as '换单操作人是自己的ka单量', 
COUNT(if(pi.`pno`!=pi.`recent_pno` and pi.`ticket_pickup_staff_info_id`=piv.`operator_id`and pi.`customer_type_category` = 1,true,null)) as '换单操作人是自己的user单量',
COUNT(if(pi.`pno`!=pi.`recent_pno` and pi.`ticket_pickup_staff_info_id`!=piv.`operator_id`,true,null)) as '换单操作人是别人的单量',
COUNT(if(pi.`pno`!=pi.`recent_pno` and pi.`ticket_pickup_staff_info_id`!=piv.`operator_id`and pi.`customer_type_category` = 2,true,null)) as '换单操作人是别人的ka单量', 
COUNT(if(pi.`pno`!=pi.`recent_pno` and pi.`ticket_pickup_staff_info_id`!=piv.`operator_id`and pi.`customer_type_category` = 1,true,null)) as '换单操作人是别人的user单量'
FROM parcel_info as pi
left join sys_store as ss on ss.id = pi.ticket_pickup_store_id
left join staff_info si on pi.`ticket_pickup_staff_info_id` = si.`id`
left join `staff_info_job_title` sijt on si.`job_title` =sijt.`id` 
left join `parcel_info_version` piv on pi.`pno` =piv.`pno` 
where pi.created_at between '2019-10-28 17:00:00' and '2019-10-31 17:00:00' and pi.returned = 0
and pi.`parcel_category`  = 1 and pi.`state` != 9 
and ss.`category`= 4
group by pi.ticket_pickup_staff_info_id,DATE(CONVERT_TZ(pi.created_at,'+00:00','+07:00'))


#Ushop######################################################
-------考勤------

SELECT att.`staff_info_id` as 员工工号 ,hjt.`job_name` as 职位名,hsi.`sys_store_id`  as 所属网点,ss.`name` as 网点名, att.`stat_date` as 统计日期,att.`display_data`as 出勤情况,(att.`attendance_time`/10) as 有效出勤时间,att.`attendance_started_at` as 上班打卡时间,att.`attendance_end_at` as 下班打卡时间
from `attendance_data_v2` as att 
LEFT JOIN `hr_staff_info` as hsi on att.staff_info_id =hsi.`staff_info_id`
left join `sys_store` as ss on hsi.`sys_store_id` =ss.`id` 
left join `hr_job_title` as hjt on hsi.`job_title` =hjt.`id` 
where att.stat_date >="2019-10-18" and att.stat_date <="2019-10-25" 
and ss.`category`=7
ORDER BY hsi.sys_store_id


-----揽件量-----------
SELECT 
pi.ticket_pickup_staff_info_id as staffid,
ss.name as store_name,
DATE(CONVERT_TZ(pi.created_at,'+00:00','+07:00')) as pickupdate,
COUNT(*) AS 'total'
FROM parcel_info as pi
left join sys_store as ss on ss.id = pi.ticket_pickup_store_id
where pi.created_at between '2019-10-25 17:00:00' and '2019-10-31 17:00:00' and pi.returned = 0
and pi.`parcel_category`  = 1 and pi.`state` != 9 
and ss.`category`= 7
group by pi.ticket_pickup_staff_info_id,DATE(CONVERT_TZ(pi.created_at,'+00:00','+07:00'))

