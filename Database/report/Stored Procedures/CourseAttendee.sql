CREATE PROCEDURE [report].[CourseAttendee]
	@SkolenieID VARCHAR(MAX) = NULL,
	@OrganizaciaID VARCHAR(MAX) = NULL,
	@UskutocneneOD DATETIME = NULL,
	@UskutocneneDO DATETIME = NULL
AS

--DECLARE
--	@SkolenieID INT = NULL

SELECT
	s.[Id]
	,s.[Reference]
	,s.[Name]
	,s.[CourseDate]
	,s.[AttendeeCount]
	,s.[PassedCount]
	,s.[FailedCount]
	,s.[CoursePlace]
	,s.Vyska15
	,s.Plosina
	,s.Rebrik5
	,s.Hlbka13
	,skp.[Name] AS SkoleniePreKoho
	,st.[Name] AS Typ
	,sd.[Name] AS Druh
	,sfs.[Name] AS FormaSkusania
	,o.[Name] AS Organizacia
	,matka.[Name] AS Matka
	,z.[LastName] + ' ' + z.[FirstName] AS Lektor
	,p.[LastName] + ' ' + p.[FirstName] AS PredsedaKomisie
	,c1.[LastName] + ' ' + c1.[FirstName] AS ClenKomisie1
	,c2.[LastName] + ' ' + c2.[FirstName] AS ClenKomisie2
	,posl.Id AS PosluchacID
	,posl.[LastName] + ' ' + posl.[Name] AS PosluchacMeno
	,posl.[UniversityDegree] AS PosluchacTitul
	,pz.[Name] AS PosluchacPracovneZaradenie
	,posl.[Address] AS PosluchacBydlisko
	,posl.[BirthDate] AS PosluchacDatumNarodenia
	
	/*obsluha motorovych vozikov*/
	,ISNULL(sp.[LicenseReleaseDate], s.[LicenseReleaseDate]) AS PreukazyVydane
	,ISNULL(sp.[LicenseReleasedBy], s.[LicenseReleasedBy]) AS PreukazyVydal
	,ISNULL(sp.[LicenseNumber], s.CisloPreukazu) AS CisloPreukazu
	,st.[CourseTypeLicenseNumber]
	
	,CASE WHEN COALESCE(sp.I, s.I, '') = 1 THEN 'I. ' ELSE '' END
	+CASE WHEN COALESCE(sp.II, s.II, '') = 1 THEN 'II. ' ELSE '' END  AS TriedaMotorovychVozikov
	
	,CASE WHEN COALESCE(sp.I, s.I, '') = 1 THEN 'I.' ELSE '' END	AS I
	,CASE WHEN COALESCE(sp.II, s.II, '') = 1 THEN 'II.' ELSE '' END	AS II

	,CASE WHEN COALESCE(sp.A, s.A, '') = 1 THEN 'A ' ELSE '' END
	+CASE WHEN COALESCE(sp.B, s.B, '') = 1 THEN 'B ' ELSE '' END
	+CASE WHEN COALESCE(sp.C, s.C, '') = 1 THEN 'C ' ELSE '' END
	+CASE WHEN COALESCE(sp.D, s.D, '') = 1 THEN 'D ' ELSE '' END
	+CASE WHEN COALESCE(sp.E, s.E, '') = 1 THEN 'E ' ELSE '' END
	+CASE WHEN COALESCE(sp.W1, s.W1, '') = 1 THEN 'W1 ' ELSE '' END
	+CASE WHEN COALESCE(sp.W2, s.W2, '') = 1 THEN 'W2 ' ELSE '' END
	+CASE WHEN COALESCE(sp.G, s.G, '') = 1 THEN 'G ' ELSE '' END
	+CASE WHEN COALESCE(sp.Z, s.Z, '') = 1 THEN 'Z ' ELSE '' END  AS DruhMotorovychVozikov

	,CASE WHEN COALESCE(sp.A, s.A, '') = 1 THEN 'A ' ELSE '' END	AS A
	,CASE WHEN COALESCE(sp.B, s.B, '') = 1 THEN 'B ' ELSE '' END	AS B
	,CASE WHEN COALESCE(sp.C, s.C, '') = 1 THEN 'C ' ELSE '' END	AS C
	,CASE WHEN COALESCE(sp.D, s.D, '') = 1 THEN 'D ' ELSE '' END	AS D
	,CASE WHEN COALESCE(sp.E, s.E, '') = 1 THEN 'E ' ELSE '' END	AS E
	,CASE WHEN ISNULL(sp.F, '') = 1		   THEN 'F ' ELSE '' END	AS F
	,CASE WHEN COALESCE(sp.W1, s.W1, '') = 1 THEN 'W1 ' ELSE '' END	AS W1
	,CASE WHEN COALESCE(sp.W2, s.W2, '') = 1 THEN 'W2 ' ELSE '' END	AS W2
	,CASE WHEN COALESCE(sp.G, s.G, '') = 1 THEN 'G ' ELSE '' END  	AS G
	,CASE WHEN COALESCE(sp.Z, s.Z, '') = 1 THEN 'Z ' ELSE '' END  	AS Z
FROM
	dbo.[Courses] s
	LEFT JOIN dbo.[Organizations] o
		ON o.Id = s.[OrganizationId]
	LEFT JOIN dbo.[Organizations] matka
		ON matka.Id = o.ParentOrganizationId
	LEFT JOIN dbo.[Employees] z
		ON z.[Id] = s.[LectorId]
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
	LEFT JOIN dbo.[CourseAttendees] sp
		ON sp.[CourseId] = s.[Id]
	LEFT JOIN dbo.[Attendees] posl
		ON posl.Id = sp.[AttendeeId]
	LEFT JOIN dbo.[WorkPositions] pz
		ON pz.[Id] = posl.[WorkPositionId]
WHERE
	(
		@SkolenieID IS NULL
		OR
		@SkolenieID LIKE '-1%'
		OR
		s.[Id] IN (SELECT Item FROM report.TableFromList(',', @SkolenieID))
	)
	AND
	(
		@OrganizaciaID IS NULL
		OR
		@OrganizaciaID LIKE '-1%'
		OR
		s.[OrganizationId] IN (SELECT Item FROM report.TableFromList(',', @OrganizaciaID))
	)
	AND
	(
		@UskutocneneOD IS NULL
		OR
		s.[CourseDate] >= @UskutocneneOD
	)
	AND
	(
		@UskutocneneDO IS NULL
		OR
		s.[CourseDate] < @UskutocneneDO
	)
