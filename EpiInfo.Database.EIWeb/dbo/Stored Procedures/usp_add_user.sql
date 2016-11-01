-- =============================================
-- Author:		Caci Inc
-- Create date: 4/15/2013
-- Description:	This stored procedure adds a user 
-- in the system. This process involves adding datasources
-- and relationship between user and datasource. 
-- This process is handled in a transaction.
-- =============================================
CREATE PROCEDURE [dbo].[usp_add_user]
@UserName Varchar(50),
@UsrId Varchar(50),
@FirstName Varchar(50),
@LastName Varchar(50),
@EmailAddress Varchar(50),
@PhoneNumber Varchar(50),
@PasswordHash Varchar(50),
@ResetPassword bit,
@DatasourceUser DatasourceUserTableType READONLY,
@OrganizationId varchar(10),
@RoleId varchar(5),
@Active BIT,
@UGuid uniqueidentifier


AS
	
SET NOCOUNT ON;

BEGIN TRANSACTION;
Declare @UserId int;
--Declare @CurrentUserCount int;

IF EXISTS(Select * From [User] Where EmailAddress = @EmailAddress)
BEGIN
Set @UsrId = (Select TOP 1 UserID From [User] Where EmailAddress = @EmailAddress);
END

--IF @CurrentUserCount > 0
--BEGIN
--@UserId = 
--END

IF @UsrId = -1 OR @UsrId = NULL
	Begin
	INSERT INTO [User] ([UserName], [FirstName], [LastName],  [EmailAddress], [PhoneNumber], [PasswordHash], [ResetPassword], [UGuid]) 
	VALUES (@UserName, @FirstName, @LastName,   @EmailAddress, @PhoneNumber, @PasswordHash, @ResetPassword, @UGuid);
	Set @UserId = SCOPE_IDENTITY();
	End
Else
	Begin
	Set @UserId = @UsrId ;
	End

 BEGIN 
	INSERT INTO DatasourceUser (DatasourceID, UserID)
		SELECT DatasourceID , @UserId
		FROM   @DatasourceUser;
 END
 
 INSERT INTO USERORGANIZATION ([UserId], [OrganizationId], [RoleID], [Active])
VALUES (@UserId, @OrganizationId, @RoleID, @Active)

IF @@Error > 0
    ROLLBACK;
ELSE
    COMMIT TRANSACTION;