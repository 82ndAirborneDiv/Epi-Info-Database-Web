-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_update_user_organization] 
@UserId varchar(50),
@OrganizationId varchar(10),
@RoleId varchar(3),
@Active bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   UPDATE [UserOrganization] SET [ROLEID] = @RoleId, [Active] = @Active
WHERE UserId = @UserId and OrganizationId = @OrganizationId
END