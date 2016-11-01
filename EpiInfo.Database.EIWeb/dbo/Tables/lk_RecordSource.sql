CREATE TABLE [dbo].[lk_RecordSource](
	[RecordSourceId] [int] NOT NULL,
	[RecordSource] [nvarchar](50) NOT NULL,
	[RecordSourceDescription] [nvarchar](100) NULL,
 CONSTRAINT [PK_lk_RecordSource] PRIMARY KEY CLUSTERED 
(
	[RecordSourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]