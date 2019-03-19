CREATE FUNCTION dbo.GetAttendeeStateName
(@StateId INT)
RETURNS VARCHAR(50) AS
BEGIN
	RETURN
		(SELECT [Name] FROM dbo.[AttendeeStates] WHERE Id = @StateId)
END
