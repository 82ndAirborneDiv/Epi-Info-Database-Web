-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[usp_read_canvasInfoGUID         ]
@canvasGUID  uniqueidentifier    
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



		begin
		SELECT UserId, CanvasID, CanvasGUID,  DatasourceId,  canvasname,    CanvasContent, DatasourceName  /*  , 
			(select count(*) from SharedCanvases where CanvasId = @canvasId) as IsShared   */    
		From vwCanvasUser 
		where canvasGUID = @canvasGUID;
		end
END