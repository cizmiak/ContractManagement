CREATE TABLE [dbo].[Organizations] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [Reference] VARCHAR (50)  NULL,
    [Name]      VARCHAR (100) NULL,
    [Note]   VARCHAR (MAX) NULL,
    [Street]      VARCHAR (100) NULL,
    [Zip]        VARCHAR (10)  NULL,
    [City]      VARCHAR (50)  NULL,
    [Mail]       VARCHAR (100) NULL,
    [Phone]    VARCHAR (100) NULL,
    [Fax]        VARCHAR (100) NULL,
    [OrganizationStateId]     INT           NULL,
    [CountryId]  INT           NULL,
    [ParentOrganizationId]      INT           NULL,
    [BusinessId]        VARCHAR (50)  NULL,
    [TaxId]        VARCHAR (50)  NULL,
    CONSTRAINT [PK_Organizacia] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Organizacia_Krajina] FOREIGN KEY ([CountryId]) REFERENCES [dbo].Country ([ID]),
    CONSTRAINT [FK_Organizacia_Matka] FOREIGN KEY ([ParentOrganizationId]) REFERENCES [dbo].[Organizations] ([Id]),
    CONSTRAINT [FK_Organizacia_OrganizaciaStav] FOREIGN KEY ([OrganizationStateId]) REFERENCES [dbo].[OrganizationStates] (Id)
);

