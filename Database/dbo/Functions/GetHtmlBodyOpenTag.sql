CREATE FUNCTION dbo.GetHtmlBodyOpenTag()
RETURNS NVARCHAR(2047) AS
BEGIN
RETURN N'<!DOCTYPE html>
<html>
	<head>
		' + dbo.GetEmailStyle() + '
	</head>
	<body>
'
END