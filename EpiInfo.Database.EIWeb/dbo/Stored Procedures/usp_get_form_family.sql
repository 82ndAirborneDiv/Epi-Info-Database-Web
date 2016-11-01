--  exec  usp_get_form_family     'D6CB7DFA-255E-4BC7-9042-1E40A0B10564'       '4AD66995-6665-4C8D-9882-05995818BC01'    
--select *  from SurveyMetaData    
--where  SurveyName like 'emr2'    
        
CREATE PROCEDURE [dbo].[usp_get_form_family]
	@SurveyId VARCHAR (50)
AS

DECLARE @topNode AS VARCHAR (50);

WITH   CteAlias2
AS     (SELECT SurveyId,
               SurveyName AS Path,
               ParentId
        FROM   SurveyMetaData
        WHERE  SurveyId = @SurveyId
        UNION ALL
        SELECT SurveyMetaData.SurveyId AS topNode,
               CAST (SurveyMetaData.SurveyName + '\' + CteAlias2.Path AS NVARCHAR (500)) AS SPath,
               SurveyMetaData.parentid
        FROM   SurveyMetaData
               INNER JOIN
               CteAlias2
               ON SurveyMetaData.SurveyId = CteAlias2.ParentId)    
               
SELECT @topNode = CteAlias2.SurveyId
FROM   CteAlias2;    
    
WITH   CteAlias
AS     (SELECT s.[SurveyName] AS Path,
               s.SurveyId, --    [SurveyId] 
               s.OwnerId,
               s.SurveyNumber,
               s.[SurveyTypeId],
               s.[SurveyName],
               s.[TemplateXML],
               s.[UserPublishKey],
               s.[DateCreated],
               s.[IsDraftMode],
               s.[StartDate],
               s.[ParentId],
               s.[ViewId],
               s.[IsSQLProject]
        FROM   SurveyMetaData AS s
        WHERE  SurveyId = @topNode
        UNION ALL
        SELECT CAST (CteAlias.Path + '\' + s.SurveyName AS NVARCHAR (500)) AS SPath,
               s.[SurveyId] AS topNode,
               s.OwnerId,
               s.SurveyNumber,
               s.[SurveyTypeId],
               s.[SurveyName],
               s.[TemplateXML],
               s.[UserPublishKey],
               s.[DateCreated],
               s.[IsDraftMode],
               s.[StartDate],
               s.[ParentId],
               s.[ViewId],
               s.[IsSQLProject]
        FROM   SurveyMetaData AS s
               INNER JOIN
               CteAlias
               ON s.parentid = CteAlias.SurveyId)
SELECT *
FROM   CteAlias;

-- select *           into  familyset      
--from SurveyMetaData 
--where SurveyId in    
--(
--select   SurveyId     
--from CteAlias    
--)
--use EWELiteIntegration    
--select * from   familyset