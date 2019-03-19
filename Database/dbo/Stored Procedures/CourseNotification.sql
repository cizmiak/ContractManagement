CREATE PROCEDURE [dbo].[CourseNotification]
	@Today DATETIME = NULL
AS
DECLARE
	--@Today DATETIME,
	@organizaciaID INT
	,@emailBody NVARCHAR(MAX)
	,@email NVARCHAR(MAX)
	,@emailTmp NVARCHAR(MAX)
	,@newLine NVARCHAR(10) = N'<br/>'
	,@mailBodyContentSeparator NVARCHAR(511)
	,@subjectTemplate NVARCHAR(255) = 'Notifikácia nasledujúcich školení, organizáca: '
	,@subject NVARCHAR(255)
SET @mailBodyContentSeparator =
	@newLine + N'------------===========--------------------=====================--------------------===========------------' +
	@newLine + N'------------===========--------------------=====================--------------------===========------------' +
	@newLine + @newLine
SET @Today = FLOOR(CAST(ISNULL(@Today, GETDATE()) AS FLOAT))

DECLARE @skolenia TABLE (OrganizaciaID INT, SkolenieID INT, Email NVARCHAR(255));

INSERT @skolenia(OrganizaciaID, SkolenieID, Email)
SELECT [OrganizationId], SkolenieID, Email
FROM dbo.[CourseToNotificate](@Today);

DECLARE organizacie CURSOR FOR
SELECT OrganizaciaID FROM @skolenia GROUP BY OrganizaciaID;
OPEN organizacie;

FETCH NEXT FROM organizacie INTO @organizaciaID;
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @emailBody = NULL
	SET @emailTmp = NULL
	SET @email = NULL
	SELECT
		@emailBody = ISNULL(@emailBody + @mailBodyContentSeparator, dbo.GetHtmlBodyOpenTag()) + dbo.[GetCourseBodyContent](SkolenieID, @Today)
		,@emailTmp = ISNULL(@emailTmp + ';', '') + Email
	FROM @skolenia
	WHERE OrganizaciaID = @organizaciaID

	SET @emailBody = @emailBody + dbo.GetHtmlBodyCloseTag();

	/*odstranenie duplicit v zozname emailov*/
	SELECT
		@email = ISNULL(@email + ';', '') + Item
	FROM
		report.TableFromList(';', @emailTmp)
	GROUP BY
		Item

	--PRINT @emailBody
	--PRINT @email
	--print '********************************************************************'

	SET @subject = @subjectTemplate + dbo.GetOrganizationName(@organizaciaID)
	EXEC msdb.dbo.sp_send_dbmail
		@recipients = @email,
		@copy_recipients = 'miroslav.hanzen@gmail.com;monika.hanzenova@gmail.com',
		--@blind_copy_recipients = 'matej.cizmarik@2ring.com',
		@subject = @subject,
		@body = @emailBody,
		@body_format = 'HTML'

FETCH NEXT FROM organizacie INTO @organizaciaID;
END

CLOSE organizacie;
DEALLOCATE organizacie;
