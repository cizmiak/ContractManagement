CREATE function dbo.CourseEmailToNotificate
(@courseId int) returns varchar(1024)
as begin 
return (
select
	COALESCE(notifikovany.Email, z.Email, 'miroslav.hanzen@gmail.com') + ISNULL(';' + nad.Email, '') + ISNULL(';' + zod.Email, '') AS Email
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
	LEFT JOIN dbo.[Contracts] zml
		ON zml.[Id] = s.[ContractId]
	LEFT JOIN dbo.[Employees] zod
		ON zod.[Id] = zml.[ResponsibleEmployeeId]
		AND
		zod.[EmployeeStateId] != 2
where
	s.[Id] = @courseId
)
end