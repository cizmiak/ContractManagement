CREATE FUNCTION [report].[GetContactPersonEmail]
(@OrganizationId INT)
RETURNS VARCHAR(MAX) AS
BEGIN
	DECLARE
		@emails VARCHAR(MAX)
		--,@matkaID INT

	SELECT
		@emails = ISNULL(@emails + ';', '') + ko.Mail
	FROM
		dbo.[ContactPersons] ko
	WHERE
		OrganizationId = @OrganizationId

	--SELECT @matkaID = Matka FROM dbo.Organizacia WHERE ID = @OrganizaciaID

	RETURN ISNULL(@emails, 'Nezadané') --+ report.GetContactPersonEmail(@matkaID)
END