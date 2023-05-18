
DECLARE @SearchStr nvarchar(100)
SET @SearchStr = '%erez%' --- please enter the value you want to search
 

    CREATE TABLE #TmpResults (ColumnName nvarchar(370), ColumnValue nvarchar(3630))
 
    SET NOCOUNT ON
 
    DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110)
    SET  @TableName = ''
    SET @SearchStr2 = QUOTENAME('%' + @SearchStr + '%','''')
 
    WHILE @TableName IS NOT NULL
     
    BEGIN
        SET @ColumnName = ''
        SET @TableName = 
        (
            SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
            FROM     INFORMATION_SCHEMA.TABLES
            WHERE         TABLE_TYPE = 'BASE TABLE'
                AND    QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
                AND    OBJECTPROPERTY(
                        OBJECT_ID(
                            QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
                             ), 'IsMSShipped'
                               ) = 0
        )
 
        WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
             
        BEGIN
            SET @ColumnName =
            (
                SELECT MIN(QUOTENAME(COLUMN_NAME))
                FROM     INFORMATION_SCHEMA.COLUMNS
                WHERE         TABLE_SCHEMA    = PARSENAME(@TableName, 2)
                    AND    TABLE_NAME    = PARSENAME(@TableName, 1)
                    AND    DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar', 'int', 'decimal')
                    AND    QUOTENAME(COLUMN_NAME) > @ColumnName
            )
     
            IF @ColumnName IS NOT NULL
             
            BEGIN
                INSERT INTO #TmpResults
                EXEC
                (
                    'SELECT ''' + @TableName + '.' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) FROM ' + @TableName + ' (NOLOCK) ' +
                    ' WHERE ' + @ColumnName + ' LIKE ' + @SearchStr2
                )
            END
        END   
    END
;


with tablea as(
			SELECT distinct columnname as StrungValue,
										PARSENAME(columnname,2) AS TableName,
										PARSENAME(columnname,1) AS ColumnName,
										ColumnValue
										FROM #TmpResults
			 )
select StrungValue,
		TableName,
		ColumnName,
		ColumnValue,
		concat('select * from ', '[',TableName,']', ' where ','[',ColumnName,']', ' = ''',ColumnValue,''';') as QueryToRun
from tablea;


DROP TABLE #TmpResults;

