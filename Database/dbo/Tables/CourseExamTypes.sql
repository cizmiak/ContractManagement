CREATE TABLE [dbo].[CourseExamTypes] (
    [Id]    INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NULL,
    CONSTRAINT [PK_CourseExamTypes] PRIMARY KEY CLUSTERED ([Id] ASC)
);

