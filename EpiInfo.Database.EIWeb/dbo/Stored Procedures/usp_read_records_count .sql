-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_read_records_count ]
	-- Add the parameters for the stored procedure here
	@DatabaseObject VARCHAR (50) = '',
	@SqlTest bit = 0,
	@WhereClause Varchar(200) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @sqlString Varchar(100)
    IF(@SqlTest = 0)
		Begin
		set @sqlString = 'select Count(*)  from  ' + @DatabaseObject
		End
	Else
		Begin
		set @sqlString = 'SELECT Count(*) FROM  ( ' + @DatabaseObject + ' ) as table1 ';
		End
		
	IF(@WhereClause <> '')
	Begin
		
	set @sqlString = @sqlString + @WhereClause;

	End
		
	exec(@sqlString);
	
END