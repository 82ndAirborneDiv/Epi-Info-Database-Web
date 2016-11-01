create proc   [dbo].[usp_process_sql_server_project_response]
  @ResponseId AS UNIQUEIDENTIFIER,
  @SurveyId AS UNIQUEIDENTIFIER,
  @ResponseXML AS XML,
  @IsSQLProject AS bit,      
  @IsDraftMode AS BIT,
  @StatusId as int,    
  @IsSQLResponse AS BIT,
  @FirstSaveLogonName AS VARCHAR (10) 
  
    AS BEGIN
           -- SET NOCOUNT ON added to prevent extra result sets from 
           -- interfering with SELECT statements. 
           SET NOCOUNT ON;    
                      

           DECLARE @InsertText AS VARCHAR (MAX);
           DECLARE @Epi7DBName AS VARCHAR (50);
           DECLARE @UpdateText AS VARCHAR (MAX);
           DECLARE @ResultText AS VARCHAR (MAX);
           DECLARE @UpdateResultText AS VARCHAR (MAX);
           DECLARE @RecordsourceId AS VARCHAR (50);                                 
                      
                      
           -- If Response is not finalized then return    
           IF @StatusId =  1
               BEGIN
                   -- EXEC xp_logevent  70000, 'exited for @statusid != 2',  informational 
                   RETURN;
               END
           
			IF @StatusId =  0    
               BEGIN

                   RETURN;
               END
                      
           
           -- Get the Epi7 proects's DB name      
           SELECT @Epi7DBName = initialcatalog
           FROM   eidatasource
           WHERE  surveyid = @SurveyId;
           
           -- Get project's SQL status        
           SELECT @IsSQLProject = issqlproject
           FROM   surveymetadata
           WHERE  surveyid = @SurveyId;
           
           -- Get record source                    
           SELECT @RecordsourceId = recordsourceid
           FROM   surveyresponse
           WHERE  responseid = @ResponseId;
                                 
     
           
                   -- STEP 1   
                   -- call usp_create_Epi7_views_statement   
                   DECLARE @ViewTableName AS VARCHAR (50);
                   
                   SELECT @ViewTableName = viewtablename
                   FROM   surveymetadataview
                   WHERE  surveyid = @SurveyId;
               
                   DECLARE @InsertviewText AS VARCHAR (500);
                
						    SET @InsertviewText = 'INSERT  INTO  [' + @Epi7DBName + '].dbo.[' + @ViewTableName + ']' + ' ([RECSTATUS]    ,
										[GlobalRecordId]    ,
										[FirstSaveLogonName]    ,
										[FirstSaveTime]    ,
										[LastSaveLogonName]    ,
										[LastSaveTime]  )
										values   ' + 
										'(  ' + 
											'1 ,  ' + 
											quotename(CAST (@ResponseId AS VARCHAR (100)), '''') + ', ' + 
											quotename('EWE', '''') + ', ' + 
											quotename(CAST (Getdate() AS VARCHAR (100)), '''') + ', ' + 
											quotename('EWE', '''') + ', ' + 
											quotename(CAST (Getdate() AS VARCHAR (100)), '''')  +   
											') ';
      

      
                   EXECUTE (@InsertviewText);
               
                   -- STEP 2    
                   EXECUTE usp_create_epi7_sql_statements_driver 
							@ResponseXml, 
							@SurveyId,  
							@ResponseId, 
							'i', 
							@Epi7DBName;                                      
                   EXECUTE (@InsertText);  --  returned from  sp                     
      
       END