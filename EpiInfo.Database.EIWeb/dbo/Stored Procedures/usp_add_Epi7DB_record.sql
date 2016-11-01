CREATE PROCEDURE  [dbo].[usp_add_Epi7DB_record]  
	@StatusId VARCHAR(50),  
	@ResponseId   uniqueidentifier,   
	@FirstSaveLogonName varchar(50 ),   
	@FirstSaveTime  dateTime, 
	@LastSaveLogonName varchar(50 ), 
	@LastSaveTime   dateTime, 
	@ParentRecordId  uniqueidentifier, 
	@Epi7DBName varchar(50 )         
	    

AS