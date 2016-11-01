CREATE TABLE [dbo].[ErrorLog](
	[ErrorDate] [datetime] NOT NULL CONSTRAINT [DF_ErrorLog_ErrorDate]  DEFAULT (getdate()),
	[SurveyId] [uniqueidentifier] NULL,
	[ResponseId] [uniqueidentifier] NULL,
	[Comment] [varchar](max) NULL,
	[ERROR_NUMBER] [int] NULL,
	[ERROR_MESSAGE] [nvarchar](4000) NULL,
	[ERROR_SEVERITY] [int] NULL,
	[ERROR_STATE] [int] NULL,
	[ERROR_PROCEDURE] [nvarchar](1128) NULL,
	[ERROR_LINE] [int] NULL,
	[ErrorText] [nvarchar](max) NULL,
	[ErrorText2] [nvarchar](max) NULL,
	[XML] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE TRIGGER   [dbo].[tr_insert_errorlog] 
   ON  [dbo].[ErrorLog]
	FOR  INSERT  
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @cleandate    datetime2    
set  @cleandate =    DATEADD (day, -7  ,     getdate(  )  )  

delete from ErrorLog    
where ErrorDate <  @cleandate    


END