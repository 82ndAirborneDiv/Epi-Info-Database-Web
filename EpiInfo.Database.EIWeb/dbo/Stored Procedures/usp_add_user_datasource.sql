-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_add_user_datasource] 
	-- Add the parameters for the stored procedure here
	@UserName varchar(50),
	@DatasourceName varchar(300)
	--@RETURN_VALUE int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
DECLARE @did Numeric = 0
DECLARE @uid Numeric = 0
	
	SET @did = (Select DatasourceID from Datasource where DatasourceName = @DatasourceName)
	Set @uid = (Select UserID from [User] where UserName = @UserName)

    INSERT DatasourceUser ([DatasourceId], [UserID]) VALUES (@did, @uid)
    --set @RETURN_VALUE = SCOPE_IDENTITY();
END