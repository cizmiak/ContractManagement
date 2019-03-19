CREATE TABLE [dbo].[PortfolioStates] (
    [Id]    INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NULL,
    CONSTRAINT [PK_PortfolioStates] PRIMARY KEY CLUSTERED ([Id] ASC)
);

