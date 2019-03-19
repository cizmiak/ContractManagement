CREATE function [dbo].[AOPCourseToNotificate]
(@today datetime) returns @courses table
(
	id int,
	[days] varchar(10),
	organizationId int
) AS
begin

set @today = FLOOR(CAST(@today AS FLOAT))

insert @courses (id, [days], organizationId)
select
	s.[Id],
	str(cast(FLOOR
	(
		CAST
		(
			DATEADD(YEAR, 5, ISNULL(sp.[LicenseReleaseDate], s.[LicenseReleaseDate])) AS FLOAT
		)
	) - @today as float)) as dni,
	s.[OrganizationId]
from
	dbo.[CourseAttendees] sp
	inner join dbo.[Courses] s
		on s.[Id] = sp.[CourseId]
where
	FLOOR
	(
		CAST
		(
			DATEADD(YEAR, 5, ISNULL(sp.[LicenseReleaseDate], s.[LicenseReleaseDate])) AS FLOAT
		)
	) - @today = 14
group by
	s.[Id],
	FLOOR
	(
		CAST
		(
			DATEADD(YEAR, 5, ISNULL(sp.[LicenseReleaseDate], s.[LicenseReleaseDate])) AS FLOAT
		)
	) - @today,
	s.[OrganizationId]
return

end