-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_read_user_for_authentication] 
	-- Add the parameters for the stored procedure here
	@UserName Varchar(50) = '',
	@PwdHash Varchar(500) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Select * FROM [User] Where (UserName = @UserName) And (PasswordHash = @PwdHash);
END