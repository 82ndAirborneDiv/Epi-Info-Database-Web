CREATE TABLE [dbo].[Datasource](
	[DatasourceID] [int] IDENTITY(1,1) NOT NULL,
	[DatasourceName] [nvarchar](300) NULL,
	[OrganizationID] [int] NOT NULL,
	[DatasourceServerName] [varchar](300) NULL,
	[DatabaseType] [varchar](50) NOT NULL,
	[InitialCatalog] [varchar](300) NULL,
	[PersistSecurityInfo] [varchar](50) NULL,
	[EIWSDatasource] [bit] NOT NULL CONSTRAINT [DF_Datasource_EIWSDatasource_1]  DEFAULT ((0)),
	[EIWSSurveyId] [uniqueidentifier] NULL,
	[DatabaseUserID] [varchar](200) NULL,
	[Password] [varchar](200) NULL,
	[DatabaseObject] [varchar](max) NOT NULL,
	[SQLQuery] [bit] NULL,
	[SQLText] [varchar](max) NULL,
	[active] [bit] NOT NULL,
	[portnumber] [varchar](50) NULL,
 CONSTRAINT [PK_Datasource1] PRIMARY KEY CLUSTERED 
(
	[DatasourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_DatasourceName] UNIQUE NONCLUSTERED 
(
	[DatasourceName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Datasource]  WITH CHECK ADD  CONSTRAINT [FK_Datasource_Organization] FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO

ALTER TABLE [dbo].[Datasource] CHECK CONSTRAINT [FK_Datasource_Organization]