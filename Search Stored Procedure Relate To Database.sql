SELECT DISTINCT o.name
FROM syscomments c  
INNER JOIN sysobjects o ON c.id=o.id  
WHERE o.xtype='P'  
and name like '%search%'