-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_read_all_datasources ]
	-- Add the parameters for the stored procedure here
	@UserName VARCHAR (50) = '',
	@DatabaseObject Varchar(50) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
Declare @SqlString Varchar(1000) = '';
   IF(@UserName = '*')
	   Begin
	   Set @SqlString  = 'SELECT * FROM ' + @DatabaseObject + ' As A Left join vwUserOrganizationUser On 
	   A.UserID = vwUserOrganizationUser.UserID and A.OrganizationId =  vwUserOrganizationUser.OrganizationId   
	   WHERE IsDatasourceactive =  ''True''  and Active = ''True'' And IsOrgActive =''True'' Order By A.DatasourceName';
	   End
	ELSE
		Begin
		Set @SqlString = 'SELECT * FROM ' + @DatabaseObject + ' As A Left join vwUserOrganizationUser 
		On A.UserID = vwUserOrganizationUser.UserID and A.OrganizationId =  vwUserOrganizationUser.OrganizationId   
		WHERE IsDatasourceactive = ''True'' And   vwUserOrganizationUser.username =  ''' + @UserName + ''' and Active = ''True'' And IsOrgActive =''True'' Order By A.DatasourceName';
		End
		
	exec(@SqlString	)
END