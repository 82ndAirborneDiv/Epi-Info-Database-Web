CREATE TABLE [dbo].[SourceTables] (
    [SourceTableName] VARCHAR (200)    NOT NULL,
    [FormId]          UNIQUEIDENTIFIER NOT NULL,
    [SourceTableXml]  XML              NOT NULL,
    CONSTRAINT [PK_SourceTables] PRIMARY KEY CLUSTERED ([SourceTableName] ASC, [FormId] ASC)
);

