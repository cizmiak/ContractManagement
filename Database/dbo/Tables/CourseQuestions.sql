CREATE TABLE [dbo].[CourseQuestions] (
    [Id]         INT IDENTITY (1, 1) NOT NULL,
    [Order]    INT NOT NULL,
    [CourseId] INT NOT NULL,
    [QuestionId]   INT NOT NULL,
    CONSTRAINT [PK_CourseQuestions] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Course_CourseQuestion] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[Questions] ([Id]),
    CONSTRAINT [FK_CourseQuestion_Course] FOREIGN KEY ([CourseId]) REFERENCES [dbo].[Courses] ([Id]),
    CONSTRAINT [UK_CourseQuestion] UNIQUE NONCLUSTERED ([CourseId] ASC, [QuestionId] ASC)
);

