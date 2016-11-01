CREATE VIEW [dbo].[vwUserOrganizationUser]
AS
SELECT     TOP (100) PERCENT dbo.[User].UserID, dbo.UserOrganization.RoleID, dbo.[User].EmailAddress, dbo.[User].PhoneNumber, dbo.[User].UserName, 
                      dbo.[User].FirstName, dbo.[User].LastName, dbo.[User].PasswordHash, dbo.[User].ResetPassword, dbo.UserOrganization.OrganizationID, dbo.Role.RoleValue, 
                      dbo.Role.RoleDescription, dbo.UserOrganization.Active, dbo.Organization.IsEnabled AS IsOrgActive
FROM         dbo.UserOrganization INNER JOIN
                      dbo.[User] ON dbo.UserOrganization.UserID = dbo.[User].UserID INNER JOIN
                      dbo.Role ON dbo.UserOrganization.RoleID = dbo.Role.RoleID INNER JOIN
                      dbo.Organization ON dbo.UserOrganization.OrganizationID = dbo.Organization.OrganizationID
ORDER BY dbo.[User].UserID