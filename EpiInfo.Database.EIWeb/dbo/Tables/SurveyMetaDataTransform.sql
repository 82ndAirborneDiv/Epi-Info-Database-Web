CREATE TABLE [dbo].[SurveyMetaDataTransform](
	[SurveyId] [uniqueidentifier] NOT NULL,
	[TableName] [nvarchar](500) NOT NULL,
	[BaseTableName] [nvarchar](500) NULL,
	[PageId] [int] NULL,
	[FieldName] [nvarchar](500) NOT NULL,
	[FieldTypeId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurveyMetaDataTransform]  WITH CHECK ADD  CONSTRAINT [FK_SurveyMetaDataTransform_SurveyMetaData] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[SurveyMetaData] ([SurveyId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SurveyMetaDataTransform] CHECK CONSTRAINT [FK_SurveyMetaDataTransform_SurveyMetaData]