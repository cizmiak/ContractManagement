CREATE FUNCTION [report].[LastCourseOfAttendee]
(
	@skolenieID INT
	,@poskuchacID INT
) RETURNS TABLE
AS RETURN
SELECT TOP 1
	s.[Id] AS SkolenieID,
	s.[Reference],
	s.[Name],
	s.[CourseDate]
FROM
	dbo.[CourseAttendees] sp
	INNER JOIN dbo.[Courses] s
		ON s.[Id] = sp.[CourseId]
WHERE
	sp.[AttendeeId] = @poskuchacID
	AND
	s.[CourseTypeId] = (SELECT [CourseTypeId] FROM dbo.[Courses] WHERE [Id] = @skolenieID)
ORDER BY
	s.[CourseDate] DESC
