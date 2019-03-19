CREATE PROCEDURE [report].[ParameterGroup]
AS
SELECT
	'Day' AS Value,
	'Den' AS Label,
	0 AS Ord

UNION ALL

SELECT
	'Week' AS Value,
	'Tyzden' AS Label,
	1 AS Ord

UNION ALL

SELECT
	'Month' AS Value,
	'Mesiac' AS Label,
	2 AS Ord

UNION ALL

SELECT
	'Year' AS Value,
	'Rok' AS Label,
	3 AS Ord

UNION ALL

SELECT
	'Riesitel' AS Value,
	'Riesitel' AS Label,
	4 AS Ord

UNION ALL

SELECT
	'Zmluva' AS Value,
	'Zmluva' AS Label,
	5 AS Ord

UNION ALL

SELECT
	'Organizacia' AS Value,
	'Organizacia' AS Label,
	6 AS Ord
