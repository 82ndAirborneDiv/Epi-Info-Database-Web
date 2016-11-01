CREATE proc [dbo].[usp_log_to_errorlog]  
	@SurveyId AS UNIQUEIDENTIFIER, 
	@ResponseId AS UNIQUEIDENTIFIER, 
	@Comment as VARCHAR(100) =  'no comment', 
	@ErrorText as VARCHAR(100) = 'no error text',   
	@ErrorText2	as   VARCHAR(100) = 'no error text2',           
	@ErrorNumber int = 0,    
	@ErrorSeverity int = 0, 
	@ErrorState int = 0, 
	@ErrorProcedure nvarchar(128) = NULL, 
	@ErrorLine int = 0, 
	@ErrorMessage nvarchar(Max) = NULL  ,       
	@Xml  xml = null
AS  


INSERT INTO [ErrorLog]
           ([SurveyId]
           ,[ResponseId]
           ,[Comment]
           ,[ERROR_NUMBER]
           ,[ERROR_MESSAGE]
           ,[ERROR_SEVERITY]
           ,[ERROR_STATE]
           ,[ERROR_PROCEDURE]
           ,[ERROR_LINE]
           ,[ErrorText]
           ,[ErrorText2]
		   ,[XML])
     VALUES
           ( @SurveyId
           , @ResponseId
           , @comment 
           , @ErrorNumber  
		   , @ErrorMessage           
           , @ERRORSEVERITY
           , @ERRORSTATE
           , @ERRORPROCEDURE
           , @ERRORLINE
		   , @ErrorText
           , @ErrorText2 
		   ,@Xml    )