CREATE PROCEDURE [report].[Course]
	@SkolenieID INT = NULL
AS

--DECLARE
--	@SkolenieID INT = NULL

SELECT
	s.[Id]
	,s.[Reference]
	,s.[Name]
	,s.[CourseDate]
	,s.[NextCourseDate]
	,s.[AttendeeCount]
	,s.[PassedCount]
	,s.[FailedCount]
	,s.[CoursePlace]
	,skp.[Name] AS SkoleniePreKoho
	,st.[Name] AS Typ
	,REPLACE(st.[CourseTypeLicenseNumber], ', ', char(10) + char(13)) AS CisloOpravnenia
	,sd.[Name] AS Druh
	,sfs.[Name] AS FormaSkusania
	,o.[Name] AS Organizacia
	,z.[LastName] + ' ' + z.[FirstName] AS Lektor
	,p.[LastName] + ' ' + p.[FirstName] AS PredsedaKomisie
	,c1.[LastName] + ' ' + c1.[FirstName] AS ClenKomisie1
	,c2.[LastName] + ' ' + c2.[FirstName] AS ClenKomisie2

	,z.[Signature] AS PodpisLektor
	,p.[Signature] AS PodpisPredsedaKomisie
	,c1.[Signature] AS PodpisClenKomisie1
	,c2.[Signature] AS PodpisClenKomisie2

	/*Voziky*/
	,s.Vyska15
	,s.Plosina
	,s.Rebrik5
	,s.Hlbka13
	,s.Postroj
	,s.[LicenseReleaseDate]
	,s.[LicenseReleasedBy]
	,s.CisloPreukazu
	
	,CASE WHEN ISNULL(s.I, '') = 1 THEN 'I. ' ELSE '' END
	+CASE WHEN ISNULL(s.II, '') = 1 THEN 'II. ' ELSE '' END  AS TriedaMotorovychVozikov
	
	,CASE WHEN ISNULL(s.I, '') = 1 THEN 'I.' ELSE '' END	AS I
	,CASE WHEN ISNULL(s.II, '') = 1 THEN 'II.' ELSE '' END	AS II

	,CASE WHEN ISNULL(s.A, '') = 1 THEN 'A ' ELSE '' END
	+CASE WHEN ISNULL(s.B, '') = 1 THEN 'B ' ELSE '' END
	+CASE WHEN ISNULL(s.C, '') = 1 THEN 'C ' ELSE '' END
	+CASE WHEN ISNULL(s.D, '') = 1 THEN 'D ' ELSE '' END
	+CASE WHEN ISNULL(s.E, '') = 1 THEN 'E ' ELSE '' END
	+CASE WHEN ISNULL(s.W1, '') = 1 THEN 'W1 ' ELSE '' END
	+CASE WHEN ISNULL(s.W2, '') = 1 THEN 'W2 ' ELSE '' END
	+CASE WHEN ISNULL(s.G, '') = 1 THEN 'G ' ELSE '' END
	+CASE WHEN ISNULL(s.Z, '') = 1 THEN 'Z ' ELSE '' END  AS DruhMotorovychVozikov

	,CASE WHEN ISNULL(s.A, '') = 1 THEN 'A ' ELSE '' END	AS A
	,CASE WHEN ISNULL(s.B, '') = 1 THEN 'B ' ELSE '' END	AS B
	,CASE WHEN ISNULL(s.C, '') = 1 THEN 'C ' ELSE '' END	AS C
	,CASE WHEN ISNULL(s.D, '') = 1 THEN 'D ' ELSE '' END	AS D
	,CASE WHEN ISNULL(s.E, '') = 1 THEN 'E ' ELSE '' END	AS E
	,CASE WHEN ISNULL(s.W1, '') = 1 THEN 'W1 ' ELSE '' END	AS W1
	,CASE WHEN ISNULL(s.W2, '') = 1 THEN 'W2 ' ELSE '' END	AS W2
	,CASE WHEN ISNULL(s.G, '') = 1 THEN 'G ' ELSE '' END  	AS G
	,CASE WHEN ISNULL(s.Z, '') = 1 THEN 'Z ' ELSE '' END  	AS Z
	
	,s.C_BezVodickehoOpravnenia
	,s.W1_BezVodickehoOpravnenia

	,report.[CourseZHourCount](s.[Id]) AS VozikyPocetHodin
FROM
	dbo.[Courses] s
	LEFT JOIN dbo.[Organizations] o
		ON o.Id = s.[OrganizationId]
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
WHERE
	s.[Id] = @SkolenieID
	OR
	@SkolenieID IS NULL
