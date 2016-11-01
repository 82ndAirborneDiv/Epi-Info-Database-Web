CREATE PROCEDURE  [dbo].[usp_IsSQLProject]    
@FormId varchar(100) = ''
AS
BEGIN

	Select IsSQLProject
	 from SurveyMetaData where Cast(SurveyId as varchar(100)) = @FormId;-- '05c7ff68-4feb-4e54-a620-8670dadf7590'   ; --CONVERT(UNIQUEIDENTIFIER, @FormId);

END