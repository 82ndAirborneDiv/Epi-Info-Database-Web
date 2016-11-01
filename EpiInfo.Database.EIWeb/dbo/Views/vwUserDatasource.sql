CREATE VIEW [dbo].[vwUserDatasource]
AS
SELECT     dbo.[User].UserID, dbo.[User].UserName, dbo.[User].PasswordHash, dbo.Datasource.DatasourceID, dbo.Datasource.DatasourceName, 
                      dbo.Datasource.DatasourceServerName, dbo.Datasource.DatabaseType, dbo.Datasource.InitialCatalog, dbo.Datasource.PersistSecurityInfo, 
                      dbo.Datasource.Password, dbo.Datasource.DatabaseObject, dbo.Datasource.SQLQuery, dbo.Datasource.SQLText, dbo.Datasource.active AS IsDatasourceActive, 
                      dbo.Datasource.DatabaseUserID, dbo.[User].FirstName, dbo.[User].LastName, dbo.[User].EmailAddress, dbo.[User].PhoneNumber, dbo.[User].ResetPassword, 
                      dbo.Datasource.OrganizationID, dbo.Datasource.portnumber, dbo.Datasource.EIWSDatasource, dbo.Datasource.EIWSSurveyId
FROM         dbo.DatasourceUser INNER JOIN
                      dbo.Datasource ON dbo.DatasourceUser.DatasourceID = dbo.Datasource.DatasourceID INNER JOIN
                      dbo.[User] ON dbo.DatasourceUser.UserID = dbo.[User].UserID