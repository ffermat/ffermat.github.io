SELECT 
  plr.`id`,
  plr.`staff_id`,
  plr.`store_id`,
  plr.`lose_task_id`,
  plr.`responsible_type`,
  plr.`duty_ratio`,
  plr.`created_at`,
  plt.`penalties` 
from `parcel_lose_responsible` plr
LEFT JOIN `parcel_lose_task` plt on plr.`lose_task_id`=plt.`id` 
WHERE plr.`created_at`>'2019-10-01 00:00:01'
and plr.`created_at` <'2019-10-31 23:59:59'
and plr.`lose_task_id` in (
40533,44317,38386,38387,40530,39118,40485,21262,44294,40865,42018,41467,42376,42365,40435,40931,41485,42047,42596,40933,41401,40281,39255,40735,40607,40421,39113,41515,41505,39433,43854,42420,39434,41404,15132,41407,40294,21910,41481,44772,41392,41395,40437,43382)





##########升级版######################
SELECT 
  plr.`id`,
  plr.`staff_id`,
  plr.`store_id`,
  plr.`lose_task_id`,
  plr.`responsible_type`,
  plr.`duty_ratio`,
  plr.`created_at`,
  plt.`penalties` as total_penalties,
(plr.`duty_ratio`/100)*(plt.`penalties`) as penalties
from `parcel_lose_responsible` plr
LEFT JOIN `parcel_lose_task` plt on plr.`lose_task_id`=plt.`id` 

INNER JOIN 
(
SELECT `lose_task_id`,date_format(MAX(`created_at` ),'%Y-%m-%d %H') as shijian
from `parcel_lose_responsible` 
GROUP BY `lose_task_id`
) r 
on r.`lose_task_id`=plr.`lose_task_id`  and r.shijian=date_format(plr.`created_at` ,'%Y-%m-%d %H')



WHERE plr.`created_at`>'2019-10-01 00:00:01'
and plr.`created_at` <'2019-10-31 23:59:59'
and plr.`lose_task_id`!=40533