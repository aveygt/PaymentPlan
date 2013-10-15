use ppdb;
drop function if exists FnCustomerAdd;
drop procedure if exists PrcModCustomer;

-- --------------------------------------------------------------------------------
-- AddCustomer Group Routines
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE function `FnCustomerAdd` (
	VFName 		 Varchar(25), 
	VLName 		 VarChar(25),  
	VDOB 		 Date, 
	VALine1 	 VarChar(45), 
	VALine2 	 VarChar(45), 
	VCity 		 VarChar(25), 
	VState 		 VarChar(2), 
	VZipCode 	 VarChar(9),
	VPhoneNumber VarChar(11)
)
returns int
BEGIN
	DECLARE CustID INT;
	

	INSERT INTO `ppdb`.`Customers`
	(
		`FirstName`,
		`LastName`,
		`DOB`,
		`Address1`,
		`Address2`,
		`City`,
		`State`,
		`ZipCode`,
		`PhoneNumber`
	)
	VALUES
	(
		VFNAME, 
		VLName, 
		VDOB,
		VALine1, 
		VALine2, 
		VCity, 
		VState,
		VZipCode,
		VPhoneNumber
	);
	
	SET CustID = Last_Insert_ID();
	return CustID;
END$$

create procedure PrcModCustomer(
	in VCID			int,
	in VFName 		Varchar(25), 
	in VLName 		VarChar(25),  
	in VDOB 		Date, 
	in VALine1 	 	VarChar(45), 
	in VALine2 	 	VarChar(45), 
	in VCity 		VarChar(25), 
	in VState 		VarChar(2), 
	in VZipCode 	VarChar(9),
	in VPhoneNumber VarChar(11)
)
begin 
	UPDATE `ppdb`.`customers`
	SET
	`FirstName` 	= VFName,
	`LastName` 		= VLName,
	`DOB` 			= VDOB,
	`Address1` 		= VALine1,
	`Address2` 		= VALine2,
	`City` 			= VCity,
	`State` 		= VState,
	`ZipCode` 		= VZipCode,
	`PhoneNumber` 	= VPhoneNumber
	WHERE `CustomerID` = VCID;

end$$
