CREATE TABLE [dbo].[AttendeeStates] (
    Id    INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NULL,
    CONSTRAINT [PK_PosluchacStav] PRIMARY KEY CLUSTERED (Id ASC)
);

