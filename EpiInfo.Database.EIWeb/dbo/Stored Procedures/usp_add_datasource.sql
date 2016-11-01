CREATE PROCEDURE [dbo].[usp_add_datasource]
	@DatasourceUser DatasourceUserTableType READONLY, 
	@DatasourceName NVARCHAR (300), 
	@DatasourceServerName NVARCHAR (300), 
	@DatabaseType VARCHAR (50),
	@OrganizationId varchar(10), 
	@InitialCatalog VARCHAR (300), 
	@PersistSecurityInfo VARCHAR (50), 
	@DatabaseUserID VARCHAR (200), 
	@Password VARCHAR (200), 
	@DatabaseObject VARCHAR (MAX), 
	@SQLQuery BIT, 
	@active BIT,
	@pnumber varchar(50),
	@EIWSSurveyId varchar(200)
AS

SET NOCOUNT OFF;

BEGIN TRANSACTION;

--Declare @EIWSSurveyId varchar(200) = '';

--select @EIWSSurveyId = (select SurveyId from EIDatasource where InitialCatalog = @InitialCatalog);

INSERT  INTO [datasource] ([DatasourceName],  [DatasourceServerName], [DatabaseType], [InitialCatalog], [PersistSecurityInfo], [EIWSSurveyId], [DatabaseUserID], [Password], [DatabaseObject ], [SQLQuery], [active], [OrganizationId],[PortNumber])
VALUES                   (@DatasourceName,   @DatasourceServerName, @DatabaseType, @InitialCatalog, @PersistSecurityInfo, @EIWSSurveyId, @DatabaseUserID, @Password, @DatabaseObject, @SQLQuery, @active, @OrganizationId, @pnumber);

declare @usercount  INT    

select @usercount = (select COUNT(* )  )    
 	from @DatasourceUser



if @usercount  >  0
 BEGIN 
	INSERT INTO DatasourceUser (DatasourceID, UserID)
		SELECT SCOPE_IDENTITY(),
			   UserID
		FROM   @DatasourceUser;
  end

IF @@Error > 0
    ROLLBACK;
ELSE
    COMMIT TRANSACTION;