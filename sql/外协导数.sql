SELECT `id` ,`staff_id` as 'applicant' ,
`store_id` ,
case `job_id` 
when 110 then 'Van Courier'
when 13 then 'Bike Courier'
when 111 then 'Warehouse Staff (Sorter) '
when 271 then 'Hub Staff'
else 'Boat Courier'
end as 'job_title',
`employment_date` ,`employment_days` ,`final_audit_num` ,`shift_id` ,`created_at`
FROM `backyard_pro`.`hr_staff_outsourcing`
WHERE `status` =2
and  `employment_date` >'2019-11-03'

