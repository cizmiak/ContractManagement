CREATE FUNCTION [report].[CourseAttendeeXML]
(
	@SkolenieID INT
)
RETURNS NVARCHAR(MAX)
AS BEGIN
DECLARE @result NVARCHAR(MAX)

SET @result =
CAST(
(SELECT
	' Priezvisko a meno' AS th, ''
	,' Titul' AS th, ''
	,' Pracovné zaradenie' AS th, ''
	,' Organizácia' AS th, ''
	,' Školenie ID' AS th, ''
	,' Referencia' AS th, ''
	,' Názov' AS th, ''
	,' Uskutočnené' AS th, ''
FOR XML PATH('tr'), TYPE)
AS NVARCHAR(MAX))
+
CAST(
(
SELECT
	td_class AS "td/@class", MenoCele AS td, ''
	,td_class AS "td/@class", [UniversityDegree] AS td, ''
	,td_class  AS "td/@class", PracovneZaradenie AS td, ''
	,td_class  AS "td/@class", Organizacia AS td, ''
	,td_class  AS "td/@class", SkolenieID AS td, ''
	,td_class  AS "td/@class", [Reference] AS td, ''
	,td_class  AS "td/@class", [Name] AS td, ''
	,CASE
		WHEN GETDATE() - [CourseDate] < 365
		THEN 'red'
		ELSE td_class
	END AS "td/@class", CONVERT(VARCHAR(20), [CourseDate], 104) AS td, ''
FROM
	(
		SELECT
			'common' AS td_class,
			ISNULL(p.[LastName] + ' ', '') + ISNULL(p.[Name], '') AS MenoCele
			,p.[UniversityDegree]
			,pz.[Name] AS PracovneZaradenie
			,org.[Name] AS Organizacia
			,psp.SkolenieID
			,psp.[Reference]
			,psp.[Name]
			,psp.[CourseDate]
		FROM
			dbo.[CourseAttendees] sp
			INNER JOIN dbo.[Attendees] p
				ON p.Id = sp.[AttendeeId]
			LEFT JOIN dbo.[WorkPositions] pz
				ON pz.[Id] = p.[WorkPositionId]
			LEFT JOIN dbo.[Organizations] org
				ON org.Id = p.[OrganizationId]
			OUTER APPLY report.[LastCourseOfAttendee](sp.[CourseId], sp.[AttendeeId]) psp
		WHERE	
			sp.[CourseId] = @SkolenieID
	) xmlPrepare
ORDER BY
	MenoCele
FOR XML PATH('tr'), TYPE)
AS NVARCHAR(MAX))

SET @result = '<table>
' + @result + '
</table>'

RETURN @result
END
