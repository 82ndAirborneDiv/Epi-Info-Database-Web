CREATE VIEW [dbo].[vwOrgsForUser]
AS
SELECT     dbo.UserOrganization.UserID, dbo.Organization.OrganizationID, dbo.Organization.Organization, dbo.UserOrganization.RoleID, 
                      dbo.UserOrganization.Active, dbo.Organization.IsEnabled AS IsOrgActive
FROM         dbo.Organization INNER JOIN
                      dbo.UserOrganization ON dbo.Organization.OrganizationID = dbo.UserOrganization.OrganizationID