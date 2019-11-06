SELECT COUNT(*)
from `fleet_van_line` fvl
LEFT JOIN `sys_store` ss on fvl.`target_id`  =ss.`id` 
WHERE

--车线未删除
fvl.`deleted` =0

--常规线路或指定日期发车的临时线路
and
(
(fvl.`mode`=1)
or
(fvl.`mode`=2 and fvl.`plan_date`='2019-11-06')
)

--目的网点是1，2，4分类即dc&sp&shop
and 
ss.`category` in (1,2,4)



Create Table `fleet_van_line` (
 `id` varchar COMMENT 'id主键',
 `name` varchar COMMENT '线路名称',
 `track` varchar COMMENT '线路走向',
 `area` smallint COMMENT '区域',
 `sorting_no` varchar COMMENT '分拣大区编号',
 `type` smallint COMMENT '线路类型',
 `mode` smallint COMMENT '线路模式 1:常规模式, 2:临时模式',
 `origin_id` varchar COMMENT '始发网点id',
 `origin_code` varchar COMMENT '始发网点简称',
 `origin_name` varchar COMMENT '始发网点名称',
 `target_id` varchar COMMENT '目的网点id',
 `target_code` varchar COMMENT '目的网点简称',
 `target_name` varchar COMMENT '目的网点名称',
 `start_time` bigint COMMENT '出车时间',
 `end_time` bigint COMMENT '结束时间',
 `plate_id` varchar COMMENT '车牌号id',
 `plate_type` int COMMENT '车型',
 `price` bigint COMMENT '价格',
 `driver` varchar COMMENT '司机姓名',
 `driver_phone` varchar COMMENT '司机电话',
 `period` bigint COMMENT '运行周期(十进制)',
 `plan_date` date COMMENT '临时线路计划出发日期',
 `operator_id` bigint COMMENT '操作人id',
 `operator_name` varchar COMMENT '操作人名称',
 `print` smallint COMMENT '是否已打印',
 `created_at` datetime COMMENT '',
 `updated_at` datetime COMMENT '',
 `deleted` tinyint COMMENT '是否删除(1:是, 0:否)',
 `version` bigint COMMENT '版本号',
 primary key (id)
) DISTRIBUTE BY HASH(`id`) INDEX_ALL='Y'






SELECT fvl. `name`,fvl.`sorting_no`,fvl.`mode`,fvl.`origin_name`,fvl.`target_name`,`end_time`
from `fleet_van_line` fvl
LEFT JOIN `sys_store` ss on fvl.`target_id`  =ss.`id` 
WHERE

--车线未删除
fvl.`deleted` =0

--常规线路或指定日期发车的临时线路
and
(
(fvl.`mode`=1)
or
(fvl.`mode`=2 and fvl.`plan_date`='2019-11-06')
)

--目的网点是1，2，4分类即dc&sp&shop
and 
ss.`category` in (1,2,4)