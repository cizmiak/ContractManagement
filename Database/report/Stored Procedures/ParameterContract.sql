CREATE PROCEDURE [report].[ParameterContract]
AS
SELECT
	-1 AS Value,
	' - All - ' AS Label

UNION ALL

SELECT
	[Id],
	[Name]
FROM
	dbo.[Contracts]
ORDER BY
	Label
