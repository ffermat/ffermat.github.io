SELECT SUM(IF(`store_keeper_weight`= 0, `exhibition_weight`, `store_keeper_weight`)) /1000 AS weight,-- 包裹实际重量
SUM(IF(`store_keeper_weight`= 0, `exhibition_weight`, `store_weight`)) /1000 AS jifeiweight,-- 包裹计费重量
       COUNT(p.pno) as parcel_count,-- 包裹数
       t2.`departure_date`,-- 计划发车日期
       t3.`name` as line_name,-- 线路名称
       t3.`plate_type`,-- 车辆类型
       t2.`plate_number`,-- 车牌号
       t3.`price`, --  出车成本
       t3.`origin_name`,-- 始发网点
       t3.`target_name` -- 目的网点       
  FROM parcel_info p
  LEFT JOIN fleet_van_proof_parcel_detail t1 ON p.`pno`= t1.`relation_no`
  LEFT JOIN fleet_van_proof t2 ON t1.proof_id= t2.id
  LEFT JOIN fleet_van_line t3 ON t2.van_line_id= t3.id
 where t1.`relation_category` IN(1, 3)
   AND t3.`mode` IN(1, 2)

   and date_format(CONVERT_TZ(t2.departure_time, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s')>'2019-10-30 00:00:01'
   and date_format(CONVERT_TZ(t2.departure_time, '+00:00', '+07:00'),'%Y-%m-%d %H:%i:%s')>'2019-10-30 24:59:59'
 GROUP BY t2.`departure_date`,line_name