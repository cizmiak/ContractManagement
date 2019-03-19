CREATE PROCEDURE [report].[ParameterEmployee]
AS
SELECT
	-1 AS Value,
	' - All - ' AS Label,
	'' AS Priezvisko

UNION ALL

SELECT
	[Id] AS Value,
	ISNULL([FirstName] + ' ', '') + ISNULL([LastName], '') AS Label,
	[LastName]
FROM
	[Employees]
ORDER BY
	Label
