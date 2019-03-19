CREATE TABLE [dbo].[Attendees] (
    Id                  INT           IDENTITY (1, 1) NOT NULL,
    [Name]                VARCHAR (50)  NULL,
    [LastName]          VARCHAR (50)  NULL,
    [UniversityDegree]               VARCHAR (10)  NULL,
    [WorkPositionId] INT           NULL,
    [BirthDate]      DATETIME      NULL,
    [Address]            VARCHAR (500) NULL,
    [OrganizationId]       INT           NULL,
    [AttendeeStateId]              INT           NULL,
    [OrganizationName]    AS            ([dbo].GetOrganizationName([OrganizationId])),
    AttendeeStateName           AS            ([dbo].GetAttendeeStateName([AttendeeStateId])),
    CONSTRAINT [PK_Posluchac] PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT [FK_Posluchac_Organizacia] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organizations] ([Id]),
    CONSTRAINT [FK_Posluchac_PosluchacStav] FOREIGN KEY ([AttendeeStateId]) REFERENCES [dbo].[AttendeeStates] (Id),
    CONSTRAINT [FK_Posluchac_PracovneZaradenie] FOREIGN KEY ([WorkPositionId]) REFERENCES [dbo].[WorkPositions] ([Id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TitulMenoPriezviskoOrganizacia_Unique]
    ON [dbo].[Attendees]([Name] ASC, [LastName] ASC, [UniversityDegree] ASC, [OrganizationId] ASC);

