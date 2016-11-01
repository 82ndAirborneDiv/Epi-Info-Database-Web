-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_save_canvas] 
	@CANVASNAME VARCHAR(50) = '',
	@USERID INT = -1,
	@CANVASDESC  NVARCHAR(MAX) = '',
	@CREATEDDATE DATETIME = '1/1/1900',
	@MODIFIEDDATE DATETIME= '1/1/1900',
	@DATASOURCEID INT = '-1',
	@ISNEWCANVAS BIT = 0,
	@CANVASID INT = -1,
	@XMLCONTENT  NVARCHAR(MAX) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
IF(@ISNEWCANVAS = 1)
	BEGIN
	CREATE TABLE #CountTable(count INT);
		
	INSERT INTO #CountTable
   		SELECT   COUNT(*)  FROM CANVAS WHERE CANVASNAME = @CANVASNAME --UNION 
		--SELECT   count(*) FROM VWCANVASSHARE  WHERE CANVASNAME = @CANVASNAME  --ORDER BY CREATEDDATE DESC
		
		-- If true there is an existing canvas  
		IF((SELECT MAX(count) FROM #CountTable) > 0)
			BEGIN
			--raiserror ('Canvas Name already exists. Select another name.',11,1);
			SELECT -1;
			END
		-- If not insert new record and return canvasID	
		ELSE
			BEGIN
			INSERT INTO CANVAS ([CANVASNAME] ,[USERID],[CANVASDESCRIPTION],[CREATEDDATE],[MODIFIEDDATE],
			[DATASOURCEID],[CANVASCONTENT])
			VALUES (''+ @CANVASNAME +'','' + @USERID + '', '' + @CANVASDESC + '', '' + @CREATEDDATE + '', '' + @MODIFIEDDATE + '',
			'' + @DATASOURCEID + '', '' + @XMLCONTENT + '');
		    
			SELECT (SELECT CANVASID FROM CANVAS WHERE CANVASNAME = '' + @CANVASNAME + '')
			END
		DROP TABLE #CountTable;
	END
-- If not then update canvas  	
ELSE
	BEGIN
	
	UPDATE CANVAS   
	SET MODIFIEDDATE = @MODIFIEDDATE, 
		CANVASCONTENT =  @XMLCONTENT   
	WHERE CANVASID=@CANVASID;
	
	SELECT @CANVASID;
	RETURN;
	END	
	
END