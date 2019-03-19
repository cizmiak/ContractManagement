CREATE TABLE [dbo].[ContractStates] (
    [Id]    INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NULL,
    CONSTRAINT [PK_ContractStates] PRIMARY KEY CLUSTERED ([Id] ASC)
);

