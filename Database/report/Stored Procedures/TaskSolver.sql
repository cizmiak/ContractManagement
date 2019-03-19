CREATE PROCEDURE [report].[TaskSolver]
AS
SELECT
	u.[Id],
	u.[Name]	AS Nazov,
	u.[TaskTypeId],
	ut.[Name] AS Typ,
	u.[Description] AS Popis,
	u.Deadline,
	YEAR(u.Deadline) AS DeadlineYear,
	MONTH(u.Deadline) AS DeadlineMonth,
	DATEPART(WEEK, u.Deadline) AS DeadlineWeek,
	CAST(FLOOR(CAST(u.Deadline AS FLOAT)) AS DATETIME) AS DeadlineDay,
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
	LEFT JOIN dbo.[Contracts] z
		ON z.[Id] = u.[ContractId]
	LEFT JOIN dbo.[Organizations] o
		ON o.Id = z.[OrganizationId]
	LEFT JOIN dbo.[Employees] zam
		ON zam.[Id] = u.[SolverEmployeeId]
	LEFT JOIN dbo.[Employees] zod
		ON zod.[Id] = z.[ResponsibleEmployeeId]
--WHERE
	--ISNULL(u.StavID, 0) != 2 -- nie je vyriesene
	--AND
	--(
	--	FLOOR(CAST(u.Deadline AS FLOAT)) - FLOOR(CAST(GETDATE() AS FLOAT)) IN (ut.Notifikacia1,ut.Notifikacia2,ut.Notifikacia3)
	--	OR
	--	ISNULL(u.Deadline, GETDATE()) <= GETDATE() + 7
	--	AND
	--	DATEPART(DW, GETDATE()) = 2
	--)
	--u.Deadline IS NOT NULL
