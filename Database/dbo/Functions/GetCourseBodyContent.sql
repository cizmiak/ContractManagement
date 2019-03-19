CREATE FUNCTION [dbo].[GetCourseBodyContent]
(
	@CourseId INT
	,@Today DATETIME
)
RETURNS NVARCHAR(MAX) AS
BEGIN

--DECLARE
--	@CourseId INT = 4768
--	,@Today DATETIME = FLOOR(CAST(GETDATE() AS FLOAT)) - 1

DECLARE
	@html NVARCHAR(MAX)
	,@DaysToNextCourse NVARCHAR(255)
	,@Lector NVARCHAR(255)
	,@ContactPersonEmail NVARCHAR(255)
	,@CourseDate NVARCHAR(255)
	,@CourseType NVARCHAR(255)
	,@NextCourseAfterYears NVARCHAR(255)

SELECT
	@Lector = COALESCE(notifikovany.[LastName] + ' ' + notifikovany.[FirstName], z.[LastName] + ' ' + z.[FirstName], 'Nezadané')
	,@DaysToNextCourse = ISNULL(CAST(CAST(FLOOR(CAST(s.[NextCourseDate] AS FLOAT)) - @Today AS INT) AS VARCHAR(20)), 'xy')
	,@CourseDate = ISNULL(CONVERT(VARCHAR(50), s.[CourseDate], 104), 'Nezadané')
	,@ContactPersonEmail = ISNULL(report.GetContactPersonEmail(s.[OrganizationId]), 'Nezadané')
	,@NextCourseAfterYears = ISNULL(CAST(YEAR(s.[NextCourseDate]) - YEAR(s.[CourseDate]) AS VARCHAR(5)), 'Nezadané')
	,@CourseType = ISNULL(st.[Name], 'Nezadané')
FROM
	dbo.[Courses] s
	LEFT JOIN dbo.[Employees] z
		ON z.[Id] = s.[LectorId]
		AND
		z.[EmployeeStateId] != 2
	LEFT JOIN dbo.[Employees] notifikovany
		ON notifikovany.[Id] = s.[NotificatedId]
		AND
		notifikovany.[EmployeeStateId] != 2
	LEFT JOIN dbo.[CourseTypes] st
		ON st.[Id] = s.[CourseTypeId]
WHERE
	s.[Id] = @CourseId

SET @html = N'
'
SET @html = @html + @Lector + ',<br/>
Nasledujúce školenie sa má konať za ' + @DaysToNextCourse + ' dní:<br/><br/>
'
SET @html = @html + dbo.GetCourseEmailTable(@CourseId) + '
<br/>
--------------------------------------------------------------------------------------------------
<br/>E-mail kontaktných osôb:<br/>
' + @ContactPersonEmail + '<br/>
--------------------------------------------------------------------------------------------------
<br/>
Dobrý deň,

<br/><br/>dňa ' + @CourseDate + ' sme vykonali, vo Vašej spoločnosti, školenie: <span class="bold">' + @CourseType +
'</span>. Dovoľte, aby sme Vás touto cestou upozornili, že o ' + @DaysToNextCourse +
' ' +
CASE
	WHEN ISNUMERIC(@DaysToNextCourse) = 1 THEN
		CASE
			WHEN @DaysToNextCourse = 1 THEN 'deň'
			WHEN @DaysToNextCourse BETWEEN 2 AND 4 THEN 'dni'
			ELSE 'dní'
		END
	ELSE 'dní'
END +
' uplynie ' + @NextCourseAfterYears  + ' ročná lehota, v rámci ktorej by ste mali vykonať periodické školenie.
<br/>Zoznam osôb, ktoré absolvovali školenie:
<br/><br/>' + report.[CourseAttendeeXML](@CourseId) +
'
<br/>Prosíme Vás o aktualizáciu zoznamu osôb ako aj návrh možného termínu periodického školenia.

<br/><br/>Ďakujem,
<br/>
'
--PRINT @html
RETURN @html
END