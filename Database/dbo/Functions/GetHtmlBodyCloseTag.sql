﻿CREATE FUNCTION dbo.GetHtmlBodyCloseTag()
RETURNS NVARCHAR(255) AS
BEGIN
RETURN N'
	</body>
</html>'
END