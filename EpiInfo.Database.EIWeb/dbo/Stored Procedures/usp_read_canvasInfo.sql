-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_read_canvasInfo]
@canvasId int = -1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	--if(@canvasId = -1)
	--	begin
	--	--raiserror('',1,1);
	--	end
	--else
		begin
		SELECT UserId, CanvasID, CanvasGUID, CanvasName,    CanvasContent,  DatasourceId,    
			(select count(*) from SharedCanvases where CanvasId = @canvasId) as IsShared 
		From vwCanvasUser 
		where CanvasId = @canvasId;
		end
END