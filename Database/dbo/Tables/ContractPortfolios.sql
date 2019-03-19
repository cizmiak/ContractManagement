CREATE TABLE [dbo].[ContractPortfolios] (
    [ContractId]    INT NOT NULL,
    [PortfolioID] INT NOT NULL,
    [Period]     INT NULL,
    [SolverEmployeeId]    INT NULL,
    CONSTRAINT [PK_ContractPortfolios] PRIMARY KEY CLUSTERED ([ContractId] ASC, [PortfolioID] ASC),
    CONSTRAINT [FK_ContractPortfolios_Portfolios] FOREIGN KEY ([PortfolioID]) REFERENCES [dbo].[Portfolios] ([Id]),
    CONSTRAINT [FK_ContractPortfolios_SolverEmployees] FOREIGN KEY ([SolverEmployeeId]) REFERENCES [dbo].[Employees] ([Id]),
    CONSTRAINT [FK_ContractPortfolios_Contracts] FOREIGN KEY ([ContractId]) REFERENCES [dbo].[Contracts] ([Id])
);

