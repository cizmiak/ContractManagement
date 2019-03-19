CREATE FUNCTION [dbo].[GetCourseEmailTable]
(
--DECLARE
	@courseId INT
) RETURNS NVARCHAR(MAX)
AS BEGIN
RETURN
CONVERT(NVARCHAR(MAX), (
SELECT
	'headerCell' AS [tr/th/@class], 'Školenie ID' AS [tr/th], class AS [tr/td/@class], SkolenieID AS [tr/td], ''
	,'headerCell' AS [tr/th/@class], 'Organizácia' AS [tr/th], class AS [tr/td/@class], Organizacia AS [tr/td], ''
	,'headerCell'  AS [tr/th/@class], 'Referencia' AS [tr/th], class AS [tr/td/@class], [Reference] AS [tr/td], ''
	,'headerCell'  AS [tr/th/@class], 'Názov' AS [tr/th], class AS [tr/td/@class], [Name] AS [tr/td], ''
	,'headerCell'  AS [tr/th/@class], 'Typ' AS [tr/th], class AS [tr/td/@class], Typ AS [tr/td], ''
	,'headerCell'  AS [tr/th/@class], 'Druh' AS [tr/th], class AS [tr/td/@class], Druh AS [tr/td], ''
	,'headerCell'  AS [tr/th/@class], 'Uskutočnené' AS [tr/th], class AS [tr/td/@class], Uskutocnene AS [tr/td], ''
	,'headerCell'  AS [tr/th/@class], 'Nasledujúce' AS [tr/th], class AS [tr/td/@class], Nasledujuce AS [tr/td], ''
	,'headerCell'  AS [tr/th/@class], 'Miesto konania' AS [tr/th], class AS [tr/td/@class], [CoursePlace] AS [tr/td], ''
	,'headerCell'  AS [tr/th/@class], 'Školenie pre koho' AS [tr/th], class AS [tr/td/@class], SkoleniePreKoho AS [tr/td], ''
FROM
	(
		SELECT
			'dataCell' as class
			,s.[Id] AS SkolenieID
			,o.[Name] AS Organizacia
			,s.[Reference]
			,s.[Name]
			,st.[Name] AS Typ
			,sd.[Name] AS Druh
			,convert(varchar(20), s.[CourseDate], 104) as Uskutocnene
			,convert(varchar(20), s.[NextCourseDate], 104) as Nasledujuce
			,s.[CoursePlace]
			,skp.[Name] AS SkoleniePreKoho
		FROM
			dbo.[Courses] s
			LEFT JOIN dbo.[Organizations] o
				ON o.Id = s.[OrganizationId]
			LEFT JOIN dbo.[CourseTypes] st
				ON st.[Id] = s.[CourseTypeId]
			LEFT JOIN dbo.[CourseKinds] sd
				ON sd.[Id] = s.[CourseKindId]
			LEFT JOIN dbo.[CourseAttendeeTypes] skp
				ON skp.[Id] = s.[CourseAttendeeTypeId]
		WHERE
			s.[Id] = @courseId
	) xmlPrepare
FOR XML PATH('tbody'), TYPE, ROOT('table')
))
END
