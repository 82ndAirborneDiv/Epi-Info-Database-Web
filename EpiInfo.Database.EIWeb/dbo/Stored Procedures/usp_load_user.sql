-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_load_user] 
	-- Add the parameters for the stored procedure here
	@UserName Varchar(50) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Declare @UserId Varchar(50);
    Set @UserId = (SELECT  UserId   FROM   [User]  WHERE    ( UserName = @UserName  )  )
    
    Select *, (Select Count(*) from DatasourceUser where DatasourceUser.UserId =  @UserId ) as 
    DatasourceCount from vwUserOrganizationUser where vwUserOrganizationUser.UserId = @UserId and Active = 'True' and IsorgActive = 'True' ;
    
END