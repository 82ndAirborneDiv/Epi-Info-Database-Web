CREATE VIEW [dbo].[vwCanvasShare]
AS
SELECT        dbo.[User].UserName, dbo.Datasource.DatasourceName, dbo.Canvas.CanvasID, dbo.Canvas.CanvasName, dbo.Canvas.CanvasDescription, 
                         dbo.Canvas.CreatedDate, dbo.Canvas.ModifiedDate, dbo.Canvas.CanvasContent, dbo.[User].UserID, dbo.[User].FirstName, dbo.[User].LastName, 
                         dbo.Datasource.DatasourceID, dbo.Datasource.OrganizationID, dbo.Canvas.CanvasGUID
FROM            dbo.Canvas INNER JOIN
                         dbo.SharedCanvases ON dbo.Canvas.CanvasID = dbo.SharedCanvases.CanvasID INNER JOIN
                         dbo.[User] ON dbo.SharedCanvases.UserID = dbo.[User].UserID INNER JOIN
                         dbo.Datasource ON dbo.Canvas.DatasourceID = dbo.Datasource.DatasourceID