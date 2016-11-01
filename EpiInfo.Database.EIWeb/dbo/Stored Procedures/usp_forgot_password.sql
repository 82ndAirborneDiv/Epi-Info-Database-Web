-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_forgot_password]
	-- Add the parameters for the stored procedure here
	@EmailAddress varchar(50),
	@HashedPassword varchar(max)
	--<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE [User] SET PasswordHash = @HashedPassword, ResetPassword = 1 Where EmailAddress = @EmailAddress
END