select
o.long_name as organization, p.name as project, 
left(u.email, instr(u.email, '@')-1) as manager, 
p.active as is_active,
date(min(ts.created_at)) as start_date, date(max(ts.created_at)) as end_date,
round(sum(ts.duration)/60, 2) as total_recorded_hours,

round(sum(case when ts.user_id = 8 then ts.duration else 0 end)/60, 2) as 'anano',
round(sum(case when ts.user_id = 16 then ts.duration else 0 end)/60, 2) as 'anna',
round(sum(case when ts.user_id = 7 then ts.duration else 0 end)/60, 2) as 'anton',
round(sum(case when ts.user_id = 15 then ts.duration else 0 end)/60, 2) as 'demetre',
round(sum(case when ts.user_id = 20 then ts.duration else 0 end)/60, 2) as 'gurika',
round(sum(case when ts.user_id = 10 then ts.duration else 0 end)/60, 2) as 'ia',
round(sum(case when ts.user_id = 9 then ts.duration else 0 end)/60, 2) as 'irakli',
round(sum(case when ts.user_id = 1 then ts.duration else 0 end)/60, 2) as 'jason',
round(sum(case when ts.user_id = 2 then ts.duration else 0 end)/60, 2) as 'keti',
round(sum(case when ts.user_id = 21 then ts.duration else 0 end)/60, 2) as 'lali',
round(sum(case when ts.user_id = 18 then ts.duration else 0 end)/60, 2) as 'm.kobuladze',
round(sum(case when ts.user_id = 13 then ts.duration else 0 end)/60, 2) as 'maiko',
round(sum(case when ts.user_id = 12 then ts.duration else 0 end)/60, 2) as 'mariam',
round(sum(case when ts.user_id = 14 then ts.duration else 0 end)/60, 2) as 'nick',
round(sum(case when ts.user_id = 22 then ts.duration else 0 end)/60, 2) as 'nika.tomadze',
round(sum(case when ts.user_id = 3 then ts.duration else 0 end)/60, 2) as 'nino',
round(sum(case when ts.user_id = 6 then ts.duration else 0 end)/60, 2) as 'pepanashvili.meko',
round(sum(case when ts.user_id = 11 then ts.duration else 0 end)/60, 2) as 'qristina',
round(sum(case when ts.user_id = 19 then ts.duration else 0 end)/60, 2) as 'salome',
round(sum(case when ts.user_id = 4 then ts.duration else 0 end)/60, 2) as 'teona'



from projects as p
inner join organizations as o on o.id = p.organization_id
inner join activities as a on a.project_id = p.id
inner join timestamps as ts on ts.activity_id = a.id
inner join users as u on u.id = p.manager_id
group by o.long_name, p.name
order by o.long_name, p.name