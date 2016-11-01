-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_read_all_canvases]
	 ( @userID int )
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- comment  
    -- Insert statements for procedure here 
	select   'Owned' As IsShared,   *  from vwCanvasUser where UserID =   @userID  UNION 
	select   'Shared' As IsShared,   * from vwCanvasShare  where UserID = @userID  Order By CreatedDate DESC
	 
END