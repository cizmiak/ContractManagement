CREATE TABLE [dbo].[Portfolios] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Reference]  NVARCHAR (50)  NULL,
    [Name]       NVARCHAR (256) NULL,
    [Description]       NVARCHAR (512) NULL,
    [RevenuePrice]   MONEY          NULL,
    [CostPrice]  MONEY          NULL,
    [PortfolioStateId]      INT            NULL,
    [PortfolioCategoryId] INT            NULL,
    CONSTRAINT [PK_Portfolio] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Portfolio_PortfolioCategory] FOREIGN KEY ([PortfolioCategoryId]) REFERENCES [dbo].[PortfolioCategories] ([Id]),
    CONSTRAINT [FK_Portfolio_PortfolioState] FOREIGN KEY ([PortfolioStateId]) REFERENCES [dbo].[PortfolioStates] ([Id])
);

