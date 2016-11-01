-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_read_datasource] 
	-- Add the parameters for the stored procedure here
	--@creatorId int = -1,
	@orgId int = -1, 
	@userId int = -1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if @userId = -1
		begin
		Select * from Datasource where OrganizationId = @orgId Order by DatasourceName--and CreatorId = @creatorId
		end
	else
		begin
		Select * from Datasource left join DatasourceUser on Datasource.DatasourceId = DatasourceUser.DatasourceId
where OrganizationId = @orgId --and CreatorId = @creatorId 
and UserId = @userId  Order by DatasourceName
		end
END