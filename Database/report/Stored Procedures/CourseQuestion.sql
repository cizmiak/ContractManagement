CREATE PROCEDURE report.[CourseQuestion]
	@SkolenieID INT
AS
SELECT
	so.[Order]
	,o.[Text]
FROM
	dbo.[CourseQuestions] so
	INNER JOIN dbo.[Questions] o
		on o.Id = so.[QuestionId]
WHERE
	so.[CourseId] = @SkolenieID
