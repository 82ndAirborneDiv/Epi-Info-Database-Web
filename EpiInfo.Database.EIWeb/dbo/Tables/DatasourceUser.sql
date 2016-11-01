CREATE TABLE [dbo].[DatasourceUser](
	[DatasourceID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
 CONSTRAINT [PK_DatasourceUser] PRIMARY KEY CLUSTERED 
(
	[DatasourceID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DatasourceUser]  WITH CHECK ADD  CONSTRAINT [FK_DatasourceUser_Datasource] FOREIGN KEY([DatasourceID])
REFERENCES [dbo].[Datasource] ([DatasourceID])
GO

ALTER TABLE [dbo].[DatasourceUser] CHECK CONSTRAINT [FK_DatasourceUser_Datasource]
GO
ALTER TABLE [dbo].[DatasourceUser]  WITH CHECK ADD  CONSTRAINT [FK_DatasourceUser_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO

ALTER TABLE [dbo].[DatasourceUser] CHECK CONSTRAINT [FK_DatasourceUser_User]