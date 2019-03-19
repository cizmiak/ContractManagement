CREATE TABLE [dbo].[ContractTypes] (
    [Id]    INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NULL,
    CONSTRAINT [PK_ContractTypes] PRIMARY KEY CLUSTERED ([Id] ASC)
);

