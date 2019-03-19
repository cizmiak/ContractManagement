CREATE TABLE [dbo].[StartupWorks] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [Order]       INT           NULL,
    [Name]         VARCHAR (100) NULL,
    [Description]         VARCHAR (500) NULL,
    [DaysToSolve] INT           NULL,
    [StartupWorkStateId]        INT           NULL,
    [ContractTypeId]   INT           NULL,
    CONSTRAINT [PK_StartupWorks] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_StartupWorks_StartupWorkStates] FOREIGN KEY ([StartupWorkStateId]) REFERENCES [dbo].[StartupWorkStates] ([Id]),
    CONSTRAINT [FK_StartupWorks_ContractTypes] FOREIGN KEY ([ContractTypeId]) REFERENCES [dbo].[ContractTypes] ([Id])
);

