-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_read_users_for_datasource] 
@orgid int = -1,
@datasourceid int = -1  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   	if @datasourceid <>  -1
	begin
	 SELECT vwUserOrganizationUser.UserID, USERNAME, FIRSTNAME, LASTNAME, ORGANIZATIONID, PHONENUMBER, PASSWORDHASH , EMAILADDRESS, ROLEID, ROLEDESCRIPTION, ACTIVE 
		FROM vwUserOrganizationUser Left join DatasourceUser on vwUserOrganizationUser.UserId = DatasourceUser.UserId Where DatasourceID =  @datasourceid and organizationid = @orgid Order by FIRSTNAME
		
		return  
	end
END