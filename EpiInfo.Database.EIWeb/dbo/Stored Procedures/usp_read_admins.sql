-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_read_admins] 
	@orgId int = -1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Create Table #TempTable(userId varchar(20), datasourceCount varchar(20))
	
	IF @orgId <> -1 
		BEGIN
				Insert Into #TempTable(userId, datasourceCount)
				SELECT UserID, Count(DatasourceId )
				FROM DatasourceUser --On [User].UserId = DatasourceUser.UserId WHERE [USER].ORGANIZATIONID = 1 AND [USER].ROLEID <> 4
				Group By UserID 

				Select vwUserOrganizationUser.USERID, USERNAME, FIRSTNAME, LASTNAME, ORGANIZATIONID, PHONENUMBER, EMAILADDRESS,PasswordHash, ROLEID, DatasourceCount
				FROM vwUserOrganizationUser Left Join #TempTable on vwUserOrganizationUser.UserId = #TempTable.UserID WHERE ORGANIZATIONID = @ORGID AND ROLEID = 2
				Order By FirstName

		END
	ELSE
		BEGIN
				Insert Into #TempTable(userId, datasourceCount)
				SELECT UserID, Count(DatasourceId )
				FROM DatasourceUser --On [User].UserId = DatasourceUser.UserId WHERE [USER].ORGANIZATIONID = 1 AND [USER].ROLEID <> 4
				Group By UserID 

				Select vwUserOrganizationUser.USERID, USERNAME, FIRSTNAME, LASTNAME, ORGANIZATIONID, PHONENUMBER, EMAILADDRESS,PasswordHash, ROLEID, DatasourceCount
				FROM vwUserOrganizationUser Left Join #TempTable on vwUserOrganizationUser.UserId = #TempTable.UserID  AND ROLEID = 2
				Order By FirstName

		END
				Drop Table #TempTable
END