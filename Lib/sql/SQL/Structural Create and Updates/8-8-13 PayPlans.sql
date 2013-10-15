SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `PPDB` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `PPDB` ;

-- -----------------------------------------------------
-- Table `PPDB`.`Customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PPDB`.`Customers` ;

CREATE TABLE IF NOT EXISTS `PPDB`.`Customers` (
  `CustomerID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(25) NOT NULL,
  `LastName` VARCHAR(25) NULL,
  `DOB` DATE NULL,
  `Address1` VARCHAR(45) NULL,
  `Address2` VARCHAR(45) NULL,
  `City` VARCHAR(25) NULL,
  `State` VARCHAR(2) NULL,
  `ZipCode` VARCHAR(9) NULL,
  `PhoneNumber` VARCHAR(11) NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PPDB`.`Frequency`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PPDB`.`Frequency` ;

CREATE TABLE IF NOT EXISTS `PPDB`.`Frequency` (
  `FrequencyID` INT NOT NULL,
  `Frequency` VARCHAR(15) NULL,
  `Description` VARCHAR(255) NULL,
  PRIMARY KEY (`FrequencyID`))
ENGINE = InnoDB
COMMENT = 'a list of frequecies available\ndaily\nweekly\nbi-weekly\nmonthl /* comment truncated */ /*y
bi-monthly*/';


-- -----------------------------------------------------
-- Table `PPDB`.`Agents`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PPDB`.`Agents` ;

CREATE TABLE IF NOT EXISTS `PPDB`.`Agents` (
  `AgentID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(25) NOT NULL,
  `LastName` VARCHAR(25) NOT NULL,
  `Initials` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`AgentID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PPDB`.`PayPlans`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PPDB`.`PayPlans` ;

CREATE TABLE IF NOT EXISTS `PPDB`.`PayPlans` (
  `PayPlanID` INT NOT NULL AUTO_INCREMENT,
  `CreationDate` DATE NULL,
  `StartingBalance` DECIMAL(10,2) NULL,
  `PaymentAmount` DECIMAL(10,2) NULL,
  `FKPayPlanFrequencyID` INT NULL,
  `StartDate` DATE NULL,
  `OtherConditions` TEXT NULL,
  `FKPayPlanAgentID` INT NOT NULL COMMENT 'the agent who wrote the payment plan',
  `ScanLocation` VARCHAR(255) NULL,
  `RecordDate` TIMESTAMP NULL DEFAULT Current_Timestamp,
  `IsSuspended` TINYINT(1) NULL DEFAULT 0,
  PRIMARY KEY (`PayPlanID`),
  INDEX `FKPayPlanFrequencyID_idx` (`FKPayPlanFrequencyID` ASC),
  INDEX `FKPayPlanAgentID_idx` (`FKPayPlanAgentID` ASC),
  CONSTRAINT `FKPayPlanFrequencyID`
    FOREIGN KEY (`FKPayPlanFrequencyID`)
    REFERENCES `PPDB`.`Frequency` (`FrequencyID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FKPayPlanAgentID`
    FOREIGN KEY (`FKPayPlanAgentID`)
    REFERENCES `PPDB`.`Agents` (`AgentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PPDB`.`PayPlans_has_Customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PPDB`.`PayPlans_has_Customers` ;

CREATE TABLE IF NOT EXISTS `PPDB`.`PayPlans_has_Customers` (
  `PayPlans_PayPlanID` INT NOT NULL,
  `Customers_CustomerID` INT NOT NULL,
  `Defendant` TINYINT(1) NULL DEFAULT 1 COMMENT '1 if customer is defendant on that payment plan',
  PRIMARY KEY (`PayPlans_PayPlanID`, `Customers_CustomerID`),
  INDEX `fk_PayPlans_has_Customers_Customers1_idx` (`Customers_CustomerID` ASC),
  INDEX `fk_PayPlans_has_Customers_PayPlans1_idx` (`PayPlans_PayPlanID` ASC),
  CONSTRAINT `fk_PayPlans_has_Customers_PayPlans1`
    FOREIGN KEY (`PayPlans_PayPlanID`)
    REFERENCES `PPDB`.`PayPlans` (`PayPlanID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PayPlans_has_Customers_Customers1`
    FOREIGN KEY (`Customers_CustomerID`)
    REFERENCES `PPDB`.`Customers` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PPDB`.`Offices`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PPDB`.`Offices` ;

CREATE TABLE IF NOT EXISTS `PPDB`.`Offices` (
  `OfficeID` INT NOT NULL AUTO_INCREMENT,
  `OfficeName` VARCHAR(25) NULL,
  `OfficeAbbreviation` VARCHAR(5) NULL,
  PRIMARY KEY (`OfficeID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PPDB`.`PowerPrefixes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PPDB`.`PowerPrefixes` ;

CREATE TABLE IF NOT EXISTS `PPDB`.`PowerPrefixes` (
  `Prefix` VARCHAR(2) NOT NULL,
  `PowerLimit` DECIMAL(10,2) NULL,
  PRIMARY KEY (`Prefix`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PPDB`.`Bonds`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PPDB`.`Bonds` ;

CREATE TABLE IF NOT EXISTS `PPDB`.`Bonds` (
  `BondiD` INT NOT NULL AUTO_INCREMENT,
  `FKBondPrefix` VARCHAR(2) NOT NULL,
  `PowerNumber` VARCHAR(10) NOT NULL,
  `FKBondAgentID` INT NULL,
  `FKBondOfficeID` INT NULL,
  `ExecutionDate` DATE NULL,
  PRIMARY KEY (`BondiD`, `FKBondPrefix`, `PowerNumber`),
  INDEX `FKBondOfficeID_idx` (`FKBondOfficeID` ASC),
  INDEX `FKBondAgedID_idx` (`FKBondAgentID` ASC),
  INDEX `FKBondPrefix_idx` (`FKBondPrefix` ASC),
  CONSTRAINT `FKBondOfficeID`
    FOREIGN KEY (`FKBondOfficeID`)
    REFERENCES `PPDB`.`Offices` (`OfficeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FKBondAgentID`
    FOREIGN KEY (`FKBondAgentID`)
    REFERENCES `PPDB`.`Agents` (`AgentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FKBondPrefix`
    FOREIGN KEY (`FKBondPrefix`)
    REFERENCES `PPDB`.`PowerPrefixes` (`Prefix`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PPDB`.`Bonds_has_PayPlans`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PPDB`.`Bonds_has_PayPlans` ;

CREATE TABLE IF NOT EXISTS `PPDB`.`Bonds_has_PayPlans` (
  `Bonds_BondiD` INT NOT NULL,
  `PayPlans_PayPlanID` INT NOT NULL,
  PRIMARY KEY (`Bonds_BondiD`, `PayPlans_PayPlanID`),
  INDEX `fk_Bonds_has_PayPlans_PayPlans1_idx` (`PayPlans_PayPlanID` ASC),
  INDEX `fk_Bonds_has_PayPlans_Bonds1_idx` (`Bonds_BondiD` ASC),
  CONSTRAINT `fk_Bonds_has_PayPlans_Bonds1`
    FOREIGN KEY (`Bonds_BondiD`)
    REFERENCES `PPDB`.`Bonds` (`BondiD`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bonds_has_PayPlans_PayPlans1`
    FOREIGN KEY (`PayPlans_PayPlanID`)
    REFERENCES `PPDB`.`PayPlans` (`PayPlanID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PPDB`.`Ledger`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PPDB`.`Ledger` ;

CREATE TABLE IF NOT EXISTS `PPDB`.`Ledger` (
  `EntryID` INT NOT NULL AUTO_INCREMENT,
  `FKLedgerBondID` INT NULL,
  `Date` DATE NULL,
  `Debit` DECIMAL(10,2) NULL COMMENT 'Increases the amount owed to us',
  `Credit` DECIMAL(10,2) NULL COMMENT 'Decreases the amount owed to us',
  `Description` VARCHAR(255) NULL,
  `RecordDate` TIMESTAMP NOT NULL DEFAULT Current_Timestamp,
  PRIMARY KEY (`EntryID`),
  INDEX `FKLedgerBondID_idx` (`FKLedgerBondID` ASC),
  CONSTRAINT `FKLedgerBondID`
    FOREIGN KEY (`FKLedgerBondID`)
    REFERENCES `PPDB`.`Bonds` (`BondiD`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PPDB`.`Comments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PPDB`.`Comments` ;

CREATE TABLE IF NOT EXISTS `PPDB`.`Comments` (
  `CommentID` INT NOT NULL AUTO_INCREMENT,
  `Comment` TEXT NULL,
  `CommentDate` TIMESTAMP NULL DEFAULT Current_Timestamp,
  `FKCommentPayPlanID` INT NOT NULL,
  PRIMARY KEY (`CommentID`, `FKCommentPayPlanID`),
  INDEX `FKCommentPayPlanID_idx` (`FKCommentPayPlanID` ASC),
  CONSTRAINT `FKCommentPayPlanID`
    FOREIGN KEY (`FKCommentPayPlanID`)
    REFERENCES `PPDB`.`PayPlans` (`PayPlanID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PPDB`.`PaymentSchedules`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PPDB`.`PaymentSchedules` ;

CREATE TABLE IF NOT EXISTS `PPDB`.`PaymentSchedules` (
  `ScheduleID` INT NOT NULL AUTO_INCREMENT,
  `FKScheduleBondID` INT NOT NULL,
  `FKSchedulePayPlanID` INT NOT NULL,
  `Amount` DECIMAL(10,2) NULL,
  `DueDate` DATE NULL,
  `SuspendedDate` DATE NULL DEFAULT NULL,
  `RecordDate` TIMESTAMP NULL DEFAULT Current_Timestamp,
  PRIMARY KEY (`ScheduleID`, `FKSchedulePayPlanID`, `FKScheduleBondID`),
  INDEX `FKScheduleBondID_idx` (`FKScheduleBondID` ASC),
  INDEX `FKSchedulePayPlanID_idx` (`FKSchedulePayPlanID` ASC),
  CONSTRAINT `FKScheduleBondID`
    FOREIGN KEY (`FKScheduleBondID`)
    REFERENCES `PPDB`.`Bonds` (`BondiD`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FKSchedulePayPlanID`
    FOREIGN KEY (`FKSchedulePayPlanID`)
    REFERENCES `PPDB`.`PayPlans` (`PayPlanID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PPDB`.`LoadedNewPlans`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PPDB`.`LoadedNewPlans` ;

CREATE TABLE IF NOT EXISTS `PPDB`.`LoadedNewPlans` (
  `CLastName` VARCHAR(25) NULL,
  `CFirstName` VARCHAR(25) NULL,
  `CAddress1` VARCHAR(45) NULL,
  `CAddress2` VARCHAR(45) NULL,
  `CCity` VARCHAR(25) NULL,
  `CState` VARCHAR(2) NULL,
  `CZipCode` VARCHAR(9) NULL,
  `CPhone` VARCHAR(11) NULL,
  `DateExe` DATE NULL,
  `Alpha_pre` VARCHAR(2) NULL,
  `Power` VARCHAR(10) NULL,
  `bl_due` DECIMAL(10,2) NULL,
  `Agent` VARCHAR(3) NULL,
  `ILastName` VARCHAR(25) NULL,
  `IFirstName` VARCHAR(25) NULL,
  `IAddress1` VARCHAR(45) NULL,
  `IAddress2` VARCHAR(45) NULL,
  `ICity` VARCHAR(25) NULL,
  `IState` VARCHAR(2) NULL,
  `IZipCode` VARCHAR(9) NULL,
  `IPhone` VARCHAR(11) NULL,
  `ID` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;

USE `PPDB` ;

-- -----------------------------------------------------
-- procedure PrcPayPlanImport
-- -----------------------------------------------------

USE `PPDB`;
DROP procedure IF EXISTS `PPDB`.`PrcPayPlanImport`;

DELIMITER $$
USE `PPDB`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcPayPlanImport`(
	IN VOfficeID	int
)
begin	
	declare VDateExe	Date;
	declare VAgentIn	VarChar(3);
	declare VAlphaPre	VarChar(2);
	declare VBondNum	VarChar(10);
	declare VBlDue		Decimal(10,2);
	declare VILastName	VarChar(25);
	declare VIFirstName	VarChar(25);
	declare VIAddress1	VarChar(25);
	declare VIAddress2 	VarChar(25);
	declare VICity		VarChar(25);
	declare VIState		VarChar(2);
	declare VIZipcode 	VarChar(9);
	declare VIPhone		VarChar(11);
	declare VID			INT;

	declare VPayPlanID	int;
	declare VAgentID	int;
	declare VCustID		int;

	declare NewCustFlag	boolean;

	/*the following variables are to identify when a value changes
		when the Cfirstname and CLastName change there needs to be a new payplan*/
	declare COldCustomerName	VarChar(50); /*for identifying the payplan*/
	declare CNewCustomerName	VarChar(50);

	/*set up the cursor*/
	declare b int;
	declare CurID cursor for select ID from LoadedNewPlans;
	declare continue handler for not found set b = 1;
	open curID;
	
	set NewCustFlag = 1;
	set b = 0;

	while b =0 DO
		fetch curID into VID;
		select
			concat(CLastName,CFirstName),
			DateExe,
			Agent,
			Alpha_pre,
			Power,
			bl_due,
			ILastName,
			IFirstName,
			IAddress1,
			IAddress2,
			ICity,
			IState,
			IZipCode,
			IPhone
		into
			CNewCustomerName,
			VDateExe,
			VAgentIn,
			VAlphaPre,
			VBondNum,
			VBlDue,
			VILastName,
			VIFirstName,
			VIAddress1,
			VIAddress2,
			VICity,
			VIState,
			VIZipCode,
			VIPhone
		From loadednewplans
		Where loadednewplans.id = VID;
		
		set VAgentID = FnAgentIDFromIn(VAgentIn); /*find the Agent ID of the initials*/
		set VCustID = null;
		
		/*this creates a customer as long as it isn't the defendant and as long as the defendant hasn't been selected yet*/			
		If NewCustFlag = 1 then
			if COldCustomerName = concat(VILastName,VIFirstName) then
				set NewCustFlag = 0;
			else
				if concat(VILastName,VIFirstName) != CNewCustomerName then
					set VCustID = FnCustomerAdd(VIFirstName, VILastName, null, VIAddress1, VIAddress2, VICity, VIState, VIZipCode, VIPhone);
				end if;
			end if;
		end if;

		/* decide whether we need a new payplan*/
		IF COldCustomerName != CNewCustomerName or COldCustomerName is null then
			set COldCustomerName = CNewCustomerName;
			-- select concat(COldCustomerName, ' != ',CNewCustomerName) as 'new Payplan?';
			set NewCustFlag = 1;	/*reset the customers so it starts adding new customers for the next payplan*/

			set	VPayPlanID = FnPayPlanAdd(VDateExe,null,null,null,null,null,VAgentID,null);

			-- select 'First add' as 'plan customer add?';
			-- select VIPhone;
			call PrcPayPlanCustomerAdd(VPayPlanID, FnCustomerAdd(VIFirstName, VILastName, null, VIAddress1, VIAddress2, VICity, VIState, VIZipCode, VIPhone), '1'); /*add defendant to payplan*/
			set VCustID = null;
			
		end if;
		

		/*this adds the signors to the payplan*/
		-- select VCustID;
		-- select VPayPlanid;
		if VCustID is not null then
			-- select 'vcustID' as 'is null';
			call PrcPayPlanCustomerAdd(VPayPlanID,VCustID, '0');
			set VCustID = null;
		end if;
		
	
		/*check if  bond exists, if not add it and add to plan*/
		-- select 'pre bond call';
		if FNCheckForBond(VAlphaPre,VBondNum) = 0 then
			-- select 'bond call';
			call PrcPayPlanBondAdd(VPayPlanID, FnBondAdd(VAlphaPre,VBondNum,VAgentID,VOfficeID,VDateExe,VBlDue));
		end if;

	end while;
	close CurID;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function FnCustomerAdd
-- -----------------------------------------------------

USE `PPDB`;
DROP function IF EXISTS `PPDB`.`FnCustomerAdd`;

DELIMITER $$
USE `PPDB`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- function FnAgentIDFromIn
-- -----------------------------------------------------

USE `PPDB`;
DROP function IF EXISTS `PPDB`.`FnAgentIDFromIn`;

DELIMITER $$
USE `PPDB`$$
Create Function FnAgentIDFromIn
(
	VInitial varchar(3)
)
returns int
Begin
	declare VID int;

	Select `agents`.`AgentID`
	into VID
	from  agents
	Where `agents`.`Initials` = Vinitial;

	return VID;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- function FnBondAdd
-- -----------------------------------------------------

USE `PPDB`;
DROP function IF EXISTS `PPDB`.`FnBondAdd`;

DELIMITER $$
USE `PPDB`$$
CREATE Function `FnBondAdd` 
(
	VarPrefix 		Varchar(2),
	VarNumber 		Varchar(10),
	VarAgent		INT,
	VarOffice 		INT,
	VarExDate 		DATE,
	BeginningDebit 	Decimal(10,2)
)
Returns int
BEGIN
	DECLARE VarBondID 	INT;

	INSERT INTO `PPDB`.`Bonds` 
	(
		`FKBondPrefix`,
		`PowerNumber`, 
		`FKBondAgentID`, 
		`FKBondOfficeID`, 
		`ExecutionDate`
	) 
	VALUES 
	(
		VarPrefix, 
		VarNumber, 
		VarAgent, 
		VarOffice, 
		VarExDate
	);
	SET VarBondID = Last_Insert_ID();
	Call PrcAddLedgerEntry(VarBondID, VarExDate, BeginningDebit, 	'Debit',	'Starting Balance');

	return VarBondID;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function FnCheckForBond
-- -----------------------------------------------------

USE `PPDB`;
DROP function IF EXISTS `PPDB`.`FnCheckForBond`;

DELIMITER $$
USE `PPDB`$$
create function FnCheckForBond
(
	VPrefix  varchar(2),
	VNumber  VarChar(10)
)
returns boolean
begin	
	return exists(select 1 from bonds where FKBondPrefix = vPrefix and PowerNumber = VNumber);
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcAddLedgerEntry
-- -----------------------------------------------------

USE `PPDB`;
DROP procedure IF EXISTS `PPDB`.`PrcAddLedgerEntry`;

DELIMITER $$
USE `PPDB`$$
CREATE PROCEDURE `PrcAddLedgerEntry`
(
	IN VarBONDID	INT,
	IN VarDate		Date,
	IN VarValue		DECIMAL(10,2),
	IN VarDebCred	VarChar(6),
	IN VarDesc		Varchar(255)
)
BEGIN
	DECLARE VarDebit 	DECIMAL(10,2);
	DECLARE VarCredit 	DECIMAL(10,2);

	set VarDebit = null;
	set VarCredit = null;

	Case VarDebCred
		When 'Debit' Then
			set VarDebit = VarValue;
		When 'Credit' Then
			set VarCredit = VarValue;
	END Case;

	IF VarDebit = Null and VarCredit = Null Then
		SIGNAL SQLSTATE '45000'
		Set	Message_Text = 'Either Debit or Credit needs to be specified';
	ELSE
		INSERT INTO `PPDB`.`Ledger` 
		(
			`FKLedgerBondID`, 
			`Date`, 
			`Debit`, 
			`Credit`, 
			`Description`
		) 
		VALUES 
		(
			VarBondID, 
			VarDate, 
			VarDebit, 
			VarCredit, 
			VarDesc
		);
	END IF;
END $$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcPayPlanCustomerAdd
-- -----------------------------------------------------

USE `PPDB`;
DROP procedure IF EXISTS `PPDB`.`PrcPayPlanCustomerAdd`;

DELIMITER $$
USE `PPDB`$$
CREATE PROCEDURE `PrcPayPlanCustomerAdd` 
(
	IN VarPayPlanID 	INT,
	IN VarCustomerID	INT,
	IN VarDefendant		BOOLEAN
)
BEGIN
	IF VarDefendant = null then
		Set VarDefendant = 0;
	END IF;

	INSERT INTO `PPDB`.`PayPlans_has_Customers` 
	(
		`PayPlans_PayPlanID`, 
		`Customers_CustomerID`, 
		`Defendant`
	) VALUES 
	(
		VarPayPlanID, 
		VarCustomerID, 
		VarDefendant
	);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function FnPayPlanAdd
-- -----------------------------------------------------

USE `PPDB`;
DROP function IF EXISTS `PPDB`.`FnPayPlanAdd`;

DELIMITER $$
USE `PPDB`$$
CREATE function `FnPayPlanAdd` 
(
	VarCreationDate		DATE,
	VarStartBal			DECIMAL(10,2),
	VarPaymentAmount	DECIMAL(10,2),
	VarFrequencyID		INT,
	VarStartDate		DATE,
	VarOthCond			text,
	VarAgentID			Int,
	VarScnLoc			VarChar(255)
)
returns int
BEGIN
	DECLARE VarPayPlanID 	INT;

	INSERT INTO `PPDB`.`PayPlans` 
	(
		`CreationDate`, 
		`StartingBalance`, 
		`PaymentAmount`, 
		`FKPayPlanFrequencyID`, 
		`StartDate`, 
		`OtherConditions`, 
		`FKPayPlanAgentID`, 
		`ScanLocation`
	) VALUES 
	(
		VarCreationDate, 
		VarStartBal, 
		VarPaymentAmount, 
		VarFrequencyID,
		VarStartDate, 
		VarOthCond,
		VarAgentID,
		VarScnLoc
	);
	SET VarPayPlanID = Last_Insert_ID();
	return VarPayPlanID;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcPayPlanBondAdd
-- -----------------------------------------------------

USE `PPDB`;
DROP procedure IF EXISTS `PPDB`.`PrcPayPlanBondAdd`;

DELIMITER $$
USE `PPDB`$$
CREATE PROCEDURE `PrcPayPlanBondAdd` 
(
	IN VPayPlanID int,
	IN VBondID int
)
BEGIN
	INSERT INTO `PPDB`.`Bonds_has_PayPlans` 
	(
		`Bonds_BondiD`, 
		`PayPlans_PayPlanID`
	) VALUES 
	(
		VBondID, 
		VPayPlanID
	);
	-- select 'bond plan added' as 'bond plan';
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
