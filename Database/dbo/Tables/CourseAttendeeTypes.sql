CREATE TABLE [dbo].[CourseAttendeeTypes] (
    [Id]    INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NULL,
    CONSTRAINT [PK_CourseAttendeeTypes] PRIMARY KEY CLUSTERED ([Id] ASC)
);

