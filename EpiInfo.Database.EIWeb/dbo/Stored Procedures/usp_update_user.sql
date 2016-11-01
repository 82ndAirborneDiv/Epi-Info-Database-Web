-- =============================================
-- Author:		CACI Inc.
-- Create date: 4/16/2013
-- Description:	This Stored procedure handles the updation
-- of the User . The process of the updation is encapsulated
-- in one single transaction.
-- =============================================
CREATE PROCEDURE [dbo].[usp_update_user] 
	@FirstName Varchar(100),
	@LastName Varchar(100),
	@EmailAddress Varchar(100),
	@PhoneNumber Varchar(100),
	@UserId varchar(50),
	--@IsUserActive BIT,
	
	@OrganizationId Varchar(100),
	@IsUserOrgActive BIT,
	@RoleId int,
	@DatasourceUser DatasourceUserTableType READONLY 
	
	
AS
BEGIN

-- Update User
BEGIN TRANSACTION;
Update [User] Set FirstName = @FirstName, LastName = @LastName, EmailAddress = @EmailAddress, PhoneNumber = @PhoneNumber--, IsActive = @IsUserActive 
WHERE UserId = @UserId;

-- Update User Organization

EXEC usp_update_user_organization @Active = @IsUserOrgActive, @RoleId = @RoleId, @UserId = @UserId , @OrganizationId = @OrganizationId;


-- remove all datasources of user for this specific organization

EXEC usp_remove_user_datasource @UserId = @UserId, @OrganizationId = @OrganizationId;

-- add given datasources for the user

INSERT INTO DatasourceUser (DatasourceID, UserID)
		SELECT DatasourceID,
			   UserID
		FROM   @DatasourceUser;


IF @@Error > 0
Begin
	Raiserror('Updating User failed' , 10 , 1);
    ROLLBACK;
End
ELSE
    COMMIT TRANSACTION;

END