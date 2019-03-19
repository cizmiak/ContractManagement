CREATE TABLE [dbo].[ContactPersonStates] (
    [Id]    INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NULL,
    CONSTRAINT [PK_ContactPersonStates] PRIMARY KEY CLUSTERED ([Id] ASC)
);

