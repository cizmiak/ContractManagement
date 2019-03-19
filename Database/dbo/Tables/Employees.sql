CREATE TABLE [dbo].[Employees] (
    [Id]         INT             IDENTITY (1, 1) NOT NULL,
    [Login]      VARCHAR (50)    NULL,
    [FirstName]       VARCHAR (50)    NULL,
    [LastName] VARCHAR (50)    NULL,
    [UniversityDegree]      VARCHAR (10)    NULL,
    [Position]    VARCHAR (100)   NULL,
    [ManagerEmployeeId] INT             NULL,
    [EmployeeStateId]     INT             NULL,
    [RoleId]     INT             NULL,
    [Email]      VARCHAR (100)   NULL,
    [Signature]     VARBINARY (MAX) NULL,
    CONSTRAINT [PK_Zamestnanec] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Zamestnanec_Nadriadeny] FOREIGN KEY ([ManagerEmployeeId]) REFERENCES [dbo].[Employees] ([Id]),
    CONSTRAINT [FK_Zamestnanec_Rola] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([Id]),
    CONSTRAINT [FK_Zamestnanec_ZamestnanecStav] FOREIGN KEY ([EmployeeStateId]) REFERENCES [dbo].[EmployeeStates] ([Id])
);

