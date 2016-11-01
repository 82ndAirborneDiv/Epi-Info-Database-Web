CREATE PROCEDURE [dbo].[usp_create_epi7_sql_statements]
	@PageXml XML, 
	@SurveyId UNIQUEIDENTIFIER, 
	@ResponseId VARCHAR (50), 
	@InsertText VARCHAR (MAX) OUTPUT, 
	@UpdateText VARCHAR (MAX) OUTPUT
AS

DECLARE @PageId AS DECIMAL;
DECLARE @TabName AS VARCHAR (MAX);

declare @throw_text as  VARCHAR (MAX)     

--  EXEC xp_logevent  70000,  'started core proc   ', informational     



-- Force GlobalRecordId     
SET @PageXml.modify(  'insert <ResponseDetail QuestionName="GlobalRecordId"> {sql:variable("@ResponseId")}  </ResponseDetail > 
				 into 	(/Page)[1]' )  



-- Cleanup    
IF OBJECT_ID('tempdb..#temp') IS NOT NULL
    DROP TABLE #temp;    


-- Get PageId from xml               
SET @PageId = (SELECT doc.col.value('@MetaDataPageId', 'decimal') AS p
               FROM   @PageXml.nodes('/Page ') AS doc(col));
               -- FROM   @xml.nodes('/SurveyResponse/Page ') AS doc(col));    
if @PageId  is null  
	BEGIN   
		INSERT  INTO [ErrorLog] ([SurveyId], [ResponseId], comment, [ErrorText])
                    VALUES (@SurveyId, @ResponseId, 'Could not read @PadId -  usp_create_epi7_sql_statements', 'usp_create_epi7_sql_statements ');
	 
		--SET @throw_text =  'Could not read @PadId -  usp_create_epi7_sql_statements - Could not parse pageId from XML ';        
		--THROW  51000,  @throw_text, 1 ;        
	END    



-- Get TabName from metadata         
SET @TabName = (SELECT TOP 1 TABLEName
                FROM   SurveyMetaDataTransform
                WHERE  SurveyId = @SurveyId
                       AND PageId = @PageId);

if @TabName is null  
	BEGIN    
		INSERT  INTO [ErrorLog] ([SurveyId], [ResponseId], comment, [ErrorText])
                    VALUES (@SurveyId, @ResponseId, 'No table name found for given SurveyId and PageId combination', 'usp_create_epi7_sql_statements '); 
		     
	END    


-- For Tests
--select @PageXml  as SourceXML    
--select @SurveyId as SurveyId, @PageId as PageId  


-- Create a work  TABLE                                 
SELECT doc.col.value('@QuestionName', 'varchar(70)') AS FieldName,
       doc.col.value('. ', 'varchar(70)') AS Fieldvalue,
       doc.col.value('. ', 'varchar(70)') AS FieldvalueForInsert, 
       (SELECT fieldtypeid
        FROM   SurveyMetaDataTransform
        WHERE  fieldname = doc.col.value('@QuestionName', 'varchar(70)')
               AND SurveyId = @SurveyId
               AND PageId = @PageId) AS FieldTypeId 
INTO   #temp
FROM   @PageXml.nodes('/Page/ResponseDetail') AS doc(col);    
-- FROM   @xml.nodes('/SurveyResponse/Page/ResponseDetail  ') AS doc(col);    


-- Force GlobalRecordId         
UPDATE  #temp
SET FieldTypeId = 99
WHERE   fieldName = 'GlobalRecordId';

-- Add a new column for UPDATE statement parse         
ALTER TABLE #temp
ADD SqlText VARCHAR (MAX);

--  adjust values for boolean FieldTypes     
update  #temp 
set  Fieldvalue = '0' 
where  Fieldvalue = 'NO'    
and FieldTypeId = 10  

--  adjust values for boolean FieldTypes  
update  #temp 
set  Fieldvalue = '1' 
where  Fieldvalue = 'YES'    
and FieldTypeId = 10  

--  adjust values for boolean FieldvalueForInsert     
update  #temp 
set  FieldvalueForInsert = '0' 
where  FieldvalueForInsert = 'NO'    
and FieldTypeId = 10  

--  adjust values for boolean FieldvalueForInsert  
update  #temp 
set  FieldvalueForInsert = '1' 
where  FieldvalueForInsert = 'YES'    
and FieldTypeId = 10  

update #temp 
set Fieldvalue = NULL 
where Fieldvalue = '' 
 
update  #temp 
set  FieldvalueForInsert = 'NULL' 
where  FieldvalueForInsert = ''    
and FieldTypeId = 7  
 

update #temp 
set SqlText = 
	( case when  Fieldvalue is null  
		then QUOTENAME(FieldName) + ' = '  +  ISNULL(Fieldvalue, 'NULL' ) 
		else QUOTENAME(FieldName) + ' = ' + QUOTENAME( Fieldvalue , '''')
		end  
	)  		


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
					@SurveyId, @ResponseId, '', 
					'usp_create_epi7_sql_statements', 'Insert/Update in #temp table may have failed', 
					@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage;		

			  END   

-- For Tests
--select * from #temp    

DECLARE @cols AS VARCHAR (MAX);
DECLARE @values AS VARCHAR (MAX);
        

-- Concat text for column list for  INSERT    
SET @cols = STUFF((SELECT ',' + QUOTENAME(FieldName)
                   FROM   #temp
                   WHERE  FieldTypeId NOT IN (2, 3, 20, 21, 13) --  , 2, 3, 17, 21   )    
                   FOR    XML PATH (''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');
if @cols  is null  
	BEGIN   
		INSERT  INTO [ErrorLog] ([SurveyId], [ResponseId], comment, [ErrorText])
                    VALUES (@SurveyId, @ResponseId, 'Could not create @cols string ', 'usp_create_epi7_sql_statements ');	  
	END    


-- Concat text for  VALUES list       
SET @values = STUFF((SELECT						
							CASE when FieldvalueForInsert = 'NULL' 
								then  ', NULL'  
								else  ',' + QUOTENAME(FieldvalueForInsert, '''')
								end
					FROM   #temp
					WHERE  FieldTypeId NOT IN (2, 3, 20, 21, 13) --  , 2, 3, 17, 21   )    
					FOR    XML PATH (''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') 

if @values  is null  
	BEGIN  
		INSERT  INTO [ErrorLog] ([SurveyId], [ResponseId], comment, [ErrorText])
                    VALUES (@SurveyId, @ResponseId, 'Could not create @values string', 'usp_create_epi7_sql_statements ');	      
	END    

-- For Tests
--select   @values  as    [values]  

-- Concat text  for SET clause     
--  dont update  GlobalRecordId    
SET @UpdateText = STUFF((SELECT ',' + SqlText
                         FROM   #temp
                         WHERE  FieldTypeId NOT IN (2, 3, 20, 21, 13) --   2, 3, 17, 21   )        
                                AND FieldName != 'GlobalRecordId' --  dont update  GlobalRecordId                    
                         FOR    XML PATH (''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

IF @UpdateText IS NULL
BEGIN  
		INSERT  INTO [ErrorLog] ([SurveyId], [ResponseId], comment, [ErrorText])
                    VALUES (@SurveyId, @ResponseId, 'Could not create @UpdateText string', 'usp_create_epi7_sql_statements ');	  
	END    

--For test
--select @UpdateText  as [UpdateText]        

DECLARE @Epi7DBName VARCHAR(50);    
          
SELECT @Epi7DBName = initialcatalog 
FROM   eidatasource 
WHERE  surveyid = @SurveyId; 

IF @Epi7DBName IS NULL
BEGIN  
		INSERT  INTO [ErrorLog] ([SurveyId], [ResponseId], comment, [ErrorText])
                    VALUES (@SurveyId, @ResponseId, 'Could not create @Epi7DBName string', 'usp_create_epi7_sql_statements ');	     
END    

set @TabName =  '[' +  @Epi7DBName  +  '].[dbo].['  +  @TabName +  ']'    

--  Bake the cake     
SET @InsertText = 'INSERT  INTO ' + @TabName +    
					' ( ' + @cols + ' ) 
				  VALUES  
					  ( ' + @values + ') ';

--  Bake the cake        
SET @UpdateText =  N' UPDATE ' + @TabName + 
				  ' SET ' + @UpdateText + ' 
				    WHERE GlobalRecordId =  ' + QUOTENAME(@ResponseId, '''');       


      				    
-- Cleanup!
DROP TABLE #temp;