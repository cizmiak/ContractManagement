CREATE FUNCTION report.[CourseZHourCount]
(
	@SkolenieID INT
) RETURNS FLOAT
AS
BEGIN

--DECLARE
--	@SkolenieID INT = 1014
RETURN (
SELECT
	report.MaxFloat(MAX(CAST(k.[Value] AS FLOAT)), s_voziky_druh_unpivoted.Z_PocetHodin)
FROM
	(
		SELECT
			s.[Id] AS SkolenieID
			,s.Z_PocetHodin
			,s.A
			,s.B
			,s.C
			,s.C_BezVodickehoOpravnenia
			,s.D
			,s.E
			,s.W1
			,s.W1_BezVodickehoOpravnenia
			,s.W2
			,s.G
			,s.Z
		FROM
			dbo.[Courses] s
		WHERE
			s.[Id] = @SkolenieID
	) s
	UNPIVOT
	(
		VozikyDruhNaSkoleni FOR VozikyDruhOznacenie IN
		(
			A
			,B
			,C
			,C_BezVodickehoOpravnenia
			,D
			,E
			,W1
			,W1_BezVodickehoOpravnenia
			,W2
			,G
			,Z
		)
	) AS s_voziky_druh_unpivoted
	LEFT JOIN dbo.[Configurations] k
		ON k.[Key] = s_voziky_druh_unpivoted.VozikyDruhOznacenie
WHERE
	s_voziky_druh_unpivoted.VozikyDruhNaSkoleni = 1
GROUP BY
	s_voziky_druh_unpivoted.SkolenieID,
	s_voziky_druh_unpivoted.Z_PocetHodin
)

END
