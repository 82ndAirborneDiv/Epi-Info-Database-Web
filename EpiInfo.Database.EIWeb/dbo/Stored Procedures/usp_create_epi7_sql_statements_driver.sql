CREATE  PROCEDURE [dbo].[usp_create_epi7_sql_statements_driver]         
	@xml XML, 
	@SurveyId UNIQUEIDENTIFIER, 
	@ResponseId  UNIQUEIDENTIFIER,    
	@Mode varchar(50 ),  
	@Epi7DBName varchar(50 )     
AS

--  EXEC xp_logevent  70000,  'start driver ', informational 
DECLARE @InsertText AS VARCHAR (MAX);
DECLARE @ResultText AS VARCHAR (MAX);
DECLARE @UpdateText AS VARCHAR (MAX);
DECLARE @InsertResultText AS VARCHAR (MAX);
DECLARE @UpdateResultText AS VARCHAR (MAX);
DECLARE @UseDBText AS VARCHAR (MAX);
DECLARE @PageXml AS XML;
DECLARE @PageId AS INT;

IF OBJECT_ID('tempdb..#temp_outer') IS NOT NULL
    DROP TABLE #temp_outer;

SELECT doc.col.value('@MetaDataPageId ', 'int') AS PageId
INTO   #temp_outer
FROM   @xml.nodes('/SurveyResponse/Page ') AS doc(col);

-- For tests     
-- SELECT *
-- FROM   #temp_outer;

-- A FAST_FORWARD      
DECLARE PAGE_ID CURSOR FAST_FORWARD
    FOR SELECT PageId
        FROM   #temp_outer;
OPEN PAGE_ID;
FETCH NEXT FROM PAGE_ID INTO @PageId;
WHILE (@@FETCH_STATUS = 0)
    BEGIN
        SELECT @PageXml = doc.col.query('Page[@MetaDataPageId=sql:variable("@PageId") ]') --    , 'varchar(70)')    
        FROM   @xml.nodes('/SurveyResponse ') AS doc(col);
		
		-- For tests    
        -- select @PageXml   as  PageXml    
        
		EXECUTE usp_create_epi7_sql_statements 
			@PageXml, @SurveyId, @ResponseId, 
			@InsertText = @InsertResultText OUTPUT, 
			@UpdateText = @UpdateResultText OUTPUT;

		-- For tests     
        -- SET @UseDBText = 'use ' + QUOTENAME(@Epi7DBName);
        -- execute (@UseDBText) 
		

            IF @Mode = 'i'
				BEGIN
					SET @ResultText =   @InsertResultText;
					EXECUTE (@InsertResultText);
				END
            ELSE
				BEGIN
					SET @ResultText =  @UpdateResultText;
					EXECUTE (@UpdateResultText);
				END

			IF @@ERROR >  0    
			  BEGIN

				DECLARE @ErrorNumber AS INT;
				DECLARE @ErrorSeverity AS INT;
				DECLARE @ErrorState AS INT;
				DECLARE @ErrorProcedure AS NVARCHAR (128);
				DECLARE @ErrorLine AS INT;
				DECLARE @ErrorMessage AS NVARCHAR (4000);
            
				SELECT @ErrorNumber = ERROR_NUMBER(), --  AS ErrorNumber
						@ErrorSeverity = ERROR_SEVERITY(), --  AS ErrorSeverity
						@ErrorState = ERROR_STATE(), --  AS ErrorState
						@ErrorProcedure = ERROR_PROCEDURE(), --  AS ErrorProcedure
						@ErrorLine = ERROR_LINE(), --   AS ErrorLine
						@ErrorMessage = ERROR_MESSAGE(); --   AS ErrorMessage;
            
				EXECUTE usp_log_to_errorlog 
					@SurveyId, @ResponseId, @ResultText, 
					'usp_create_epi7_sql_statements_driver', '@InsertResultText/@UpdateResultText', 
					@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage;		

			  END   
			     
		-- For tests
        --SELECT @ResultText;
             

        FETCH NEXT FROM PAGE_ID INTO @PageId;

    END  -- WHILE    

CLOSE PAGE_ID;
DEALLOCATE PAGE_ID;