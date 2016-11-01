CREATE         PROCEDURE  [dbo].[usp_get_shared_canvases_guid]        
	@canvasGuid   UNIQUEIDENTIFIER   
	

AS
BEGIN
    
DECLARE   @canvasId      INT      

SET  @canvasId   =   ( SELECT   CanvasID            
FROM Canvas 
WHERE     CanvasGUID =    @canvasGuid            )
  

SELECT 
       dbo.[User].UserName,
       dbo.[User].FirstName,
       dbo.[User].LastName,
       dbo.[User].UserID,
       CASE 
			WHEN dbo.[User].UserID IN
			(
				SELECT dbo.[User].UserID AS u2
				FROM   dbo.SharedCanvases
					   INNER JOIN
					   dbo.[User]
					   ON dbo.SharedCanvases.UserID = dbo.[User].UserID				
			   WHERE  (dbo.SharedCanvases.CanvasID   = @canvasId  )    /*   AND (dbo.UserOrganization.OrganizationID = 1) */
			) 
			THEN  CAST(1 AS BIT)  
			ELSE  CAST(0 AS BIT)   
		END     
		AS Shared
FROM   dbo.[User]



END