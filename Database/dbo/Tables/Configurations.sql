CREATE TABLE [dbo].[Configurations] (
    [Id]        INT IDENTITY (1, 1) NOT NULL,
    [Key]		NVARCHAR (127) NOT NULL,
    [Value]		NVARCHAR (511) NOT NULL,
    [ValidFrom] DATETIME NULL,
    [ValidTo]	DATETIME NULL,
    CONSTRAINT [PK_Configuration] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Key_Value]
    ON [dbo].[Configuration]([Key] ASC, [Value] ASC);

