CREATE PROCEDURE [dbo].[usp_update_datasource]
(
	  @DatasourceUser DatasourceUserTableType READONLY,          
	@DatasourceName nvarchar(300),
	@DatasourceServerName nvarchar(300),
	@DatabaseType varchar(50),
	@InitialCatalog varchar(300),
	@PersistSecurityInfo varchar(50),
	@DatabaseUserID varchar(200),
	@Password varchar(200),
	@DatabaseObject   varchar(MAX),
    -- @SQLQuery bit,
	-- @SQLText varchar(MAX),
	@active bit,
	@DatasourceID int,
	@pnumber varchar(50),
	@EIWSSurveyId varchar(200)
)
AS
	SET NOCOUNT OFF;    
	
	BEGIN TRANSACTION;

--Declare @EIWSSurveyId varchar(200) = '';

--select @EIWSSurveyId = (select SurveyId from EIDatasource where InitialCatalog = @InitialCatalog);

 declare @usercount  INT    
		
UPDATE [datasource] 
SET [DatasourceName] = @DatasourceName,  [DatasourceServerName] = @DatasourceServerName, [DatabaseType] = @DatabaseType, 
[InitialCatalog] = @InitialCatalog, [PersistSecurityInfo] = @PersistSecurityInfo, [EIWSSurveyId] = @EIWSSurveyId, [DatabaseUserID] = @DatabaseUserID, 
[Password] = @Password,   DatabaseObject = @DatabaseObject,    [active] = @active, [portnumber]=@pnumber WHERE (([DatasourceID] =  @DatasourceID));

delete from DatasourceUser where DatasourceID 	=  @DatasourceID                              

select @usercount = (select COUNT(* )  )    
 	from @DatasourceUser



if @usercount  >  0
 BEGIN 
	INSERT INTO DatasourceUser (DatasourceID, UserID)
		SELECT @DatasourceID,      
			   UserID
		FROM   @DatasourceUser;
  end



IF @@Error > 0
    ROLLBACK;
ELSE
    COMMIT TRANSACTION;