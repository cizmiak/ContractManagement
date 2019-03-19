CREATE TABLE [dbo].[StartupWorkStates] (
    [Id]    INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NULL,
    CONSTRAINT [PK_StartupWorkStates] PRIMARY KEY CLUSTERED ([Id] ASC)
);

