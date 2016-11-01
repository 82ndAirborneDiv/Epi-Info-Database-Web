CREATE TABLE [dbo].[UserOrganization](
	[UserID] [int] NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_UserOrganization] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[OrganizationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserOrganization]  WITH CHECK ADD  CONSTRAINT [FK_UserOrganization_Organization] FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organization] ([OrganizationId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[UserOrganization] CHECK CONSTRAINT [FK_UserOrganization_Organization]
GO
ALTER TABLE [dbo].[UserOrganization]  WITH CHECK ADD  CONSTRAINT [FK_UserOrganization_Role] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleID])
GO

ALTER TABLE [dbo].[UserOrganization] CHECK CONSTRAINT [FK_UserOrganization_Role]
GO
ALTER TABLE [dbo].[UserOrganization]  WITH CHECK ADD  CONSTRAINT [FK_UserOrganization_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO

ALTER TABLE [dbo].[UserOrganization] CHECK CONSTRAINT [FK_UserOrganization_User]