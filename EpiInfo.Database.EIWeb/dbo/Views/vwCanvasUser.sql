CREATE VIEW [dbo].[vwCanvasUser]
AS
SELECT        dbo.[User].UserName, dbo.Datasource.DatasourceName, dbo.Canvas.CanvasID, dbo.Canvas.CanvasName, dbo.Canvas.CanvasDescription, 
                         dbo.Canvas.CreatedDate, dbo.Canvas.ModifiedDate, dbo.Canvas.CanvasContent, dbo.[User].UserID, dbo.[User].FirstName, dbo.[User].LastName, 
                         dbo.Datasource.DatasourceID, dbo.Datasource.OrganizationID, dbo.Canvas.CanvasGUID
FROM            dbo.Canvas INNER JOIN
                         dbo.[User] ON dbo.Canvas.UserID = dbo.[User].UserID INNER JOIN
                         dbo.DatasourceUser ON dbo.[User].UserID = dbo.DatasourceUser.UserID INNER JOIN
                         dbo.Datasource ON dbo.Canvas.DatasourceID = dbo.Datasource.DatasourceID AND dbo.DatasourceUser.DatasourceID = dbo.Datasource.DatasourceID