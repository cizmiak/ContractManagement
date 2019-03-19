CREATE FUNCTION [dbo].[GetCourseHTML]
(
	@courseId INT
	,@Today DATETIME
)
RETURNS NVARCHAR(MAX) AS
BEGIN

--DECLARE
--	@courseId INT = 4768
--	,@Today DATETIME = FLOOR(CAST(GETDATE() AS FLOAT)) - 1

DECLARE
	@html NVARCHAR(MAX)
	,@NasledujuceZa NVARCHAR(255)
	,@Lektor NVARCHAR(255)
	,@ContactPersonEmail NVARCHAR(255)
	,@Uskutocnene NVARCHAR(255)
	,@Typ NVARCHAR(255)
	,@Lehota NVARCHAR(255)

SELECT
	@Lektor = COALESCE(notifikovany.[LastName] + ' ' + notifikovany.[FirstName], z.[LastName] + ' ' + z.[FirstName], 'Nezadané')
	,@NasledujuceZa = ISNULL(CAST(CAST(FLOOR(CAST(s.[NextCourseDate] AS FLOAT)) - @Today AS INT) AS VARCHAR(20)), 'xy')
	,@Uskutocnene = ISNULL(CONVERT(VARCHAR(50), s.[CourseDate], 104), 'Nezadané')
	,@ContactPersonEmail = ISNULL(report.GetContactPersonEmail(s.[OrganizationId]), 'Nezadané')
	,@Lehota = ISNULL(CAST(YEAR(s.[NextCourseDate]) - YEAR(s.[CourseDate]) AS VARCHAR(5)), 'Nezadané')
	,@Typ = ISNULL(st.[Name], 'Nezadané')
FROM
	dbo.[Courses] s
	LEFT JOIN dbo.[Employees] z
		ON z.[Id] = s.[LectorId]
		AND
		z.[EmployeeStateId] != 2
	LEFT JOIN dbo.[Employees] notifikovany
		ON z.[Id] = s.[NotificatedId]
		AND
		z.[EmployeeStateId] != 2
	LEFT JOIN dbo.[CourseTypes] st
		ON st.[Id] = s.[CourseTypeId]
WHERE
	s.[Id] = @courseId

SET @html = '<!DOCTYPE html>
<html>
	<head>
		' + dbo.GetEmailStyle() + '
	</head>
	<body>
'

SET @html = @html + @Lektor + ',<br/>
Nasledujúce školenie sa má konať za ' + @NasledujuceZa + ' dní:<br/><br/>
'

SET @html = @html + dbo.GetCourseEmailTable(@courseId) + '
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
<br/><br/>' + report.[CourseAttendeeXML](@courseId) +
'
<br/>Prosíme Vás o aktualizáciu zoznamu osôb ako aj návrh možného termínu periodického školenia.

<br/><br/>Ďakujem,
<br/>
'

SET @html = @html + '
	</body>
</html>'

--PRINT @html
RETURN @html
END