-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_remove_user_datasource] 
@UserId Numeric,
@OrganizationId varchar(10)
--@CreatorId Numeric--,
--@RETURN_VALUE int OUTPUT
AS
BEGIN
--DECLARE @uid Numeric = 0
--Set @uid = (Select UserID from [User] where UserName = @UserName)
--DELETE DatasourceUser WHERE UserId = @uid;
--set @RETURN_VALUE = SCOPE_IDENTITY();
Delete DatasourceUser from DatasourceUser left join Datasource 
on DatasourceUser.DatasourceId = Datasource.DatasourceId 
where --creatorId = @CreatorId and 
DatasourceUser.UserId = @UserId and Datasource.OrganizationId = @OrganizationId
END