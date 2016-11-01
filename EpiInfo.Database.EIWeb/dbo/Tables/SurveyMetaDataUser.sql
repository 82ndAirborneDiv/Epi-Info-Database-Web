CREATE TABLE [dbo].[SurveyMetaDataUser](
	[UserId] [int] NOT NULL,
	[FormId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SurveyMetaDataUser_1] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[FormId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurveyMetaDataUser]  WITH CHECK ADD  CONSTRAINT [FK_SurveyMetaDataUser_SurveyMetaData] FOREIGN KEY([FormId])
REFERENCES [dbo].[SurveyMetaData] ([SurveyId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SurveyMetaDataUser] CHECK CONSTRAINT [FK_SurveyMetaDataUser_SurveyMetaData]
GO
ALTER TABLE [dbo].[SurveyMetaDataUser]  WITH CHECK ADD  CONSTRAINT [FK_SurveyMetaDataUser_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserID])
GO

ALTER TABLE [dbo].[SurveyMetaDataUser] CHECK CONSTRAINT [FK_SurveyMetaDataUser_User]