-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_update_password] 
	-- Add the parameters for the stored procedure here
	@UserId varchar(10),
	@HashedPassword varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Update [User] Set PasswordHash = @HashedPassword, ResetPassword = 0 Where UserId = @UserId
END