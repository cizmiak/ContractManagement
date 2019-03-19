CREATE FUNCTION [report].[TableFromList]
(
	@Separator VARCHAR(1),
	@String VARCHAR(MAX)
)
RETURNS @Items TABLE
(
	Item VARCHAR(50)
)
AS
BEGIN
WHILE CHARINDEX(@Separator, @String) > 0
BEGIN
	
	INSERT INTO @Items
	VALUES(LEFT(@String, CHARINDEX(@Separator, @String) - 1))
	
	SET	@String = RIGHT(@String, LEN(@String) - CHARINDEX(@Separator, @String))
		
END

INSERT INTO @Items
VALUES(@String)

RETURN
END
