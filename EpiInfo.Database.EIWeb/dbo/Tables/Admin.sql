

CREATE TABLE [dbo].[Admin](
	[AdminId] [uniqueidentifier] NOT NULL,
	[AdminEmail] [varchar](300) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Notify] [bit] NOT NULL,
	[LastName] [varchar](150) NULL,
	[FirstName] [varchar](150) NULL,
	[PhoneNumber] [varchar](50) NULL,
 CONSTRAINT [PK_Admin] PRIMARY KEY CLUSTERED 
(
	[AdminId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



ALTER TABLE [dbo].[Admin] ADD  CONSTRAINT [DF_Admin_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[Admin] ADD  CONSTRAINT [DF_Admin_Notify]  DEFAULT ((0)) FOR [Notify]
GO

ALTER TABLE [dbo].[Admin]  WITH CHECK ADD  CONSTRAINT [FK_Admin_Organization] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO

ALTER TABLE [dbo].[Admin] CHECK CONSTRAINT [FK_Admin_Organization]
GO


