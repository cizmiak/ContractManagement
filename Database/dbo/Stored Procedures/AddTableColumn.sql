CREATE procedure dbo.AddTableColumn
	@table nvarchar(128),
	@column nvarchar(128),
	@type nvarchar(128)
as
if not exists (select * from sys.columns where object_id = object_id(@table) and name = @column)
begin
	exec ('alter table ' + @table + ' add ' + @column + ' ' + @type)
end
