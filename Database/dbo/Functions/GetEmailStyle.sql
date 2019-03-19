CREATE FUNCTION [dbo].[GetEmailStyle]()
RETURNS NVARCHAR(511) AS
BEGIN
RETURN '<style type="text/css">
			body {font-family: Tahoma; font-size: 10pt;}
			.label {font-weight: bold; padding-right: 10px;}
			.bold {font-weight: bold;}
			th {font-weight: bold; text-align: left; padding-left: 10px;}
			td {padding-left: 10px;}
			.red {color: red;}
		 </style>'
END