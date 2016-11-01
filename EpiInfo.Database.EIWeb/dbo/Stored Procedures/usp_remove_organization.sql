-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_remove_organization]
	-- Add the parameters for the stored procedure here
	@orgId int = -1,
	@userId varchar(50) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --DELETE FROM ORGANIZATION WHERE ORGANIZATIONID = @orgId 
END