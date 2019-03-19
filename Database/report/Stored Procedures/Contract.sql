CREATE PROCEDURE [report].[Zmluva]
(
	@now DATETIME = NULL,
	@fakturacia BIT = NULL,
	@StavID INT = NULL,
	@TypID INT = NULL,
	@ZodpovednyID INT = NULL
)
AS

/*debug_start*/
--DECLARE
--	@now DATETIME = NULL,
--	@fakturacia BIT = NULL,
--	@StavID INT = NULL,
--	@TypID INT = NULL
/*debug_end*/

SET @now = ISNULL(@now, GETDATE())

SELECT
	o.[Name] AS Organizacia,
	o.BusinessId,
	o.Street,
	o.City,
	o.Zip,
	--Ulica	Mesto	PSC	ICO

	z.[ContractNumber],
	z.[Name],
	zod.[LastName] + ' ' + zod.[FirstName] AS Zodpovedny,
	zt.[Name] AS Typ,
	zs.[Name] AS Stav,
	z.[ContractEffectiveDate],
	z.[ContractExpirationDate],
	z.[InvoicePeriod],
	--DATEDIFF(MONTH, CAST(YEAR(z.UcinnostZmluvyOd) AS VARCHAR(4)), @now) AS Difference,
	--DATEDIFF(MONTH, CAST(YEAR(z.UcinnostZmluvyOd) AS VARCHAR(4)), @now) % z.PeriodaFaktur AS Remainder,
	--CASE
	--	WHEN
	--		@now >
	--		DATEADD
	--		(
	--			MONTH, 1,
	--			CAST(YEAR(z.UcinnostZmluvyOd) AS VARCHAR(4)) + '-' + 
	--			CAST(MONTH(z.UcinnostZmluvyOd) AS VARCHAR(2)) + '-01'
	--		)
	--		AND
	--		DATEDIFF(MONTH, CAST(YEAR(z.UcinnostZmluvyOd) AS VARCHAR(4)), @now) % z.PeriodaFaktur = 0
	--	THEN 'true'
	--	ELSE 'false'
	--END InInvoice,
	--CAST(@now - DAY(@now) + 1 - z.UcinnostZmluvyOd AS FLOAT) AS citatel,
	--CAST(@now - DAY(@now) + 1 - DATEADD(MONTH, -z.PeriodaFaktur, @now - DAY(@now) + 1) AS FLOAT) AS menovatel,
	CASE
		WHEN
			CAST(@now - DAY(@now) + 1 - z.[ContractEffectiveDate] AS FLOAT) <
			CAST(@now - DAY(@now) + 1 - DATEADD(MONTH, -z.[InvoicePeriod], @now - DAY(@now) + 1) AS FLOAT)
		THEN
			CAST(@now - DAY(@now) + 1 - z.[ContractEffectiveDate] AS FLOAT) /
			CAST(@now - DAY(@now) + 1 - DATEADD(MONTH, -z.[InvoicePeriod], @now - DAY(@now) + 1) AS FLOAT)
		ELSE 1.0
	END AS PriceRatio,			
	z.[AgreedPrice],
	z.[DateUpdated],
	up.[LastName] + ' ' + up.[FirstName] AS Upravil
FROM
	dbo.[Contracts] z
	LEFT JOIN dbo.[Organizations] o
		ON o.Id = z.[OrganizationId]
	LEFT JOIN dbo.[ContractTypes] zt
		ON zt.[Id] = z.[ContractTypeId]
	LEFT JOIN dbo.[ContractStates] zs
		ON zs.[Id] = z.[ContractStateId]
	LEFT JOIN dbo.[Employees] up
		ON up.[Id] = z.[UpdateEmployeeId]
	LEFT JOIN dbo.[Employees] zod
		ON zod.[Id] = z.[ResponsibleEmployeeId]
WHERE
	(
		@now >=
		DATEADD
		(
			MONTH, 1,
			z.[ContractEffectiveDate] - DAY(z.[ContractEffectiveDate]) + 1
		)
		AND
		DATEDIFF(MONTH, CAST(YEAR(z.[ContractEffectiveDate]) AS VARCHAR(4)), @now) % z.[InvoicePeriod] = 0
		AND
		z.[ContractStateId] = 1 --len aktivne
		AND
		@fakturacia = 1
		OR
		ISNULL(@fakturacia, 0) = 0 
	)
	AND
	(
		z.[ContractStateId] = @StavID
		OR
		@StavID IS NULL
	)
	AND
	(
		z.[ContractTypeId] = @TypID
		OR
		@TypID IS NULL
	)
	AND
	(
		z.[ResponsibleEmployeeId] = @ZodpovednyID
		OR
		ISNULL(@ZodpovednyID, -1) = -1
	)
