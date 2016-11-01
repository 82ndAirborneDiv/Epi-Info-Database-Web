-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_delete_canvas]
	-- Add the parameters for the stored procedure here
	@canvasId int = -1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   if(@canvasId <> -1)
   begin
   Delete From SharedCanvases where CanvasId = @canvasId;
   
   Delete from Canvas where CanvasId = @canvasId;
   end
END