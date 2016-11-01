CREATE TABLE [dbo].[ResponseDisplaySettings](
	[FormId] [uniqueidentifier] NOT NULL,
	[ColumnName] [varchar](200) NOT NULL,
	[SortOrder] [int] NOT NULL,
 CONSTRAINT [PK_ResponseGridcolumns] PRIMARY KEY CLUSTERED 
(
	[FormId] ASC,
	[ColumnName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ResponseDisplaySettings]  WITH CHECK ADD  CONSTRAINT [FK_ResponseGridcolumns_SurveyMetaData] FOREIGN KEY([FormId])
REFERENCES [dbo].[SurveyMetaData] ([SurveyId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ResponseDisplaySettings] CHECK CONSTRAINT [FK_ResponseGridcolumns_SurveyMetaData]