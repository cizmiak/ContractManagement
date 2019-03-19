CREATE FUNCTION [dbo].[CourseToNotificate]
(
	@Today DATETIME
) RETURNS TABLE
AS RETURN
SELECT
	s.[OrganizationId]
	,s.[Id] AS SkolenieID
	,COALESCE(notifikovany.Email, skolitel.Email, 'miroslav.hanzen@gmail.com')
	+ ISNULL(';' + nadriadeny.Email, '')
	+ ISNULL(';' + zodpovedny.Email, '') AS Email
FROM
	dbo.[Courses] s
	LEFT JOIN dbo.[Employees] skolitel
		ON skolitel.[Id] = s.[LectorId]
		AND
		skolitel.[EmployeeStateId] != 2
	LEFT JOIN dbo.[Employees] notifikovany
		ON notifikovany.[Id] = s.[NotificatedId]
		AND
		notifikovany.[EmployeeStateId] != 2
	LEFT JOIN dbo.[Employees] nadriadeny
		ON nadriadeny.[Id] = skolitel.[ManagerEmployeeId]
		AND
		nadriadeny.[EmployeeStateId] != 2
	LEFT JOIN dbo.[Contracts] zmluva
		ON zmluva.[Id] = s.[ContractId]
	LEFT JOIN dbo.[Employees] zodpovedny
		ON zodpovedny.[Id] = zmluva.[ResponsibleEmployeeId]
		AND
		zodpovedny.[EmployeeStateId] != 2
WHERE
	FLOOR(CAST(s.[NextCourseDate] AS FLOAT)) - ISNULL(@Today, GETDATE()) = 14