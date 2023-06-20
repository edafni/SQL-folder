

declare @tableName varchar(100)
set @tableName = 'TableName'
Select  
TABLE_NAME
, Stuff(
(
Select ',' + C.COLUMN_NAME
From INFORMATION_SCHEMA.COLUMNS As C
Where C.TABLE_SCHEMA = T.TABLE_SCHEMA
    And C.TABLE_NAME = T.TABLE_NAME
Order By C.ORDINAL_POSITION
For Xml Path('')
), 1, 1, '') As Columns
From INFORMATION_SCHEMA.TABLES As T
WHERE T.TABLE_NAME = @tableName;
