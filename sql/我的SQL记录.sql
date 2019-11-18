select `delivery_staff_info_id`,`delivery_finished_at`,`pno`
from `parcel_main`

select `store_id`,`stat_date`,`pno`
from `dc_should_delivery_today`;

select count(pno),`stat_date`
from `dc_should_delivery_2019_05`
group by `store_id`

-----网点应派送量统计---------------------------------------------
select count(pno),`store_id`,`stat_date`
from `dc_should_delivery_2019_05`
group by `store_id`,`stat_date`;

-----特定日期网点应派送量统计-------------------------------------
select count(pno),`store_id`,`stat_date`
from `dc_should_delivery_2019_06`
WHERE date_format(`stat_date`, '%Y-%m-%d') = '2019-06-03'
group by `store_id`,`stat_date`;

-----最新网点信息------------------------------------------------
select
ss.id,
ss.name,
sp.name as provinceName
from sys_store ss
left join sys_province sp on ss.province_code=sp.code

-----关于网点行政划分的情况可以查这个表----------------------------
sys_department

left join sys_city sc 
on pi.dst_city_code = sc.code

left JOIN `sys_district` sd 
on pi.`dst_district_code` = sd.`code`

-----郭哥需求----------------------------------------------------
select `dst_province_code`,`dst_city_code`,`dst_district_code`,count(`pno`)
from `parcel_main`
WHERE `pickup_finished_at`='2019-06-03'
group by(`dst_district_code`)

where 发生日期>'2008-7-1' and 发生日期<'2008-12-31'

select `dst_province_code`,`dst_city_code`,`dst_district_code`,count(`pno`)
from `parcel_main`
WHERE date_format(`pickup_finished_at`, '%Y-%m-%d') = '2019-06-02'
group by(`dst_district_code`)

----郭哥需求完成SQL----------------------------------------------
select `dst_province_code`,`dst_city_code`,`dst_district_code`,count(`pno`)
from `parcel_main`
WHERE date_format(`pickup_finished_at`, '%Y-%m-%d') = '2019-06-02'
group by(`dst_district_code`)

----员工出勤与操作量情况（揽件+派件）------------------------------
select `staff_info_id`,sum(attendance_time),`operator_count`,`delivery_count`
from `attendance_data`
WHERE date_format(`stat_date`, '%Y-%m') = '2019-05'
group by(`staff_info_id`)

select `staff_info_id`,sum(attendance_time),`operator_count`,`delivery_count`
from `attendance_data`
WHERE date_format(`stat_date`, '%Y-%m-%d') > '2019-04-30' and date_format(`stat_date`, '%Y-%m-%d') < '2019-06-01'
group by(`staff_info_id`)

select `staff_info_id`,sum(attendance_time),sum(`operator_count`)
from `attendance_data`
WHERE date_format(`stat_date`, '%Y-%m-%d') > '2019-04-30' and date_format(`stat_date`, '%Y-%m-%d') < '2019-06-01'

----特定员工特定时间段出勤打卡情况---------------------------------------------
select `staff_info_id`,`stat_date`,`attendance_time`,`leave_time`,`leave_time_type`,`attendance_started_at`,`attendance_end_at`
from `attendance_data`
WHERE date_format(`stat_date`, '%Y-%m')>'2019-04-30'and`staff_info_id` = "25231"

----贾哥19万票统计---------parcel_main不精确统计------------------------------
select count(pno),`delivery_store_id`,`delivery_store_provincecode`,`pickup_finished_at`
from `parcel_main`
where date_format(`pickup_finished_at`, '%Y-%m-%d') = '2019-06-02'
group by `delivery_store_id`

----贾哥19万票统计---------parcel_info精确统计------------------------------
select count(pno),`ticket_delivery_store_id`,`dst_province_code`,`pickup_finished_at`
from `parcel_info`
where date_format(`pickup_finished_at`, '%Y-%m-%d') = '2019-06-02'
group by `delivery_store_id`

----网点总人数、快递员人数、Bike、Van------------------------------------------
select hr.sys_store_id,store.name ,count(1) 总数 
,sum(if(ti.job_name in ('Bike Courier','Van Courier'),1,0)) 快递员,
sum(if(ti.job_name in ('hub officer','hub staff','Warehouse supervisor','Warehouse Staff (Sorter)','Warehouse officer'),1,0)) 仓管员,
sum(if(ti.job_name = 'Bike Courier' ,1,0)) bike,
sum(if(ti.job_name = 'Van Courier' ,1,0)) van
from hr_staff_info hr
join hr_job_title ti on hr.job_title = ti.id
left join sys_store store on hr.sys_store_id = store.id
where hr.formal = 1 -- 编制
and hr.state = 1 -- 在职
and hr.sys_store_id != -1 -- 网点员工 非部门
group by hr.sys_store_id

----网点当天总派件人效-------------------------------------------------------
select `store_id`,`total_delivery_effect`
from dc_stat_increment
where `stat_date`="2019-06-04"
 
 ---打卡时间统计--------------------------------------
 select 
    staff_info_id
    ,attendance_date
    ,CONVERT_TZ(started_at, '+00:00','+07:00') as started_at
    ,CONVERT_TZ(end_at, '+00:00','+07:00') as end_at
    from staff_work_attendance 
    where attendance_date > '2019-04-30'
	
	
------查考勤------------------------------------------------
select `staff_info_id`AS 员工编号,
`started_path`,`attendance_date`as	考勤日期,
`attendance_range`,CONVERT_TZ(`started_at`, '+00:00', '+07:00')as 上班打卡时间,
`started_store_id`as 上班打卡网点,
CONVERT_TZ(`end_at`, '+00:00', '+07:00')as 下班打卡时间,
`end_store_id`AS 下班打卡网点编号
FROM `staff_work_attendance` 
WHERE `staff_info_id` ="19934"

-----查几个网点每日到件量-----------------------------------
select `arrival_scan_route_store_id`,count(`pno`),date_format(`arrival_scan_route_at`, '%Y-%m-%d')
from `parcel_sub`
where `arrival_scan_route_store_id`
in
(SELECT `id`FROM `sys_store` 
where (`name` like "NON%")
or(`name` like "BKT%")
or(`name` like "SUL%")
or(`name` like "HUY%")
or(`name` like "LPW%")
or(`name` like "Rama III%")
or(`name` like "DUS%")
or(`name` like "LKS%")
or(`name` like "BTG%")
or(`name` like "SKV%")
or(`name` like "PTW%"))
and date_format(`arrival_scan_route_at`, '%Y-%m-%d') >= '2019-06-01'
GROUP BY date_format(`arrival_scan_route_at`, '%Y-%m-%d'),`arrival_scan_route_store_id`

-----查各网点总的扫描到件量1-----------------------------------
select date_format(CONVERT_TZ(`arrival_scan_route_at`, '+00:00', '+07:00'),'%Y-%m-%d'),count(`pno`)
from `parcel_sub`
where date_format(CONVERT_TZ(`arrival_scan_route_at`, '+00:00', '+07:00'),'%Y-%m-%d')>= '2019-05-01'
--where date_format(`arrival_scan_route_at`, '%Y-%m-%d') >= '2019-06-01'
GROUP BY `arrival_scan_route_store_id`

-----查各网点总的扫描到件量2------------------------------
SELSELECT 
	date_format(CONVERT_TZ(pi.created_at, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') AS 揽件日期和时间,
	pi.recent_pno AS 运单号,
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

	case pr.`route_action` 
	when 'RECEIVED' THEN '快件已揽收'
	when 'REPLACE_PNO' THEN '换单'
	when 'RECEIVE_WAREHOUSE_SCAN' THEN '收件入仓扫描'
	when 'SEAL' THEN '集包'
	when 'SHIPMENT_WAREHOUSE_SCAN' THEN '发件出仓扫描'
	when 'ARRIVAL_WAREHOUSE_SCAN' THEN '到件入仓扫描'
	when 'DETAIN_WAREHOUSE' THEN '货件留仓'
	when 'UNSEAL' THEN '拆包'
	when 'DELIVERY_TICKET_CREATION_SCAN' THEN '交接扫描'
	when 'PHONE' THEN '电话联系'
	when 'DELIVERY_CONFIRM' THEN '已妥投'
	when 'DELIVERY_MARKER' THEN '派件标记'
	when 'DIFFICULTY_SEAL' THEN '集包异常'
	when 'DELIVERY_TRANSFER' THEN '派件转单'
	when 'MANUAL_REMARK' THEN '包裹备注'
	when 'THIRD_EXPRESS_ROUTE' THEN '第三方路由'
	when 'DIFFICULTY_HANDOVER' THEN '疑难件交接'
	when 'DIFFICULTY_RE_TRANSIT' THEN '疑难件退回区域总部/重启运送'
	when 'CHANGE_PARCEL_CLOSE' THEN '关闭运单'
	when 'CHANGE_PARCEL_INFO' THEN '修改包裹信息'
	when 'CONTINUE_TRANSPORT' THEN '继续派送'
	when 'HURRY_PARCEL' THEN '催单'
	when 'INTERRUPT_PARCEL_AND_RETURN' THEN '中断运输并退回'
	when 'STAFF_INFO_UPDATE_WEIGHT' THEN '收派员更改数量'
	when 'CLOSE_ORDER' THEN '终止运送'
    when 'DIFFICULTY_RETURN' THEN '疑难件退回寄件人'
	end as 路由动作,
	date_format(CONVERT_TZ(pr.`routed_at`, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') AS '路由时间',
	pr.`store_name`  as 所处网点,
	pr.`staff_info_id` AS 操作员,
	ss.`name` as '揽件网点' ,
	pi.ticket_pickup_staff_info_id AS '揽件员ID' ,
	#ss3.`name`  as '目的地网点名称',
	ss2.`name` as '妥投网点名称',
	pi.ticket_delivery_staff_info_id AS '妥投员ID',
	date_format(CONVERT_TZ(pi.finished_at, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') AS '妥投日期和时间'

	FROM `parcel_info` pi
	LEFT JOIN `sys_store` ss on ss.`id` = pi.`ticket_pickup_store_id` 
	LEFT JOIN `sys_store` ss2 on ss2.`id` = pi.`ticket_delivery_store_id` 
	LEFT JOIN `sys_store` ss3 on ss3.`id` =pi.`dst_store_id` 
	LEFT JOIN `parcel_route` pr on pr.`pno` =pi.

	where`route_action`='ARRIVAL_WAREHOUSE_SCAN'
and date_format(CONVERT_TZ(pi.created_at, '+00:00', '+07:00'),'%Y-%m-%d')>="2019-05-01 00:00:00")









---根据网点缩写查网点id----------------------------------
SELECT `id`FROM `sys_store` 
where (`name` like "NON%")
or(`name` like "BKT%")
or(`name` like "SUL%")
or(`name` like "HUY%")
or(`name` like "LPW%")
or(`name` like "Rama III%")
or(`name` like "DUS%")
or(`name` like "LKS%")
or(`name` like "BTG%")
or(`name` like "SKV%")
or(`name` like "PTW%")

---关闭疑难件统计明细-----------------------------------
select  di.pno
from customer_diff_ticket cdt
LEFT JOIN diff_info di ON 
cdt.diff_info_id = di.id
where cdt.state = 0 or cdt.state = 2


---使用bs软件和巴枪补单或者揽件是多少-------------------
SELECT pi.`ticket_pickup_store_id`  ,COUNT(IF(pi.`channel_category` = 6,true,null))  AS '揽件量', COUNT(IF(pi.`channel_category` = 9,true,null))  AS '补单量',COUNT(pi.pno) AS '总量'
FROM parcel_info AS pi where  DATE(CONVERT_TZ(pi.`created_at`,  '+00:00', '+07:00')) >= '2019-06-07' 
AND DATE(CONVERT_TZ(pi.`created_at`,  '+00:00', '+07:00')) <= '2019-06-10' and pi.`channel_category` IN (6,9) and pi.`state`  != 9 GROUP BY pi.`ticket_pickup_store_id`

---网点集包率数据-----------------------------------
SELECT 
sp.`store_id` AS  '集包网点ID',
ss.`name` AS '集包网点名称',
sp.`store_area` AS  '集包网点区域',
sp.`pack_pr` AS  '集包率',
sp.`pack_too_big` AS  '超大集包数量',
sp.`pack_at` AS  '集包日期',
sp.`created_at` AS '创建时间'
FROM `store_pack_pr` sp
LEFT JOIN `sys_store` ss on ss.`id` = sp.`store_id` 
WHERE sp.`pack_at` = "2019-06-28"

---作为派件网点的扫描d对的
SELECT 
`store_id` ,
`store_name`,
DATE(CONVERT_TZ(`routed_at`,   '+00:00', '+07:00')) AS 'routeAt',
COUNT(*) AS 'count' 

FROM parcel_route 
where `route_action`  = 'SHIPMENT_WAREHOUSE_SCAN' 

GROUP BY 
`store_id`,
`store_name`  ,
DATE(CONVERT_TZ(`routed_at`,   '+00:00', '+07:00')) ORDER BY  `store_id` ,
routeAt

---网点揽件来源分类汇总（limengqi）----------------------

select 
pi.`ticket_pickup_store_id`,
DATE(CONVERT_TZ(pi.`created_at`,  '+00:00', '+07:00')),
COUNT(if(pi.`customer_type_category` = 2,true,null)) AS 'ka',
COUNT(if(pi.`customer_type_category` = 1,true,null)) AS 'user',
COUNT(pi.pno) AS 'total'

from parcel_info as pi 

where 
CONVERT_TZ(pi.`created_at`,  '+00:00', '+07:00') >= '2019-06-01 00:00:00'
and CONVERT_TZ(pi.`created_at`,  '+00:00', '+07:00') <= '2019-06-10 23:59:59' 
and pi.`parcel_category`  = 1 and pi.`state` != 9 

GROUP BY pi.`ticket_pickup_store_id` ,DATE(CONVERT_TZ(pi.`created_at`,  '+00:00', '+07:00'));

---网点扫描到件量，网点作为最终派件网点的（limengqi）---------------------
SELECT
`store_id`,
`store_name`,
DATE(CONVERT_TZ(`routed_at`,'+00:00', '+07:00')) AS 'routeAt',
COUNT(*) AS 'count' 
FROM parcel_route 
where `route_action`  = 'SHIPMENT_WAREHOUSE_SCAN' 
GROUP BY `store_id`,`store_name`  ,DATE(CONVERT_TZ(`routed_at`,   '+00:00', '+07:00')) ORDER BY  `store_id` ,routeAt


---查询最近一周网点总派件距离---------------------------------------------------------------------------------------------------------
select st.organization_id,sum(di.coordinate_distance)
from courier_coordinate_distance as di
left join staff_info as st
on di.staff_id=st.id 
where date(CONVERT_TZ(di.created_at,  '+00:00', '+07:00'))>= '2019-06-23 00:00:00'
and date(CONVERT_TZ(di.created_at,  '+00:00', '+07:00'))<= '2019-06-29 23:59:59'
group by st.organization_id

---查询最近一周各网点有派送距离的人数------------------------------------------------------------------------------------------------
select st.organization_id,COUNT(if(di.coordinate_distance!=0,true,null)) as 距离不为零数量
from courier_coordinate_distance as di
left join staff_info as st
on di.staff_id=st.id 
where CONVERT_TZ(di.`created_at`,  '+00:00', '+07:00') >= '2019-06-24 00:00:00'
and CONVERT_TZ(di.`created_at`,  '+00:00', '+07:00') <= '2019-06-30 23:59:59' 
group by st.organization_id

---各网点揽件量按签约非签约分类------------------------------------------------
select pi.`ticket_pickup_store_id`,DATE(CONVERT_TZ(pi.`created_at`,  '+00:00', '+07:00')),COUNT(if(pi.`customer_type_category` = 2,true,null)) AS 'ka',COUNT(if(pi.`customer_type_category` = 1,true,null)) AS 'user'  ,COUNT(pi.pno) AS 'total'
from parcel_info as pi 
where CONVERT_TZ(pi.`created_at`,  '+00:00', '+07:00') >= '2019-06-01 00:00:00'
and CONVERT_TZ(pi.`created_at`,  '+00:00', '+07:00') <= '2019-06-10 23:59:59' 
and pi.`parcel_category`  = 1 and pi.`state` != 9 
GROUP BY pi.`ticket_pickup_store_id` ,DATE(CONVERT_TZ(pi.`created_at`,  '+00:00', '+07:00'));

---员工、网点、统计时间、有效出勤时间------------------
SELECT att.`staff_info_id` as 员工工号 , stt.`store_id` as 所属网点, att.`stat_date` as 统计日期 ,count(att.`attendance_time`) as 有效出勤时间
from `attendance_data_v2` as att LEFT JOIN `staff_info` as stt
on att.staff_info_id =stt.id
where att.stat_date ="2019-06-01" 

---各网点指定日期的有效出勤人数（含半天）------------------
SELECT stt.`store_id` as 所属网点, att.`stat_date` as 统计日期 ,count(att.`attendance_time`) as 有效出勤人数
from `attendance_data_v2` as att LEFT JOIN `staff_info` as stt
on att.staff_info_id =stt.id
where att.stat_date ="2019-06-01" 
GROUP BY stt.`store_id`

---各网点实际出勤人数（安朋刚）-----------
SELECT hsi.sys_store_id  AS 网点ID,
hsi.`sys_department_id` AS 部门ID,
ss.name AS 网点名称,
sd.name AS 部门名称,
adv.`stat_date` 日期,
count(1) as 出勤人数
FROM `attendance_data_v2` adv
LEFT JOIN `hr_staff_info` hsi on hsi.`staff_info_id` = adv.`staff_info_id` 
LEFT JOIN `sys_store` ss on hsi.`sys_store_id` = ss.`id` 
LEFT JOIN `sys_department` sd on hsi.`sys_department_id` = sd.id
WHERE `stat_date` BETWEEN '2019-06-01' and '2019-06-30'
and (adv.`attendance_started_at` IS NOT NULL or adv.`attendance_end_at` IS NOT NULL)
GROUP BY adv.`stat_date` ,hsi.`sys_store_id`,hsi.`sys_department_id`
---各网点实际出勤人数（靳增广）、按上班打卡网点分类--------------------------------------------------
SELECT `organization_id`  AS 网点ID,
`attendance_date` as 考勤日期,
count(1) as 出勤人数
FROM `staff_work_attendance`
WHERE `attendance_date`>='2019-06-01'
and (`started_at` IS NOT NULL or `end_at` IS NOT NULL)
GROUP BY `attendance_date`,`organization_id`

---员工揽件量（马彦军）----------------------------------------------------------------------------
SELECT 
pd.ticket_pickup_staff_info_id as staff_info_id,
 DATE(pd.created_at) as finished_at,
count(*) as day_count_pickup,
max(pd.ticket_pickup_store_id) as ticket_pickup_store_id,
max(ss.name) as store_name
FROM parcel_info as pd
left join sys_store as ss on ss.id = pd.ticket_pickup_store_id
where pd.created_at between '2019-06-01 00:00:00' and '2019-07-01 00:00:00' and pd.returned = 0 
-- and ticket_pickup_store_id = 'TH01470301'
group by pd.ticket_pickup_staff_info_id,DATE(pd.created_at)
limit 0, 10000
---员工揽件量（马彦军）修改时间-----------------------------------------------

SELECT 
pd.ticket_pickup_staff_info_id as staff_info_id,
 DATE(CONVERT_TZ(pd.created_at,'+00:00','+07:00')) as 时间,
count(*) as day_count_pickup,
max(pd.ticket_pickup_store_id) as ticket_pickup_store_id,
max(ss.name) as store_name
FROM parcel_info as pd
left join sys_store as ss on ss.id = pd.ticket_pickup_store_id
where pd.created_at between '2019-06-30 17:00:00' and '2019-07-01 17:00:00' and pd.returned = 0 
-- and ticket_pickup_store_id = 'TH01470301'
group by pd.ticket_pickup_staff_info_id,DATE(CONVERT_TZ(pd.created_at,'+00:00','+07:00'))

---快递员揽件来源分签约非签约------------------------------------
SELECT 
pd.ticket_pickup_staff_info_id as staff_info_id,
 DATE(CONVERT_TZ(pd.created_at,'+00:00','+07:00')) as 时间,
count(*) as day_count_pickup,
COUNT(if(pi.`customer_type_category` = 2,true,null)) AS '签约客户',
COUNT(if(pi.`customer_type_category` = 1,true,null)) AS '未签约客户'  ,COUNT(pi.pno) AS '总计'，
max(pd.ticket_pickup_store_id) as ticket_pickup_store_id,
max(ss.name) as store_name
FROM parcel_info as pd
left join sys_store as ss on ss.id = pd.ticket_pickup_store_id
where pd.created_at between '2019-06-30 17:00:00' and '2019-07-01 17:00:00' and pd.returned = 0 
-- and ticket_pickup_store_id = 'TH01470301'
group by pd.ticket_pickup_staff_info_id,DATE(CONVERT_TZ(pd.created_at,'+00:00','+07:00'))

---网点揽件来源分签约非签约----------------------------------------
select pi.`ticket_pickup_store_id`,DATE(CONVERT_TZ(pi.`created_at`,  '+00:00', '+07:00')),
COUNT(if(pi.`customer_type_category` = 2,true,null)) AS 'ka',
COUNT(if(pi.`customer_type_category` = 1,true,null)) AS 'user'  ,COUNT(pi.pno) AS 'total'
from parcel_info as pi 
where CONVERT_TZ(pi.`created_at`,  '+00:00', '+07:00') >= '2019-06-01 00:00:00'
and CONVERT_TZ(pi.`created_at`,  '+00:00', '+07:00') <= '2019-06-10 23:59:59' 
and pi.`parcel_category`  = 1 and pi.`state` != 9 
GROUP BY pi.`ticket_pickup_store_id` ,DATE(CONVERT_TZ(pi.`created_at`,  '+00:00', '+07:00'));


---员工派件量（马彦军）原始-------------------------------------------------
SELECT 
pd.ticket_delivery_staff_info_id as staff_info_id,
DATE(pd.finished_at) as finished_at,
count(*) as day_count_delivery,
max(pd.ticket_delivery_store_id) as ticket_delivery_store_id,
max(ss.name) as store_name
FROM parcel_info as pd
left join sys_store as ss on ss.id = pd.ticket_delivery_store_id
where pd.finished_at between '2019-06-01 00:00:00' and '2019-07-01 00:00:00' 
--  and pd.ticket_delivery_store_id = 'TH01470301'
group by pd.ticket_delivery_staff_info_id,DATE(pd.finished_at)
limit 0, 10000

---员工派件量（马彦军）修改------------------------------------------------
SELECT 
pd.ticket_delivery_staff_info_id as 派件员工工号,
DATE(CONVERT_TZ(pd.finished_at,'+00:00','+07:00')) as 派件完成时间,
count(*) as day_count_delivery,
max(pd.ticket_delivery_store_id) as ticket_delivery_store_id,
max(ss.name) as store_name
FROM parcel_info as pd
left join sys_store as ss on ss.id = pd.ticket_delivery_store_id
where CONVERT_TZ(pd.finished_at,'+00:00','+07:00') between '2019-06-01 00:00:00' and '2019-07-01 00:00:00' 
--  and pd.ticket_delivery_store_id = 'TH01470301'
group by pd.ticket_delivery_staff_info_id,DATE(CONVERT_TZ(pd.finished_at,'+00:00','+07:00'))



---网点职位分类-------------------------------------------
select hr.sys_store_id,store.name ,count(1) 总数 
,sum(if(ti.job_name in ('Bike Courier','Van Courier'),1,0)) 快递员,
sum(if(ti.job_name in ('DC officer','hub staff','Warehouse Staff (Sorter)'),1,0)) 仓管员,
sum(if(ti.job_name = 'Mini-CS officer' ,1,0)) bike,
sum(if(ti.job_name = 'Bike Courier' ,1,0)) bike,
sum(if(ti.job_name = 'Van Courier' ,1,0)) van
from hr_staff_info hr
join hr_job_title ti on hr.job_title = ti.id
left join sys_store store on hr.sys_store_id = store.id
where hr.formal = 1 -- 编制
and hr.state = 1 -- 在职
and hr.sys_store_id != -1 -- 网点员工 非部门
group by hr.sys_store_id


select hr.sys_store_id,store.name ,count(1) 总数 
,sum(if(ti.job_name in ('Bike Courier','Van Courier'),1,0)) 快递员,
sum(if(ti.job_name in ('Branch Supervisor'),1,0)) 网点主管,
sum(if(ti.job_name in ('DC officer','Warehouse Staff (Sorter)'),1,0)) 仓管员,
sum(if(ti.job_name = 'Mini-CS officer' ,1,0)) 'Mini-CS',
sum(if(ti.job_name = 'Bike Courier' ,1,0)) bike,
sum(if(ti.job_name = 'Van Courier' ,1,0)) van
from hr_staff_info hr
join hr_job_title ti on hr.job_title = ti.id
left join sys_store store on hr.sys_store_id = store.id
where hr.formal = 1 -- 编制
and hr.state = 1 -- 在职
and hr.sys_store_id != -1 -- 网点员工 非部门
group by hr.sys_store_id


----------------------------------------------
SELSELECT 
	date_format(CONVERT_TZ(pi.created_at, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') AS 揽件日期和时间,
	pi.recent_pno AS 运单号,
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

	case pr.`route_action` 
	when 'RECEIVED' THEN '快件已揽收'
	when 'REPLACE_PNO' THEN '换单'
	when 'RECEIVE_WAREHOUSE_SCAN' THEN '收件入仓扫描'
	when 'SEAL' THEN '集包'
	when 'SHIPMENT_WAREHOUSE_SCAN' THEN '发件出仓扫描'
	when 'ARRIVAL_WAREHOUSE_SCAN' THEN '到件入仓扫描'
	when 'DETAIN_WAREHOUSE' THEN '货件留仓'
	when 'UNSEAL' THEN '拆包'
	when 'DELIVERY_TICKET_CREATION_SCAN' THEN '交接扫描'
	when 'PHONE' THEN '电话联系'
	when 'DELIVERY_CONFIRM' THEN '已妥投'
	when 'DELIVERY_MARKER' THEN '派件标记'
	when 'DIFFICULTY_SEAL' THEN '集包异常'
	when 'DELIVERY_TRANSFER' THEN '派件转单'
	when 'MANUAL_REMARK' THEN '包裹备注'
	when 'THIRD_EXPRESS_ROUTE' THEN '第三方路由'
	when 'DIFFICULTY_HANDOVER' THEN '疑难件交接'
	when 'DIFFICULTY_RE_TRANSIT' THEN '疑难件退回区域总部/重启运送'
	when 'CHANGE_PARCEL_CLOSE' THEN '关闭运单'
	when 'CHANGE_PARCEL_INFO' THEN '修改包裹信息'
	when 'CONTINUE_TRANSPORT' THEN '继续派送'
	when 'HURRY_PARCEL' THEN '催单'
	when 'INTERRUPT_PARCEL_AND_RETURN' THEN '中断运输并退回'
	when 'STAFF_INFO_UPDATE_WEIGHT' THEN '收派员更改数量'
	when 'CLOSE_ORDER' THEN '终止运送'
    when 'DIFFICULTY_RETURN' THEN '疑难件退回寄件人'
	end as 路由动作,
	date_format(CONVERT_TZ(pr.`routed_at`, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') AS '路由时间',
	pr.`store_name`  as 所处网点,
	pr.`staff_info_id` AS 操作员,
	ss.`name` as '揽件网点' ,
	pi.ticket_pickup_staff_info_id AS '揽件员ID' ,
	#ss3.`name`  as '目的地网点名称',
	ss2.`name` as '妥投网点名称',
	pi.ticket_delivery_staff_info_id AS '妥投员ID',
	date_format(CONVERT_TZ(pi.finished_at, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') AS '妥投日期和时间'

	FROM `parcel_info` pi
	LEFT JOIN `sys_store` ss on ss.`id` = pi.`ticket_pickup_store_id` 
	LEFT JOIN `sys_store` ss2 on ss2.`id` = pi.`ticket_delivery_store_id` 
	LEFT JOIN `sys_store` ss3 on ss3.`id` =pi.`dst_store_id` 
	LEFT JOIN `parcel_route` pr on pr.`pno` =pi.

	where`route_action`='DELIVERY_TICKET_CREATION_SCAN'
	and pr.`store_id`=pi.`dst_store_id`
	and 
	and date_format(CONVERT_TZ(pi.created_at, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s')>="2019-07-01 00:00:00"

-----------------------
SELECT 
count(pi.recent_pno) AS 单量,
pr.`store_name`  as 所处网点，
max(IF (pr.`route_action` = 'ARRIVAL_WAREHOUSE_SCAN' , date_format(CONVERT_TZ(pr.`routed_at`, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') , '')) as '到件入仓时间',
max(IF (pr.`route_action` = 'DELIVERY_TICKET_CREATION_SCAN' , date_format(CONVERT_TZ(pr.`routed_at`, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') ,null)) as '派件出仓时间',
pr.`store_name`  as 所处网点
        
FROM `parcel_info` pi

LEFT JOIN `parcel_route` pr on pr.`pno` =pi.`pno` 

WHERE  
pr.`routed_at` > '2019-06-10 00:00'
and pi.`state` !=9
and pr.`store_name`=pi.`dst_store_id`
and '到件入仓时间' < '2019-07-01 08:30'
and '派件出仓时间' > '2019-07-01 08:30'

group by 所处网点	

---各网点包裹（7月1号早8：30在仓的量）-------------------------------------------------------------
SELECT 
count(pi.recent_pno) AS 单量,
pi.`dst_store_id` as 目的网点id,
pr.`store_id` as 所在网点id,
pr.`store_name` as 所处网点名称

FROM `parcel_info` pi LEFT JOIN `parcel_route` pr 
on pr.`pno` =pi.`pno` 


/*WHERE  
pr.`routed_at` >'2019-06-10 00:00'
and pi.`state` !=9
-- and pr.`store_id`=pi.`dst_store_id`
where 
max(IF (pr.`route_action` = 'ARRIVAL_WAREHOUSE_SCAN' , date_format(CONVERT_TZ(pr.`routed_at`, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') , '')) < '2019-07-01 08:30'
and max(IF (pr.`route_action` = 'DELIVERY_TICKET_CREATION_SCAN' , date_format(CONVERT_TZ(pr.`routed_at`, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') , '')) > '2019-07-01 08:30'*/

where pi.`dst_store_id`=pr.`store_id`
and pr.`routed_at` > '2019-06-10 00:00'
and pi.`state` !=9
group by pi.`dst_store_id`
HAVING max(IF (pr.`route_action` = 'ARRIVAL_WAREHOUSE_SCAN' , date_format(CONVERT_TZ(pr.`routed_at`, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') , '')) < '2019-07-01 08:30'
and max(IF (pr.`route_action` = 'DELIVERY_TICKET_CREATION_SCAN' , date_format(CONVERT_TZ(pr.`routed_at`, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s') , '')) > '2019-07-01 00:30'


-----------郭晋铎-----------------------------------------------------------------
select 
a.dst_store_id as '网点ID',
sum(if(b.handover_scan_route_store_id=a.dst_store_id and b.handover_scan_route_at > '2019-07-03 00:00:00' and b.handover_scan_route_at < '2019-07-03 09:30:00',1,0)) as '9:30前交接量',
count(*) as '应派送量'

from parcel_main a 
left JOIN `parcel_sub` b 
on a.`pno` = b.`pno` 

where 
a.resp_store_id = a.dst_store_id 
and  ( a.state in (1,2,3,4) or (a.state=5 and a.`delivery_finished_at`>'2019-07-03 09:30:00'))   
and b.`receive_scan_route_at`< '2019-07-03 08:30:00'
and b.`arrival_scan_route_at`<'2019-07-03 08:30:00' 
and a.`parcel_created_at` > '2019-06-20' 
GROUP BY a.`dst_store_id`

-------------------------------------------------------------------------------
select 
a.dst_store_id as '网点ID',
c.name as '网点名',
sum(if(b.handover_scan_route_store_id=a.dst_store_id and b.handover_scan_route_at > '2019-07-03 00:00:00' and b.handover_scan_route_at < '2019-07-03 09:30:00',1,0)) as '9:30前交接量',
count(*) as '应派送量'

from parcel_main a 
left JOIN `parcel_sub` b on a.`pno` = b.`pno` 
left join `sys_store`c on a.`dst_store_id`=c.`id`

where 
a.resp_store_id = a.dst_store_id 
and  ( a.state in (1,2,3,4) or (a.state=5 and a.`delivery_finished_at`>'2019-07-03 09:30:00'))   
and b.`receive_scan_route_at`< '2019-07-03 08:30:00'
and b.`arrival_scan_route_at`<'2019-07-03 08:30:00' 
and b.`arrival_scan_route_at`>'2019-06-03 08:30:00' 
and a.`parcel_created_at` > '2019-06-20' 
GROUP BY a.`dst_store_id`

---梦雨员工揽件分类-----------------------------------------------------------------------------
	SELECT 
	pi.ticket_pickup_staff_info_id as staff_info_id,
	DATE(CONVERT_TZ(pi.created_at,'+00:00','+07:00')) as 时间,
	count(*) as day_count_pickup,
	COUNT(if(pi.`customer_type_category` = 2,true,null)) AS '签约客户',
	COUNT(if(pi.`customer_type_category` = 1,true,null)) AS '未签约客户',
	COUNT(pi.pno) AS '总计',
	max(pi.ticket_pickup_store_id) as ticket_pickup_store_id,
	max(ss.name) as store_name
	FROM parcel_info as pi
	left join sys_store as ss on ss.id = pi.ticket_pickup_store_id
	where pi.created_at between '2019-06-30 17:00:00' and '2019-07-01 17:00:00' and pi.returned = 0 
	-- and ticket_pickup_store_id = 'TH01470301'
	group by pi.ticket_pickup_staff_info_id,DATE(CONVERT_TZ(pi.created_at,'+00:00','+07:00'))

	---财务中心支付问题件赔款------
	select d.pno,f.* 
	from finance_diff_ticket f 
	left join diff_info d on f.diff_info_id = d.id

---问题件责任裁定------------------------------------------------------------------------------
 `operation_diff_judge_ticket`
	select
	d.pno,
	o.*
	from `operation_diff_judge_ticket` o
	left join diff_info d
	on o.diff_info_id = d.id

---任务创建到揽件时长超过两个小时的----------------------------------
	select id,a.finished_at,a.created_at,staff_info_id 
	from ticket_pickup as a 
	where a.state=2 
	and timestampdiff(second,a.created_at,a.finished_at)>7200
	and a.created_at>'2019-05-31 17:00:00' 
	and a.`created_at` < '2019-06-30 17:00:00' 
	limit 100

---导出最新排班表--------------------------------------------------
	的


---shop--------------------------------------------------------
	SELECT pi.`ticket_pickup_staff_info_id`as 揽件快递员id,
		pi.`ticket_pickup_store_id`as 揽件网点,
	ss.name,
		DATE(CONVERT_TZ(pi.`created_at`, '+00:00', '+07:00')) AS 'dateTime',
		COUNT(pi.pno) AS 'total',
		COUNT(if(pi.`customer_type_category` = 2 and pi.`channel_category` IN (1,2,3,4,5,6,8,10),true,null)) AS 'KA',
		count(if(pi.`channel_category`IN(7, 9) and pi.`sub_channel_category` is null, true, null)) AS '小标签',
		count(if(pi.`channel_category`IN(7, 9) and pi.`sub_channel_category`= 14, true, null)) AS '喵喵机'
	FROM `parcel_info` AS pi
	LEFT JOIN sys_store AS ss on pi.`ticket_pickup_store_id`= ss.`id`
	LEFT JOIN `staff_info` AS si on pi.`ticket_pickup_staff_info_id`= si.`id`
	where pi.`state`!= 9
	and pi.`parcel_category`= 1
	and DATE(CONVERT_TZ(pi.`created_at`, '+00:00', '+07:00'))>= '2019-06-01'
	AND DATE(CONVERT_TZ(pi.`created_at`, '+00:00', '+07:00'))<= '2019-06-30'
	and ss.`category`= 4
	and si.`vehicle`= 0
	GROUP BY pi.`ticket_pickup_staff_info_id`, pi.`ticket_pickup_store_id`,ss.name, DATE(CONVERT_TZ(pi.`created_at`, '+00:00', '+07:00'))
	ORDER BY pi.`ticket_pickup_store_id`, pi.`ticket_pickup_staff_info_id`,DATE(CONVERT_TZ(pi.`created_at`, '+00:00', '+07:00'))

---算HUB提成时，HUB员工操作量分类（到件入仓扫描，发件出仓扫描，集包扫描）-----------------------------------------------------------------------------------------
	select 
	r.staff_info_id,
	max(CASE r.route_action
		when 'ARRIVAL_WAREHOUSE_SCAN' 
		THEN r.total_count
		END) 到件扫描, 
	max(CASE r.route_action
		when 'SHIPMENT_WAREHOUSE_SCAN' 
		THEN r.total_count
		END) 发件扫描,
	max(CASE r.route_action
		when 'SEAL' 
		THEN r.total_count
		END) 集包 
		
	from 
	(select 
				max_route.staff_info_id,max_route.route_action,count(*) as total_count
				from
				(
					select
					a.staff_info_id,a.route_action
					from parcel_route as a
					where 
			a.routed_at >= '2019-07-01 17:00:00' and a.routed_at<'2019-07-02 17:00:00' and a.route_action in('SHIPMENT_WAREHOUSE_SCAN','ARRIVAL_WAREHOUSE_SCAN','SEAL')
					group by a.staff_info_id,a.pno,a.route_action
				) as max_route             
				group by  max_route.staff_info_id ,max_route.route_action
	) r 
	GROUP BY r.staff_info_id 
	order BY r.staff_info_id asc



---揽件任务从创建到揽收完成，时间大于2小时（郭晋铎）----------------------------------------------------------
	select 
		id as 任务id,
		CONVERT_TZ(a.created_at, '+00:00', '+07:00') as 任务创建时间,
		CONVERT_TZ(a.finished_at, '+00:00', '+07:00') as 任务完成时间,
		staff_info_id as 员工id
	from ticket_pickup as a where a.state=2 and timestampdiff(second,a.created_at,a.finished_at)>7200
	and a.created_at>'2019-05-31 17:00:00' and a.`created_at` < '2019-06-30 17:00:00'


--快递员月度揽件------
SELECT 
ticket_pickup_staff_info_id as staff_info_id,
count(*) as count_pickup,
count()
FROM parcel_info
where created_at between '2019-05-31 17:00:00' and '2019-06-30 17:00:00' and returned = 0 
-- and ticket_pickup_store_id = 'TH01470301'
group by ticket_pickup_staff_info_id

----------揽件量
SELECT 
ticket_pickup_staff_info_id as staff_info_id,
count(1) as count_pickup
FROM parcel_info
where created_at between '2019-05-31 17:00:00' and '2019-06-30 17:00:00' and returned = 0 
group by ticket_pickup_staff_info_id

----派件量


---派件天数------
select staff_info_id,count(1)
from
(
SELECT 
ticket_delivery_staff_info_id as staff_info_id,
DATE(finished_at)
from parcel_info
where finished_at between '2019-05-31 17:00:00' and '2019-06-30 17:00:00' 
group by ticket_delivery_staff_info_id,DATE(finished_at)
)

group by staff_info_id




--揽件天数

select staff_info_id,count(1)
from
(
SELECT 
ticket_pickup_staff_info_id as staff_info_id,
DATE(created_at)
FROM parcel_info
where created_at between '2019-05-31 17:00:00' and '2019-06-30 17:00:00' and returned = 0 
group by ticket_pickup_staff_info_id，DATE(created_at)
)
group by staff_info_id


-----------------

	select 
		a.id,
		CONVERT_TZ(a.created_at, '+00:00', '+07:00')as 任务创建时间,
		CONVERT_TZ(a.finished_at, '+00:00', '+07:00')as 任务完成时间,
		a.staff_info_id as 员工id,
        si.`organization_id` as 所属网点,
-- sd.`beg_time` ,
-- sd.`end_time` ,
sd.`given_time` 
	from ticket_pickup as a left join `staff_info` si on a.`staff_info_id` =si.`id` 
LEFT JOIN `sys_district` sd on si.`organization_id` =sd.`store_id` 
where a.state=2 and timestampdiff(second,a.created_at,a.finished_at)>7200
	and a.created_at>'2019-05-31 17:00:00' and a.`created_at` < '2019-06-30 17:00:00'
and sd.`beg_time` <=36000


----梦雨----bike-非bike出勤-----
SELECT hsi.sys_store_id  AS 网点ID,
hsi.`sys_department_id` AS 部门ID,
ss.name AS 网点名称,
sd.name AS 部门名称,
adv.`stat_date` 日期,
count(1) as 出勤人数
FROM `attendance_data_v2` adv
LEFT JOIN `hr_staff_info` hsi on hsi.`staff_info_id` = adv.`staff_info_id` 
LEFT JOIN `sys_store` ss on hsi.`sys_store_id` = ss.`id` 
LEFT JOIN `sys_department` sd on hsi.`sys_department_id` = sd.id
WHERE `stat_date` BETWEEN '2019-07-01' and '2019-07-07'
and (adv.`attendance_started_at` IS NOT NULL or adv.`attendance_end_at` IS NOT NULL)
and hsi.`job_title`!=13
GROUP BY adv.`stat_date` ,hsi.`sys_store_id`,hsi.`sys_department_id`

-------shop员工出勤明细-------------------
SELECT att.`staff_info_id` as 员工工号 ,hjt.`job_name` as 职位名,hsi.`sys_store_id`  as 所属网点,ss.`name` as 网点名, att.`stat_date` as 统计日期,att.`display_data`as 出勤情况,att.`attendance_started_at` as 上班打卡时间,att.`attendance_end_at` as 下班打卡时间
from `attendance_data_v2` as att 
LEFT JOIN `hr_staff_info` as hsi on att.staff_info_id =hsi.`staff_info_id`
left join `sys_store` as ss on hsi.`sys_store_id` =ss.`id` 
left join `hr_job_title` as hjt on hsi.`job_title` =hjt.`id` 
where att.stat_date >="2019-07-01" 
and ss.`category`=4
-- 职位类型限定and hsi.`job_title` =13


--------固定工号的出勤----------------------------------
SELECT att.`staff_info_id` as 员工工号 ,hjt.`job_name` as 职位名,hsi.`sys_store_id`  as 所属网点,ss.`name` as 网点名, att.`stat_date` as 统计日期,att.`display_data`as 出勤情况,att.`attendance_started_at` as 上班打卡时间,att.`attendance_end_at` as 下班打卡时间
    from `attendance_data_v2` as att 
    LEFT JOIN `hr_staff_info` as hsi on att.staff_info_id =hsi.`staff_info_id`
    left join `sys_store` as ss on hsi.`sys_store_id` =ss.`id` 
    left join `hr_job_title` as hjt on hsi.`job_title` =hjt.`id` 
    where att.`staff_info_id` in(19571,19570)



-----shop签约客户信息-----------------------------------------
SELECT 
kp.`id` '大客户编号',
kp.`name` as '姓名',
kp. `major_mobile` as '电话号码',
kp.`sign_date` as '签约日期'
from `ka_profile` kp
where kp.`id`  in
(SELECT ko.`ka_id` 
-- ,ko.`operator_id`,sd.`name` 
FROM `fle_staging`.`ka_account_open_log` ko
LEFT JOIN `staff_info` si on ko.`operator_id` =si.`id` 
left join `sys_store` ss on si.`organization_id` =ss.`id` 
LEFT JOIN `sys_department` sd on si.`department_id` =sd.`id` 
where si.`department_id`='13')
and kp.`state` =1



--梦雨导数-20190819-------
SELECT 
	case pi.`customer_type_category`
    when 1 then '普通用户'
    when 2 then 'ka用户'
    end as '客户类别',
	COUNT(pi.pno) AS 'total',
	COUNT(DISTINCT `client_id` ) as '客户数',
	(COUNT(pi.pno))/(COUNT(DISTINCT `client_id` )) as '平均'
	FROM parcel_info as pi
	LEFT JOIN  `ka_profile` kp on pi.`client_id` =kp.`id` 
	left join sys_store as ss on ss.id = pi.ticket_pickup_store_id
	where pi.created_at between '2019-07-31 17:00:00' and '2019-08-18 17:00:00' and pi.returned = 0
	and pi.`parcel_category`  = 1 and pi.`state` != 9 
	and ss.`category`=4
 	group by pi.`customer_type_category`

	 
----查询包裹状态-------------------------
SELECT 
`pno`as '运单号', 
`recent_pno` as '最新运单号',
case `state`
when 1	then	'已揽收'
when 2	then	'运输中'
when 3	then	'派送中'
when 4	then	'已滞留'
when 5	then	'已签收'
when 6	then	'疑难件处理中'
when 7	then	'已退件'
when 8	then	'异常关闭'
when 9	then	'已撤销'
end as '当前状态'

from `parcel_info` 
WHERE (`pno` IN (
'TH71091PEVT2A','TH67011RENG5D','TH67011RGM23G','TH650346KN54','TH65032WJ154','TH65031GNS09','CF11398124P01','TH65021SQTP6C','TH65051SYU64D','TH65021T3AQ5C','TH65021SU3M3C','CF11395302P01','TH65021SVT55C','CF11394583P01','CF11386991P01','CF11386498P01','CF11381923P01','CF11374292P01','TH65021RXVE9C','TH65011QP535J','TH71041SD0U6D','TH71031RAJV4A','TH66071RP7F9C','TH7705745418','TH770170FZ63','TH7701707918','TH77016Z9A45','TH770174JD36','33529854','43016527','TH77016ZFC54','TH770179NU90','TH7701792A18','TH77016Z3772','TH770174GA90','TH7503ZQ0281','TH02011D0BW3Z','TH68041D01J7Z','TH68053FM654','TH760632FV45','TH21021S0UC9C','TH22031NDZE1H','CF11330352P01','TH0301ZQ6Y54','TH07011T66N8P','TH21011P3NH1I','TH21011NDH97I','TH21011KKMC5I','TH21011K5V35I','15559255','TH21011FS520I','TH21011CYKN2I','TH21011E2G09I','TH21011BP060I','TH21011AT6P8I','TH210118QSC0K','TH210118BWQ4I','TH210118AGW2I','TH21081S14D4A','TH20041R6HA7H','TH20041R90M5B','TH29121QWTH7I','TH66071QAZS9B','TH51041JEFG0I','TH01221HF7Q0A','TH20041SRUP6H','TH20041T2RP3H','TH21011SR982E','CF11367725P01','CF11360910P01','CF11341140P01','TH20041NA5Z7H','TH20041JNY49H','TH26011PRXD4E','TH20071FFKA6E','70279945','TH02021QJTA3D','60167254','TH23011PYV24G','TH20011K5Q63E','TH20011D7DX8I','TH01431D67A0A','TH20011KR383E','TH20011M8G07J','TH01271T1M24C','TH20011SNFR5P','CF11241461P01','91361354','TH01331H8QR0G','TH01201R1AV8A','TH012014SCW8A','TH01201T3NE2C','TH01201SZ5V5C','TH01331SSP37C','TH01201REJH4C','53942763','TH013314Z1S7Z','TH0124UMF090','59193572','TH0124M9HR72','TH01161FZFX1B','TH01161SPV28B','TH01261MX3D4A','TH02031RZ5S3A','TH02011K6E20J','86370481','TH02011EZWM3F','CF11393420P01','TH02011S3N93K','TH01061RP6G5D','TH01221R6D02A','TH02031RFBQ6B','TH03041PSJN3D','TH03021RTGV2E','TH01371QJ1H9C','TH01081RSUV4A','CF11191352P01','TH01301N8631A','TH01081SFNT8A','CF11338392P01','CF11294011P01','TH01071T9JF7C','TH01091SH988B','TH0132RHHG18','TH01321S0R76G','CF10963876P01','TH16021Q6TX3B','TH01511K58N2C','57114263','TH26041FBY06A','TH01451SU2W9B','TH01321RG1G7B','TH01321QK9Z1L','TH01091PRY86A','51118045','TH01091KRH35A','CF11125583P01','CF11345579P01','94920118','TH01511RG5Q6A','TH01161MX5C2Z','TH26071STD23A','TH0126XB0S09','TH03011PVC82C','CF11381616P01','60449854','TH030114UDT8E','TH0301164EQ1D','TH030113YDX9E','TH03011S1DV1D','TH03011RTDZ9E','TH04051M5B65A','TH03061KZ0F3D','CF11277045P01','TH03061H0E15D','TH03061T3K33C','TH03061T06Z3B','TH03061SXUT6B','TH03061SH2N9A','TH03061PK153Z','TH02011T7RQ0D','TH02011T1W77F','TH02011T0YP3L','TH01281NP2R6B','CF11116414P01','CF11031099P01','TH01141QWBK0C','TH01281DE8R2C','TH01281QE5U6A','TH02051T6SY2C','CF11355467P01','TH01371J06N8D','CF11401619P01','59089290','CF11402582P01','TH01271SKYY4A','TH01271SXBG3C','TH01271T2W43C','TH01271T2818C','TH01271SKJN1C','CF11382076P01','CF11381370P01','CF11374493P01','CF11357182P01','CF11354831P01','CF11381671P01','TH01271DZQW9A','TH75032U3B72','CF11372846P01','TH0142PZJK36','TH01281DGHC2B','TH0142Z6QM18','71262845','TH01421E2327A','TH01011D11T9C','TH01421DBR29B','TH01421T4H02B','TH01421S9BB6A','TH01271SC1Q5C','TH01421RCK96A','TH01421R25V4A','7114000097571','TH01431J34B0A','TH01431PH1C0A','CF11377413P01','TH01411HQ3H0B','TH01411Q4AD3B','TH01411HEF66B','TH01411KY4K6C','TH01411KHQF5Z','TH01411B0DW1B','TH01411EY202C','TH01411EMQQ4Z','TH01411AWGS1C','TH05061MMAB4Z','TH05061K0D19B','TH16021KK769D','TH14011S9U07R','TH27011HN6R4A','TH14011RD4J8D','TH16021S1Z95J','TH18051SX618D','15515555','TH770266PN72','TH42071SGJ62A','89715390','28810245','28805345','42897281','42897109','TH30031S98E5L','TH03011S9917G','CF11395513P01','CF11339952P01','TH02011CZVP3B','TH1401SC1V63','CF11289919P01','TH55011SWP54A','TH55051S84K2F','TH55051S5JB9E','TH55041S1EB2B','91365390','CF11305331P01','TH47071NUDY2C','TH5201T9XE81','TH58071T0230A','CF11244616P01','TH51041PNTY4K','CF11378173P01','TH59021SHGG5B','TH59011QSPA4I'

))
or (`recent_pno` in (
'TH71091PEVT2A','TH67011RENG5D','TH67011RGM23G','TH650346KN54','TH65032WJ154','TH65031GNS09','CF11398124P01','TH65021SQTP6C','TH65051SYU64D','TH65021T3AQ5C','TH65021SU3M3C','CF11395302P01','TH65021SVT55C','CF11394583P01','CF11386991P01','CF11386498P01','CF11381923P01','CF11374292P01','TH65021RXVE9C','TH65011QP535J','TH71041SD0U6D','TH71031RAJV4A','TH66071RP7F9C','TH7705745418','TH770170FZ63','TH7701707918','TH77016Z9A45','TH770174JD36','33529854','43016527','TH77016ZFC54','TH770179NU90','TH7701792A18','TH77016Z3772','TH770174GA90','TH7503ZQ0281','TH02011D0BW3Z','TH68041D01J7Z','TH68053FM654','TH760632FV45','TH21021S0UC9C','TH22031NDZE1H','CF11330352P01','TH0301ZQ6Y54','TH07011T66N8P','TH21011P3NH1I','TH21011NDH97I','TH21011KKMC5I','TH21011K5V35I','15559255','TH21011FS520I','TH21011CYKN2I','TH21011E2G09I','TH21011BP060I','TH21011AT6P8I','TH210118QSC0K','TH210118BWQ4I','TH210118AGW2I','TH21081S14D4A','TH20041R6HA7H','TH20041R90M5B','TH29121QWTH7I','TH66071QAZS9B','TH51041JEFG0I','TH01221HF7Q0A','TH20041SRUP6H','TH20041T2RP3H','TH21011SR982E','CF11367725P01','CF11360910P01','CF11341140P01','TH20041NA5Z7H','TH20041JNY49H','TH26011PRXD4E','TH20071FFKA6E','70279945','TH02021QJTA3D','60167254','TH23011PYV24G','TH20011K5Q63E','TH20011D7DX8I','TH01431D67A0A','TH20011KR383E','TH20011M8G07J','TH01271T1M24C','TH20011SNFR5P','CF11241461P01','91361354','TH01331H8QR0G','TH01201R1AV8A','TH012014SCW8A','TH01201T3NE2C','TH01201SZ5V5C','TH01331SSP37C','TH01201REJH4C','53942763','TH013314Z1S7Z','TH0124UMF090','59193572','TH0124M9HR72','TH01161FZFX1B','TH01161SPV28B','TH01261MX3D4A','TH02031RZ5S3A','TH02011K6E20J','86370481','TH02011EZWM3F','CF11393420P01','TH02011S3N93K','TH01061RP6G5D','TH01221R6D02A','TH02031RFBQ6B','TH03041PSJN3D','TH03021RTGV2E','TH01371QJ1H9C','TH01081RSUV4A','CF11191352P01','TH01301N8631A','TH01081SFNT8A','CF11338392P01','CF11294011P01','TH01071T9JF7C','TH01091SH988B','TH0132RHHG18','TH01321S0R76G','CF10963876P01','TH16021Q6TX3B','TH01511K58N2C','57114263','TH26041FBY06A','TH01451SU2W9B','TH01321RG1G7B','TH01321QK9Z1L','TH01091PRY86A','51118045','TH01091KRH35A','CF11125583P01','CF11345579P01','94920118','TH01511RG5Q6A','TH01161MX5C2Z','TH26071STD23A','TH0126XB0S09','TH03011PVC82C','CF11381616P01','60449854','TH030114UDT8E','TH0301164EQ1D','TH030113YDX9E','TH03011S1DV1D','TH03011RTDZ9E','TH04051M5B65A','TH03061KZ0F3D','CF11277045P01','TH03061H0E15D','TH03061T3K33C','TH03061T06Z3B','TH03061SXUT6B','TH03061SH2N9A','TH03061PK153Z','TH02011T7RQ0D','TH02011T1W77F','TH02011T0YP3L','TH01281NP2R6B','CF11116414P01','CF11031099P01','TH01141QWBK0C','TH01281DE8R2C','TH01281QE5U6A','TH02051T6SY2C','CF11355467P01','TH01371J06N8D','CF11401619P01','59089290','CF11402582P01','TH01271SKYY4A','TH01271SXBG3C','TH01271T2W43C','TH01271T2818C','TH01271SKJN1C','CF11382076P01','CF11381370P01','CF11374493P01','CF11357182P01','CF11354831P01','CF11381671P01','TH01271DZQW9A','TH75032U3B72','CF11372846P01','TH0142PZJK36','TH01281DGHC2B','TH0142Z6QM18','71262845','TH01421E2327A','TH01011D11T9C','TH01421DBR29B','TH01421T4H02B','TH01421S9BB6A','TH01271SC1Q5C','TH01421RCK96A','TH01421R25V4A','7114000097571','TH01431J34B0A','TH01431PH1C0A','CF11377413P01','TH01411HQ3H0B','TH01411Q4AD3B','TH01411HEF66B','TH01411KY4K6C','TH01411KHQF5Z','TH01411B0DW1B','TH01411EY202C','TH01411EMQQ4Z','TH01411AWGS1C','TH05061MMAB4Z','TH05061K0D19B','TH16021KK769D','TH14011S9U07R','TH27011HN6R4A','TH14011RD4J8D','TH16021S1Z95J','TH18051SX618D','15515555','TH770266PN72','TH42071SGJ62A','89715390','28810245','28805345','42897281','42897109','TH30031S98E5L','TH03011S9917G','CF11395513P01','CF11339952P01','TH02011CZVP3B','TH1401SC1V63','CF11289919P01','TH55011SWP54A','TH55051S84K2F','TH55051S5JB9E','TH55041S1EB2B','91365390','CF11305331P01','TH47071NUDY2C','TH5201T9XE81','TH58071T0230A','CF11244616P01','TH51041PNTY4K','CF11378173P01','TH59021SHGG5B','TH59011QSPA4I'

))



--时间段内三段码信息
SELECT pi.pno '运单号（pno）', 
CASE ss.`generate_district_code` 
        when 0 THEN CASE   ss. `province_code` 
                        when 'TH01'  THEN IFNULL ((SELECT `sorting_code`  FROM `sys_three_sorting` sts where sts.zoning_basis_code = pi.`dst_district_code` and  sts.store_id = pi.`dst_store_id` and sts.deleted=0 ),'00')
                        when 'TH02'  THEN IFNULL ((SELECT `sorting_code`  FROM `sys_three_sorting` sts where sts.zoning_basis_code = pi.`dst_district_code` and  sts.store_id = pi.`dst_store_id` and sts.deleted=0 ),'00')
                        when 'TH03'  THEN IFNULL ((SELECT `sorting_code`  FROM `sys_three_sorting` sts where sts.zoning_basis_code = pi.`dst_district_code` and  sts.store_id = pi.`dst_store_id` and sts.deleted=0 ),'00')
                        when 'TH04'  THEN IFNULL ((SELECT `sorting_code`  FROM `sys_three_sorting` sts where sts.zoning_basis_code = pi.`dst_district_code` and  sts.store_id = pi.`dst_store_id` and sts.deleted=0 ),'00')
                        ELSE   IFNULL ((SELECT `sorting_code`  FROM `sys_three_sorting` sts where sts.zoning_basis_code = pi.`dst_postal_code` and  sts.store_id = pi.`dst_store_id` and sts.deleted=0 ),'00') END
    when 1  THEN IFNULL ((SELECT  sst.`sorting_code`  FROM `sys_three_sorting` sst where sst.zoning_basis_code = pi.`dst_district_code`  and sst.store_id = pi.`dst_store_id` and  sst.deleted=0),'00')
END  as '面单第三段码',
CASE  ss.`generate_district_code` 
  when 0 THEN CASE   ss. `province_code` 
                        when 'TH01'  THEN '按乡'
                        when 'TH02'  THEN  '按乡'
                        when 'TH03'  THEN  '按乡'
                        when 'TH04'  THEN  '按乡'
                        ELSE   '按邮编' END
   when 1 THEN '按乡'
end as '三段码类型' ,
(SELECT COUNT(*) FROM sys_three_sorting where store_id = pi.`dst_store_id` and  deleted=0)as '目的地网点的三段码数量',
pi.`dst_store_id` '目的地网点ID（dst_store_id）',
pi.`dst_district_code`  '目的地的第三级行政区id（dst_district_code）',
pi.`dst_postal_code`  '目的地的邮编（dst_postal_code）',
pi.`dst_detail_address`  '收件人地址（dst_detail_address）',
CASE  pi.`channel_category`  
  when 3 THEN '是'
  else  '否'
end as  '该运单的发件人是否是API接口客户'
FROM parcel_info pi
LEFT JOIN `sys_store` ss on ss.`id`  = pi.dst_store_id
WHERE   ss.`category` =1 and  pi.`created_at`>=CONVERT_TZ('2019-08-14 00:00:00',  '+00:00', '-07:00')
and pi.`created_at`<=CONVERT_TZ('2019-08-14 23:59:59',  '+00:00', '-07:00');


---历史未关闭包裹数----------
SELECT COUNT(*) 
FROM `parcel_info` 
WHERE (`state` IN (1,2,3,4,6)) AND (`created_at` <'2019-07-31 17:00:00')


---集包率计算调整------------

-- 分子
SELECT
count(DISTINCT a.pno)
from pack_seal_detail a
JOIN pack_info b on b.pack_no =a.pack_no 
JOIN parcel_info c on c.pno =a.pno 
JOIN (
    SELECT  pno, max(routed_at) as routed_at
    from parcel_route
    WHERE store_id = 'TH01470301' and route_action ='SHIPMENT_WAREHOUSE_SCAN' 
    and routed_at > CONVERT_TZ('2019-08-10 00:00:00', '+00:00', '-07:00') and routed_at <= CONVERT_TZ('2019-08-10 23:59:59', '+00:00', '-07:00') 
    group by pno
) d on a.pno = d.pno 
WHERE 
(
(b.seal_store_id = 'TH01470301')-- 在本网点集包的
or
(b.seal_store_id != 'TH01470301' and d.`routed_at`>b.`seal_at` and d.`routed_at`<b.`updated_at`  )-- 不在本网点集包，但发件出仓时仍为集包状态的
)

and if(c.exhibition_weight!=0, c.`exhibition_weight`, c.`store_weight`) <= 3000



-- 分母
SELECT
count(DISTINCT a.pno)
from parcel_info a
join (
    SELECT DISTINCT pno
    from parcel_route
    WHERE store_id = 'TH01470301' and route_action ='SHIPMENT_WAREHOUSE_SCAN' 
    and routed_at > CONVERT_TZ('2019-08-10 00:00:00', '+00:00', '-07:00') and routed_at <= CONVERT_TZ('2019-08-10 23:59:59', '+00:00', '-07:00') 
) b on a.pno = b.pno 
WHERE 
if(a.exhibition_weight!=0, a.`exhibition_weight`, a.`store_weight`) <= 3000



----三段码--------------------------
--时间段内三段码信息
SELECT pi.pno '运单号（pno）', 
CASE ss.`generate_district_code` 
        when 0 THEN CASE   ss. `province_code` 
                        when 'TH01'  THEN IFNULL ((SELECT `sorting_code`  FROM `sys_three_sorting` sts where sts.zoning_basis_code = pi.`dst_district_code` and  sts.store_id = pi.`dst_store_id` and sts.deleted=0 ),'00')
                        when 'TH02'  THEN IFNULL ((SELECT `sorting_code`  FROM `sys_three_sorting` sts where sts.zoning_basis_code = pi.`dst_district_code` and  sts.store_id = pi.`dst_store_id` and sts.deleted=0 ),'00')
                        when 'TH03'  THEN IFNULL ((SELECT `sorting_code`  FROM `sys_three_sorting` sts where sts.zoning_basis_code = pi.`dst_district_code` and  sts.store_id = pi.`dst_store_id` and sts.deleted=0 ),'00')
                        when 'TH04'  THEN IFNULL ((SELECT `sorting_code`  FROM `sys_three_sorting` sts where sts.zoning_basis_code = pi.`dst_district_code` and  sts.store_id = pi.`dst_store_id` and sts.deleted=0 ),'00')
                        ELSE   IFNULL ((SELECT `sorting_code`  FROM `sys_three_sorting` sts where sts.zoning_basis_code = pi.`dst_postal_code` and  sts.store_id = pi.`dst_store_id` and sts.deleted=0 ),'00') END
    when 1  THEN IFNULL ((SELECT  sst.`sorting_code`  FROM `sys_three_sorting` sst where sst.zoning_basis_code = pi.`dst_district_code`  and sst.store_id = pi.`dst_store_id` and  sst.deleted=0),'00')
END  as '面单第三段码',
CASE  ss.`generate_district_code` 
  when 0 THEN CASE   ss. `province_code` 
                        when 'TH01'  THEN '按乡'
                        when 'TH02'  THEN  '按乡'
                        when 'TH03'  THEN  '按乡'
                        when 'TH04'  THEN  '按乡'
                        ELSE   '按邮编' END
   when 1 THEN '按乡'
end as '三段码类型' ,
(SELECT COUNT(*) FROM sys_three_sorting where store_id = pi.`dst_store_id` and  deleted=0)as '目的地网点的三段码数量',
pi.`dst_store_id` '目的地网点ID（dst_store_id）',
pi.`dst_district_code`  '目的地的第三级行政区id（dst_district_code）',
pi.`dst_postal_code`  '目的地的邮编（dst_postal_code）',
pi.`dst_detail_address`  '收件人地址（dst_detail_address）',
CASE  pi.`channel_category`  
  when 3 THEN '是'
  else  '否'
end as  '该运单的发件人是否是API接口客户'
FROM parcel_info pi
LEFT JOIN `sys_store` ss on ss.`id`  = pi.dst_store_id
WHERE  pi.pno in (

'CF11678721P01','CF11678856P01','CF11678940P01','CF11678184P01','CF11678664P01','CF11679676P01','CF11679246P01','CF11677841P01','CF11679672P01','CF11678364P01','CF11677878P01','CF11677397P01','CF11677914P01','TH21082497A7D','CF11677338P01','TH390224A5G6D','TH6508249ZP4B','TH650824A583B','TH012024A575C','TH4718249KT5B','TH0304249V51B','TH7103248W97F','TH2007246KG1B','TH051123U4M4D','TH5501246XH5C','TH2502246AC5M','TH3724249SM4C','TH200423XS13B','TH711623YTR3A','TH7507249RH1E','TH040623Z9G6A','60915036','TH0141249FK4C','TH015123MTT9Z','TH4417249905B','TH6506248X51C','TH030123MTB2Z','TH210823G3G3B','TH6508243UR3B','TH4723249894E','91172863','TH6502246XA7B','TH4601242T46A','TH1312248JQ7A','TH65022474R1A','TH2005247JN3I','TH29012444J9F','TH77032474Q9A','TH6401242SC7E','TH7406248JM3B','TH7103248HU6F','TH73072414D8A','18984546','CF11676858P01','TH6605248784G','TH0138248518A','TH7001248068J','TH03012482F1H','TH2106247E09B','TH20012474N3M','TH4305247XE8E','TH3701246KA1A','TH030623SZ78Z','TH4718246T44A','CF11672477P01','TH01162433M6B','TH0106244YP1B','TH7101243N43D','TH610323WJT5A','TH681023UCS1C','TH2810246UA4O','TH490323MF13A','TH0301247Q81C','TH2004247KB1B','TH450923UU25B','TH2101247BB7C','TH1302247K54D','TH200623UQZ4Q','TH550423UQU6E','TH7107241QB6D','TH120123NDB1B','TH510623P8X6E','TH391223NKP3C','TH711023NTP2H','TH68052469R8B','TH13082465S0E','TH7101246P90A','TH25052430K6H','TH1601246SD3N','TH4401246P06I','TH3715245XN9I','TH6503246G35B','TH640123M021L','TH310123JWA0A','TH0127242UK6C','TH3905246SC3F','TH2007246K26E','TH1902245SK9F','TH71072462B0L','TH711123YEK1J','TH760123ZDC1Z','TH210523ZUH3G','TH2506246912D','TH2207246244C','TH1409245Z46C','TH0103244R31D','TH720523ZUA5F','TH0101245R80B','TH3801245GC9I','802001000666546','76455372','TH5901245QZ1I','TH5901245RJ5I','TH5901245S05I','802001000663883','TH580723WNM8A','TH7307244WW0A','CF11674741P01','CF11676325P01','TH200723ZWU7G','TH0142245DM3B','TH120423TJ19B','TH480623TJ17H','TH680723Y5X7D','TH0304244RQ4A','TH02052450Z2E','7114000428443','TH20042444X4B','TH0102245DN4B','TH42012456K1G','TH610123W294Q','TH710723YHT3A','TH71112449W4A','TH040623ZC96Z','TH0139245037Z','TH6815240TA7E','TH0149244VZ1G','TH3801243GV6H','CF11674748P01','TH4705244CV8B','TH3508244XF2A','TH4404244C69A','TH451023W5V9Z','TH0138244K23A','TH3901244DE0B','TH6506243ZZ6D','TH3311242M72D','TH200423W5T5B','TH330223W4P0D','TH720123W4K9Z','TH331323Q4F2A','TH650123UUR5E','TH0122244987C','TH01502414K7A','TH20042422N8B','CF11675179P01','TH290923X5C6J','CF11675169P01','TH6815243ZJ3D','TH040223TRE7F','TH2108242ZE0A','TH471823UEV9A','CF11673670P01','TH0143243RC1C','TH7107242ED3D','TH5410241JK5G','TH0304241PP6C','TH710723XHW7Z','TH710123YH07D','TH0302241D00H','SP061912872','TH200720UH15Z','TH0102242ZA2C','TH200123Z6D2A','TH0116242Z55A','TH020323UJ41A','TH2101242VT1I','TH110323ZFS5B','TH220923Z5Y8F','TH1907241GG0D','TH1013242BX7D','TH0125242KH3B','CF11676145P01','TH020223ZTF3H','TH4219242CH9C','48672945','48677590','CF11674260P01','TH7302241HA0A','TH560523MC30H','TH20042414T9B','CF11673208P01','97998409','CF11673203P01','TH210823ZJG9A','CF11675071P01','TH6501240X59H','TH030623Y6X3D','TH0140241UT0B','56428763','TH240123XEQ7R','TH0306241A99H','TH400723ZHE1B','TH0201240X29E','CF11676140P01','TH3905241085F','TH77012412K0A','TH630123ZW00F','TH620123DF51M','TH4725240SK2C','CF11671504P01','CF11674009P01','TH7111240NW8A','TH710123WP81D','CF11676697P01','TH2701240FM0A','TH2007240GW1C','84398809','TH020223XSE8A','CF11671488P01','TH560123UJP5L','TH75022401Y5D','TH020323ZMT3E','CF11676674P01','TH370123YG16O','CF11671505P01','TH012723ZS64C','CF11670886P01','TH014223ZB93A','TH050623Z8H5P','TH210823Z9V7A','CF11671803P01','TH170123YUM2C','TH680423YVH3F','TH01012384D1C','TH6108237CB1A','CF11671650P01','CF11670810P01','CF11671694P01','TH710123X537C','TH650123YJ19H','TH471823Y5Y0B','TH470123Y2J2D','TH010123Y0W4B','98350736','CF11671071P01','CF11668589P01','TH560723WQ24A','CF11671089P01','CF11671205P01','CF11668439P01','TH300322QQJ0B','CF11670696P01','TH010323BSS4C','TH610122UZA3G','CF11670687P01','CF11670261P01','TH020123BU05B','CF11668528P01','CF11669007P01','CF11668543P01','CF11667644P01','CF11668075P01','CF11671152P01','CF11667856P01','CF11667844P01','CF11668106P01','TH260423VBM0A','CF11667593P01','CF11666521P01','CF11667222P01','CF11665373P01','CF11665086P01','CF11666097P01','CF11665979P01','CF11665275P01','CF11665429P01','CF11664731P01','TH012721ABB1C','TH012723UNV3A','TH550422XQB0G','CF11663572P01','CF11663645P01','TH471923E6F0C','TH450122XP00A','CF11662968P01','TH59062158P6A','CF11661964P01','TH020323QWS2Z','TH020323QWU3Z','TH020323QWU7Z','TH020323S0D0Z','TH014323U4M9A','TH700123E889A','TH02012154M7K','TH680523TWF0A','TH020123AZC7F','TH200723J7B0C','TH240123HUF4F','TH640823KJ69A','CF11662813P01','TH711123TAQ3H','TH711423TQQ1A','TH650123MBE2A','TH550323TM69A','TH650823EKM7B','TH640923T9A9K','60914463','TH660823KP87C','TH010623TQ36C','TH590123SR07A','60914381','TH710723K0M8D','TH650123GK35G','TH540623GJ10A','89644790','TH330723TBS3A','TH330723TCE1A','TH330723TD08A','TH040623T8F9B','CF11662339P01','11309946','11310837','TH650823D798B','TH010423B1C1A','TH240123DBG8H','TH014623QQ82B','TH130823QCV7D','TH014223RWS6C','TH010723RNA3A','TH030623S685D','11309637','11310937','11309028','TH020323F5B5D','TH013923JSH0F','99325154','TH200223D9K0H','TH680423RSF8G','TH711223RQQ5A','TH610223RP25E','TH010823RF11A','TH471423ENJ8B','TH660523EYB4F','TH680423QF67D','TH711623PWB1A','TH020123QRQ0J','TH012623Q8U0A','TH012823QS74A','TH380123QPT9A','TH670123C9H7F','TH014923QRU9E','TH330123GDR2O','TH013923PFF7E','TH012623NA78C','TH670120ZGU9Z','TH030223BRC9D','TH014223Q853A','TH010823B4J0A','TH270123NEC6K','TH670123DG09H','TH660823P2P6A','TH680923P1S0A','TH012823PA10C','TH710723H9V8L','TH030423PPS4G','TH020123NJR3J','TH012823P4E0A','TH640723P928A','TH372023PA77E','FGDMT52771111','FGDMT81360157','TH020123NGA8D','TH560723M783B','TH0304235D62H','TH030123NMM4G','TH471823BDW4A','TH0151239Y14A','TH770823MVS9C','TH550723EQU7C','TH650623NGD3A','TH490522QTZ1Z','TH120423NNS2A','98496109','TH540123HKQ6B','TH480123N6K0E','TH160323MB04C','TH471423JWC2D','TH420123MKB0G','TH680123MZ17K','TH120323MAX2C','TH370323F139C','TH590823F1F3D','TH260623FFD3Z','TH030123BYM5I','61489109','TH250623KX56D','TH051123K106D','TH020523C844E','TH470123BHF0J','61446072','TH330523JXC1C','TH560523GR54G','TH120423G483H','TH550123KHA5D','TH590723KBW6C','TH200423JFW9B','TH650823HZH8B','TH480323J940A','TH012723FBU1C','TH371823C5A1A','TH300123J4J0A','TH590123HVB2G','TH030523H1Q9B','TH302223ESV2I','CF11660027P01','TH580223HBR3G','TH250423GTT5H','TH640823GRF3A','TH150123GDE0A','CF11660868P01','TH470123G4V5K','TH011023F6Z3D','CF11660512P01','TH210523GKR5C','TH291023GF10F','TH490123G936H','TH5208237XR8C','TH650823C8Q5B','TH0403239BZ3A','72865027','72864463','TH370123FHP5A','CF11659966P01','TH460123EQF8A','TH46012390J6A','TH670223E487B','602001000003793','TH730523DFB0C','TH200422WWN0B','CF11658529P01','TH630323CA24A','TH012523BMU0E','CF11657869P01','CF11655914P01','CF11657260P01','TH012323BEA4A','CF11655173P01','CF11654810P01','TH200123AMQ3Z','CF11654472P01','TH711122K2F1B','99247109','TH0105237150C','TH03032300B8Z','TH015023A571B','61098018','TH6506239VQ2A','TH0206239UJ5C','TH7203239JT3B','61093509','99341018','TH1701239DK5A','TH5501239A43G','TH250122ZRX4H','97152790','97153345','TH16022393Z9F','TH4701235NV5I','TH2804231B42A','TH2901231374J','TH38012301R7A','TH66062307S6A','TH670322WD57F','TH5601236SC2F','TH014022Y992B','TH3305235Z86A','TH4707235H56C','TH6501233YS7C','TH7101234619C','TH250422YXY8E','TH040122XRX3N','TH0301232V25E','TH012322KQ46A','TH70072377U3A','TH012722ZKV6A','CF11652924P01','TH7702233HS6A','TH013722Z644A','TH200722YQ73B','TH0306234Y87C','TH04022325W5B','TH6804233NG5F','TH01162355B0B','TH0136230XQ0B','85887327','TH711122V8D1Z','TH020522Z7Q3E','TH0304230CX1E','TH43092327M7G','TH0403229ZT3C','TH4801235WP7A','TH040622ZGT3B','TH65082369P6B','TH5411231TN8B','TH0201235UP5B','TH220422VUN3B','TH200422YMY7B','TH6701234M09A','TH471322ZEF6E','TH0507235UW7A','TH010922WEB3C','TH2701234W29A','TH0301234HS9A','TH010422TWA8A','TH011822XTN0B','TH0143219KR8Z','TH6508234K52B','TH0401234KW1D','TH3303234805D','TH240122XDH2L','TH250221KGM9K','TH700322WHS1D','TH0101234NY9A','TH0106234KE7B','76458672','TH0203234777A','TH2004234CD8H','TH040622DJT8C','CF11653189P01','TH70062342Y5D','7116000557727','TH650122Z568I','TH0128233FF6A','TH6703233DY9A','TH0401233827F','TH240222TAS0D','CF11652456P01','TH4724230EX9A','TH3905231JN9A','TH04012322B0N','TH010222YH61Z','TH01502325Z6B','TH4701231Q57D','TH730822W7B9A','TH0101231NF3A','TH04012312M7A','TH051522VBP3G','TH160122ZT80K','TH4204230P86I','TH0507230TY6B','66896490','TH2004230JB0B','TH330122Z8F5A','78320390','TH490122YNJ8E','TH030122Z7H4D','TH270222Z2Z4C','TH681522Z0J5D','TH650822YR20B','CF11650416P01','TH014222Y8G3A','TH300722YHB9C','TH270122Y3F6F','802001000670890','TH200722C2F3E','CF11650489P01','TH200122BA99E','TH310622W180A','TH014222BEG7A','TH240422VVR9A','CF11649155P01','CF11648716P01','CF11649201P01','TH012822V9T8A','CF11648847P01','CF11648843P01','CF11648603P01','CF11648536P01','CF11647297P01','CF11646370P01','CF11646268P01','TH201122UGD5A','TH370122UFM9F','TH040122U342A','TH20041ZB0K5B','TH670121Q335E','CF11646175P01','TH580122AUP7I','TH660121X1J7A','TH740822TH76E','TH680422AZZ3F','TH014522T925C','TH030222S6E2F','TH270122FFU9O','TH030622SEJ7D','TH470422SE89D','TH200422SF53B','TH014222SEH8B','7110003424819','TH770422RZ32E','TH160222NEB7B','TH740422C5Y0A','TH030422P450E','TH650822J357B','TH030622PV40L','TH030422CTA4B','TH650821UWV0B','TH012022R1K1A','TH01301Z1UK7Z','TH012822QBW0B','TH010822QCJ2A','TH360122KCA7F','TH260522PZR4G','TH381322PFT5F','TH470122P0D5Z','TH650822MWR0B','TH040622P0X4D','TH014422DYS7A','601001000032099','601001000032418','TH6508228NY3B','TH011922D9E9B','TH2106229580E','85883454','TH130322MMJ3D','TH014622JE57A','TH45012286R4K','TH450122DDY1L','TH372522KB93A','TH281122B965B','85884027','TH740522KRS6J','TH080622KVN3A','TH0107229XP0C','TH040122H410K','TH012922K767C','TH270122E7Y1Q','TH012722A8P0A','TH100922HDM8C','TH012822JMK6Z','TH250622JR39J','78921645','78921681','78921727','78921772','78921781','78921790','78921809','78921818','78921836','78921845','78921854','78921872','78921881','78921890','78921909','78921918','78921927','78922136','78922218','TH051022J9B0B','61305509','TH650122E1U5G','85884936','TH1801228FW3S','TH4715228G18K','TH570121HS68A','TH301722CDN9C','TH650122HUR3E','TH010522H6R3D','TH471922GPV1J','TH270722DWV1E','TH650822GMV2B','TH200422FT92B','TH040422DUM8E','TH650422BPE3F','TH030122DJR2E','TH650822CF86B','TH030422BV30F','TH03012298Q7B','CF11642499P01','CF11638763P01','CF11637672P01','TH0205206AH7E','TH030120W9F4A','CF11637864P01','TH75032289R7G','TH01311ZMX03A','TH01271ZB4Q8A','97997836','61095909','TH1906227TW3B','61094218','TH77082270U1C','TH2004225N27B','61090536','TH7101226N56F','61091090','61095027','TH7002226GU8E','PZG23437KW83','TH3901225KF6G','48999136','61312145','61320881','TH0303224WS7D','PZG70961KJ78','TH120321F0C7C','TH0101223Z02B','TH2004224A45B','TH7402224R51A','TH2007224FA6C','TH4002224T78D','TH6701221MF9A','TH550221PTK9D','TH200721ZTN5H','TH030621C3C6B','TH3701223YT4O','TH6001221200A','70984018','TH55042241R3Z','TH381121X6T4Z','TH6804222ZQ7F','TH1491ZWG88A','TH200121QH23A','TH011820VXE6B','TH20042238X4A','98065136','TH012221RJB0A','TH5503221JC3C','TH650221UP57E','TH2005221H02D','TH2704222179A','TH5607221712B','TH030621TUN4G','98232854','TH020321TUA7E','TH011321W115C','TH030321YK13C','TH020121QAK1C','TH260121QGQ7A','96960172','TH711121NTD5B','TH010621YHK4B','TH360121QV07F','TH47212GNP3A','TH011421YC63D','TH030621RKF7C','TH240421XF31A','TH010521X2V4A','CF11635199P01','TH020121W9T0A','TH012721V877A','TH010321THK2B','TH271821USJ1H','TH010121TCY8B','TH051520VVG6B','91180245','TH381121T0K9H','61321672','TH030420S5F1H','TH4701209WT8D','61323127','TH710721K6B5A','61344572','TH020120VX71K','TH020321P8S5E','TH01421Y8RS8B','TH03061Y8RY5B','CF11631961P01','CF11632018P01','TH480121MQ99G','CF11628728P01','CF11627852P01','CF11627856P01','TH051021FPQ8C','TH160121F8N3A','TH580421J189I','TH270121J2J6J','TH012721HKH4A','TH550721FRG4A','TH01232174K3A','26157818','TH6804217SA3F','TH490321GUQ4D','TH012521GE64C','TH020221GN41D','TH071121FXN8B','96452954','TH200421FCS8B','TH20071ZZB15C','TH681121F9X0E','TH730121DVH1A','TH550721D4Z5A','TH510421CHE6B','TH014621DCV3A','TH272121D817A','TH012721AMY4A','TH013421D185A','TH560721AGK1B','TH2008215FK9A','TH030621BVR3B','TH3106219817A','TH680421CGZ7F','TH540121C8H9E','TH210121BT30N','89635927','CF11622392P01','CF11617960P01','TH012720V8R9Z','TH2007216YB9G','TH0305216NK3A','TH1410213AR5F','TH4801214EY1L','TH012820QXJ9B','TH59072138Q6B','TH5507211ZQ7A','96532018','TH560120ZXA2A','TH0201212CA2F','TH39092129G6B','TH200120V086E','62625318','TH012720TR10C','TH0501211AD1D','TH010920YET9A','67772909','TH2701210SW1A','TH470120S360E','TH38012102P5D','TH740520SAF6C','TH590620X6S5A','TH670120X210F','CF11608460P01','TH0302206644B','CF11606690P01','CF11602428P01','CF11599202P01','TH210820NTT0B','TH010720QR71A','91177872','TH014220Q2R2A','TH650220P639A','TH331220F9T8J','TH710420BXA2A','TH360420NMS9A','TH650220M9R3A','TH05071ZHN70','TH420420H0S2L','TH012720KFQ4C','TH670120K8T8A','TH01511X8Q76Z','TH200720AY14Z','TH200420GFJ9B','TH330120EF94A','TH030420D098E','TH012720GH78A','TH160120GYP2A','TH014620FHQ2B','TH130820EUG1I','TH471320D8J1J','TH030120BMF9A','TH68041ZVXZ8C','CF11587942P01','CF11587155P01','CF11585553P01','TH47191YFG73G','TH5402208H15A','TH56042087E8A','TH6502207C89B','TH0127201KZ9A','TH20041ZH9P9B','TH7107204Q71D','TH6801205GT7A','TH0127201725A','TH0109203GG2B','TH56011ZZ0C7K','85918072','76460563','TH03041ZXFA4H','TH0306202NX9J','TH47251Y6HK2C','PZG12978CG22','TH2004201B40B','TH05061ZYAJ8B','TH04061ZZMQ3B','TH47011ZY0Z5E','85913354','TH71151ZWVJ5B','TH01271ZUE77C','CF11568418P01','TH12081ZQJB3C','TH42041Z9HV6I','TH65021ZHSQ6E','TH19031ZM7B5E','TH67031ZM629B','91096172','TH65021ZA795E','90940281','TH03061ZGVE7E','CF11569649P01','TH01071Z8EB7B','TH20071Z8AQ4E','TH20041Z2P43G','TH74101Z17H7D','TH02011YW745J','TH01511YN9E6B','TH03041Y2X28B','TH01121YPX96B','TH65081YNE38B','TH65081YN851B','TH01201YDXF6B','70252509','CF11544730P01'
	
)



---车线导数------------
SELECT fvp.`id` as '出车凭证编号',DATE(CONVERT_TZ(fvp.`departure_time`, '+00:00','+07:00')) as '计划出车日期',CONVERT_TZ(fvp.`departure_time`, '+00:00','+07:00') AS '计划出车时间',fvl.`name`as '线路名称' ,(fvl.`price` /100) as '价格',
case fvl.`mode`
when 1 THEN '常规'
when 2 then '临时'
end as '线路模式',
fvl.`track` as '线路走向'
FROM `fleet_van_proof` fvp left JOIN `fleet_van_line` fvl on fvp.`van_line_id` =fvl.`id` 
where fvp.deleted=0 
and fvl.`mode` !=3
and CONVERT_TZ(fvp.`departure_time`, '+00:00','+07:00') >'2019-10-28 00:00:01'
and CONVERT_TZ(fvp.`departure_time`, '+00:00','+07:00') <'2019-10-28 23:59:59'

---线路基本信息---------
SELECT `name` ,(`price`/100) AS 'price',`track`,
case `mode`
when 1 THEN '常规'
when 2 then '临时'
end as '线路模式'
FROM `fle_staging`.`fleet_van_line` 
WHERE `deleted`=0
and `mode`=1

--价格表信息--------
SELECT flt.`id`,fi.`name` as 'supplier co. name',flt.`line_track`,
case flt.`type`
WHEN 1 then '单边'
when 2 then '双边'
end as '单边or双边',
case flt. `van_type`
when 100 then '4W'
when 101 then '4WJ'
when 200 then '6W5.5'
when 201 then '6W6.4'
when 203 then '6W7.5'
when 300 then '10W'
end as '车型',
(flt. `price`/100) as 'price'
FROM `fleet_line_tariff` flt 
LEFT JOIN `fleet_info` fi on flt.`fleet_id`=fi.`id` 
WHERE flt.`deleted` =0

---罚款相关SQL------------
---0全部正式员工名单-----
SELECT `id` ,`organization_id`,
case `is_sub_staff` 
when 0 then '否'
when 1 then '是'
end as '是否子账号',
case `virtual_number_enabled` 
when 0 then '否'
when 1 then '是'
end as '是否虚拟账号'
FROM `fle_staging`.`staff_info`
WHERE `id` <90000



---01虚假疑难件罚款
SELECT 

`pno` ,`delivery_staff_info_id` as '派件员工号',`cheat_at` as '虚假信息发生时间', `created_at` '创建时间',`operator_store_id` as  '验证网点编号',`operator_staff_info_id`as  '验证人工号',

case  `cheat_type`
when 0 then '疑难件原因虚假'
when 1 then '留仓原因虚假'
end as '虚假类型',

case  `state`
when 0 then '未验证'
when 1 then '已验证'
end as '处理结果',

case  `cheat_result_category`
when 0 then '虚假'
when 1 then '正常'
end as '处理结果',

case `cheat_reason_category`
when 'cheat_reason_category_0' then 'miniCS验证'
when 'cheat_reason_category_1' then '没有电话联系'
when 'cheat_reason_category_2' then '没有通话时长'
when 'cheat_reason_category_3' then '打电话少于2次'
when 'cheat_reason_category_4' then '打电话间隔小于1小时'
when 'cheat_reason_category_5' then '振铃小于5秒'
end as  '虚假理由',

case `cheat_evidence_category`
when 40 then '客户不在家/电话无人接听'
when 14 then '客户改约时间'
when 17 then '收件人拒收'
when 23 then '收件人/地址不清晰或不正确'
when 24 then '收件地址已关闭营业(企业)'
when 25 then '收件人电话号码错误/电话号码不存在'
when 27 then '无实际包裹'
when 28 then '已妥投未交接'
end as '虚假原因'

FROM `cheat_info` 
WHERE  `state` =1 and  `cheat_result_category`=0 
and   `cheat_reason_category` ='cheat_reason_category_0'
-- and `created_at`>='2019-07-01' and `created_at`<='2019-07-31'
and `cheat_at`>='2019-08-01' and `cheat_at`<='2019-08-31'


---02称重不准-------------

SELECT * FROM `bi_production`.`abnormal_message` WHERE  `punish_category` =10





---玉莹导数-快递员回款-------

-----按人天汇总-------------------------

SELECT srbd.`business_date`as '业务日期' , (SUM(`receivable_amount`)/100) as '应收金额',
case srbd.`state`
when 0 then '未结清'
end as '回款状态',
srbd.`staff_info_id` as '工号', srbd.`staff_info_name`as '姓名' ,srbd.`store_id` as '网点id',ss.`name` '网点名',
case si.`state`
when 1 then '在职'
when 2 then '离职'
else '停职'
end as '在职状态'

FROM `fle_staging`.`store_receivable_bill_detail` srbd
LEFT JOIN `staff_info` si on srbd.`staff_info_id` =si.`id` 
LEFT JOIN `sys_store` ss on srbd.`store_id` =ss.`id` 
WHERE srbd.`business_date` <'2019-09-08' and srbd.`state` =0
GROUP BY srbd.`staff_info_id`,srbd.`business_date`
ORDER BY srbd.`business_date` desc



---明细-------------------------
SELECT srbd.`business_date`as '业务日期' ,srbd.`pno` as '运单号/订单号', ((`receivable_amount`)/100) as '应收金额',
CASE srbd.`receivable_type_category` 
when 1	then '揽件'
when 2	then '揽件抹零'
when 3	then '派件'
when 4	then '派件抹零'
when 5	then 'COD'
when 6	then '包材销售'
when 7	then 'COD调账'
when 8	then 'COD 手续费增值税'
when null then  '无类型标记'
end as '回款类型', 


case srbd.`state`
when 0 then '未结清'
end as '回款状态',
srbd.`staff_info_id` as '工号', srbd.`staff_info_name`as '姓名' ,srbd.`store_id` as '网点id',ss.`name` '网点名',
case si.`state`
when 1 then '在职'
when 2 then '离职'
else '停职'
end as '在职状态'

FROM `fle_staging`.`store_receivable_bill_detail` srbd
LEFT JOIN `staff_info` si on srbd.`staff_info_id` =si.`id` 
LEFT JOIN `sys_store` ss on srbd.`store_id` =ss.`id` 
WHERE srbd.`business_date` <'2019-09-08' and srbd.`state` =0 
ORDER BY srbd.`business_date` DESC 

-----------------------
---SHOP&U-project每天有效揽件量

SELECT DATE(CONVERT_TZ(pi.`created_at`, '+00:00','+07:00')),pi.`ticket_pickup_store_id`,ss.`name` ,COUNT(pi.`pno`) 
from `parcel_info` pi LEFT JOIN `sys_store` ss on pi.`ticket_pickup_store_id` =ss.`id` 

WHERE DATE(CONVERT_TZ(pi.`created_at`, '+00:00','+07:00'))>='2019-09-02' and DATE(CONVERT_TZ(pi.`created_at`, '+00:00','+07:00'))<='2019-09-07' and ss.`category` in (4,7) 
and pi.returned = 0
and pi.`parcel_category`  = 1 and pi.`state` != 9 

GROUP BY ss.`name` ,DATE(CONVERT_TZ(pi.`created_at`, '+00:00','+07:00'))
ORDER BY ss.`name` ,DATE(CONVERT_TZ(pi.`created_at`, '+00:00','+07:00'))



----
SELECT DATE(CONVERT_TZ(pi.`finished_at`, '+00:00','+07:00')) as '妥投日期',pi.`pno`,((srbd.`receivable_amount`)/100) as '应收金额' ,
CASE srbd.`receivable_type_category` 
when 1	then '揽件'
when 2	then '揽件抹零'
when 3	then '派件'
when 4	then '派件抹零'
when 5	then 'COD'
when 6	then '包材销售'
when 7	then 'COD调账'
when 8	then 'COD 手续费增值税'
when null then  '无类型标记'
end as '回款类型',
case srbd.`state`
when 0 then '未结清'
when 1 then '已结清'
when 2 then '已取消'
end as '回款状态',
pi.`ticket_delivery_staff_info_id` as '快递员工号',si.`name` as '快递员姓名',
case si.`state`
when 1 then '在职'
when 2 then '离职'
else '停职'
end as '在职状态',
pi.`ticket_delivery_store_id` as '派件网点'
from `parcel_info` pi 
LEFT JOIN  `store_receivable_bill_detail`  srbd on pi.`pno` =srbd.`pno` 
LEFT JOIN `staff_info` si on pi.`ticket_delivery_staff_info_id` =si.`id` 
WHERE pi.`ticket_delivery_store_id` ='TH01080102' and DATE(CONVERT_TZ(pi.`finished_at`, '+00:00','+07:00'))<='2019-09-07'
and pi.`settlement_category` =1 and pi.`settlement_type` =2
ORDER BY DATE(CONVERT_TZ(pi.`finished_at`, '+00:00','+07:00')) DESC 

------
SELECT DATE(CONVERT_TZ(pi.`finished_at`, '+00:00','+07:00')) as '妥投日期',pi.`pno`,((pi.`store_total_amount`+pi.`cod_amount` )/100) as '应收金额' ,
pi.`ticket_delivery_staff_info_id` as '快递员工号',si.`name` as '快递员姓名',
case si.`state`
when 1 then '在职'
when 2 then '离职'
else '停职'
end as '在职状态',
pi.`ticket_delivery_store_id` as '派件网点'
from `parcel_info` pi 
LEFT JOIN `staff_info` si on pi.`ticket_delivery_staff_info_id` =si.`id` 
WHERE pi.`ticket_delivery_store_id` ='TH01080102' and DATE(CONVERT_TZ(pi.`finished_at`, '+00:00','+07:00'))<='2019-09-07'
and pi.`settlement_category` =1 and `returned`=0
-- and pi.`settlement_type` =2
ORDER BY DATE(CONVERT_TZ(pi.`finished_at`, '+00:00','+07:00')) DESC 

----某个具体工号的原始出勤---------
SELECT `staff_info_id`,`organization_id` ,`attendance_date`,`shift_start` ,`shift_end`,CONVERT_TZ(`started_at`, '+00:00','+07:00') as '上班打卡时间',CONVERT_TZ(`end_at`, '+00:00','+07:00') as '下班打卡时间'
from `staff_work_attendance` 
WHERE `staff_info_id` =22711 and `attendance_date` >'2019-08-31'
ORDER BY `attendance_date`



---指定工号一周揽件------------------
SELECT `ticket_pickup_staff_info_id`as staffid ,COUNT(`pno`) as count
FROM `parcel_info`
WHERE `ticket_pickup_staff_info_id`
IN
(
16913,16915,19077,19383,19860,21643,22291,22323,22831,23192,23201,23339,23797,24255,25055,25095,27723,28689,31959,32431,32490
)

and `created_at` >'2019-09-02 17:00:00' and `created_at` <'2019-09-08 17:00:00'

GROUP BY `ticket_pickup_staff_info_id`

---指定工号一周派件------------------
SELECT `ticket_delivery_staff_info_id` as staffid ,COUNT(`pno`) as count
FROM `parcel_info`
WHERE `ticket_delivery_staff_info_id` 
IN
(
16913,16915,19077,19383,19860,21643,22291,22323,22831,23192,23201,23339,23797,24255,25055,25095,27723,28689,31959,32431,32490
)

and `finished_at`  >'2019-09-02 17:00:00' and `finished_at`  <'2019-09-08 17:00:00'

GROUP BY `ticket_delivery_staff_info_id`


---指定工号一周出勤------------------

SELECT `staff_info_id`,COUNT(IF(`attendance_time`!=0,true,null))
FROM `attendance_data_v2`
WHERE `staff_info_id` IN 
(
16913,16915,19077,19383,19860,21643,22291,22323,22831,23192,23201,23339,23797,24255,25055,25095,27723,28689,31959,32431,32490
)

and `stat_date`>='2019-09-02' and `stat_date`  <='2019-09-08'
GROUP BY `staff_info_id`
-----

SELECT hoo.`id` ,hoo.`serial_no` ,hoo.`staff_info_id` ,hjt.`job_name` ,sd.`name` ,ss.`id` ,ss.`name` ,hoo.`employment_date` ,hoo.`employment_days` ,hoo.`effective_date` ,hoo.`invalid_date`,hoo.`shift_id` ,hoo.`final_audit_num` ,hoo.`status` ,hoo.`created_at` 
FROM `hr_outsourcing_order` hoo
LEFT JOIN `hr_job_title` hjt on hoo.`job_id` =hjt.`id`
LEFT JOIN `sys_department` sd on hoo.`department_id` =sd.`id` 
LEFT JOIN `sys_store` ss on hoo.`store_id` =ss.`id`

---外协申请情况--------------------------------
SELECT hoo.`id` ,hoo.`serial_no` ,hoo.`staff_info_id`AS 'applicant_id',hoo.`final_audit_num`as '批准人数' ,hjt.`job_name` ,sd.`name` ,ss.`id` ,ss.`name` ,hoo.`employment_date` ,hoo.`employment_days` ,hoo.`shift_id` ,hoo.`created_at` 
FROM `hr_outsourcing_order` hoo
LEFT JOIN `hr_job_title` hjt on hoo.`job_id` =hjt.`id`
LEFT JOIN `sys_department` sd on hoo.`department_id` =sd.`id` 
LEFT JOIN `sys_store` ss on hoo.`store_id` =ss.`id`
WHERE hoo.`employment_date`>='2019-10-13'

---三段码---------------
SELECT pi.pno '运单号（pno）', 
CASE ss.`generate_district_code` 
        when 0 THEN CASE   ss. `province_code` 
                        when 'TH01'  THEN IFNULL ((SELECT `sorting_code`  FROM `sys_three_sorting` sts where sts.zoning_basis_code = pi.`dst_district_code` and  sts.store_id = pi.`dst_store_id` and sts.deleted=0 ),'00')
                        when 'TH02'  THEN IFNULL ((SELECT `sorting_code`  FROM `sys_three_sorting` sts where sts.zoning_basis_code = pi.`dst_district_code` and  sts.store_id = pi.`dst_store_id` and sts.deleted=0 ),'00')
                        when 'TH03'  THEN IFNULL ((SELECT `sorting_code`  FROM `sys_three_sorting` sts where sts.zoning_basis_code = pi.`dst_district_code` and  sts.store_id = pi.`dst_store_id` and sts.deleted=0 ),'00')
                        when 'TH04'  THEN IFNULL ((SELECT `sorting_code`  FROM `sys_three_sorting` sts where sts.zoning_basis_code = pi.`dst_district_code` and  sts.store_id = pi.`dst_store_id` and sts.deleted=0 ),'00')
                        ELSE   IFNULL ((SELECT `sorting_code`  FROM `sys_three_sorting` sts where sts.zoning_basis_code = pi.`dst_postal_code` and  sts.store_id = pi.`dst_store_id` and sts.deleted=0 ),'00') END
    when 1  THEN IFNULL ((SELECT  sst.`sorting_code`  FROM `sys_three_sorting` sst where sst.zoning_basis_code = pi.`dst_district_code`  and sst.store_id = pi.`dst_store_id` and  sst.deleted=0),'00')
END  as '面单第三段码',
CASE  ss.`generate_district_code` 
  when 0 THEN CASE   ss. `province_code` 
                        when 'TH01'  THEN '按乡'
                        when 'TH02'  THEN  '按乡'
                        when 'TH03'  THEN  '按乡'
                        when 'TH04'  THEN  '按乡'
                        ELSE   '按邮编' END
   when 1 THEN '按乡'
end as '三段码类型' ,
(SELECT COUNT(*) FROM sys_three_sorting where store_id = pi.`dst_store_id` and  deleted=0)as '目的地网点的三段码数量',
pi.`dst_store_id` '目的地网点ID（dst_store_id）',
pi.`dst_district_code`  '目的地的第三级行政区id（dst_district_code）',
pi.`dst_postal_code`  '目的地的邮编（dst_postal_code）',
pi.`dst_detail_address`  '收件人地址（dst_detail_address）',
CASE  pi.`channel_category`  
  when 3 THEN '是'
  else  '否'
end as  '该运单的发件人是否是API接口客户'
FROM parcel_info pi
LEFT JOIN `sys_store` ss on ss.`id`  = pi.dst_store_id
WHERE   ss.`category` =1 and  pi.`created_at`>=CONVERT_TZ('2019-08-14 00:00:00',  '+00:00', '-07:00')
and pi.`created_at`<=CONVERT_TZ('2019-08-14 23:59:59',  '+00:00', '-07:00');

----梦雨大客户	----------------------
SELECT pi.client_id,ki.`name` ,ki.`mobile` ,pi.`ticket_pickup_store_id`,ss.`name` ,COUNT(pi.`pno`) 
from `parcel_info` pi 
LEFT JOIN `sys_store` ss on pi.`ticket_pickup_store_id` =ss.`id` 
LEFT JOIN `ka_info` ki on pi.`client_id` =ki.`ka_id` 


WHERE 
-- DATE(CONVERT_TZ(pi.`created_at`, '+00:00','+07:00'))>='2019-09-02' and 
DATE(CONVERT_TZ(pi.`created_at`, '+00:00','+07:00'))<='2019-06-15' 
and ss.`category` in (4,7) 
and pi.`customer_type_category` = 2
and pi.returned = 0
and pi.`parcel_category`  = 1 
and pi.`state` != 9
and (pi.`client_id` NOT IN 
(
SELECT DISTINCT `client_id`
from `parcel_info` 
WHERE `created_at`>'2019-06-15'
    and `client_id` IS NOT NULL ))

GROUP BY ss.`name`，pi.client_id
ORDER BY ss.`name`，pi.client_id


---大客户---------------------------
SELECT pi.client_id,ki.`name` ,ki.`mobile` ,pi.`ticket_pickup_store_id`,ss.`name` ,COUNT(pi.`pno`) 
from `parcel_info` pi 
LEFT JOIN `sys_store` ss on pi.`ticket_pickup_store_id` =ss.`id` 
LEFT JOIN `ka_info` ki on pi.`client_id` =ki.`ka_id` 


WHERE 
-- DATE(CONVERT_TZ(pi.`created_at`, '+00:00','+07:00'))>='2019-09-02' and 
DATE(CONVERT_TZ(pi.`created_at`, '+00:00','+07:00'))<='2019-07-15' 
and ss.`category` in (4,7) 
and pi.`customer_type_category` = 2
and pi.returned = 0
and pi.`parcel_category`  = 1 
and pi.`state` != 9
and (pi.`client_id` NOT IN 
(
SELECT DISTINCT `client_id`
from `parcel_info` 
WHERE `created_at`>'2019-08-15'
    and `client_id` IS NOT NULL ))

GROUP BY ss.`name`，pi.client_id
ORDER BY ss.`name`，pi.client_id

-----ka----------------------------
SELECT pi.client_id,ki.`name` ,ki.`mobile` ,pi.`ticket_pickup_store_id` as '发件网点',ss.`name` ,COUNT(pi.`pno`) as '发货量'
from `parcel_info` pi 
LEFT JOIN `sys_store` ss on pi.`ticket_pickup_store_id` =ss.`id` 
LEFT JOIN `ka_info` ki on pi.`client_id` =ki.`ka_id` 


WHERE 
DATE(CONVERT_TZ(pi.`created_at`, '+00:00','+07:00'))>='2019-10-01' 
and DATE(CONVERT_TZ(pi.`created_at`, '+00:00','+07:00'))<='2019-10-24' 
and ss.`category`=4
and pi.`customer_type_category` = 2
and pi.returned = 0
and pi.`parcel_category`  = 1 
and pi.`state` != 9


GROUP BY ss.`name`，pi.client_id
ORDER BY ss.`name`，pi.client_id


---小c客户-----------------

SELECT ui.`id` ,ss.`name`,pi.`src_name` ,ui.`mobile` ,ui.`created_at` ,COUNT(pi.`pno`)
from `parcel_info` pi 
LEFT JOIN `sys_store` ss on pi.`ticket_pickup_store_id` =ss.`id` 
LEFT JOIN `user_info` ui on pi.`client_id` =ui.`id` 


WHERE 
DATE(CONVERT_TZ(pi.`created_at`, '+00:00','+07:00'))>='2019-09-01' and 
DATE(CONVERT_TZ(pi.`created_at`, '+00:00','+07:00'))<='2019-09-30' 
and ss.`category` in (4,7) 
and pi.`customer_type_category` = 1
and pi.returned = 0
and pi.`parcel_category`  = 1 
and pi.`state` != 9
GROUP BY ui.`id`,ss.`name` 
ORDER BY COUNT(pi.`pno`) DESC 












SELECT pi.client_id,ss.`name`,pi.`src_name` ,ui.`mobile` ,ui.`created_at` ,COUNT(pi.`pno`)
from `parcel_info` pi 
LEFT JOIN `sys_store` ss on pi.`ticket_pickup_store_id` =ss.`id` 
LEFT JOIN `user_info` ui on pi.`client_id` =ui.`id` 


WHERE 
-- DATE(CONVERT_TZ(pi.`created_at`, '+00:00','+07:00'))>='2019-09-02' and 
DATE(CONVERT_TZ(pi.`created_at`, '+00:00','+07:00'))<='2019-09-15' 
and ss.`category` in (4,7) 
and pi.`customer_type_category` = 1
and pi.returned = 0
and pi.`parcel_category`  = 1 
and pi.`state` != 9
and (pi.`client_id` NOT IN 
(
SELECT DISTINCT `client_id`
from `parcel_info` 
WHERE `created_at`>'2019-09-15'
    and `client_id` IS NOT NULL ))

GROUP BY pi.client_id,ss.`name` 
ORDER BY COUNT(pi.`pno`) DESC 




SELECT 
pi.`pno`as '运单号', 
pi.`recent_pno` as '最新运单号',
case pi.`state`
when 1	then	'已揽收'
when 2	then	'运输中'
when 3	then	'派送中'
when 4	then	'已滞留'
when 5	then	'已签收'
when 6	then	'疑难件处理中'
when 7	then	'已退件'
when 8	then	'异常关闭'
when 9	then	'已撤销'
end as '当前状态', pi.`dst_store_id`as '目的地网点id',ss.`name` as '目的地网点名'

from `parcel_info` pi
LEFT JOIN `sys_store` ss on pi.`dst_store_id` =ss.`id` 
WHERE pi.`pno` IN 
('TH71091PEVT2A','TH71091PEVT2A')


-------------------------------
--车线成本情况------------------
SELECT fvp.`id` as '出车凭证编号',CONVERT_TZ(fvp.`created_at`, '+00:00','+07:00') as '打印出车凭证时间',`departure_date`,
fvl.`name` ,fvl.`track`,
case fvl.`mode`
when 1 THEN '常规'
when 2 then '临时'
end as '线路模式',
(fvl.`price`/100) AS 'price'
FROM `fleet_van_proof` fvp 
JOIN `fleet_van_line` fvl on fvp.`van_line_id` =fvl.`id` 
WHERE CONVERT_TZ(fvp.`created_at`, '+00:00','+07:00')>'2019-10-11 00:00:01'
and CONVERT_TZ(fvp.`created_at`, '+00:00','+07:00')<'2019-10-11 23:59:59'

---秦皓---------------
SELECT  date_format(CONVERT_TZ(pi.`created_at` , '+00:00', '+07:00'),'%Y-%m'),ss.`sorting_no` ,SUM(pi.`store_parcel_amount`/100)
FROM `parcel_info` pi 
left JOIN `sys_store` ss on pi.`ticket_pickup_store_id` =ss.`id` 
WHERE pi.`created_at` >'2019-05-31 17:00:00' and pi.`returned` =0
GROUP BY date_format(CONVERT_TZ(pi.`created_at` , '+00:00', '+07:00'),'%Y-%m'),ss.`sorting_no` 
ORDER BY date_format(CONVERT_TZ(pi.`created_at` , '+00:00', '+07:00'),'%Y-%m')


SELECT pi.`pno` as '运单号',ss1.`id` as '揽件网点id' ,ss1.`name` as'揽件网点名',ss1.`sorting_no`as'分区',CONVERT_TZ(pi.`created_at` , '+00:00', '+07:00')as'揽件时间',ss2.`id`as'目的地网点id',ss2.`name`as'目的地网点名',ss2.`sorting_no`'目的网点分区',CONVERT_TZ(pi.`finished_at`  , '+00:00', '+07:00')as '派件时间',pi.`exhibition_weight`/1000 as'重量kg',pi.`exhibition_length`as '长度cm',pi.`exhibition_width`as'宽度cm',pi.`exhibition_height`as '高度cm',pi.`store_parcel_amount`/100 as '运费', pi.`total_amount`/100 as '总费用'
from `parcel_info` pi 
LEFT JOIN `sys_store` ss1 on pi.`ticket_pickup_store_id` =ss1.`id` 
LEFT JOIN `sys_store` ss2 on pi.`dst_store_id` =ss2.`id` 
WHERE pi.`created_at` >'2019-10-04 17:00:00' and pi.`created_at` <'2019-10-14 17:00:00' 



----峰-------------------------------
SELECT pi.`pno` ,CONVERT_TZ(pi.`created_at`,  '+00:00', '+07:00') as 'created_at',CONVERT_TZ(pi.`finished_at`,   '+00:00', '+07:00') as 'finished_at'
FROM `parcel_info` pi
WHERE pi.`created_at` >'2019-10-13 17:00:00' 
and pi.`created_at` <'2019-10-20 17:00:00'
and pi.`client_id` ='AA0306'
ORDER BY pi.`created_at` 


---打卡加坐标-----------------
select `staff_info_id`AS 员工编号,
`attendance_date`as	考勤日期,
CONVERT_TZ(`started_at`, '+00:00', '+07:00')as 上班打卡时间,
`started_store_id`as 上班打卡网点,
 `started_staff_lng` as '上班打卡位置经度',
 `started_staff_lat`as'上班打卡位置的纬度',
CONVERT_TZ(`end_at`, '+00:00', '+07:00')as 下班打卡时间,
`end_store_id`AS 下班打卡网点编号,
`end_staff_lng` as '下班打卡位置的经度',
`end_staff_lat` as '下班打卡位置的纬度'
FROM `staff_work_attendance` 
WHERE `staff_info_id` ="19011"
and `attendance_date`>'2019-07-31'
ORDER BY `attendance_date`


--各网点集包量-----------------
SELECT 
pi.`seal_store_name` as 集包网点名称,date_format(CONVERT_TZ(pi.`seal_at`,  '+00:00', '+07:00'),'%Y-%m-%d') AS 集包日期,count(pi.`pack_no`) as 集包量
FROM `pack_info` pi

WHERE DATE(CONVERT_TZ(pi.`seal_at`, '+00:00', '+07:00'))>= '2019-10-21'
and DATE(CONVERT_TZ(pi.`seal_at`, '+00:00', '+07:00')) <= '2019-10-23'

group by date_format(CONVERT_TZ(pi.`seal_at`,  '+00:00', '+07:00'),'%Y-%m-%d'),pi.`seal_store_name`
ORDER BY pi.`seal_store_name`,date_format(CONVERT_TZ(pi.`seal_at`,  '+00:00', '+07:00'),'%Y-%m-%d')




-----B区域各网点派件量-------------

SELECT ss.`sorting_no` as '区域',ss.`id` ,ss.`name` ,date_format(CONVERT_TZ(pi.`finished_at`,   '+00:00', '+07:00'),'%Y-%m-%d') as '日期',COUNT(*) as '派件量'
from `parcel_info` pi LEFT JOIN `sys_store` ss on pi.`ticket_delivery_store_id` =ss.`id` 
WHERE pi.`finished_at` >'2019-09-30 17:00:00'
and ss.`sorting_no` ='B'
and ss.`category` in (1,2)
GROUP BY pi.`ticket_delivery_store_id`,date_format(CONVERT_TZ(pi.`finished_at`,   '+00:00', '+07:00'),'%Y-%m-%d')
ORDER BY pi.`ticket_delivery_store_id`,date_format(CONVERT_TZ(pi.`finished_at`,   '+00:00', '+07:00'),'%Y-%m-%d')



-----各网点

SELECT hsi.`sys_store_id`  as 所属网点,ss.`name` as 网点名, att.`stat_date` as 统计日期,sum(att.`attendance_time`/10) as 有效出勤时间
from `attendance_data_v2` as att 
LEFT JOIN `hr_staff_info` as hsi on att.staff_info_id =hsi.`staff_info_id`
left join `sys_store` as ss on hsi.`sys_store_id` =ss.`id` 
left join `hr_job_title` as hjt on hsi.`job_title` =hjt.`id` 
where att.stat_date >="2019-10-01"
and ss.`category` in (1,2)
and hsi.`job_title` =13
GROUP BY hsi.`sys_store_id`,att.`stat_date`
ORDER BY hsi.sys_store_id

/*
when 110 then 'Van Courier'
when 13 then 'Bike Courier'
when 111 then 'Warehouse Staff (Sorter) '
*/

-------





----揽件网点，派件网点区域限定-------
SELECT ss1.`sorting_no` as '揽件网点区域',ss1.`name`as '揽件网点名' ,ss2.`sorting_no`as '目的网点区域',count(*) as '件量'
from `parcel_info` pi
LEFT JOIN `sys_store` ss1 on ss1.`id` =pi.`ticket_pickup_store_id` #揽件网点
LEFT JOIN `sys_store` ss2 on ss2.`id` =pi.`ticket_delivery_store_id` #派件网点

WHERE ss1.`sorting_no` in ('NE','N') and ss1.`category` in (1,2)
and   ss2.`sorting_no` in ('NE','N') and ss2.`category` in (1,2)
and pi.`created_at` >'2019-09-30 17:00:00'
and pi.`created_at` <'2019-10-31 17:00:00'
GROUP BY ss1.`id` ,ss2.`sorting_no` 
ORDER BY ss1.`id` 


---分天
SELECT DATE(CONVERT_TZ(pi.created_at,'+00:00','+07:00')) as '日期',ss1.`sorting_no` as '揽件网点区域',ss1.`name`as '揽件网点名' ,ss2.`sorting_no`as '目的网点区域',count(*) as '件量'
from `parcel_info` pi
LEFT JOIN `sys_store` ss1 on ss1.`id` =pi.`ticket_pickup_store_id` #揽件网点
LEFT JOIN `sys_store` ss2 on ss2.`id` =pi.`dst_store_id`  #目的网点

WHERE ss1.`sorting_no` in ('NE','N') and ss1.`category` in (1,2)
and   ss2.`sorting_no` in ('NE','N') and ss2.`category` in (1,2)
and pi.`created_at` >'2019-09-30 17:00:00'
and pi.`created_at` <'2019-10-31 17:00:00'
GROUP BY ss1.`id` ,ss2.`sorting_no`,DATE(CONVERT_TZ(pi.created_at,'+00:00','+07:00'))
ORDER BY ss1.`id` ,DATE(CONVERT_TZ(pi.created_at,'+00:00','+07:00'))

----快递员里程--------
SELECT smr.`store_id`,smr.`staff_info_id`,SUM(`end_kilometres`-`start_kilometres`)/1000
from `staff_mileage_record` smr 
WHERE smr.`store_id` ='TH12010101'
and smr.`mileage_date` <='2019-10-31'
and date_format(`mileage_date`, '%Y-%m')='2019-10'
GROUP BY smr.`staff_info_id`


---小宇------------日期	客户账号	收入	单量
SELECT 
	DATE(CONVERT_TZ(pi.created_at,'+00:00','+07:00')) as '日期',
	pi.`client_id`  as '客户id',
	(SUM(pi. `store_total_amount`)/100) as '总运费',
	COUNT(*) AS '单量'
	FROM parcel_info as pi
	left join sys_store as ss on ss.id = pi.ticket_pickup_store_id
	where pi.created_at between '2019-09-30 17:00:00' and '2019-10-31 17:00:00' 
	and pi.returned = 0
	and pi.`parcel_category`  = 1 and pi.`state` != 9 
	and ss.`category`in (4,7)
group by pi.`client_id`,DATE(CONVERT_TZ(pi.created_at,'+00:00','+07:00'))
ORDER by pi.`client_id`,DATE(CONVERT_TZ(pi.created_at,'+00:00','+07:00'))


#泽铭查手机号数量

SELECT count(DISTINCT  `dst_phone`)
FROM `parcel_info` 
WHERE `created_at` >'2019-09-30 17:00:00' and `created_at` <'2019-10-31 17:00:00'

and `client_id` in 
(SELECT `client_id` from (
SELECT `client_id`,COUNT(*) as columnss
FROM `parcel_info` 
WHERE `created_at` >'2019-09-30 17:00:00' and `created_at` <'2019-10-31 17:00:00'
GROUP BY `client_id` 
HAVING columnss>=10 and columnss<=100
))

and `parcel_category`  = 1 and `state` != 9 
and timestampdiff(hour, created_at, finished_at) <= 24
and `dst_phone` not in (
SELECT `src_phone`
    from `parcel_info` 
)
and `customer_type_category` = 1




#有菜单权限的人员名单

SELECT rsm.`staff_info_id`,hsi.`name` ,hsi.`formal`,hjt.`job_name` ,hsi.`sys_store_id`,hsi.`sys_department_id`,sd.`name` 
from `role_staff_menus` rsm
LEFT JOIN `hr_staff_info` hsi on rsm.`staff_info_id` =hsi.`staff_info_id` 
LEFT JOIN `hr_job_title`  hjt on hsi.`job_title` =hjt.`id` 
LEFT JOIN `sys_department` sd on hsi.`sys_department_id` =sd.`id` 
WHERE rsm.`menu_id`=74




---------------------------------
1. 9月一个月的目的地到件量（平均值）
-----------------------------------
SELECT pr.`store_id`,pr.`store_name`,COUNT(DISTINCT pr.`pno` ) AS 'count' 
FROM `parcel_route` pr
LEFT JOIN `parcel_info` pi on pr.`pno` =pi.`pno` 
where pr.`route_action`  = 'ARRIVAL_WAREHOUSE_SCAN'
and  pr.`store_id`=pi.`dst_store_id` 
and CONVERT_TZ(pr.`routed_at`,'+00:00', '+07:00')>'2019-09-01 00:00:01' 
and CONVERT_TZ(pr.`routed_at`,'+00:00', '+07:00')<'2019-09-30 23:59:59'
GROUP BY pr.`store_id`,pr.`store_name`
ORDER BY  pr.`store_id`




#梦雨要某网点所有客户按天得发货量

SELECT ss.`name` as 'store_name',pi.`client_id` ,DATE(CONVERT_TZ(pi.`created_at`, '+00:00', '+07:00')) as 'date',COUNT(*) as 'volumn'
FROM `parcel_info` pi
LEFT JOIN `sys_store` ss on pi.`ticket_pickup_store_id` =ss.`id` 
WHERE 
CONVERT_TZ(pi.`created_at`, '+00:00', '+07:00')>'2019-09-01 00:00:01' 
and CONVERT_TZ(pi.`created_at`, '+00:00', '+07:00')<'2019-11-07 23:59:59'
and pi.`ticket_pickup_store_id` in ('TH01370202','TH01370203')
and pi.`returned`= 0
and pi.`state` != 9 

GROUP BY ss.`name`,pi.`client_id` ,DATE(CONVERT_TZ(pi.`created_at`, '+00:00', '+07:00'))
ORDER BY DATE(CONVERT_TZ(pi.`created_at`, '+00:00', '+07:00')),ss.`name`






###########花花###############

SELECT ss.`id` ,ss.`name` ,ss.`manager_id`,ss.`manager_name` ,ss.`manager_phone` ,ss.`province_code`,sp.`name` ,ss.`city_code`,sc.`name` ,ss.`district_code`,sd.`name` ,ss.`detail_address`,ss.`lat` ,ss.`lng` 
FROM `sys_store` ss 
LEFT JOIN `sys_province` sp on sp.`code` =ss.`province_code`
LEFT JOIN `sys_city` sc on sc.`code` =ss.`city_code` 
LEFT JOIN `sys_district` sd on sd.`code` =ss.`district_code` 
WHERE ss.`category` in (1,2)