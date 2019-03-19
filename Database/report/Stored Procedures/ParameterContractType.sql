CREATE PROCEDURE [report].[ParameterContractType]
AS
SELECT
	NULL AS Value,
	' - All -' AS Label

UNION ALL

SELECT
	[Id],
	[Name]
FROM
	dbo.[ContractTypes]
