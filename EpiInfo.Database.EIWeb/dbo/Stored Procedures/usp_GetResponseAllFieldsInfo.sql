CREATE PROCEDURE  [dbo].[usp_GetResponseAllFieldsInfo]    
@FormId VARCHAR (1000) = ''
AS
BEGIN

 
 --select FieldName, TableName, ViewTableName from SurveyMetaDataTransform  
 --inner join SurveyMetaDataView On
	--SurveyMetaDataTransform.SurveyId = SurveyMetaDataView.SurveyId
	--Where  Cast(SurveyMetaDataTransform.SurveyId as varchar(100)) = @FormId
	--AND FieldTypeId Not in (20, 2, 3, 17, 21 )
	
	select FieldName, TableName from SurveyMetaDataTransform  
	Where  Cast(SurveyMetaDataTransform.SurveyId as varchar(100)) = @FormId
	AND FieldTypeId Not in (20, 2, 3, 21 )

END