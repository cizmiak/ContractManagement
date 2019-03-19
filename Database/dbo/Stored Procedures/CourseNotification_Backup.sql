CREATE PROCEDURE [dbo].[CourseNotification_Backup]
AS
--SET DATEFIRST 1
DECLARE
	@ID VARCHAR(200),
	@Referencia VARCHAR(200),
	@Nazov VARCHAR(200),
	@Uskutocnene VARCHAR(200),
	@Nasledujuce VARCHAR(200),
	@Lehota VARCHAR(200),
	@UcastCelkom VARCHAR(200),
	@Vyhovelo VARCHAR(200),
	@Nevyhovelo VARCHAR(200),
	@MiestoKonania VARCHAR(200),
	@SkoleniePreKoho VARCHAR(200),
	@Typ VARCHAR(200),
	@Druh VARCHAR(200),
	@FormaSkusania VARCHAR(200),
	@Organizacia VARCHAR(200),
	@Lektor VARCHAR(200),
	@PredsedaKomisie VARCHAR(200),
	@ClenKomisie1 VARCHAR(200),
	@ClenKomisie2 VARCHAR(200),
	@Email VARCHAR(200),
	@NasledujuceZa VARCHAR(200),
	@ContactPersonEmail VARCHAR(MAX),

	@body VARCHAR(MAX),
	@subject VARCHAR(100),
	@spravaZmluvURL VARCHAR(500),
	@aElement VARCHAR(1000),
	@Today DATETIME

SET @Today = FLOOR(CAST(GETDATE() AS FLOAT))
SET @subject = 'Notifikácia nasledujúceho školenia'
--SET @Today = '2014-09-01'
--SET @subject = '!!!test vymazte(ako by bolo 1.9.2014)!!! Notifikácia nasledujúceho školenia'

DELETE FROM dbo.[CourseNotificationLog] WHERE InsertedDateTime < @Today - 90

SELECT @spravaZmluvURL = [Value] FROM dbo.[Configurations] WHERE [Key] = 'SpravaZmluvURL'
SET @spravaZmluvURL = @spravaZmluvURL + '/#/'

DECLARE cur CURSOR FOR
SELECT
	s.[Id] AS ID
	,ISNULL(s.[Reference], 'Nezadané') AS Referencia
	,ISNULL(s.[Name], 'Nezadané') AS  SkolenieNazov
	,ISNULL(CONVERT(VARCHAR(50), s.[CourseDate], 104), 'Nezadané') AS Uskutocnene
	,CONVERT(VARCHAR(50), s.[NextCourseDate], 104) AS Nasledujuce
	,ISNULL(CAST(YEAR(s.[NextCourseDate]) - YEAR(s.[CourseDate]) AS VARCHAR(5)), 'Nezadané') AS Lehota
	,ISNULL(CAST(s.[AttendeeCount] AS VARCHAR(50)), 'Nezadané') AS UcastCelkom
	,ISNULL(CAST(s.[PassedCount] AS VARCHAR(50)), 'Nezadané') AS Vyhovelo
	,ISNULL(CAST(s.[FailedCount] AS VARCHAR(50)), 'Nezadané') AS Nevyhovelo
	,ISNULL(s.[CoursePlace], 'Nezadané') AS MiestoKonania
	,ISNULL(skp.[Name], 'Nezadané') AS SkoleniePreKoho
	,ISNULL(st.[Name], 'Nezadané')  AS Typ
	,ISNULL(sd.[Name], 'Nezadané')  AS Druh
	,ISNULL(sfs.[Name], 'Nezadané')  AS FormaSkusania
	,ISNULL(o.[Name], 'Nezadané')  AS Organizacia
	,COALESCE(notifikovany.[LastName] + ' ' + notifikovany.[FirstName], z.[LastName] + ' ' + z.[FirstName], 'Nezadané')  AS Lektor
	,ISNULL(p.[LastName] + ' ' + p.[FirstName], 'Nezadané')  AS PredsedaKomisie
	,ISNULL(c1.[LastName] + ' ' + c1.[FirstName], 'Nezadané')  AS ClenKomisie1
	,ISNULL(c2.[LastName] + ' ' + c2.[FirstName], 'Nezadané')  AS ClenKomisie2
	,COALESCE(notifikovany.Email, z.Email, 'miroslav.hanzen@gmail.com') + ISNULL(';' + nad.Email, '') + ISNULL(';' + zod.Email, '') AS Email
	,ISNULL(CAST(CAST(FLOOR(CAST(s.[NextCourseDate] AS FLOAT)) - @Today AS INT) AS VARCHAR(20)), 'xy') AS NasledujuceZa
	,ISNULL(report.GetContactPersonEmail(s.[OrganizationId]), 'Nezadané') AS ContactPersonEmail
FROM
	dbo.[Courses] s
	LEFT JOIN dbo.[Organizations] o
		ON o.Id = s.[OrganizationId]
	LEFT JOIN dbo.[Employees] z
		ON z.[Id] = s.[LectorId]
		AND
		z.[EmployeeStateId] != 2
	LEFT JOIN dbo.[Employees] notifikovany
		ON z.[Id] = s.[NotificatedId]
		AND
		z.[EmployeeStateId] != 2
	LEFT JOIN dbo.[Employees] nad
		ON nad.[Id] = z.[ManagerEmployeeId]
		AND
		nad.[EmployeeStateId] != 2
	LEFT JOIN dbo.[Employees] p
		ON p.[Id] = s.[CommitteeHeadId]
	LEFT JOIN dbo.[Employees] c1
		ON c1.[Id] = s.[CommitteeMember1Id]
	LEFT JOIN dbo.[Employees] c2
		ON c2.[Id] = s.[CommitteeMember2Id]
	LEFT JOIN dbo.[CourseTypes] st
		ON st.[Id] = s.[CourseTypeId]
	LEFT JOIN dbo.[CourseKinds] sd
		ON sd.[Id] = s.[CourseKindId]
	LEFT JOIN dbo.[CourseExamTypes] sfs
		ON sfs.[Id] = s.[CourseExamTypeId]
	LEFT JOIN dbo.[CourseAttendeeTypes] skp
		ON skp.[Id] = s.[CourseAttendeeTypeId]
	LEFT JOIN dbo.[Contracts] zml
		ON zml.[Id] = s.[ContractId]
	LEFT JOIN dbo.[Employees] zod
		ON zod.[Id] = zml.[ResponsibleEmployeeId]
		AND
		zod.[EmployeeStateId] != 2
WHERE
	FLOOR(CAST(s.[NextCourseDate] AS FLOAT)) - @Today IN (30,14)
	/*2014-10-01 pondelokove notifikacie davame do precu*/
	--OR
	--s.Nasledujuce BETWEEN @Today AND @Today + 7
	--AND
	--DATEPART(DW, GETDATE()) = 1

OPEN cur

FETCH NEXT FROM cur INTO
	@ID,
	@Referencia,
	@Nazov,
	@Uskutocnene,
	@Nasledujuce,
	@Lehota,
	@UcastCelkom,
	@Vyhovelo,
	@Nevyhovelo,
	@MiestoKonania,
	@SkoleniePreKoho,
	@Typ,
	@Druh,
	@FormaSkusania,
	@Organizacia,
	@Lektor,
	@PredsedaKomisie,
	@ClenKomisie1,
	@ClenKomisie2,
	@Email,
	@NasledujuceZa,
	@ContactPersonEmail

WHILE @@FETCH_STATUS = 0
BEGIN

--SELECT
--	@ID,
--	@Referencia,
--	@Nazov,
--	@Uskutocnene,
--	@Nasledujuce,
--	@UcastCelkom,
--	@Vyhovelo,
--	@Nevyhovelo,
--	@MiestoKonania,
--	@SkoleniePreKoho,
--	@Typ,
--	@Druh,
--	@FormaSkusania,
--	@Organizacia,
--	@Lektor,
--	@PredsedaKomisie,
--	@ClenKomisie1,
--	@ClenKomisie2,
--	@Email,
--	@NasledujuceZa
	
SET @body = '<!DOCTYPE html>
<html>
	<head>
		<style type="text/css">
			body {font-family: Tahoma; font-size: 10pt;}
			.label {font-weight: bold; padding-right: 10px;}
			.bold {font-weight: bold;}
			th {font-weight: bold; text-align: left; padding-left: 10px;}
			td {padding-left: 10px;}
			.red {color: red;}
		 </style>
	</head>
	<body>
'

SET @body = @body + @Lektor + ',<br/>
Nasledujúce školenie sa má konať za ' + @NasledujuceZa + ' dní:<br/><br/>
'
--SET @aElement = '<a href="' + @spravaZmluvURL + 'SkoleniaVM?SkolenieID=' + @ID + '">Naviguj na skolenie...</a>'
--SET @aElement = NULL;

SET @body = @body + '
<table>
<tr>
<td class="label">ID: </td><td>' + @ID + '</td>
</tr>
<tr>
<td class="label">Organizácia:</td><td>' + @Organizacia + '</td>
</tr>
<tr>
<td class="label">Referencia:</td><td>' + @Referencia + '</td>
</tr>
<tr>
<td class="label">Názov:</td><td>' + @Nazov + '</td>
</tr>
<tr>
<td class="label">Typ:</td><td>' + @Typ + '</td>
</tr>
<tr>
<td class="label">Druh:</td><td> ' + @Druh + '</td>
</tr>
<tr>
<td class="label">Uskutočnené:</td><td>' + @Uskutocnene + '</td>
</tr>
<tr>
<td class="label">Nasledujúce:</td><td>' + @Nasledujuce + '</td>
</tr>
<tr>
<td class="label">Miesto konania:</td><td>' + @MiestoKonania + '</td>
</tr>
<tr>
<td class="label">Školenie pre koho:</td><td>' + @SkoleniePreKoho + '</td>
</tr>
</table>
<br/>
--------------------------------------------------------------------------------------------------
<br/>E-mail kontaktných osôb:<br/>
' + @ContactPersonEmail + '<br/>
--------------------------------------------------------------------------------------------------
<br/>
Dobrý deň,

<br/><br/>dňa ' + @Uskutocnene + ' sme vykonali, vo Vašej spoločnosti, školenie: <span class="bold">' + @Typ +
'</span>. Dovoľte, aby sme Vás touto cestou upozornili, že o ' + @NasledujuceZa +
' ' +
CASE
	WHEN ISNUMERIC(@NasledujuceZa) = 1 THEN
		CASE
			WHEN @NasledujuceZa = 1 THEN 'deň'
			WHEN @NasledujuceZa BETWEEN 2 AND 4 THEN 'dni'
			ELSE 'dní'
		END
	ELSE 'dní'
END +
' uplynie ' + @Lehota  + ' ročná lehota, v rámci ktorej by ste mali vykonať periodické školenie.
<br/>Zoznam osôb, ktoré absolvovali školenie:
<br/><br/>' + report.[CourseAttendeeXML](@ID) +
'
<br/>Prosíme Vás o aktualizáciu zoznamu osôb ako aj návrh možného termínu periodického školenia.

<br/><br/>Ďakujem,
<br/>
'

SET @body = @body + '
	</body>
</html>'

--PRINT ''
--PRINT @Email
--PRINT @subject
--PRINT @body

EXEC msdb.dbo.sp_send_dbmail
--@profile_name = 'cizmiak@gmail.com',
@recipients = @Email,
@copy_recipients = 'miroslav.hanzen@gmail.com;monika.hanzenova@gmail.com',

--@recipients = 'matej.cizmarik@2ring.com;miroslav.hanzen@gmail.com',
--@recipients = 'matej.cizmarik@2ring.com',
--@blind_copy_recipients = 'matej.cizmarik@2ring.com',

@subject = @subject,
@body = @body,
@body_format = 'HTML'

INSERT INTO dbo.[CourseNotificationLog]([Id], [Reference], [Name], [Date], [NextDate], [AttendeeCount], [PassedCount], [FailedCount], [Place], [AttendeeType], [Type], [Kind], [ExamType], [Organization], [Lector], [CommitteeHead], [CommitteeMember1], [CommitteeMember2], Email, [NextIn])
VALUES
(	@ID,
	@Referencia,
	@Nazov,
	@Uskutocnene,
	@Nasledujuce,
	@UcastCelkom,
	@Vyhovelo,
	@Nevyhovelo,
	@MiestoKonania,
	@SkoleniePreKoho,
	@Typ,
	@Druh,
	@FormaSkusania,
	@Organizacia,
	@Lektor,
	@PredsedaKomisie,
	@ClenKomisie1,
	@ClenKomisie2,
	@Email,
	@NasledujuceZa
)

FETCH NEXT FROM cur INTO
	@ID,
	@Referencia,
	@Nazov,
	@Uskutocnene,
	@Nasledujuce,
	@Lehota,
	@UcastCelkom,
	@Vyhovelo,
	@Nevyhovelo,
	@MiestoKonania,
	@SkoleniePreKoho,
	@Typ,
	@Druh,
	@FormaSkusania,
	@Organizacia,
	@Lektor,
	@PredsedaKomisie,
	@ClenKomisie1,
	@ClenKomisie2,
	@Email,
	@NasledujuceZa,
	@ContactPersonEmail
END

CLOSE cur
DEALLOCATE cur
