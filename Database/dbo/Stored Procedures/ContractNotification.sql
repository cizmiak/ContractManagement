CREATE PROCEDURE [dbo].[ContractNotification]
AS
DECLARE
	@Organizacia VARCHAR(100),
	@CisloZmluvy VARCHAR(100),
	@OrganizaciaPoznamka VARCHAR(MAX),
	@Nazov VARCHAR(100),
	@Typ VARCHAR(100),
	@Stav VARCHAR(100),
	@Ucinnost VARCHAR(100),
	@Pravoplatnost VARCHAR(100),
	@NaDobuUrcitu VARCHAR(100),
	@Ukoncenie VARCHAR(100),
	@Zodpovedny VARCHAR(100),
	@Email VARCHAR(100),
	@DeadlineDiff VARCHAR(100),
	@IsNewAssign BIT,
	@body VARCHAR(MAX),
	@subject VARCHAR(100),
	@Now DATETIME = GETDATE(),
	@DebugMode BIT = 0

IF @DebugMode = 1 SET @Now = '2011-05-01'

DECLARE cur CURSOR FOR
SELECT
	ISNULL(o.[Name], '') AS Organizacia,
	ISNULL(o.[Note], '') AS OrganizaciaPoznamka,
	ISNULL(z.[ContractNumber], '') AS CisloZmluvy,
	ISNULL(z.[Name], '') AS Nazov,
	ISNULL(zt.[Name], '') AS Typ,
	ISNULL(zs.[Name], '') AS Stav,
	ISNULL(CONVERT(VARCHAR(25), z.[ContractEffectiveDate], 104) + ' ' + CONVERT(VARCHAR(25), z.[ContractEffectiveDate], 108), '') AS Ucinnost,
	ISNULL(CONVERT(VARCHAR(25), z.[ContractLegalDate], 104) + ' ' + CONVERT(VARCHAR(25), z.[ContractLegalDate], 108), '') AS Pravoplatnost,
	CASE
		WHEN z.[FixedContractExpirationDate] = 1 THEN 'Ano'
		WHEN z.[FixedContractExpirationDate] = 0 THEN 'Nie'
		ELSE 'Nezadane'
	END AS NaDobuUrcitu,
	ISNULL(CONVERT(VARCHAR(25), z.[ContractExpirationDate], 104) + ' ' + CONVERT(VARCHAR(25), z.[ContractExpirationDate], 108), '') AS Ukoncenie,
	ISNULL(zod.[FirstName] + ' ', '') + ISNULL(zod.[LastName], '') AS Zodpovedny,
	ISNULL(zod.Email, 'miroslav.hanzen@gmail.com') + ISNULL(';' + nad.Email, '') AS Email,
	ISNULL(CAST(CAST(z.[ContractExpirationDate] - @Now AS INT) AS VARCHAR(20)), 'xy') AS DeadlineDiff,
	CASE WHEN z.[AsignmentDate] >= FLOOR(CAST(@Now AS FLOAT)) - 1 THEN 1 END AS IsNewAssign
FROM
	dbo.[Contracts] z
	LEFT JOIN dbo.[Organizations] o
		ON o.Id = z.[OrganizationId]
	LEFT JOIN dbo.[Employees] zod
		ON zod.[Id] = z.[ResponsibleEmployeeId]
		AND
		zod.[EmployeeStateId] != 2
	LEFT JOIN dbo.[Employees] nad
		ON nad.[Id] = zod.[ManagerEmployeeId]
		AND
		nad.[EmployeeStateId] != 2
	LEFT JOIN dbo.[ContractTypes] zt
		ON zt.[Id] = z.[ContractTypeId]
	LEFT JOIN dbo.[ContractStates] zs
		ON zs.[Id] = z.[ContractStateId]
WHERE
	(
		z.[FixedContractExpirationDate] = 1
		OR
		z.[ContractExpirationDate] IS NOT NULL
	)
	AND
	(
		(
			FLOOR(CAST(z.[ContractExpirationDate] AS FLOAT)) - FLOOR(CAST(@Now AS FLOAT)) IN (30,14,0)
			OR
			ISNULL(z.[ContractExpirationDate], @Now) >= @Now
			AND
			ISNULL(z.[ContractExpirationDate], @Now) <= @Now + 7
			AND
			DATEPART(DW, @Now) = 2
		)
	)
	OR
	z.[AsignmentDate] >= FLOOR(CAST(@Now AS FLOAT)) - 1
	AND
	z.[AsignmentDate] <= FLOOR(CAST(@Now AS FLOAT))
	
OPEN cur

FETCH NEXT FROM cur INTO
	@Organizacia,
	@OrganizaciaPoznamka,
	@CisloZmluvy,
	@Nazov,
	@Typ,
	@Stav,
	@Ucinnost,
	@Pravoplatnost,
	@NaDobuUrcitu,
	@Ukoncenie,
	@Zodpovedny,
	@Email,
	@DeadlineDiff,
	@IsNewAssign


WHILE @@FETCH_STATUS = 0
BEGIN

SET @body = '<html>
	<head>
		<style type="text/css">
			 body {font-family: Tahoma; font-size: 10pt;}
			 .label {font-weight: bold; padding-right: 10px;}
		 </style>
	</head>
	<body>
'

IF @IsNewAssign = 1
BEGIN
	SET @body = @body + @Zodpovedny + ',<br/>
	bola Vám pridelená nasledujúca zmluva:<br/>
	'
	SET @subject = 'pridelenie novej zmluvy'
END
ELSE
BEGIN
	SET @body = @body + @Zodpovedny + ',<br/>
	nasledujúca zmluva má dátum ukončenia za ' + @DeadlineDiff + ' dní:<br/>
	'
	SET @subject = 'notifikácia ukončenia zmluvy'
END

SET @body = @body + '
		<table>
		<tr>
		<td class="label">Organizácia:</td><td>' + @Organizacia + '</td>
		</tr>
		<tr>
		<td class="label">Poznámka:</td><td>' + @OrganizaciaPoznamka + '</td>
		</tr>
		<tr>
		<td class="label">Číslo zmluvy:</td><td>' + @CisloZmluvy + '</td>
		</tr>
		<tr>
		<td class="label">Názov:</td><td>' + @Nazov + '</td>
		</tr>
		<tr>
		<td class="label">Typ:</td><td>' + @Typ + '</td>
		</tr>
		<tr>
		<td class="label">Stav:</td><td> ' + @Stav + '</td>
		</tr>
		<tr>
		<td class="label">Účinnosť:</td><td>' + @Ucinnost + '</td>
		</tr>
		<tr>
		<td class="label">Právoplatnosť:</td><td>' + @Pravoplatnost + '</td>
		</tr>
		<tr>
		<td class="label">Na dobu určitú:</td><td>' + @NaDobuUrcitu + '</td>
		</tr>
		<tr>
		<td class="label">Ukončenie:</td><td>' + @Ukoncenie + '</td>
		</tr>
		<tr>
		<td class="label">Zodpovedný:</td><td>' + @Zodpovedny + '</td>
		</tr>
		</table>'

SET @body = @body + '
	</body>
</html>'

IF @DebugMode = 1
BEGIN
	PRINT ''
	PRINT @Email
	PRINT @subject
	PRINT @body

	EXEC msdb.dbo.sp_send_dbmail
	@recipients = 'matej.cizmarik@2ring.com',
	@subject = @subject,
	@body = @body,
	@body_format = 'HTML'
END ELSE
	EXEC msdb.dbo.sp_send_dbmail
	@recipients = @Email,
	@copy_recipients = 'miroslav.hanzen@gmail.com',
	@subject = @subject,
	@body = @body,
	@body_format = 'HTML'


FETCH NEXT FROM cur INTO
	@Organizacia,
	@OrganizaciaPoznamka,
	@CisloZmluvy,
	@Nazov,
	@Typ,
	@Stav,
	@Ucinnost,
	@Pravoplatnost,
	@NaDobuUrcitu,
	@Ukoncenie,
	@Zodpovedny,
	@Email,
	@DeadlineDiff,
	@IsNewAssign
END

CLOSE cur
DEALLOCATE cur
