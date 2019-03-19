CREATE TABLE [dbo].[Questions] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [Text]    VARCHAR (MAX) NOT NULL,
    [Check_Sum] AS            (checksum([Text])),
    CONSTRAINT [PK_Questions] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_Questions] UNIQUE NONCLUSTERED ([Check_Sum] ASC)
);

