CREATE TABLE [dbo].[EIDatasource](
	[DatasourceID] [int] IDENTITY(1,1) NOT NULL,
	[DatasourceServerName] [varchar](300) NULL,
	[DatabaseType] [varchar](50) NOT NULL,
	[InitialCatalog] [varchar](300) NULL,
	[PersistSecurityInfo] [varchar](50) NULL,
	[SurveyId] [uniqueidentifier] NULL,
	[DatabaseUserID] [varchar](200) NULL,
	[Password] [varchar](200) NULL,
 CONSTRAINT [PK_Datasource] PRIMARY KEY CLUSTERED 
(
	[DatasourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EIDatasource]  WITH CHECK ADD  CONSTRAINT [FK_Datasource_SurveyMetaData] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[SurveyMetaData] ([SurveyId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[EIDatasource] CHECK CONSTRAINT [FK_Datasource_SurveyMetaData]