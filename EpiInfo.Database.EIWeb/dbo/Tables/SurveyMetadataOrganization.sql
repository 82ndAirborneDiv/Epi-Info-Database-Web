CREATE TABLE [dbo].[SurveyMetadataOrganization](
	[SurveyId] [uniqueidentifier] NOT NULL,
	[OrganizationId] [int] NOT NULL,
 CONSTRAINT [PK_SurveyMetadataOrganization] PRIMARY KEY CLUSTERED 
(
	[SurveyId] ASC,
	[OrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurveyMetadataOrganization]  WITH CHECK ADD  CONSTRAINT [FK_SurveyMetadataOrganization_Organization] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO

ALTER TABLE [dbo].[SurveyMetadataOrganization] CHECK CONSTRAINT [FK_SurveyMetadataOrganization_Organization]
GO
ALTER TABLE [dbo].[SurveyMetadataOrganization]  WITH CHECK ADD  CONSTRAINT [FK_SurveyMetadataOrganization_SurveyMetaData] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[SurveyMetaData] ([SurveyId])
GO

ALTER TABLE [dbo].[SurveyMetadataOrganization] CHECK CONSTRAINT [FK_SurveyMetadataOrganization_SurveyMetaData]