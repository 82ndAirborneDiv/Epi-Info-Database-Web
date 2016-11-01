-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_read_all_organization_for_user] 
@UserName Varchar(50) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   Select * From   vwOrgsforUser  Where RoleId > 1 AND UserId  =  @UserName AND Active = 1 AND IsOrgActive = 1
    
END