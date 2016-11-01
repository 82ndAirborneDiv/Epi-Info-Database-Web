CREATE VIEW [dbo].[ErrorLogSorted]
AS
SELECT     TOP (100) PERCENT ErrorDate, SurveyId, ResponseId, Comment, ErrorText, ErrorText2
FROM         dbo.ErrorLog
ORDER BY ErrorDate DESC