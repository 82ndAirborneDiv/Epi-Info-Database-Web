-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE   [dbo].[usp_read_all_organization_tallys]     

AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT OrganizationID,
       [Organization],
       [IsEnabled],
       -- Get  DatasourceCount         
       (SELECT COUNT(*)
        FROM   Datasource
        WHERE  Datasource.OrganizationID = Organization.OrganizationID) AS DatasourceCount,    
		-- Get  TotalUserCount         
       (SELECT COUNT(*)
        FROM   [UserOrganization] 
        WHERE  [UserOrganization].OrganizationID = Organization.OrganizationID) AS TotalUserCount,    
		-- Get  AdminCount                  
       (SELECT COUNT(*)
        FROM   UserOrganization 
        WHERE UserOrganization.OrganizationID =  Organization.OrganizationID AND
				UserOrganization.RoleID =  2 
		) AS AdminCount,        
		-- Get  AnalystCount         
       (SELECT COUNT(*)
		FROM   UserOrganization 
        WHERE UserOrganization.OrganizationID =  Organization.OrganizationID AND
				UserOrganization.RoleID =  1    
				) AS AnalystCount,  
		-- Get  SuperAdminCount                                 
       (SELECT COUNT(*)
		FROM   UserOrganization 
        WHERE UserOrganization.OrganizationID =  Organization.OrganizationID AND
				UserOrganization.RoleID =  4 
		  ) AS    SuperAdminCount             
               
FROM   [dbo].[Organization] Order by Organization;    


END