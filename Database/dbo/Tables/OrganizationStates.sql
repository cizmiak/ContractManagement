CREATE TABLE [dbo].[OrganizationStates] (
    Id    INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NULL,
    CONSTRAINT [PK_OrganizationStates] PRIMARY KEY CLUSTERED (Id ASC)
);

