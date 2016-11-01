-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_read_external_connec_str]
	-- Add the parameters for the stored procedure here
	@ViewName VARCHAR (50) = '',
	@DSName Varchar(50) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @sqlString Varchar(100)
	set @sqlString = 'SELECT *  FROM ' + @ViewName + ' WHERE DatasourceName =  ''' + @DSName + '''';
	
	exec(@sqlString)
	
END