CREATE PROCEDURE [dbo].[SendSkolbozNotification]
AS
EXEC [dbo].[TaskNotification]
EXEC [dbo].[ContractNotification]
EXEC [dbo].[CourseNotification]
EXEC [dbo].[AOPNotification]