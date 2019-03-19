CREATE TABLE [dbo].[MeasurementUnits] (
    [Id]      INT          IDENTITY (1, 1) NOT NULL,
    [Symbol]  VARCHAR (5)  NULL,
    [Name]   VARCHAR (10) NULL,
    [SQLName] VARCHAR (10) NULL,
    CONSTRAINT [PK_MeasurementUnits] PRIMARY KEY CLUSTERED ([Id] ASC)
);

