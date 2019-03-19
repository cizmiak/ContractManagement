CREATE FUNCTION dbo.GetOrganizationName
(@OrganizationId INT)
RETURNS VARCHAR(100) AS BEGIN
RETURN
	(SELECT o.Name FROM dbo.[Organizations] o WHERE o.Id = @OrganizationId)
END
