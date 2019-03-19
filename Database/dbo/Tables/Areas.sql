CREATE TABLE [dbo].[Areas] (
    [Id]    INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NULL,
    CONSTRAINT [PK_Area] PRIMARY KEY CLUSTERED ([Id] ASC)
);

