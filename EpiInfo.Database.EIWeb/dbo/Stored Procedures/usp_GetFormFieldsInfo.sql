CREATE PROCEDURE  [dbo].[usp_GetFormFieldsInfo]    
@FormId VARCHAR (1000) = ''
AS
BEGIN


	select ColumnName, TableName, SortOrder from ResponseDisplaySettings inner join SurveyMetaDataTransform  ON 
	ResponseDisplaySettings.FormId = SurveyMetaDataTransform.SurveyId 
	Where  Cast(ResponseDisplaySettings.FormId as varchar(100)) = @FormId
	And ResponseDisplaySettings.ColumnName = SurveyMetaDataTransform.FieldName
	AND FieldTypeId Not in (20, 2, 3, 21 ) -- Neglecting non data fields.
    Order by SortOrder

END