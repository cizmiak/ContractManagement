CREATE TABLE [dbo].[Entities] (
    [Id]       INT          IDENTITY (1, 1) NOT NULL,
    [TableName]  NVARCHAR (128) NULL,
    [ParentEntityId] INT          NULL,
    CONSTRAINT [PK_Entity] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Entity_Parent] FOREIGN KEY ([ParentEntityId]) REFERENCES [dbo].[Entities] ([Id])
);

