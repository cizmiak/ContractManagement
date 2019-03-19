CREATE TABLE [dbo].[ContactPersons] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [Name]          VARCHAR (20)  NULL,
    [LastName]    VARCHAR (20)  NULL,
    [UniversityDegree]         VARCHAR (10)  NULL,
    [Mail]          VARCHAR (100) NULL,
    [Phone]       VARCHAR (100) NULL,
    [Fax]           VARCHAR (100) NULL,
    [Note]      VARCHAR (MAX) NULL,
    [PersonStateId]        INT           NULL,
    [OrganizationId] INT           NULL,
    CONSTRAINT [PK_ContactPerson] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ContactPerson_ContactPersonStav] FOREIGN KEY ([PersonStateId]) REFERENCES [dbo].[ContactPersonStates] ([Id]),
    CONSTRAINT [FK_ContactPerson_Organizacia] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organizations] ([Id])
);

