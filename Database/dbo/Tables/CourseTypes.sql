CREATE TABLE [dbo].[CourseTypes] (
    [Id]                 INT          IDENTITY (1, 1) NOT NULL,
    [Name]              VARCHAR (50) NULL,
    [Notification1st]       INT          NULL,
    [Notification2nd]       INT          NULL,
    [Notification3rd]       INT          NULL,
    [CourseTypeLicenseNumber]    VARCHAR (50) NULL,
    [CourseAttendeeLicenseNumberMask] VARCHAR (50) NULL,
    CONSTRAINT [PK_SkolenieTyp] PRIMARY KEY CLUSTERED ([Id] ASC)
);

