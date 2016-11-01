--   exec  usp_update_sharedcanvases    
CREATE       PROCEDURE [dbo].[usp_update_sharedcanvases]
	@OrganizationID INT  , 
	@canvasId INT      , 
	@UsersToShare VARCHAR (50)  -- ='11, 4, ' --     24, 17,  26,     14'

AS

-- Clean up work tabs      
IF OBJECT_ID('tempdb..#UNShare') IS NOT NULL
    DROP TABLE #UNShare;
IF OBJECT_ID('tempdb..#MIGHTShare') IS NOT NULL
    DROP TABLE #MIGHTShare;
IF OBJECT_ID('tempdb..#ToShare') IS NOT NULL
    DROP TABLE #ToShare;
IF OBJECT_ID('tempdb..#ToEmail') IS NOT NULL
    DROP TABLE #ToEmail;

-- =============================================
-- select the users from the organization 
-- that are NOT to be shared with.  Also if these 
-- users are shared currently they will get UN-shared   

SELECT UserID
INTO   #UNShare
FROM   UserOrganization
WHERE  OrganizationID = @OrganizationID
       AND UserID NOT IN (SELECT Item
                          FROM   dbo.SplitInts (@UsersToShare, ',')); --   (11, 14 )       
-- =============================================
-- Takes the comma separated list argument @UsersToShare
-- amd creates a selected set                                                        
-- select the users from the organization 
-- that are MAY get shared if not shared already  
--      
SELECT UserID
INTO   #MIGHTShare
FROM   UserOrganization
WHERE  OrganizationID =  @OrganizationID    
       AND UserID IN (SELECT item
                      FROM   SplitInts (@UsersToShare, ',')); --   (11, 14 )    
-- =============================================    
-- create share tahle with the as 
-- one column and userid as the other       
    
SELECT @canvasId AS CanvasID,
       UserId
INTO   #ToShare
FROM   #mightshare;    

BEGIN TRANSACTION;
BEGIN TRY

    -- Unshare the canvas         
    DELETE SharedCanvases
    WHERE  UserID IN (SELECT UserID
                      FROM   #unshare)
           AND CanvasID = @canvasId;              
                      
    -- Save the newly shared to a list for emails    
    SELECT *
    INTO   #ToEmail
    FROM   #toshare
    WHERE  UserID NOT IN (SELECT UserID
                          FROM   SharedCanvases
                          WHERE  CanvasID = @canvasId);    
                                                    
    -- Share with anyone from the share list that is 
    -- NOT ALREADY shared witth  
    INSERT INTO SharedCanvases
    SELECT CanvasID, UserId
   				       
    FROM   #toshare
    WHERE  UserID NOT IN (SELECT UserID
                          FROM   SharedCanvases
                          WHERE  CanvasID = @canvasId);

	-- Return results                              
    SELECT *
    FROM   #toemail;
    
    COMMIT TRANSACTION;

END TRY
BEGIN CATCH

    SELECT ERROR_NUMBER() AS ErrorNumber,
           ERROR_SEVERITY() AS ErrorSeverity,
           ERROR_STATE() AS ErrorState,
           ERROR_PROCEDURE() AS ErrorProcedure,
           ERROR_LINE() AS ErrorLine,
           ERROR_MESSAGE() AS ErrorMessage;
    -- in case of an error, ROLLBACK the transaction    
    ROLLBACK;
        
END CATCH