--   exec usp_get_canvas_share_status  69,  2  
   CREATE   PROCEDURE  [dbo].[usp_get_canvas_share_status] 
	@CanvasID int, 
	@OrganizationID  int    
	
AS
BEGIN

SELECT dbo.Organization.Organization,
       dbo.[User].UserName,
       dbo.[User].FirstName,
       dbo.[User].LastName,
       dbo.Organization.OrganizationID,
       dbo.[User].UserID,
       CASE 
			WHEN dbo.[User].UserID IN
			(
				SELECT dbo.[User].UserID AS u2
				FROM   dbo.SharedCanvases
					   INNER JOIN
					   dbo.[User]
					   ON dbo.SharedCanvases.UserID = dbo.[User].UserID
					   INNER JOIN
					   dbo.UserOrganization
					   ON dbo.[User].UserID = dbo.UserOrganization.UserID
			   WHERE  (dbo.SharedCanvases.CanvasID = @CanvasID)    /*   AND (dbo.UserOrganization.OrganizationID = 1) */
			) 
			THEN  CAST(1 AS bit)  
			ELSE  CAST(0 AS bit)   
		END     
		AS Shared
FROM   dbo.[User]
       INNER JOIN
       dbo.UserOrganization
       ON dbo.[User].UserID = dbo.UserOrganization.UserID
       INNER JOIN
       dbo.Organization
       ON dbo.UserOrganization.OrganizationID = dbo.Organization.OrganizationID
WHERE  (dbo.Organization.OrganizationID = @OrganizationID    );        




END