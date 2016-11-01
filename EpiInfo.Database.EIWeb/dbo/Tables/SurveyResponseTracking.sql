CREATE TABLE [dbo].[SurveyResponseTracking](
	[ResponseId] [uniqueidentifier] NOT NULL,
	[IsSQLResponse] [bit] NOT NULL,
	[IsResponseinsertedToEpi7] [bit] NOT NULL,
 CONSTRAINT [PK_SurveyResponseTracking] PRIMARY KEY CLUSTERED 
(
	[ResponseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurveyResponseTracking]  WITH CHECK ADD  CONSTRAINT [FK_SurveyResponseTracking_SurveyResponse] FOREIGN KEY([ResponseId])
REFERENCES [dbo].[SurveyResponse] ([ResponseId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SurveyResponseTracking] CHECK CONSTRAINT [FK_SurveyResponseTracking_SurveyResponse]