CREATE PROCEDURE [dbo].[TaskNotification]
AS
DECLARE
	@Nazov VARCHAR(100),
	@Typ VARCHAR(100),
	@Popis VARCHAR(100),
	@Deadline VARCHAR(100),
	@Plan VARCHAR(100),
	@Zmluva VARCHAR(100),
	@Organizacia VARCHAR(100),
	@Email VARCHAR(100),
	@DeadlineDiff VARCHAR(100),
	@Zamestnanec VARCHAR(100),
	@body VARCHAR(MAX)

DECLARE cur CURSOR FOR
SELECT
	ISNULL(u.[Name], '') AS Nazov,
	ISNULL(ut.[Name], '') AS Typ,
	ISNULL(u.[Description], '') AS Popis,
	--ISNULL(u.Deadline, '') AS Deadline,
	--ISNULL(u.[Plan], '') AS [Plan],
	ISNULL(CONVERT(VARCHAR(25), u.Deadline, 104) + ' ' + CONVERT(VARCHAR(25), u.Deadline, 108), '') AS Deadline,
	ISNULL(CONVERT(VARCHAR(25), u.[PlannedDate], 104) + ' ' + CONVERT(VARCHAR(25), u.[PlannedDate], 108), '') AS [Plan],
	ISNULL(z.[Name], '') AS Zmluva,
	ISNULL(o.[Name], '') AS Organizacia,
	COALESCE(zam.Email, zod.Email, 'miroslav.hanzen@gmail.com') AS Email,
	ISNULL(CAST(CAST(u.Deadline - FLOOR(CAST(GETDATE() AS FLOAT)) AS INT) AS VARCHAR(20)), 'xy') AS DeadlineDiff,
	ISNULL(zam.[FirstName] + ' ', '') + ISNULL(zam.[LastName], '') AS Zamestnanec
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
		AND
		zam.[EmployeeStateId] != 2
	LEFT JOIN dbo.[Employees] zod
		ON zod.[Id] = z.[ResponsibleEmployeeId]
WHERE
	ISNULL(u.[TaskStateId], 0) != 2 -- nie je vyriesene
	AND
	(
		FLOOR(CAST(u.Deadline AS FLOAT)) - FLOOR(CAST(GETDATE() AS FLOAT)) IN (ut.[Notification1st],ut.[Notification2nd],ut.[Notification3rd])
		OR
		ISNULL(u.Deadline, GETDATE()) <= GETDATE() + 7
		AND
		DATEPART(DW, GETDATE()) = 2
	)	
	--AND
	--zam.Email like 'miro%'
	
OPEN cur

FETCH NEXT FROM cur INTO
	@Nazov ,
	@Typ ,
	@Popis ,
	@Deadline ,
	@Plan ,
	@Zmluva ,
	@Organizacia ,
	@Email ,
	@DeadlineDiff,
	@Zamestnanec


WHILE @@FETCH_STATUS = 0
BEGIN

SET @body = @Zamestnanec + ',
nasledujuca uloha ma prekroceny deadline, alebo ma deadline do ' + @DeadlineDiff + ' dni:
' --+ CHAR(13) + CHAR(10)

SELECT
	@body = @body + '
Nazov: ' + @Nazov + '
Typ: ' + @Typ + '
Popis: ' + @Popis + '
Deadline: ' + @Deadline + '
Plan: ' + @Plan + '
Zmluva: ' + @Zmluva + '
Organizacia: ' + @Organizacia		

EXEC msdb.dbo.sp_send_dbmail
@recipients = @Email,
@subject = 'skolboz notifikacia deadline ulohy',
@body = @body

--PRINT @body

FETCH NEXT FROM cur INTO
	@Nazov ,
	@Typ ,
	@Popis ,
	@Deadline ,
	@Plan ,
	@Zmluva ,
	@Organizacia ,
	@Email,
	@DeadlineDiff,
	@Zamestnanec
END

CLOSE cur
DEALLOCATE cur
