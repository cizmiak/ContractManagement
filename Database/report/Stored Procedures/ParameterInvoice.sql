
CREATE PROCEDURE report.[ParameterInvoice]
AS
SELECT
	NULL AS Value,
	' - All -' AS Label

UNION ALL

SELECT
	1 AS Value,
	'Len na fakturaciu' AS Label
