CREATE TABLE [dbo].[CourseTypeQuestions] (
    [Id]            INT IDENTITY (1, 1) NOT NULL,
    [CourseTypeId] INT NOT NULL,
    [QuestionId]      INT NOT NULL,
    CONSTRAINT [PK_CourseTypeQuestions] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_CourseTypeQuestions_Questions] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[Questions] ([Id]),
    CONSTRAINT [FK_CourseTypeQuestions_CourseTypes] FOREIGN KEY ([CourseTypeId]) REFERENCES [dbo].[CourseTypes] ([Id]),
    CONSTRAINT [UK_CourseTypeQuestions] UNIQUE NONCLUSTERED ([CourseTypeId] ASC, [QuestionId] ASC)
);

