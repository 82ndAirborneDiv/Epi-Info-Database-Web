CREATE procedure  [dbo].[usp_copy_canvas] 

@oldCanvasName varchar(50), 
@newCanvasName varchar(50), 
--@userID int, 
--@datasourceID int      
--@oldDatasourceName varchar(50),
@newDatasourceName varchar(50)

AS 


declare  @newCanvasId  int        ;        
declare @recordCount int ;
declare @newDatasourceId int;

IF((Select Count(*) from canvas where CanvasName = @newCanvasName) > 0)
			BEGIN
			raiserror ('Canvas Name already exists. Select another name.',11,1);
			--select -1;
			return;
			END
			

BEGIN TRANSACTION;			
/**
Copy the existing row that has CanvasContent column into a new row 
**/  
INSERT INTO canvas  ([CanvasName]
           ,[UserID]
           ,[CanvasDescription]
           ,[CreatedDate]
           ,[ModifiedDate]
           ,[DatasourceID]
           ,[CanvasContent])
       SELECT  CanvasName
           ,UserID
           ,CanvasDescription
           ,CreatedDate
           ,ModifiedDate
           ,DatasourceID
           ,CanvasContent
       FROM Canvas where CanvasName = @oldCanvasName ;

set @newCanvasId  = @@identity ;


set @newDatasourceId = (Select DatasourceId from Datasource Where DatasourceName = @newDatasourceName);
/**
Update Canvas name to new name.
Update the old DatasourceId column to new DatasourceId with same columns and schema.
Update createdDate column to latest date in order to see the canvas on the top of the list in Open Canvas
**/

UPDATE [Canvas]
   SET [CanvasName] = @newCanvasName
      ,[CreatedDate] =  GETDATE( )
      ,[DatasourceID] =  @newDatasourceId
 WHERE CanvasID = @newCanvasId ;
 
-- set @userID = (Select UserID from CanvasId = @newCanvasId);

--set @recordCount =   ( select COUNT(*) from DatasourceUser
--	where UserID = @userID and
--	DatasourceID = @datasourceID );

--IF ( @recordCount = 0  )
--BEGIN
--	INSERT INTO [DatasourceUser]
--			   ([DatasourceID]
--			   ,[UserID])
--		 VALUES
--			   (@datasourceID
--			   ,@userID)
--END
	

IF @@Error > 0
    ROLLBACK TRANSACTION;
ELSE
    COMMIT TRANSACTION;