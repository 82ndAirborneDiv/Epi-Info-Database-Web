-- =============================================
-- Author:		CACI
-- Create date: 4/15/2013
-- Description: This Stored Procedure is created to Add organization in 
-- a the system. The process of adding new organization
-- and admin to the organization will be encapsulated as
-- a one transaction.
-- =============================================
CREATE PROCEDURE [dbo].[usp_add_organization] 
@OrganizationName Varchar(50),
@OrganizationDescription varchar(max),
@UserId varchar(10),
@UserNm varchar(100),
@FirstNm Varchar(100),
@LastNm Varchar(100),
@EmailAdd Varchar(100),
@PhoneNbr Varchar(100),
@PwdHash Varchar(100),
@ResetPwd bit,
@RoleId int,
@IsActive bit,
@IsExistingUser bit,
@OrganizationKey nvarchar(500)



AS
BEGIN

Declare @RETURN_VALUE int = -1 , @OrganizationId int = -1;
Declare @ErrMsg nvarchar(250);
BEGIN TRANSACTION;

-- Adding Organization
	INSERT INTO ORGANIZATION (Organization, IsEnabled, OrganizationKey) VALUES (@OrganizationName, @IsActive, @OrganizationKey);   
	set @OrganizationId =   SCOPE_IDENTITY( )    ;
	
-- Adding User	
	If(@IsExistingUser = 0)
		BEGIN
			IF EXISTS(Select * From [User] Where EmailAddress = @EmailAdd)
				BEGIN
				Set @UserId = (Select UserId from [User] Where EmailAddress = @EmailAdd);
				END
			ELSE
				BEGIN
				INSERT INTO [User] ([UserName], [FirstName], [LastName],  [EmailAddress], [PhoneNumber], [PasswordHash], [ResetPassword]) 
				VALUES (@UserNm, @FirstNm, @LastNm,   @EmailAdd, @PhoneNbr, @PwdHash, @ResetPwd);
				Set @UserId = SCOPE_IDENTITY();
				END
		END
	Else
		Begin
			--EXEC [dbo].[usp_add_user]
			--@UserName = @UserNm,
			--@FirstName = @FirstNm,
			--@LastName = @LastNm,
			--@EmailAddress = @EmailAdd,
			--@PhoneNumber = @PhoneNbr,
			--@PasswordHash = @PwdHash,
			--@ResetPassword = @ResetPwd,
			--@UsrId = @UserId,
			--@OrganizationId = @OrganizationId,
			--@RoleId = @RoleId
			--@RETURN_VALUE = @RETURN_VALUE OUTPUT;
			
			--Set @UserId = @RETURN_VALUE;
			--INSERT INTO [User] ([UserName], [FirstName], [LastName],  [EmailAddress], [PhoneNumber], [PasswordHash], [ResetPassword]) 
			--VALUES (@UserNm, @FirstNm, @LastNm,   @EmailAdd, @PhoneNbr, @PwdHash, @ResetPwd);
			--Set @UserId = SCOPE_IDENTITY();
			Set @UserId = (Select UserId from [User] Where EmailAddress = @EmailAdd);
		End
		
--Adding relationship

INSERT INTO USERORGANIZATION ([UserId], [OrganizationId], [RoleID], [Active])
VALUES (@UserId, @OrganizationId, @RoleID, @IsActive)

IF (@@Error > 0 OR @UserId = -1 OR @OrganizationId = -1)
	Begin
		Set @ErrMsg = 'Adding organization "' + @OrganizationName + '" with Administrator failed.';
		RaisError(@ErrMsg, 10, 1) ;
		ROLLBACK;
    End
ELSE
    COMMIT TRANSACTION;
	
END