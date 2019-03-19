CREATE PROCEDURE [report].[ParameterTaskState]
AS
SELECT
	-1 AS Value,
	' - All - ' AS Label

UNION ALL

SELECT
	[Id],
	[Name]
FROM
	[TaskStates]
