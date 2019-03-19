CREATE PROCEDURE [report].[Task]
(
	@From DATETIME = NULL,
	@To DATETIME = NULL,
	@TypID VARCHAR(MAX) = NULL,
	@StavID VARCHAR(MAX) = NULL,
	@ZmluvaID VARCHAR(MAX) = NULL,
	@RiesitelID VARCHAR(MAX) = NULL,
	@OrganizaciaID VARCHAR(MAX) = NULL,
	@GroupBy1 VARCHAR(20) = NULL,
	@GroupBy2 VARCHAR(20) = NULL
)
AS

--DECLARE
--	@From DATETIME = '2009-03-14',
--	@To DATETIME = '2012-04-21',
--	@TypID VARCHAR(MAX) = '-1',
--	@StavID VARCHAR(MAX) = '-1',
--	@ZmluvaID VARCHAR(MAX) = '-1',
--	@RiesitelID VARCHAR(MAX) = '-1',
--	@OrganizaciaID VARCHAR(MAX) = '-1',
--	@GroupBy1 VARCHAR(20) = 'Month',
--	@GroupBy2 VARCHAR(20) = 'Day'

SET DATEFIRST 1

SELECT
	u.[Id],
	u.[Name]	AS Nazov,
	u.[TaskTypeId],
	ut.[Name] AS Typ,
	u.[TaskStateId],
	us.[Name] AS Stav,
	u.[Description] AS Popis,
	u.Deadline,
	CASE
		WHEN @GroupBy1 = 'Day' THEN ISNULL(CONVERT(VARCHAR(10), u.Deadline, 104), '-')
		WHEN @GroupBy1 = 'Week'
			THEN 
				ISNULL(CAST(YEAR(u.Deadline) AS VARCHAR(4)), '-') + 
				'/' +
				ISNULL(CAST(DATEPART(WEEK, u.Deadline) AS VARCHAR(2)), '-')
		WHEN @GroupBy1 = 'Month'
			THEN 
				ISNULL(CAST(YEAR(u.Deadline) AS VARCHAR(4)), '-') + 
				'/' +
				ISNULL(CAST(MONTH(u.Deadline) AS VARCHAR(2)), '-')
		WHEN @GroupBy1 = 'Year' THEN ISNULL(CAST(YEAR(u.Deadline) AS VARCHAR(4)), '-')
	END AS GroupBy1Interval,
	CASE
		WHEN @GroupBy2 = 'Day' THEN ISNULL(CONVERT(VARCHAR(10), u.Deadline, 104), '-')
		WHEN @GroupBy2 = 'Week'
			THEN 
				ISNULL(CAST(YEAR(u.Deadline) AS VARCHAR(4)), '-') + 
				'/' +
				ISNULL(CAST(DATEPART(WEEK, u.Deadline) AS VARCHAR(2)), '-')
		WHEN @GroupBy2 = 'Month'
			THEN 
				ISNULL(CAST(YEAR(u.Deadline) AS VARCHAR(4)), '-') + 
				'/' +
				ISNULL(CAST(MONTH(u.Deadline) AS VARCHAR(2)), '-')
		WHEN @GroupBy2 = 'Year' THEN ISNULL(CAST(YEAR(u.Deadline) AS VARCHAR(4)), '-')
	END AS GroupBy2Interval,
	
	CASE
		WHEN @GroupBy1 = 'Day'   THEN CAST(FLOOR(CAST(u.Deadline AS FLOAT)) AS DATETIME)
		WHEN @GroupBy1 = 'Week'  THEN DATEADD(WEEK, DATEPART(WEEK, u.Deadline) - 1, CAST(YEAR(u.Deadline) AS VARCHAR(4)))
		WHEN @GroupBy1 = 'Month' THEN DATEADD(MONTH, DATEPART(MONTH, u.Deadline) - 1, CAST(YEAR(u.Deadline) AS VARCHAR(4)))
		WHEN @GroupBy1 = 'Year'  THEN CAST(CAST(YEAR(u.Deadline) AS VARCHAR(4)) AS DATETIME)
	END AS GroupBy1IntervalDateTime,
	CASE
		WHEN @GroupBy2 = 'Day'   THEN CAST(FLOOR(CAST(u.Deadline AS FLOAT)) AS DATETIME)
		WHEN @GroupBy2 = 'Week'  THEN DATEADD(WEEK, DATEPART(WEEK, u.Deadline) - 1, CAST(YEAR(u.Deadline) AS VARCHAR(4)))
		WHEN @GroupBy2 = 'Month' THEN DATEADD(MONTH, DATEPART(MONTH, u.Deadline) - 1, CAST(YEAR(u.Deadline) AS VARCHAR(4)))
		WHEN @GroupBy2 = 'Year'  THEN CAST(CAST(YEAR(u.Deadline) AS VARCHAR(4)) AS DATETIME)
	END AS GroupBy2IntervalDateTime,

	u.[PlannedDate],
	u.[ContractId],
	z.[Name] AS Zmluva,
	z.[OrganizationId],
	o.[Name] AS Organizacia,
	zam.Email,
	FLOOR(CAST(u.Deadline AS FLOAT)) - FLOOR(CAST(GETDATE() AS FLOAT)) AS DeadlineDiff,
	u.[SolverEmployeeId] AS RiesitelID,
	ISNULL(zam.[FirstName] + ' ', '') + ISNULL(zam.[LastName], '') AS Riesitel
FROM
	dbo.[Tasks] u
	LEFT JOIN [TaskTypes] ut
		ON ut.[Id] = u.[TaskTypeId]
	LEFT JOIN [TaskStates] us
		ON us.[Id] = u.[TaskStateId]
	LEFT JOIN dbo.[Contracts] z
		ON z.[Id] = u.[ContractId]
	LEFT JOIN dbo.[Organizations] o
		ON o.Id = z.[OrganizationId]
	LEFT JOIN dbo.[Employees] zam
		ON zam.[Id] = u.[SolverEmployeeId]
	LEFT JOIN dbo.[Employees] zod
		ON zod.[Id] = z.[ResponsibleEmployeeId]
WHERE
	(
		u.Deadline >= @From
		AND
		u.Deadline < @To
		OR
		u.Deadline IS NULL
	)
	AND
	(
		u.[TaskTypeId] IN (SELECT Item FROM report.TableFromList(',',@TypID))
		OR
		@TypID LIKE '%-1%'
	)
	AND
	(
		u.[TaskStateId] IN (SELECT Item FROM report.TableFromList(',',@StavID))
		OR
		@StavID LIKE '%-1%'
	)
	AND
	(
		u.[ContractId] IN (SELECT Item FROM report.TableFromList(',',@ZmluvaID))
		OR
		@ZmluvaID LIKE '%-1%'
	)
	AND
	(
		u.[SolverEmployeeId] IN (SELECT Item FROM report.TableFromList(',',@RiesitelID))
		OR
		@RiesitelID LIKE '%-1%'
	)
	AND
	(
		z.[OrganizationId] IN (SELECT Item FROM report.TableFromList(',',@OrganizaciaID))
		OR
		@OrganizaciaID LIKE '%-1%'
	)