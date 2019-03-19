CREATE procedure [dbo].[AOPNotification] as
declare @today datetime = getdate()
declare @body varchar(max), @email varchar(1024)
declare @skolenieID int, @dni varchar(10), @organizaciaID int
declare cur cursor for
select
	id, days, organizationId
from
	dbo.[AOPCourseToNotificate](@today)

open cur
fetch next from cur into @skolenieID, @dni, @organizaciaID

while @@FETCH_STATUS = 0
begin

SET @body = '<!DOCTYPE html>
<html>
	<head>
		<style type="text/css">
			body {font-family: Tahoma; font-size: 10pt;}
			.label {font-weight: bold; padding-right: 10px;}
			.bold {font-weight: bold;}
			th {font-weight: bold; text-align: left; padding-left: 10px;}
			td {padding-left: 10px;}
			.red {color: red;}
		 </style>
	</head>
	<body>
O ' + @dni +' dní uplynie 5 rokov od vydania preukazov:<br/><br/>'
+ [dbo].[GetCourseEmailTable](@skolenieID) + '<br/>
--------------------------------------------------------------------------------------------------
<br/>E-mail kontaktných osôb:<br/>
' + report.GetContactPersonEmail(@organizaciaID) + '<br/>
--------------------------------------------------------------------------------------------------
<br/><br/>Zoznam osôb, ktoré absolvovali školenie:<br/><br/>'
+ dbo.[AttendeeAtCourseHTML](@skolenieID, null) +
'<br/>Prosíme Vás o aktualizáciu zoznamu osôb ako aj návrh možného termínu periodického školenia.
<br/><br/>Ďakujem,
<br/>
	</body>
</html>'
--print @body
--print ''

set @email = dbo.CourseEmailToNotificate(@skolenieID)
EXEC msdb.dbo.sp_send_dbmail
@recipients = @email,
@copy_recipients = 'miroslav.hanzen@gmail.com;monika.hanzenova@gmail.com',
@blind_copy_recipients = 'matej.cizmarik@2ring.com',
@subject = 'Notifikácia AOP',
@body = @body,
@body_format = 'HTML'

fetch next from cur into @skolenieID, @dni, @organizaciaID
end

close cur
deallocate cur
