CREATE TABLE [dbo].[CourseKinds] (
    [Id]    INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NULL,
    CONSTRAINT [PK_CourseKinds] PRIMARY KEY CLUSTERED ([Id] ASC)
);

