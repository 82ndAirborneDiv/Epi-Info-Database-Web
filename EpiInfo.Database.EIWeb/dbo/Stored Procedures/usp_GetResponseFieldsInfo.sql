CREATE PROCEDURE  [dbo].[usp_GetResponseFieldsInfo]    
@FormId VARCHAR (1000) = ''
AS
BEGIN


	--select ColumnName, TableName, SortOrder from ResponseDisplaySettings inner join SurveyMetaDataTransform  ON 
	--ResponseDisplaySettings.FormId = SurveyMetaDataTransform.SurveyId 
	--Where  Cast(ResponseDisplaySettings.FormId as varchar(100)) = @FormId
	--And ResponseDisplaySettings.ColumnName = SurveyMetaDataTransform.FieldName
	--AND FieldTypeId Not in (20, 2, 3, 17, 21 ) -- Neglecting non data fields.
 --   Order by SortOrder
 
 select ColumnName, TableName, SortOrder, FieldTypeID, ViewTableName from ResponseDisplaySettings 
 	inner join SurveyMetaDataTransform  ON 
	ResponseDisplaySettings.FormId = SurveyMetaDataTransform.SurveyId 
	inner join SurveyMetaDataView On
	ResponseDisplaySettings.FormId = SurveyMetaDataView.SurveyId
	Where  Cast(ResponseDisplaySettings.FormId as varchar(100)) = @FormId
	And ResponseDisplaySettings.ColumnName = SurveyMetaDataTransform.FieldName
	AND FieldTypeId Not in (20, 2, 3, 21 )
    Order by SortOrder

END