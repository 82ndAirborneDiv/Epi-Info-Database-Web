-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[usp_GetEIRecord]  
@FormId varchar(100) = '',
@ViewTableName varchar(100) = ''
AS
BEGIN
set  @ViewTableName =(	select ViewTableName from SurveyMetaDataView where SurveyId = @FormId) --  '14eaa835-9c33-4c7d-81a3-41ce0e122784'

END