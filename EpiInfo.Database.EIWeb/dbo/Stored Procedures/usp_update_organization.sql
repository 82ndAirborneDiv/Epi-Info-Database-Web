-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_update_organization]
	-- Add the parameters for the stored procedure here
	@orgId int = -1,
	@orgName varchar(50) ,     
	@active bit    
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE ORGANIZATION SET  Organization = @orgName, IsEnabled = @active  WHERE ORGANIZATIONID = @orgId;    
	
END