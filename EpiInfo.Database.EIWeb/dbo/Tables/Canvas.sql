CREATE TABLE [dbo].[Canvas](
	[CanvasID] [int] IDENTITY(1,1) NOT NULL,
	[CanvasGUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Canvas_CanvasGUID]  DEFAULT (newid()),
	[CanvasName] [varchar](50) NOT NULL,
	[UserID] [int] NOT NULL,
	[CanvasDescription] [varchar](max) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[DatasourceID] [int] NOT NULL,
	[CanvasContent] [NVARCHAR](MAX) NOT NULL,
 CONSTRAINT [PK_Canvas] PRIMARY KEY CLUSTERED 
(
	[CanvasID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Canvas]  WITH CHECK ADD  CONSTRAINT [FK_Canvas _Datasource] FOREIGN KEY([DatasourceID])
REFERENCES [dbo].[Datasource] ([DatasourceID])
GO

ALTER TABLE [dbo].[Canvas] CHECK CONSTRAINT [FK_Canvas _Datasource]
GO
ALTER TABLE [dbo].[Canvas]  WITH CHECK ADD  CONSTRAINT [FK_Canvas_CreatorUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO

ALTER TABLE [dbo].[Canvas] CHECK CONSTRAINT [FK_Canvas_CreatorUser]