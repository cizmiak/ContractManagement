CREATE PROCEDURE [report].[ParameterOrganization]
AS
SELECT
	-1 AS Value,
	' - All - ' AS Label

UNION ALL

SELECT
	Id,
	[Name]
FROM
	[Organizations]
ORDER BY
	Label
