
DECLARE @TableName nvarchar(100)
SET @TableName = '%TableName%' ---- or part of the name


SELECT
    fk.name 'FK Name',
    tp.name 'Parent table',
    cp.name as 'Parent col name', 
    cp.column_id as 'Parent col order #',
    tr.name 'Refrenced table',
    cr.name as 'Refrenced col name', 
    cr.column_id as 'Refrenced col order #'
FROM 
    sys.foreign_keys fk
INNER JOIN 
    sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN 
    sys.tables tr ON fk.referenced_object_id = tr.object_id
INNER JOIN 
    sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
INNER JOIN 
    sys.columns cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
INNER JOIN 
    sys.columns cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id
WHERE tp.name like @TableName or tr.name like  @TableName
ORDER BY 2,5;
