-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_read_user] 
@orgid int = -1,
@userid int = -1,
@email varchar(50) =  NULL, 
@roleid int = -1--,
--@datasourceid int = -1  


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	


	Create Table #TempTable(userId varchar(20), datasourceCount varchar(20))
	
	IF @email <> ''
	BEGIN
	SELECT USERID, USERNAME, FIRSTNAME, LASTNAME, ORGANIZATIONID, PHONENUMBER, PASSWORDHASH , EMAILADDRESS, ROLEID, ROLEDESCRIPTION, ACTIVE, 
	(Select Count(*) from DatasourceUser where UserId= (Select UserID from [User] where EmailAddress = @email)) As DatasourceCount  FROM vwUserOrganizationUser WHERE EMAILADDRESS = @email
	Order by FIRSTNAME
	END
	
	ELSE
		IF @USERID <> -1
		BEGIN
		SELECT USERID, USERNAME, FIRSTNAME, LASTNAME, ORGANIZATIONID, PHONENUMBER, PASSWORDHASH , EMAILADDRESS, ROLEID, ROLEDESCRIPTION,  ACTIVE,
			(Select Count(*) from DatasourceUser where UserId= @userid) As DatasourceCount  FROM vwUserOrganizationUser WHERE ORGANIZATIONID = @ORGID AND USERID = @USERID
			 Order by FIRSTNAME
		END
		ELSE
		BEGIN
			IF @roleid <> -1
				BEGIN
				--SELECT USERID, USERNAME, FIRSTNAME, LASTNAME, ORGANIZATIONID, PHONENUMBER, PASSWORDHASH , EMAILADDRESS, ROLEID 
				--	FROM vwUserOrganizationUser WHERE ORGANIZATIONID = @ORGID AND ROLEID <> 4
				Insert Into #TempTable(userId, datasourceCount)
				SELECT UserID,  Count(DatasourceId )
				FROM DatasourceUser --On vwUserOrganizationUser.UserId = DatasourceUser.UserId WHERE vwUserOrganizationUser.ORGANIZATIONID = 1 AND vwUserOrganizationUser.ROLEID <> 4

				Group By UserID 

				Select vwUserOrganizationUser.USERID, USERNAME, FIRSTNAME, LASTNAME, ORGANIZATIONID, PHONENUMBER, PASSWORDHASH , EMAILADDRESS, ROLEID, ROLEDESCRIPTION, ACTIVE, DatasourceCount
				FROM vwUserOrganizationUser Left Join #TempTable on vwUserOrganizationUser.UserId = #TempTable.UserID WHERE ORGANIZATIONID = @ORGID AND ROLEID = @roleid
				Order by FIRSTNAME;


				Drop Table #TempTable
				END
			ELSE
				BEGIN
				--SELECT USERID, USERNAME, FIRSTNAME, LASTNAME, ORGANIZATIONID, PHONENUMBER, PASSWORDHASH , EMAILADDRESS, ROLEID FROM vwUserOrganizationUser WHERE ORGANIZATIONID = @ORGID  --AND ROLEID <> 4 AND ROLEID = 2
				--SELECT USERID, USERNAME, FIRSTNAME, LASTNAME, ORGANIZATIONID, PHONENUMBER, PASSWORDHASH , EMAILADDRESS, ROLEID FROM vwUserOrganizationUser WHERE ROLEID = 2
				--Create Table #TempTable(userId varchar(20), datasourceCount varchar(20))
				Insert Into #TempTable(userId, datasourceCount)
				SELECT UserID, Count(DatasourceUser.DatasourceId ) as DatasourceCount
				FROM DatasourceUser left join Datasource on 
				Datasource.DatasourceId = DatasourceUser.DatasourceId
				Where OrganizationId = @ORGID --On vwUserOrganizationUser.UserId = DatasourceUser.UserId WHERE vwUserOrganizationUser.ORGANIZATIONID = 1 AND vwUserOrganizationUser.ROLEID <> 4
				Group By UserID

				Select vwUserOrganizationUser.USERID, USERNAME, FIRSTNAME, LASTNAME, ORGANIZATIONID, PHONENUMBER, PASSWORDHASH , EMAILADDRESS, ROLEID, ROLEDESCRIPTION, ACTIVE, DatasourceCount
				FROM vwUserOrganizationUser Left Join #TempTable on vwUserOrganizationUser.UserId = #TempTable.UserID WHERE ORGANIZATIONID = @ORGID 
				Order by FIRSTNAME

				Drop Table #TempTable

			END
	END
END