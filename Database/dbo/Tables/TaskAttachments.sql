CREATE TABLE [dbo].[TaskAttachments] (
    [Id]      INT           IDENTITY (1, 1) NOT NULL,
    [TaskId] INT           NULL,
    [RelativePath]   VARCHAR (512) NULL,
    CONSTRAINT [PK_TaskAttachments] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TaskAttachments_Tasks] FOREIGN KEY ([TaskId]) REFERENCES [dbo].[Tasks] ([Id])
);

