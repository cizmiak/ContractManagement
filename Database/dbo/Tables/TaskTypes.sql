CREATE TABLE [dbo].[TaskTypes] (
    [Id]           INT          IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (50) NULL,
    [Notification1st] INT          NULL,
    [Notification2nd] INT          NULL,
    [Notification3rd] INT          NULL,
    CONSTRAINT [PK_TaskTypes] PRIMARY KEY CLUSTERED ([Id] ASC)
);

