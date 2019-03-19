CREATE TABLE [dbo].[CourseAttendeeTypeQuestions] (
    [Id]                INT IDENTITY (1, 1) NOT NULL,
    [CourseAttendeeTypeId] INT NOT NULL,
    [QuestionId]          INT NOT NULL,
    CONSTRAINT [PK_CourseAttendeeTypeQuestions] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_CourseAttendeeTypeQuestion_Question] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[Questions] ([Id]),
    CONSTRAINT [FK_CourseAttendeeTypeQuestion_CourseAttendeeType] FOREIGN KEY ([CourseAttendeeTypeId]) REFERENCES [dbo].[CourseAttendeeTypes] ([Id]),
    CONSTRAINT [UK_CourseAttendeeTypeQuestions] UNIQUE NONCLUSTERED ([CourseAttendeeTypeId] ASC, [QuestionId] ASC)
);

