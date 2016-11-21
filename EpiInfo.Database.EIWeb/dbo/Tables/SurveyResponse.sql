CREATE TABLE [dbo].[SurveyResponse](
	[ResponseId] [uniqueidentifier] NOT NULL,
	[SurveyId] [uniqueidentifier] NOT NULL,
	[DateUpdated] [datetime2](7) NOT NULL,
	[DateCompleted] [datetime2](7) NULL,
	[StatusId] [int] NOT NULL,
	[ResponseXML] [xml] NOT NULL,
	[ResponsePasscode] [nvarchar](30) NULL,
	[ResponseXMLSize] [bigint] NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[IsDraftMode] [bit] NOT NULL,
	[IsLocked] [bit] NOT NULL CONSTRAINT [DF_SurveyResponse_IsLocked]  DEFAULT ((0)),
	[ParentRecordId] [uniqueidentifier] NULL,
	[RelateParentId] [uniqueidentifier] NULL,
	[RecordSourceId] [int] NULL CONSTRAINT [DF_SurveyResponse_RecordSourceId]  DEFAULT ((1)),
	[OrganizationId] [int] NULL,
 CONSTRAINT [PK_SurveyResponse] PRIMARY KEY CLUSTERED 
(
	[ResponseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurveyResponse]  WITH CHECK ADD  CONSTRAINT [FK_SurveyResponse_lk_Status] FOREIGN KEY([StatusId])
REFERENCES [dbo].[lk_Status] ([StatusId])
GO

ALTER TABLE [dbo].[SurveyResponse] CHECK CONSTRAINT [FK_SurveyResponse_lk_Status]
GO
ALTER TABLE [dbo].[SurveyResponse]  WITH CHECK ADD  CONSTRAINT [FK_SurveyResponse_SurveyMetaData] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[SurveyMetaData] ([SurveyId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SurveyResponse] CHECK CONSTRAINT [FK_SurveyResponse_SurveyMetaData]
GO
ALTER TABLE [dbo].[SurveyResponse]  WITH NOCHECK ADD  CONSTRAINT [FK_SurveyResponse_SurveyResponse] FOREIGN KEY([RelateParentId])
REFERENCES [dbo].[SurveyResponse] ([ResponseId])
GO
ALTER TABLE [dbo].[SurveyResponse]  WITH CHECK ADD  CONSTRAINT [FK_SurveyResponse_lk_RecordSource] FOREIGN KEY([RecordSourceId])
REFERENCES [dbo].[lk_RecordSource] ([RecordSourceId])
GO

ALTER TABLE [dbo].[SurveyResponse] CHECK CONSTRAINT [FK_SurveyResponse_lk_RecordSource]
GO

ALTER TABLE [dbo].[SurveyResponse] CHECK CONSTRAINT [FK_SurveyResponse_SurveyResponse]
GO
CREATE TRIGGER [dbo].[tr_delete_surveyresponse]
    ON [dbo].[SurveyResponse]	
    FOR DELETE
AS 

BEGIN

	   SET NOCOUNT ON;

	   -- Cleanup    
	   IF OBJECT_ID('tempdb..#temp') IS NOT NULL
		   DROP TABLE #temp;

	   DECLARE @IsSQLResponse AS BIT;
	   DECLARE @IsResponseinsertedToEpi7 AS BIT;
	   DECLARE @ViewTableName AS VARCHAR (50);
	   DECLARE @UpdateSQL AS VARCHAR (MAX);
	   DECLARE @Epi7DBName AS VARCHAR (50);
	   DECLARE @RECSTATUS AS SMALLINT = 0;
	   DECLARE @IsSQLProject AS BIT;
	   DECLARE @SurveyId AS UNIQUEIDENTIFIER;
	   DECLARE @ResponseId AS UNIQUEIDENTIFIER;
	   DECLARE @PageTableName AS VARCHAR (50);
	   DECLARE @DeleteSQL AS VARCHAR (500); 
	   DECLARE @RecordsourceId  AS VARCHAR (50); 

	    SELECT @RecordsourceId = d.RecordsourceId			  
	   FROM   deleted AS d;

	   If @RecordsourceId='2'
		BEGIN
			RETURN;
		END

		 If @RecordsourceId='3'
		BEGIN
			RETURN;
		END

		 If @RecordsourceId='4'
		BEGIN
			RETURN;
		END

	   SELECT @ResponseId = d.responseid,
			  @SurveyId = d.surveyid
	   FROM   deleted AS d;
	   	   
	   SELECT @IsSQLProject = issqlproject
	   FROM   surveymetadata
	   WHERE  surveyid = @SurveyId;
	   
	   -- Is this a SQL project?            
	   IF @IsSQLProject = 1
		   BEGIN
		   
			   -- Get the Epi7 proects's DB name      
			   SELECT @Epi7DBName = initialcatalog
			   FROM   eidatasource
			   WHERE  surveyid = @SurveyId;
			   
			   -- Get the Epi7 ViewTable name     
			   SELECT @ViewTableName = viewtablename
			   FROM   surveymetadataview
			   WHERE  surveyid = @SurveyId;
			   
			   -- Get a uique list of the data collection tabs
			   -- for this SurveyId    
			   SELECT DISTINCT [TableName]
			   INTO   #temp
			   FROM   [SurveyMetaDataTransform]
			   WHERE  SurveyId = @SurveyId;    
			   			   			   
			   -- Loop through all data collection tabs and delete 
			   -- the response records    aaaa  			   			   			   
			   DECLARE PAGE_TABLE CURSOR FAST_FORWARD
				   FOR SELECT TableName
					   FROM   #temp;
			   OPEN PAGE_TABLE;
			   FETCH NEXT FROM PAGE_TABLE INTO @PageTableName;        
			   			   			   			   
			   WHILE (@@FETCH_STATUS = 0)
				   BEGIN
					   SET @DeleteSQL = ' DELETE FROM ' + '[' + @Epi7DBName + '].[dbo].[' + @PageTableName + ']' + 
										' WHERE GlobalRecordId = ' + QUOTENAME(CAST (@ResponseId AS VARCHAR (255)), '''');
										
					   EXECUTE (@DeleteSQL);
					    IF @@ERROR > 0
							GOTO ERRORBLOCK;

					   FETCH NEXT FROM PAGE_TABLE INTO @PageTableName;
				   END
			   
			   CLOSE PAGE_TABLE;
			   DEALLOCATE PAGE_TABLE;
			   			   
			   SET @DeleteSQL = ' DELETE FROM ' + '[' + @Epi7DBName + '].[dbo].[' + @ViewTableName + ']' + 
								' WHERE GlobalRecordId = ' + QUOTENAME(CAST (@ResponseId AS VARCHAR (255)), '''');
			   
			   -- Delete the parent record  										
			   EXECUTE (@DeleteSQL);
			   IF @@ERROR > 0
					GOTO ERRORBLOCK;
		   END

		    RETURN;

		   ERRORBLOCK:
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
						@SurveyId, @ResponseId, '', 
						'tr_delete_surveyresponse', @DeleteSQL, 
						@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage;	

			END   

	RETURN;
END
GO
CREATE    TRIGGER [dbo].[tr_insert_surveyresponse]
    ON [dbo].[SurveyResponse]
    FOR INSERT  
    AS 
    
    BEGIN
           -- SET NOCOUNT ON added to prevent extra result sets from
           -- interfering with SELECT statements.
           SET NOCOUNT ON;
    
           DECLARE @SurveyId AS UNIQUEIDENTIFIER;
           DECLARE @ResponseId AS UNIQUEIDENTIFIER;
           DECLARE @StatusId AS INT;
           DECLARE @IsDraftMode AS BIT;
           DECLARE @RecordsourceId  AS VARCHAR (50); 		   
           
           SELECT @ResponseId = i.ResponseId,
                  @SurveyId = i.SurveyId,
                  @StatusId = i.StatusId,
                  @IsDraftMode = i.IsDraftMode, 
                  @RecordsourceId = i.RecordsourceId
           FROM   inserted AS i;

             If @RecordsourceId='2'
		BEGIN
			RETURN;
		END

		If @RecordsourceId='3'
		BEGIN
			RETURN;
		END

		If @RecordsourceId='4'
		BEGIN
			RETURN;
		END


           -- Get project's SQL status       
           DECLARE @IsSQLProject AS BIT;
           SELECT @IsSQLProject = IsSQLProject 
           FROM   SurveyMetaData
           WHERE  SurveyId = @SurveyId;


           -- PATH 1     
           IF @IsSQLProject = 1
              AND @StatusId = 1
              AND @RecordsourceId = '1'
               BEGIN
                    INSERT INTO   SurveyResponseTracking
						(ResponseId, IsSQLResponse, IsResponseinsertedToEpi7  )
						VALUES
						(@ResponseId, 1, 0)
						
						IF @@ERROR > 0
							GOTO ERRORBLOCK;						  						           
                   RETURN;
               END
           
           -- PATH 2        
           IF @IsSQLProject = 0
               BEGIN
                    INSERT INTO   SurveyResponseTracking
						(ResponseId, IsSQLResponse, IsResponseinsertedToEpi7  )
						VALUES
						(@ResponseId,  0, 0 ) 	

						IF @@ERROR > 0
							GOTO ERRORBLOCK;

                   RETURN;
               END
           
           --  PATH 3            
           IF @IsSQLProject = 1
              AND @StatusId = 2       
              and @RecordsourceId = '2'  
               BEGIN
                INSERT INTO   SurveyResponseTracking
						(ResponseId, IsSQLResponse, IsResponseinsertedToEpi7  )
						VALUES
						(@ResponseId, 1, 1 ) 
						
						IF @@ERROR > 0
							GOTO ERRORBLOCK;
								      
                   RETURN;
               END
           
           --  PATH  5                        
           IF @IsSQLProject = 1
              AND @StatusId = 2
              AND @RecordsourceId  = '3'
               BEGIN
					INSERT INTO   SurveyResponseTracking
						(ResponseId, IsSQLResponse, IsResponseinsertedToEpi7  )
						   VALUES
						(@ResponseId, 1, 0 ) 		                   
				
                     UPDATE  SurveyResponseTracking
						SET IsResponseinsertedToEpi7 = 1     
                     WHERE  ResponseId =  @ResponseId ;

					 IF @@ERROR > 0
							GOTO ERRORBLOCK;

                   RETURN;
               END
      	  
	   RETURN;

	   ERRORBLOCK:
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
					@SurveyId, @ResponseId, '', 
					'tr_insert_surveyresponse', 'Insert/Update of SurveyResponseTracking failed', 
					@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage;	

		END   

	   RETURN;

	END
GO
CREATE TRIGGER [dbo].[tr_update_surveyresponse]
    ON [dbo].[SurveyResponse]
    FOR UPDATE
    AS 
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from 
    -- interfering with SELECT statements. 
    SET NOCOUNT ON;

    DECLARE @SurveyId AS UNIQUEIDENTIFIER;
    DECLARE @ResponseId AS UNIQUEIDENTIFIER;
    DECLARE @StatusId AS INT;
    DECLARE @ResponseXml AS XML;
    DECLARE @IsDraftMode AS BIT;
    DECLARE @IsSQLResponse AS BIT;
    DECLARE @IsResponseinsertedToEpi7 AS BIT;
    DECLARE @ParentRecordId AS UNIQUEIDENTIFIER;   
    DECLARE @InsertText AS VARCHAR (MAX);
    DECLARE @Epi7DBName AS VARCHAR (50);
    DECLARE @UpdateText AS VARCHAR (MAX);
    DECLARE @ResultText AS VARCHAR (MAX);
    DECLARE @UpdateResultText AS VARCHAR (MAX);
    DECLARE @RecordsourceId AS VARCHAR (50);
    DECLARE @UseDBText AS VARCHAR (100);
    DECLARE @ViewTableName AS VARCHAR (50);
    DECLARE @RelateParentId AS UNIQUEIDENTIFIER;
	DECLARE @throw_text as  VARCHAR(MAX); 
	DECLARE @ErrorNumber AS INT;
	DECLARE @ErrorSeverity AS INT;
	DECLARE @ErrorState AS INT;
	DECLARE @ErrorProcedure AS NVARCHAR (128);
	DECLARE @ErrorLine AS INT;
	DECLARE @ErrorMessage AS NVARCHAR (4000);
	DECLARE @InsertviewText AS VARCHAR (500); 

	-- Get values from just inserted record                
    SELECT @ResponseId = i.responseid,
            @SurveyId = i.surveyid,
            @StatusId = i.statusid,
            @ResponseXml = i.responsexml,
            @IsDraftMode = i.isdraftmode,
            @ParentRecordId = i.parentrecordid,
            @RelateParentId = i.relateparentid
    FROM   inserted AS i;


	-- Get record source                    
    SELECT @RecordsourceId = recordsourceid
    FROM   surveyresponse
    WHERE  responseid = @ResponseId;

	 IF @RecordsourceId='2'
	 BEGIN
	 RETURN;--For Future Implementation
	 END

	 IF @RecordsourceId='3'
	  BEGIN
	 RETURN;--For Future Implementation
	 END

	 IF @RecordsourceId='4'
		BEGIN
		DECLARE @FirstSaveLogonNameWS AS VARCHAR (100) = 'EIWS';

		EXECUTE usp_log_to_errorlog @SurveyId, @ResponseId, 'test1'  
	       
       
      -- IF @IsDraftMode = 1   
          -- BEGIN
             --  RETURN;
           --END
       
       IF  @StatusId <> 3  
           BEGIN
               RETURN;
           END
	
		-- If IsSQLProject = true
			-- Enter data to Epi Info using code similar to EWE Integration
		--Else
			-- Code below    
			
		SELECT @IsSQLResponse = IsSQLProject           
		FROM   surveymetadata
		WHERE  surveyid = @SurveyId;
			
			
			--SET  @IsSQLResponse = 1    
			   
			IF @IsSQLResponse = 1 
				BEGIN
					--===========================		
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

			
					-- STEP 1   
					-- call usp_create_Epi7_views_statement   
					--DECLARE @ViewTableName AS VARCHAR (50);

					SELECT @ViewTableName = viewtablename
					FROM   surveymetadataview
					WHERE  surveyid = @SurveyId;
				

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
									quotename(@FirstSaveLogonNameWS, '''') + ', ' + 
									quotename(CAST (Getdate() AS VARCHAR (100)), '''') + ', ' + 
									quotename(@FirstSaveLogonNameWS, '''') + ', ' + 
									quotename(CAST (Getdate() AS VARCHAR (100)), '''')  +   
									') ';

						IF @InsertviewText IS NULL
							BEGIN            
								INSERT  INTO [ErrorLog] ([SurveyId], [ResponseId], comment, [ErrorText])
								VALUES                 (@SurveyId, @ResponseId, '@InsertviewText is null ', @InsertviewText);				  
							END 
						ELSE
							BEGIN
								EXECUTE (@InsertviewText);

									IF @@ERROR >  0    
									  BEGIN 					             
										SELECT @ErrorNumber = ERROR_NUMBER(), --  AS ErrorNumber
												@ErrorSeverity = ERROR_SEVERITY(), --  AS ErrorSeverity
												@ErrorState = ERROR_STATE(), --  AS ErrorState
												@ErrorProcedure = ERROR_PROCEDURE(), --  AS ErrorProcedure
												@ErrorLine = ERROR_LINE(), --   AS ErrorLine
												@ErrorMessage = ERROR_MESSAGE(); --   AS ErrorMessage;
            
										EXECUTE usp_log_to_errorlog 
											@SurveyId, @ResponseId, @InsertviewText, 
											'usp_create_epi7_sql_statements', 'Insert/Update in #temp table may have failed', 
											@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage;
									  END   
						END    


					
					 
					-- STEP 2    
					EXECUTE usp_create_epi7_sql_statements_driver 
							@ResponseXml, 
							@SurveyId,  
							@ResponseId, 
							'i', 
							@Epi7DBName;                                      

					EXECUTE (@InsertText);  --  returned from  sp      
					
					
						IF @@ERROR >  0    
							BEGIN 					             
								SELECT @ErrorNumber = ERROR_NUMBER(), --  AS ErrorNumber
								@ErrorSeverity = ERROR_SEVERITY(), --  AS ErrorSeverity
								@ErrorState = ERROR_STATE(), --  AS ErrorState
								@ErrorProcedure = ERROR_PROCEDURE(), --  AS ErrorProcedure
								@ErrorLine = ERROR_LINE(), --   AS ErrorLine
								@ErrorMessage = ERROR_MESSAGE(); --   AS ErrorMessage;
            
							EXECUTE usp_log_to_errorlog 
							@SurveyId, @ResponseId, @InsertText, 
							'usp_create_epi7_sql_statements', 'Insert/Update in #temp table may have failed', 
							@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage;
					  END                          					
					--===========================  
					RETURN 
				END
			ELSE 
				BEGIN
				   -- Simple replace of Yes with 1 / No with 
					--DECLARE @xmltext AS VARCHAR (MAX);
					--SET @xmltext = CONVERT (VARCHAR (MAX), @ResponseXML);
					--SET @xmltext = REPLACE(@xmltext, 'Yes', 1);
					--SET @xmltext = REPLACE(@xmltext, 'No', 0);
					--SET @ResponseXML  = CONVERT (XML, @xmltext);



				   -- Create the relational records from the XML     
				 --  INSERT INTO [dbo].[ResponsesForPivot] ([SurveyId], [ResponseId], [FieldName], [FieldValue])
				 --  (SELECT @SurveyId AS SurveyId,
					--	   @ResponseId AS ResponseId,
					--	   T.c.value('(@QuestionName)[1 ]  ', 'Varchar(100 )  ') AS FieldName,
					--	   T.c.value('(.)', 'Varchar(100 )  ') AS FieldValue
					--FROM   @ResponseXML.nodes('/SurveyResponse/Page/*') AS T(c));
				   
				 --  --  Explicilty deal with fields that should NULL    
				 --  UPDATE  ResponsesForPivot
					--   SET FieldValue = NULL
				 --  WHERE   FieldValue = '';		
				



			RETURN;
			END
		END

	 IF @RecordsourceId='1'
		BEGIN

		 DECLARE @FirstSaveLogonName AS VARCHAR (100) = 'EWE\';

    -- Get User Id 
    DECLARE @UserId AS INT;
    DECLARE @UserName AS VARCHAR (100);
    SELECT @UserId = UserId
    FROM   SurveyResponseUser
    WHERE  ResponseId = @ResponseId;
    
	-- Get User name
    SELECT @UserName = UserName
    FROM   dbo.[User]
    WHERE  UserId = @UserId;
    
	-- Update  @FirstSaveLogonName
    SET @FirstSaveLogonName = @FirstSaveLogonName + @UserName;
    
	-- If Response is not finalized then return    
    IF @StatusId = 1
        BEGIN            
            RETURN;
        END    

	-- If status is delete then soft delete    					
	IF @StatusId = 0
        BEGIN
            EXECUTE usp_soft_delete_Epi7_record @ResponseId, @SurveyId, 1;           
            RETURN;
        END

    -- Is this response from SQL?  Query surveyresponsetracking 
    SELECT @IsSQLResponse = issqlresponse,
            @IsResponseinsertedToEpi7 = isresponseinsertedtoepi7
    FROM   surveyresponsetracking
    WHERE  responseid = @ResponseId;    
		
			
    -- If Response is not from a SQL server project then return          
    IF @IsSQLResponse = 0
        BEGIN            
            RETURN;
        END    

    -- Get the Epi7 proects's DB name      
    SELECT @Epi7DBName = initialcatalog
    FROM   eidatasource
    WHERE  surveyid = @SurveyId;   
				
	-- Get project's SQL status        
    DECLARE @IsSQLProject AS BIT;
    SELECT @IsSQLProject = issqlproject
    FROM   surveymetadata
    WHERE  surveyid = @SurveyId;    	

    IF @IsSQLResponse = 1 AND @IsResponseinsertedToEpi7 = 0
        BEGIN
            -- STEP 1   
            -- call usp_create_Epi7_views_statement   
            SELECT @ViewTableName = viewtablename
            FROM   surveymetadataview
            WHERE  surveyid = @SurveyId;                     


			IF @RelateParentId IS NOT NULL
                BEGIN
                    SET @InsertviewText = 'INSERT  INTO  [' + @Epi7DBName + '].dbo.[' + @ViewTableName + ']' + ' ([RECSTATUS]    ,
								[GlobalRecordId]    ,
								[FirstSaveLogonName]    ,
								[FirstSaveTime]    ,
								[LastSaveLogonName]    ,
								[LastSaveTime]    ,
								[FKEY])     
								values    ' + 
								'(  ' + '1 ,  ' + 
								QUOTENAME(CAST (@ResponseId AS VARCHAR (100)), '''') + ', ' + 
								QUOTENAME(@FirstSaveLogonName, '''') + ', ' + 
								QUOTENAME(CAST (Getdate() AS VARCHAR (100)), '''') + ', ' + 
								QUOTENAME(@FirstSaveLogonName, '''') + ', ' + 
								QUOTENAME(CAST (Getdate() AS VARCHAR (100)), '''') + ', ' + 
								QUOTENAME(CAST (@RelateParentId AS VARCHAR (100)), '''') + ') ';
                END
            ELSE
                BEGIN
                    SET @InsertviewText = 'INSERT  INTO  [' + @Epi7DBName + '].dbo.[' + @ViewTableName + ']' + ' ([RECSTATUS]    ,
								[GlobalRecordId]    ,
								[FirstSaveLogonName]    ,
								[FirstSaveTime]    ,
								[LastSaveLogonName]    ,
								[LastSaveTime]  )
								values   ' + 
								'(  ' + '1 ,  ' + 
								QUOTENAME(CAST (@ResponseId AS VARCHAR (100)), '''') + ', ' + 
								QUOTENAME(@FirstSaveLogonName, '''') + ', ' + 
								QUOTENAME(CAST (Getdate() AS VARCHAR (100)), '''') + ', ' + 
								QUOTENAME(@FirstSaveLogonName, '''') + ', ' + 
								QUOTENAME(CAST (Getdate() AS VARCHAR (100)), '''') + ') ';
                END
            

			IF @InsertviewText IS NULL
                BEGIN            
                    INSERT  INTO [ErrorLog] ([SurveyId], [ResponseId], comment, [ErrorText])
                    VALUES                 (@SurveyId, @ResponseId, '@InsertviewText is null ', @InsertviewText);				  
                END
            ELSE
                BEGIN
                    EXECUTE (@InsertviewText);
					

					IF @@ERROR >  0    
					  BEGIN 					             
						SELECT @ErrorNumber = ERROR_NUMBER(), --  AS ErrorNumber
								@ErrorSeverity = ERROR_SEVERITY(), --  AS ErrorSeverity
								@ErrorState = ERROR_STATE(), --  AS ErrorState
								@ErrorProcedure = ERROR_PROCEDURE(), --  AS ErrorProcedure
								@ErrorLine = ERROR_LINE(), --   AS ErrorLine
								@ErrorMessage = ERROR_MESSAGE(); --   AS ErrorMessage;
            
						EXECUTE usp_log_to_errorlog 
							@SurveyId, @ResponseId, @InsertviewText, 
							'usp_create_epi7_sql_statements', 'Insert/Update in #temp table may have failed', 
							@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage;
					  END   
                END    

			--STEP 2    
			-- this sp returns  @InsertText
            EXECUTE [usp_create_epi7_sql_statements_driver] 
				@ResponseXml, @SurveyId, 
				@ResponseId, 'i', @Epi7DBName;
            EXECUTE (@InsertText); --  returned from  sp  
			
			IF @@ERROR >  0    
					  BEGIN 					             
						SELECT @ErrorNumber = ERROR_NUMBER(), --  AS ErrorNumber
								@ErrorSeverity = ERROR_SEVERITY(), --  AS ErrorSeverity
								@ErrorState = ERROR_STATE(), --  AS ErrorState
								@ErrorProcedure = ERROR_PROCEDURE(), --  AS ErrorProcedure
								@ErrorLine = ERROR_LINE(), --   AS ErrorLine
								@ErrorMessage = ERROR_MESSAGE(); --   AS ErrorMessage;
            
						EXECUTE usp_log_to_errorlog 
							@SurveyId, @ResponseId, @InsertText, 
							'usp_create_epi7_sql_statements', 'Insert/Update in #temp table may have failed', 
							@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage;
					  END                       
            
			-- STEP 3   
            -- after insert update tracking   
            UPDATE  surveyresponsetracking
            SET IsResponseinsertedToEpi7 = 1
            WHERE   responseid = @ResponseId;
			            
			RETURN;
        END    
	
    IF @IsSQLResponse = 1  AND @IsResponseinsertedToEpi7 = 1
        BEGIN    

            -- STEP 1   
            -- call usp_create_Epi7_views_statement   
            SELECT @ViewTableName = viewtablename
            FROM   surveymetadataview
            WHERE  surveyid = @SurveyId;
            
			DECLARE @UpdateviewText AS VARCHAR (500);
              

			IF @RelateParentId IS NOT NULL
                BEGIN
                    SET @UpdateviewText =              
						' UPDATE   [' + @Epi7DBName + '].dbo.[' + @ViewTableName + ']' + 
						' SET [LastSaveLogonName] = ' + quotename(@FirstSaveLogonName, '''') + ', ' + 
						'     [LastSaveTime] = ' + quotename(CAST (Getdate() AS VARCHAR (100)), '''') + ' , ' + 
						'     [FKEY] = ' + quotename(CAST (@RelateParentId AS VARCHAR (100)), '''') + ' ' + 
						 ' WHERE GlobalRecordId = ' + QUOTENAME(CAST (@ResponseId AS VARCHAR (255)), '''');    
						--  ' WHERE GlobalRecordId = ' +  CAST (@ResponseId AS VARCHAR (255))        ;    
                END
            ELSE
                BEGIN
                    SET @UpdateviewText =   
						' UPDATE   [' + @Epi7DBName + '].dbo.[' + @ViewTableName + ']' + 
						' SET [LastSaveLogonName] = ' + quotename(@FirstSaveLogonName, '''') + ', ' + 
						'     [LastSaveTime] = ' + quotename(CAST (Getdate() AS VARCHAR (100)), '''') + '  ' + 
						 ' WHERE GlobalRecordId = ' + QUOTENAME(CAST (@ResponseId AS VARCHAR (255)), '''');    
						--    ' WHERE GlobalRecordId = ' +  CAST (@ResponseId AS VARCHAR (255))        ;    						 
						                    
                END    
  
            IF @UpdateviewText IS NULL
                BEGIN

			
                    INSERT  INTO [ErrorLog] ([SurveyId], [ResponseId],comment, [ErrorText])
                    VALUES                 (@SurveyId, @ResponseId, '@UpdateViewText  ',   @UpdateViewText  );
					
                END
            ELSE
                BEGIN
                    EXECUTE (@UpdateviewText);
					
					IF @@ERROR >  0    
					  BEGIN 					             
						SELECT @ErrorNumber = ERROR_NUMBER(), --  AS ErrorNumber
								@ErrorSeverity = ERROR_SEVERITY(), --  AS ErrorSeverity
								@ErrorState = ERROR_STATE(), --  AS ErrorState
								@ErrorProcedure = ERROR_PROCEDURE(), --  AS ErrorProcedure
								@ErrorLine = ERROR_LINE(), --   AS ErrorLine
								@ErrorMessage = ERROR_MESSAGE(); --   AS ErrorMessage;
            
						EXECUTE usp_log_to_errorlog 
							@SurveyId, @ResponseId, @UpdateviewText, 
							'usp_create_epi7_sql_statements', 'Insert/Update in #temp table may have failed', 
							@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage;
					  END    
                END

            -- STEP 2   
			-- this sp returns  @UpdateText    
            EXECUTE [usp_create_epi7_sql_statements_driver] 
				@ResponseXml, @SurveyId, 
				@ResponseId, 'u', @Epi7DBName;
            EXECUTE (@UpdateText); -- returned   
			
			IF @@ERROR >  0    
					  BEGIN 					             
						SELECT @ErrorNumber = ERROR_NUMBER(), --  AS ErrorNumber
								@ErrorSeverity = ERROR_SEVERITY(), --  AS ErrorSeverity
								@ErrorState = ERROR_STATE(), --  AS ErrorState
								@ErrorProcedure = ERROR_PROCEDURE(), --  AS ErrorProcedure
								@ErrorLine = ERROR_LINE(), --   AS ErrorLine
								@ErrorMessage = ERROR_MESSAGE(); --   AS ErrorMessage;
            
						EXECUTE usp_log_to_errorlog 
							@SurveyId, @ResponseId, @UpdateText, 
							'usp_create_epi7_sql_statements', 'Insert/Update in #temp table may have failed', 
							@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage;
					  END    
            
			RETURN;
        END
	END

END