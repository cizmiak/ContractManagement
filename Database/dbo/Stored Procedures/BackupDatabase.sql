CREATE PROCEDURE dbo.BackupDatabase
(
	@databaseName NVARCHAR(128) = 'SpravaZmluv'
	,@backupFolder NVARCHAR(1024) = N'E:\SpravaZmluv_Backup'
	,@backupName NVARCHAR(128) = NULL
)
AS
--DECLARE
--	@databaseName NVARCHAR(128) = 'SpravaZmluv'
--	,@backupFolder NVARCHAR(1024) = N'E:\SpravaZmluv_Backup'
--	,@backupName NVARCHAR(128) = NULL

DECLARE
	@backupPath NVARCHAR(2014)

IF RIGHT(@backupFolder, 1) != '\'
BEGIN
	SET @backupFolder = @backupFolder + '\'
END

SET @backupPath = @backupFolder + @databaseName + '_' + REPLACE(CONVERT(NVARCHAR(10), GETDATE(), 20), ' ', '_') + '.bak'

IF @backupName IS NULL
BEGIN
	SET @backupName = @databaseName + N'-Full Database Backup'
END

--PRINT @backupPath
--PRINT @backupName

BACKUP DATABASE @databaseName
TO DISK = @backupPath
WITH
	NAME = @backupName,
	FORMAT,
	INIT,
	SKIP,
	NOREWIND,
	NOUNLOAD
