CREATE PROCEDURE  [dbo].[usp_GetDatasourceConnectionString]    
@FormId varchar(100) = ''
AS
BEGIN

	Select 'Data Source=' + DatasourceServerName  
	+ ';Persist Security Info=' + PersistSecurityInfo + ';User ID=' + DatabaseUserID + '; Password='
	+ [Password] + ';Initial Catalog=' + InitialCatalog
	 from EIDatasource where Cast(SurveyId as varchar(100)) = @FormId;-- '05c7ff68-4feb-4e54-a620-8670dadf7590'   ; --CONVERT(UNIQUEIDENTIFIER, @FormId);

END