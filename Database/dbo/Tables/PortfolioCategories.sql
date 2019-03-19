CREATE TABLE [dbo].[PortfolioCategories] (
    [Id]    INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NULL,
    CONSTRAINT [PK_PortfolioCategories] PRIMARY KEY CLUSTERED ([Id] ASC)
);

