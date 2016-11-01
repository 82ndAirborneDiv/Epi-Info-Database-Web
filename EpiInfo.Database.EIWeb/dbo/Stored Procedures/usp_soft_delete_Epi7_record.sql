CREATE   PROC  [dbo].[usp_soft_delete_Epi7_record]         
	@ResponseId as uniqueidentifier,
	@SurveyId as uniqueidentifier,   
	@IsResponsePresent as bit 
AS 

DECLARE @IsSQLResponse as BIT  
DECLARE @IsResponseinsertedToEpi7 AS BIT    
DECLARE @ViewTableName AS VARCHAR (50);
DECLARE @UpdateSQL AS VARCHAR(MAX) ;
DECLARE @Epi7DBName AS VARCHAR(50) ;
DECLARE @RECSTATUS  as SMALLINT =  0  ; 
DECLARE @IsSQLProject AS BIT;

-- exec  usp_log_to_errorlog  @SurveyId, @ResponseId, 'soft delete testHello world ', 'text'  
	
-- Get the Epi7 proects's DB name      
SELECT @Epi7DBName = initialcatalog
FROM   eidatasource
WHERE  surveyid = @SurveyId;
							     
IF @IsResponsePresent = 1  
	BEGIN
	
    	-- Get IsSqlResponse from SurveyResponseTracking  
		SELECT	@IsSQLResponse = issqlresponse, 
				@IsResponseinsertedToEpi7 = isresponseinsertedtoepi7                   
		FROM   surveyresponsetracking
		WHERE  responseid = @ResponseId;

		IF	@IsSQLResponse = 1 
			and @IsResponseinsertedToEpi7 = 1 
			BEGIN  
                   SELECT @ViewTableName = viewtablename
                   FROM   surveymetadataview
                   WHERE  surveyid = @SurveyId;
                   
                   SET @UpdateSQL =   'UPDATE  [' + @Epi7DBName + '].dbo.[' + @ViewTableName + '] ' + 
											' SET RECSTATUS = ' + CAST (@RECSTATUS AS VARCHAR(10)) + ' ' + 
											' WHERE GlobalRecordId = ' + QUOTENAME(CAST (@ResponseId as VARCHAR(100)), '''')										

					EXECUTE (@UpdateSQL ) ; 
					RETURN ; 											
			END         
			
	END 
ELSE
	BEGIN
	
		-- exec  usp_log_to_errorlog  @SurveyId, @ResponseId, 'soft delete test from APP 1 ', 'text'  
					
	   -- Get project's SQL status                   
	   SELECT @IsSQLProject = issqlproject
	   FROM   surveymetadata
	   WHERE  surveyid = @SurveyId;

		IF @IsSQLProject = 1  
			BEGIN  
				   SELECT @ViewTableName = viewtablename
                   FROM   surveymetadataview
                   WHERE  surveyid = @SurveyId;
            
					SET @UpdateSQL =   'UPDATE  [' + @Epi7DBName + '].dbo.[' + @ViewTableName + '] ' + 
											' SET RECSTATUS = ' + CAST (@RECSTATUS AS VARCHAR(10)) + ' ' + 
											' WHERE GlobalRecordId = ' + QUOTENAME(CAST (@ResponseId as VARCHAR(100)) , '''')  
											
		--  exec  usp_log_to_errorlog  @SurveyId, @ResponseId, 'soft delete test from APP 2 ',  @UpdateSQL  
		
					EXECUTE (@UpdateSQL ) ; 
					RETURN ; 											            
			END  
			           
	END