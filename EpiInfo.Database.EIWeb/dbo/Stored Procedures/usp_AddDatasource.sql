CREATE PROCEDURE [dbo].[usp_AddDatasource]
	@DatasourceServerName NVARCHAR (300), 
	@DatabaseType VARCHAR (50),
	@InitialCatalog VARCHAR (300), 
	@PersistSecurityInfo VARCHAR (50), 
	@DatabaseUserID VARCHAR (200), 
	@SurveyID Uniqueidentifier , 
	@Password VARCHAR (200)
AS

SET NOCOUNT OFF;

BEGIN TRANSACTION;


INSERT  INTO [EIDatasource] (  [DatasourceServerName], [DatabaseType], [InitialCatalog], [PersistSecurityInfo],[SurveyId], [DatabaseUserID], [Password])
VALUES                   (   @DatasourceServerName, @DatabaseType, @InitialCatalog, @PersistSecurityInfo,@SurveyID, @DatabaseUserID, @Password);

IF @@Error > 0
    ROLLBACK;
ELSE
    COMMIT TRANSACTION;