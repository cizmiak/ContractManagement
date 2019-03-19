CREATE PROCEDURE [report].[ParameterTaskType]
AS
SELECT
	-1 AS Value,
	' - All - ' AS Label

UNION ALL

SELECT
	[Id],
	[Name]
FROM
	[TaskTypes]
