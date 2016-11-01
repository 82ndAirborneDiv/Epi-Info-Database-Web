CREATE TABLE [dbo].[SurveyResponseUser](
	[UserId] [int] NOT NULL,
	[ResponseId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SurveyResponseUser] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[ResponseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurveyResponseUser]  WITH CHECK ADD  CONSTRAINT [FK_SurveyResponseUser_SurveyResponse] FOREIGN KEY([ResponseId])
REFERENCES [dbo].[SurveyResponse] ([ResponseId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SurveyResponseUser] CHECK CONSTRAINT [FK_SurveyResponseUser_SurveyResponse]
GO
ALTER TABLE [dbo].[SurveyResponseUser]  WITH CHECK ADD  CONSTRAINT [FK_SurveyResponseUser_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserID])
GO

ALTER TABLE [dbo].[SurveyResponseUser] CHECK CONSTRAINT [FK_SurveyResponseUser_User]