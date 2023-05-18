SELECT
j.[name] as 'SQL Agent Job Name',
s.database_name ,
case
when j.enabled = 1 then 'Active'
when j.enabled = 0 then 'Not-Active'
else null
end as 'JOB_IS_ACTIVE?',
case 
when s.database_name in (SELECT name FROM dbo.sysdatabases) then 'DB EXIST'
else 'DB not exsist'
end as 'DB exist?'
FROM   msdb.dbo.sysjobsteps AS s
INNER JOIN msdb.dbo.sysjobs AS j ON  s.job_id = j.job_id
order by 1 ;