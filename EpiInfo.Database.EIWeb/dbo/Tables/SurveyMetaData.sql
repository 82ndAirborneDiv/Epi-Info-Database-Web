CREATE TABLE [dbo].[SurveyMetaData](
	[SurveyId] [uniqueidentifier] NOT NULL,
	[OwnerId] [int] NOT NULL,
	[SurveyNumber] [nvarchar](50) NULL,
	[SurveyTypeId] [int] NOT NULL,
	[ClosingDate] [datetime2](7) NOT NULL,
	[SurveyName] [nvarchar](500) NOT NULL,
	[OrganizationName] [nvarchar](500) NULL,
	[DepartmentName] [nvarchar](500) NULL,
	[IntroductionText] [nvarchar](max) NULL,
	[TemplateXML] [xml] NOT NULL,
	[ExitText] [nvarchar](max) NULL,
	[UserPublishKey] [uniqueidentifier] NOT NULL,
	[TemplateXMLSize] [bigint] NOT NULL,
	[DateCreated] [datetime2](7) NOT NULL CONSTRAINT [DF_SurveyMetaData_DateCreated]  DEFAULT (getdate()),
	[OrganizationId] [int] NOT NULL,
	[IsDraftMode] [bit] NOT NULL CONSTRAINT [DF_SurveyMetaData_IsDraftMode]  DEFAULT ((0)),
	[StartDate] [datetime2](7) NOT NULL CONSTRAINT [DF_SurveyMetaData_StartDate]  DEFAULT (getdate()),
	[ParentId] [uniqueidentifier] NULL,
	[ViewId] [int] NULL,
	[IsSQLProject] [bit] NULL CONSTRAINT [DF_SurveyMetaData_IsSQLProject]  DEFAULT ((0)),
	[IsShareable] [bit] NULL,
	[ShowAllRecords] [bit] NULL CONSTRAINT [DF_SurveyMetaData_ShowAllRecords]  DEFAULT ((0)),
	[DataAccessRuleId] [int] NULL CONSTRAINT [DF_SurveyMetaData_DataAccessRuleId]  DEFAULT ((1)),
 CONSTRAINT [PK_SurveyMetaData] PRIMARY KEY CLUSTERED 
(
	[SurveyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE     TRIGGER [dbo].[tr_update_SurveyMetaData  ]  
    ON [dbo].[SurveyMetaData]  
    FOR UPDATE, INSERT
      AS 
    

	   DECLARE @SurveyId AS UNIQUEIDENTIFIER;
       DECLARE @IsDraftMode AS BIT;
         DECLARE @xmlMetadataDocument AS XML 
   
         DECLARE @ViewTableName as varchar(50)  
   declare   @PageTableName  varchar(50)  
   declare   @PageId   varchar(50)  
          
        SELECT @SurveyId = i.SurveyId
       FROM   inserted AS i;
       
       SELECT @IsDraftMode = i.IsDraftMode
       FROM   inserted AS i;

		SELECT  @xmlMetadataDocument = i.TemplateXML 
		from inserted as i; 
		
              
       DELETE  SurveyMetaDataTransform     
       WHERE  SurveyId = @SurveyId;
       
       DELETE  SurveyMetadataView  
       WHERE  SurveyId = @SurveyId;
              
  
    select  @ViewTableName =    doc.col.value('@Name  ', 'varchar(70)')   
        FROM   @xmlMetadataDocument.nodes('/Template/Project/View  ') AS doc(col  )    

    select  @PageId  =    doc.col.value('@PageId', 'varchar(70)')   
        FROM   @xmlMetadataDocument.nodes('/Template/Project/View/Page    ') AS doc(col  )    
        
  set  @PageTableName  =  @ViewTableName +   @PageId               
        
        print  'surveyid = ' +  cast   (@surveyid as  varchar(50) )  
        
	--  Insert into SurveyMetaDataView  
	   INSERT INTO   SurveyMetaDataView 
			([SurveyId], [ViewTableName] )
	   VALUES  
			( @SurveyId, @ViewTableName  ) ; 
	
	--  Insert into SurveyMetaDataTransform  
       INSERT INTO   SurveyMetaDataTransform (  [SurveyId], [FieldName], [FieldTypeId], [TableName], [PageId]         )
       (SELECT @SurveyId AS SurveyId,
               doc.col.value('@Name', 'varchar(70)') AS FieldName,
               doc.col.value('@FieldTypeId', 'int') AS FieldTypeId, 
				@ViewTableName + doc.col.value('@PageId', 'varchar(10)') AS TableName,  
				 doc.col.value('@PageId', 'int') AS PageId      
        FROM   @xmlMetadataDocument.nodes('/Template/Project/View/Page/Field  ') AS doc(col));