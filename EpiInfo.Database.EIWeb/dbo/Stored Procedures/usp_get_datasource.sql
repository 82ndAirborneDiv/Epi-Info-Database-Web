-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
  CREATE    PROCEDURE [dbo].[usp_get_datasource] 
	-- Add the parameters for the stored procedure here
	@datasourceId int    
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		Select * from Datasource where DatasourceID =  @datasourceId    

END