-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_read_database_type]
	-- Add the parameters for the stored procedure here
	@DatabaseObject Varchar(200) = '',
	@TableName Varchar(200) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
Declare @SqlString Varchar(200) = '';

   set @SqlString = 'SELECT * FROM ' + @TableName + ' WHERE DataSourceName =  ''' + @DatabaseObject + '''';
   exec(@SqlString);
END