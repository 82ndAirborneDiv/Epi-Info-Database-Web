-- =============================================
-- Author:		Mohammad Usman
-- Create date: 6/8/2015
-- Description:	This stored proc returns list of all the canvases associated with given datasource for a given user. 
-- =============================================
CREATE PROCEDURE [dbo].[usp_read_canvases_for_lite] 
	@FormId VARCHAR (1000) = '',
	@UserId Varchar(50) = ''
AS
BEGIN
declare @ewavdsid  INT 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 -- set @ewavdsid = (Select TOP 1 DatasourceId  from DataSource where EIWSSurveyId ='' + @FormId + '');
  
 -- 	Select Count(*) from (select   'Owned' As IsShared,   *  from vwCanvasUser where UserID =   @UserId and DatasourceID = @ewavdsid UNION 
	--select   'Shared' As IsShared,   * from vwCanvasShare  where UserID = @UserId 
	--and DatasourceID = @ewavdsid) as UnionTable
	
	
	
Create Table #T(DatasourceId int)

--Reading all the active datasources for the given form, this User has access to.  
Insert into #T
Select  DataSource.DataSourceID  from DataSource join DatasourceUser on Datasource.DatasourceId = DatasourceUser.Datasourceid 
where EIWSSurveyId ='' + @FormId + '' and UserId = @UserId and active = 1

--Reading count for all the canvases, for all the datasources read above, for this user. 
Select *  from (select   'Owned' As IsShared,   *  from vwCanvasUser where UserID =   @UserId  UNION 
	select   'Shared' As IsShared,   * from vwCanvasShare  where UserID = @UserId 
	) as UnionTable join #T on UnionTable.DatasourceId = #T.DatasourceId
	
Drop Table #T
  
    
END