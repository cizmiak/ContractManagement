CREATE TABLE [dbo].[ContractScopes] (
    [ContractId] INT NOT NULL,
    [ScopeId] INT NOT NULL,
    CONSTRAINT [PK_ContractScopes] PRIMARY KEY CLUSTERED ([ContractId] ASC, [ScopeId] ASC),
    CONSTRAINT [FK_ContractScopes_Scopes] FOREIGN KEY ([ScopeId]) REFERENCES [dbo].[Scopes] ([Id]),
    CONSTRAINT [FK_ContractScopes_Contracts] FOREIGN KEY ([ContractId]) REFERENCES [dbo].[Contracts] ([Id])
);

