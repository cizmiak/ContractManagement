CREATE FUNCTION [dbo].[AttendeeAtCourseHTML]
(
--DECLARE
	@courseId INT,
	@organizationId INT = NULL
) RETURNS NVARCHAR(MAX)
AS BEGIN

DECLARE @result NVARCHAR(MAX)
SET @result = CONVERT (NVARCHAR(MAX), (
SELECT
'table-table' AS [@class],
'tableHeader' AS [thead/@class],
(
	SELECT
		'headerRow' AS [@class]
		,'headerCell' AS [th/@class], 'SkolenieID' AS th, ''
		,'headerCell' AS [th/@class], 'Referencia' AS th, ''
		,'headerCell'  AS [th/@class], 'Nazov' AS th, ''
		,'headerCell'  AS [th/@class], 'Uskutocnene' AS th, ''
		,'headerCell'  AS [th/@class], 'Druh' AS th, ''
		,'headerCell'  AS [th/@class], 'Typ' AS th, ''
		,'headerCell'  AS [th/@class], 'PreukazVydany' AS th, ''
		,'headerCell'  AS [th/@class], 'PreukazVydal' AS th, ''
		,'headerCell'  AS [th/@class], 'Posluchac' AS th, ''
		,'headerCell'  AS [th/@class], 'Titul' AS th, ''
		,'headerCell'  AS [th/@class], 'PracovneZaradenie' AS th, ''
		,'headerCell'  AS [th/@class], 'Organizacia' AS th, ''
	FOR XML PATH('tr'), TYPE
) thead,
'tableBody' AS [tbody/@class],
(
	SELECT
		'row' AS [@class]
		,class AS [td/@class], [CourseId] AS td, ''
		,class AS [td/@class], [Reference] AS td, ''
		,class  AS [td/@class], [Name] AS td, ''
		,class  AS [td/@class], Uskutocnene AS td, ''
		,class  AS [td/@class], Druh AS td, ''
		,class  AS [td/@class], Typ AS td, ''
		,class  AS [td/@class], PreukazVydany AS td, ''
		,class  AS [td/@class], PreukazVydal AS td, ''
		,class  AS [td/@class], Posluchac AS td, ''
		,class  AS [td/@class], [UniversityDegree] AS td, ''
		,class  AS [td/@class], PracovneZaradenie AS td, ''
		,class  AS [td/@class], Organizacia AS td, ''
	FROM
		(
			SELECT
				'dataCell' as class
				,sp.[CourseId]
				,s.[Reference]
				,s.[Name]
				,convert(varchar(20), s.[CourseDate], 104) as Uskutocnene
				,sd.[Name] as Druh
				,st.[Name] as Typ
				,CONVERT(varchar(20), ISNULL(sp.[LicenseReleaseDate], s.[LicenseReleaseDate]), 104) AS PreukazVydany
				,ISNULL(sp.[LicenseReleasedBy], s.[LicenseReleasedBy]) AS PreukazVydal
				,ISNULL(p.[LastName] + ' ', '') + ISNULL(p.[Name], '') AS Posluchac
				,p.[UniversityDegree]
				,pz.[Name] AS PracovneZaradenie
				,o.Nazov AS Organizacia
			FROM
				dbo.[CourseAttendees] sp
				inner join dbo.[Courses] s
					on s.[Id] = sp.[CourseId]
				inner join dbo.[Attendees] p
					on p.Id = sp.[AttendeeId]
				left join dbo.[Organizations] o
					on o.ID = p.[OrganizationId]
				left join dbo.[WorkPositions] pz
					on pz.[Id] = p.[WorkPositionId]
				left join dbo.[CourseKinds] sd
					on sd.[Id] = s.[CourseKindId]
				left join dbo.[CourseTypes] st
					on st.[Id] = s.[CourseTypeId]
			WHERE
				sp.[CourseId] = @courseId
				AND
				(
					p.[OrganizationId] = @organizationId
					OR
					@organizationId IS NULL
				)
		) xmlPrepare
	FOR XML PATH('tr'), TYPE
) tbody
FOR XML PATH('table'), TYPE
))

--PRINT @result
RETURN @result
END