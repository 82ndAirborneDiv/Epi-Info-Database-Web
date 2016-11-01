-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_sharecanvas] 
@canvasId int = -1,
@userId int = -1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	IF NOT Exists(Select * from SharedCanvases where UserId = @userId and CanvasId = @canvasId)
	 INSERT INTO SharedCanvases    ([CanvasID] ,[UserID]) VALUES (@canvasId,@userId) ;
END