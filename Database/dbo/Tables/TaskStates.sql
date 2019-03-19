CREATE TABLE [dbo].[TaskStates] (
    [Id]    INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NULL,
    CONSTRAINT [PK_TaskStates] PRIMARY KEY CLUSTERED ([Id] ASC)
);

