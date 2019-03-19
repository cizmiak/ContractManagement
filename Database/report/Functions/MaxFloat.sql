CREATE FUNCTION [report].[MaxFloat]
(
	@float1 FLOAT,
	@float2 FLOAT
) RETURNS FLOAT
AS
BEGIN
	RETURN
		CASE
			WHEN @float1 > @float2
				THEN @float1
			ELSE
				ISNULL(@float2, @float1)
		END
END