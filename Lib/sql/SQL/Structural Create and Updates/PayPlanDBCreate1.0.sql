SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';
SET GLOBAL log_bin_trust_function_creators = 1;
CREATE SCHEMA IF NOT EXISTS `ppdb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `ppdb` ;

-- -----------------------------------------------------
-- Table `ppdb`.`Customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ppdb`.`Customers` ;

CREATE TABLE IF NOT EXISTS `ppdb`.`Customers` (
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
-- Table `ppdb`.`Agents`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ppdb`.`Agents` ;

CREATE TABLE IF NOT EXISTS `ppdb`.`Agents` (
  `AgentID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(25) NOT NULL,
  `LastName` VARCHAR(25) NOT NULL,
  `Initials` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`AgentID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ppdb`.`Frequency`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ppdb`.`Frequency` ;

CREATE TABLE IF NOT EXISTS `ppdb`.`Frequency` (
  `FrequencyID` INT NOT NULL,
  `Frequency` VARCHAR(15) NULL,
  `Description` VARCHAR(255) NULL,
  PRIMARY KEY (`FrequencyID`))
ENGINE = InnoDB
COMMENT = 'a list of frequecies available\ndaily\nweekly\nbi-weekly\nmonthl /* comment truncated */ /*y
bi-monthly*/';


-- -----------------------------------------------------
-- Table `ppdb`.`PayPlans`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ppdb`.`PayPlans` ;

CREATE TABLE IF NOT EXISTS `ppdb`.`PayPlans` (
  `PayPlanID` INT NOT NULL AUTO_INCREMENT,
  `CreationDate` DATE NULL,
  `StartingBalance` DECIMAL(10,2) NULL,
  `PaymentAmount` DECIMAL(10,2) NULL,
  `FKPayPlanFrequencyID` INT NULL,
  `StartDate` DATE NULL,
  `OtherConditions` TEXT NULL,
  `FKPayPlanAgentID` INT NOT NULL COMMENT 'the agent who wrote the payment plan',
  `ScanLocation` VARCHAR(255) NULL,
  `RecordDate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `IsSuspended` TINYINT(1) NULL DEFAULT 0,
  `IsFinanced` TINYINT(1) NULL DEFAULT 0,
  `IsBadDebt` TINYINT(1) NULL DEFAULT 0,
  `OldDebt` DECIMAL(10,2) NULL,
  PRIMARY KEY (`PayPlanID`),
  INDEX `FKPayPlanFrequencyID_idx` (`FKPayPlanFrequencyID` ASC),
  INDEX `FKPayPlanAgentID_idx` (`FKPayPlanAgentID` ASC),
  CONSTRAINT `FKPayPlanAgentID`
    FOREIGN KEY (`FKPayPlanAgentID`)
    REFERENCES `ppdb`.`Agents` (`AgentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FKPayPlanFrequencyID`
    FOREIGN KEY (`FKPayPlanFrequencyID`)
    REFERENCES `ppdb`.`Frequency` (`FrequencyID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ppdb`.`PayPlans_has_Customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ppdb`.`PayPlans_has_Customers` ;

CREATE TABLE IF NOT EXISTS `ppdb`.`PayPlans_has_Customers` (
  `PayPlans_PayPlanID` INT NOT NULL,
  `Customers_CustomerID` INT NOT NULL,
  `Defendant` TINYINT(1) NULL DEFAULT 1 COMMENT '1 if customer is defendant on that payment plan',
  PRIMARY KEY (`PayPlans_PayPlanID`, `Customers_CustomerID`),
  INDEX `fk_PayPlans_has_Customers_Customers1_idx` (`Customers_CustomerID` ASC),
  INDEX `fk_PayPlans_has_Customers_PayPlans1_idx` (`PayPlans_PayPlanID` ASC),
  CONSTRAINT `fk_PayPlans_has_Customers_PayPlans1`
    FOREIGN KEY (`PayPlans_PayPlanID`)
    REFERENCES `ppdb`.`PayPlans` (`PayPlanID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PayPlans_has_Customers_Customers1`
    FOREIGN KEY (`Customers_CustomerID`)
    REFERENCES `ppdb`.`Customers` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ppdb`.`Offices`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ppdb`.`Offices` ;

CREATE TABLE IF NOT EXISTS `ppdb`.`Offices` (
  `OfficeID` INT NOT NULL AUTO_INCREMENT,
  `OfficeName` VARCHAR(25) NULL,
  `OfficeAbbreviation` VARCHAR(5) NULL,
  PRIMARY KEY (`OfficeID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ppdb`.`PowerPrefixes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ppdb`.`PowerPrefixes` ;

CREATE TABLE IF NOT EXISTS `ppdb`.`PowerPrefixes` (
  `Prefix` VARCHAR(5) NOT NULL,
  `PowerLimit` DECIMAL(10,2) NULL,
  PRIMARY KEY (`Prefix`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ppdb`.`Bonds`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ppdb`.`Bonds` ;

CREATE TABLE IF NOT EXISTS `ppdb`.`Bonds` (
  `BondiD` INT NOT NULL AUTO_INCREMENT,
  `FKBondPrefix` VARCHAR(5) NOT NULL,
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
    REFERENCES `ppdb`.`Offices` (`OfficeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FKBondAgentID`
    FOREIGN KEY (`FKBondAgentID`)
    REFERENCES `ppdb`.`Agents` (`AgentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FKBondPrefix`
    FOREIGN KEY (`FKBondPrefix`)
    REFERENCES `ppdb`.`PowerPrefixes` (`Prefix`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ppdb`.`Bonds_has_PayPlans`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ppdb`.`Bonds_has_PayPlans` ;

CREATE TABLE IF NOT EXISTS `ppdb`.`Bonds_has_PayPlans` (
  `Bonds_BondiD` INT NOT NULL,
  `PayPlans_PayPlanID` INT NOT NULL,
  PRIMARY KEY (`Bonds_BondiD`, `PayPlans_PayPlanID`),
  INDEX `fk_Bonds_has_PayPlans_PayPlans1_idx` (`PayPlans_PayPlanID` ASC),
  INDEX `fk_Bonds_has_PayPlans_Bonds1_idx` (`Bonds_BondiD` ASC),
  CONSTRAINT `fk_Bonds_has_PayPlans_Bonds1`
    FOREIGN KEY (`Bonds_BondiD`)
    REFERENCES `ppdb`.`Bonds` (`BondiD`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bonds_has_PayPlans_PayPlans1`
    FOREIGN KEY (`PayPlans_PayPlanID`)
    REFERENCES `ppdb`.`PayPlans` (`PayPlanID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ppdb`.`Ledger`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ppdb`.`Ledger` ;

CREATE TABLE IF NOT EXISTS `ppdb`.`Ledger` (
  `EntryID` INT NOT NULL AUTO_INCREMENT,
  `FKLedgerBondID` INT NULL,
  `Date` DATE NULL,
  `Debit` DECIMAL(10,2) NULL COMMENT 'Increases the amount owed to us',
  `Credit` DECIMAL(10,2) NULL COMMENT 'Decreases the amount owed to us',
  `Description` VARCHAR(255) NULL,
  `RecordDate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IsFinanced` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`EntryID`),
  INDEX `FKLedgerBondID_idx` (`FKLedgerBondID` ASC),
  CONSTRAINT `FKLedgerBondID`
    FOREIGN KEY (`FKLedgerBondID`)
    REFERENCES `ppdb`.`Bonds` (`BondiD`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ppdb`.`Comments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ppdb`.`Comments` ;

CREATE TABLE IF NOT EXISTS `ppdb`.`Comments` (
  `CommentID` INT NOT NULL AUTO_INCREMENT,
  `Comment` TEXT NULL,
  `CommentDate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `FKCommentPayPlanID` INT NOT NULL,
  `Agents_AgentID` INT NULL,
  PRIMARY KEY (`CommentID`, `FKCommentPayPlanID`),
  INDEX `FKCommentPayPlanID_idx` (`FKCommentPayPlanID` ASC),
  INDEX `fk_Comments_Agents1_idx` (`Agents_AgentID` ASC),
  CONSTRAINT `FKCommentPayPlanID`
    FOREIGN KEY (`FKCommentPayPlanID`)
    REFERENCES `ppdb`.`PayPlans` (`PayPlanID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Comments_Agents1`
    FOREIGN KEY (`Agents_AgentID`)
    REFERENCES `ppdb`.`Agents` (`AgentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ppdb`.`PaymentSchedules`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ppdb`.`PaymentSchedules` ;

CREATE TABLE IF NOT EXISTS `ppdb`.`PaymentSchedules` (
  `ScheduleID` INT NOT NULL AUTO_INCREMENT,
  `FKSchedulePayPlanID` INT NOT NULL,
  `FKScheduleBondID` INT NULL,
  `Amount` DECIMAL(10,2) NULL,
  `DueDate` DATE NULL,
  `SuspendedDate` DATE NULL DEFAULT NULL,
  `RecordDate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `IsAutoPay` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`ScheduleID`, `FKSchedulePayPlanID`),
  INDEX `FKScheduleBondID_idx` (`FKScheduleBondID` ASC),
  INDEX `FKSchedulePayPlanID_idx` (`FKSchedulePayPlanID` ASC),
  CONSTRAINT `FKScheduleBondID`
    FOREIGN KEY (`FKScheduleBondID`)
    REFERENCES `ppdb`.`Bonds` (`BondiD`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FKSchedulePayPlanID`
    FOREIGN KEY (`FKSchedulePayPlanID`)
    REFERENCES `ppdb`.`PayPlans` (`PayPlanID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ppdb`.`LoadedNewPlans`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ppdb`.`LoadedNewPlans` ;

CREATE TABLE IF NOT EXISTS `ppdb`.`LoadedNewPlans` (
  `processed` TINYINT(1) NULL DEFAULT NULL,
  `CLastName` TEXT NULL,
  `CFirstName` TEXT NULL,
  `CAddress1` TEXT NULL,
  `CAddress2` TEXT NULL,
  `CCity` TEXT NULL,
  `CState` TEXT NULL,
  `CZipCode` TEXT NULL,
  `CPhone` TEXT NULL,
  `DateExe` TEXT NULL,
  `Alpha_pre` TEXT NULL,
  `Power` TEXT NULL,
  `bl_due` TEXT NULL,
  `Agent` TEXT NULL,
  `ILastName` TEXT NULL,
  `IFirstName` TEXT NULL,
  `IAddress1` TEXT NULL,
  `IAddress2` TEXT NULL,
  `ICity` TEXT NULL,
  `IState` TEXT NULL,
  `IZipCode` TEXT NULL,
  `IPhone` TEXT NULL,
  `ID` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ppdb`.`ppdbsettings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ppdb`.`ppdbsettings` ;

CREATE TABLE IF NOT EXISTS `ppdb`.`ppdbsettings` (
  `ID` INT NOT NULL,
  `CCListDate` DATE NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ppdb`.`importold`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ppdb`.`importold` ;

CREATE TABLE IF NOT EXISTS `ppdb`.`importold` (
  `plannum` TEXT NULL,
  `agent` TEXT NULL,
  `execdate` TEXT NULL,
  `prevbal` TEXT NULL,
  `pymntamount` TEXT NULL,
  `pymntfreq` TEXT NULL,
  `ledgerdate` TEXT NULL,
  `ledgerdesc` TEXT NULL,
  `ledgdebit` TEXT NULL,
  `ledgcredit` TEXT NULL,
  `duedate` TEXT NULL,
  `amntdue` TEXT NULL,
  `commentdate` TEXT NULL,
  `comment` TEXT NULL,
  `firstname` TEXT NULL,
  `lastname` TEXT NULL,
  `add1` TEXT NULL,
  `add2` TEXT NULL,
  `city` TEXT NULL,
  `state` TEXT NULL,
  `zip` TEXT NULL,
  `phone` TEXT NULL,
  `prefix` TEXT NULL,
  `bondnum` TEXT NULL,
  `id` INT NOT NULL AUTO_INCREMENT,
  `isproc` TINYINT(1) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

USE `ppdb` ;

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwagentlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwagentlist` (`Agent ID` INT, `Agent Name` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwbondonplan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwbondonplan` (`Bond ID` INT, `Pay Plan ID` INT, `Power Number` INT, `Agent ID` INT, `Agent` INT, `Office ID` INT, `Office` INT, `ExecutionDate` INT, `Remove` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwbondquicklist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwbondquicklist` (`Bond ID` INT, `Number` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwbonds`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwbonds` (`Bond ID` INT, `Power Number` INT, `Agent ID` INT, `Agent` INT, `Office ID` INT, `Office` INT, `ExecutionDate` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwccduelist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwccduelist` (`PayPlanID` INT, `Customer` INT, `Amount` INT, `Due Date` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwcommentsonplan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwcommentsonplan` (`Comment ID` INT, `Pay Plan ID` INT, `Agent ID` INT, `Date` INT, `Agent` INT, `Comment` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwcondensedcomments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwcondensedcomments` (`CommentID` INT, `Comment` INT, `FKCommentPayPlanID` INT, `Agents_AgentID` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwcustomeraddlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwcustomeraddlist` (`CustomerID` INT, `Name` INT, `DOB` INT, `Cancel` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwcustomerlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwcustomerlist` (`CustomerID` INT, `Name` INT, `DOB` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwcustomeronplan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwcustomeronplan` (`Pay Plan ID` INT, `Def` INT, `Customer ID` INT, `First Name` INT, `Last Name` INT, `D.O.B` INT, `Address 1` INT, `Address 2` INT, `City` INT, `State` INT, `Zip Code` INT, `Phone` INT, `Remove` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwcustomeronplanlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwcustomeronplanlist` (`Customer ID` INT, `Customer Name` INT, `Pay Plan ID` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwledger`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwledger` (`ID` INT, `Date` INT, `Bond ID` INT, `Bond` INT, `Description` INT, `Credit` INT, `Debit` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwledgeronplan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwledgeronplan` (`Entry ID` INT, `Bond ID` INT, `Pay Plan ID` INT, `Date` INT, `Bond Number` INT, `Description` INT, `Debit` INT, `Credit` INT, `Financed` INT, `Delete` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwpayplanlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwpayplanlist` (`ID` INT, `Defendant` INT, `Def Address 1` INT, `Def Address 2` INT, `Def City` INT, `Def State` INT, `Def Zip Code` INT, `Def Phone` INT, `Indemnitor` INT, `Ind Address 1` INT, `Ind Address 2` INT, `Ind City` INT, `Ind State` INT, `Ind Zip Code` INT, `Ind Phone` INT, `Old Debt` INT, `Exec Date` INT, `Agent ID` INT, `Agent` INT, `Date Last Paid` INT, `Freq` INT, `Amount` INT, `# payments` INT, `Start Bal` INT, `Balance` INT, `Past Due` INT, `Past Due CSS ID` INT, `Start Date` INT, `Age` INT, `Comments` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwpayplanlist90day`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwpayplanlist90day` (`ID` INT, `Defendant` INT, `Def Address 1` INT, `Def Address 2` INT, `Def City` INT, `Def State` INT, `Def Zip Code` INT, `Def Phone` INT, `Indemnitor` INT, `Ind Address 1` INT, `Ind Address 2` INT, `Ind City` INT, `Ind State` INT, `Ind Zip Code` INT, `Ind Phone` INT, `Old Debt` INT, `Exec Date` INT, `Agent ID` INT, `Agent` INT, `Date Last Paid` INT, `Freq` INT, `Amount` INT, `# payments` INT, `Start Bal` INT, `Balance` INT, `Past Due` INT, `Past Due CSS ID` INT, `Start Date` INT, `Age` INT, `Comments` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwpayplanlistnew`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwpayplanlistnew` (`ID` INT, `Defendant` INT, `Def Address 1` INT, `Def Address 2` INT, `Def City` INT, `Def State` INT, `Def Zip Code` INT, `Def Phone` INT, `Indemnitor` INT, `Ind Address 1` INT, `Ind Address 2` INT, `Ind City` INT, `Ind State` INT, `Ind Zip Code` INT, `Ind Phone` INT, `Old Debt` INT, `Exec Date` INT, `Agent ID` INT, `Agent` INT, `Date Last Paid` INT, `Freq` INT, `Amount` INT, `# payments` INT, `Start Bal` INT, `Balance` INT, `Past Due` INT, `Past Due CSS ID` INT, `Start Date` INT, `Age` INT, `Comments` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwpayplansimple`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwpayplansimple` (`ID` INT, `Creation Date` INT, `Start Bal` INT, `Pay Amount` INT, `Freq ID` INT, `Freq` INT, `Start Date` INT, `Other Conditions` INT, `Agent ID` INT, `Agent` INT, `Scan Location` INT, `Old Debt` INT, `Financed` INT, `Bad Debt` INT, `Scan` INT, `susp` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwplanoncustomer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwplanoncustomer` (`CustID` INT, `PayPlanID` INT, `Plan Date` INT, `Starting Bal` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwplansonbond`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwplansonbond` (`Pay Plan ID` INT, `Creation Date` INT, `Start Bal` INT, `Bond ID` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwppbondaddlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwppbondaddlist` (`Bond ID` INT, `Pay Plan ID` INT, `Power Number` INT, `Agent ID` INT, `Agent` INT, `Office ID` INT, `Office` INT, `ExecutionDate` INT, `Cancel` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwprefixlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwprefixlist` (`ID` INT, `Prefix` INT);

-- -----------------------------------------------------
-- Placeholder table for view `ppdb`.`vwscheduleonplan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ppdb`.`vwscheduleonplan` (`Schedule ID` INT, `Pay Plan ID` INT, `Due Date` INT, `Order DDate` INT, `Due` INT, `Past Due` INT, `Past Due CSS ID` INT, `Paid` INT, `Balance` INT, `Auto CC` INT, `PPF Mark` INT, `delete` INT);

-- -----------------------------------------------------
-- procedure PrcPayPlanCustomerDelete
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcPayPlanCustomerDelete`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcPayPlanCustomerDelete`(
	IN VarPayPlanID		INT,
	in VarCustomerID	INT
)
begin
	DELETE FROM `ppdb`.`payplans_has_customers` 
		WHERE `PayPlans_PayPlanID`= VarPayPlanID 
		and `Customers_CustomerID`=	VarCustomerID;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcPayPlanImport
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcPayPlanImport`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcPayPlanImport`(
	IN VOfficeID	int
)
begin	
	declare VCLastName 	VarChar(25);
	declare VDateExe	Date;
	declare VAgentIn	VarChar(3);
	declare VAlphaPre	VarChar(5);
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
	declare VBegBal		Decimal(10,2);

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

	ImportLoadedLoop: while b =0 DO
		fetch curID into VID;
		select
			CLastName,  -- to check if the last client last name is null, if not then it will stop the script
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
			VCLastName,
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

		-- check if record is VOID
		if VCLastName != 'VOID' and CNewCustomerName != '' and VBlDue > 0 then

			-- select VID as 'VID', VAgentIn as 'Agent Init', VAlphaPre as 'AlphaPre';


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

				-- checks if  there wasa previous payplan and adds additional calculated info to it
				if VPayPlanID is not null then
					call PrcSetPayBegBal(VPayPlanID, VBegBal);
				end if;
				
				set	VPayPlanID = FnPayPlanAdd(VDateExe,null,null,'7',null,null,VAgentID,null,null,null,null);
				set VBegBal = 0; -- resets the beginning ballance variable

				-- select 'First add' as 'plan customer add?';
				-- select VIPhone;
				call PrcPayPlanCustomerAdd(VPayPlanID, FnCustomerAdd(VIFirstName, VILastName, null, VIAddress1, VIAddress2, VICity, VIState, VIZipCode, VIPhone), '1'); /*add defendant to payplan*/
				set VCustID = null;

				-- show what plan we are on  without overloading the system
				-- select VID as 'VID', VAgentIn as 'Agent Init', VAlphaPre as 'AlphaPre';
				
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
				set VBegBal = VBegBal + VBlDue;
			end if;

			-- for debuging purposes marks all records that have been processed
			UPDATE `ppdb`.`loadednewplans` SET `processed`='1' WHERE `ID`=VID;
		end if;

		-- if the VCLastName is null it signals the end of the import list, the rest is garbage
		if CNewCustomerName = '' then
			LEAVE ImportLoadedLoop;
		end if;
		

	end while;
	close CurID;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function FnCustomerAdd
-- -----------------------------------------------------

USE `ppdb`;
DROP function IF EXISTS `ppdb`.`FnCustomerAdd`;

DELIMITER $$
USE `ppdb`$$
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

USE `ppdb`;
DROP function IF EXISTS `ppdb`.`FnAgentIDFromIn`;

DELIMITER $$
USE `ppdb`$$
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

USE `ppdb`;
DROP function IF EXISTS `ppdb`.`FnBondAdd`;

DELIMITER $$
USE `ppdb`$$
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

USE `ppdb`;
DROP function IF EXISTS `ppdb`.`FnCheckForBond`;

DELIMITER $$
USE `ppdb`$$
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

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcAddLedgerEntry`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcAddLedgerEntry`(
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
			`Description`,
			`IsFinanced`
		) 
		VALUES 
		(
			VarBondID, 
			VarDate, 
			VarDebit, 
			VarCredit, 
			VarDesc,
			0
		);
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcPayPlanBondDelete
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcPayPlanBondDelete`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcPayPlanBondDelete`(
	IN VPayPlanID int,
	IN VBondID int
)
BEGIN
	DELETE FROM `ppdb`.`bonds_has_payplans` 
	WHERE `Bonds_BondiD`= VBondID
	and`PayPlans_PayPlanID`= VPayPlanID;

	-- select 'bond plan added' as 'bond plan';
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcPayPlanCommentAdd
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcPayPlanCommentAdd`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcPayPlanCommentAdd`(
	IN VarPayPlanID	INT,
	IN VarComDate	timestamp,
	IN VarAgentID	INT,
	IN VarComment	text
)
begin
	Case VarComDate
		when null then
			set VarComDate = current_timestamp;
		else 
			begin
			end;
	END Case;

	INSERT INTO `PPDB`.`Comments` 
	(
		`Comment`, 
		`CommentDate`, 
		`FKCommentPayPlanID`,
		`comments`.`Agents_AgentID`
	) VALUES 
	(
		VarComment, 
		VarComDate, 
		VarPayPlanID,
		VarAgentID
	);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcPayPlanCustomerAdd
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcPayPlanCustomerAdd`;

DELIMITER $$
USE `ppdb`$$
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

USE `ppdb`;
DROP function IF EXISTS `ppdb`.`FnPayPlanAdd`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `FnPayPlanAdd`(
	VarCreationDate		DATE,
	VarStartBal			DECIMAL(10,2),
	VarPaymentAmount	DECIMAL(10,2),
	VarFrequencyID		INT,
	VarStartDate		DATE,
	VarOthCond			text,
	VarAgentID			Int,
	VarScanLoc			VarChar(255),
	VarOldDebt			Decimal(10,2),
	VarFinanced			boolean,
	VarBadDebt			boolean
) RETURNS int(11)
BEGIN
	DECLARE VarPayPlanID 	INT;

	if VarOldDebt = 0 then
		set VarOldDebt = null;
	end if;

	INSERT INTO `PPDB`.`PayPlans` 
	(
		`CreationDate`, 
		`StartingBalance`, 
		`PaymentAmount`, 
		`FKPayPlanFrequencyID`, 
		`StartDate`, 
		`OtherConditions`, 
		`FKPayPlanAgentID`, 
		`ScanLocation`,
		`IsFinanced`,
		`OldDebt`,		
		`IsBadDebt`
	) VALUES 
	(
		VarCreationDate, 
		VarStartBal, 
		VarPaymentAmount, 
		VarFrequencyID,
		VarStartDate, 
		VarOthCond,
		VarAgentID,
		VarScanLoc,
		VarFinanced,
		VarOldDebt,
		VarBadDebt	
	);
	SET VarPayPlanID = Last_Insert_ID();
	return VarPayPlanID;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcAutoSchedule
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcAutoSchedule`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcAutoSchedule`(
	IN VarInPlan int,
	IN VarAutoCC boolean
)
begin
	declare VarStartBal Decimal(10,2);
	declare VarPaymentAmnt	Decimal(10,2);
	declare	VarFreq 	VarChar(255);
	declare VarStartDate date;
	declare VarNumSched INT;
	declare VarSchedDate date;
	declare i int;
	
-- get the perameters fromthe payplan
	SELECT 
		`payplans`.`StartingBalance`,
		`payplans`.`PaymentAmount`,
		`frequency`.`description`,
		`payplans`.`StartDate`
	into
		VarStartBal,
		VarPaymentAmnt,
		VarFreq,
		VarStartDate
	FROM `ppdb`.`payplans`
	join `ppdb`.`frequency`
		on `payplans`.`FKPayPlanFrequencyID` = `frequency`.`FrequencyID`
	where `payplans`.`PayPlanID` = VarInPlan;

-- figure out how many schedules there are

	set VarNumSched = ceiling(VarStartBal / VarPaymentAmnt);
	set VarSchedDate = VarStartDate;


	set i = 0;
	while i < VarNumSched do
		case 
			When VarPaymentAmnt < VarStartBal then
				call PrcPayScheduleAdd(null,VarInPlan,VarPaymentAmnt,VarSchedDate,VarAutoCC);
				set VarStartBal = VarStartBal - VarPaymentAmnt;
			else
				call PrcPayScheduleAdd(null,VarInPlan,VarStartBal,VarSchedDate,VarAutoCC);
		end case;

-- increment the date
		case VarFreq
			when "1 Day" then
				set VarSchedDate = adddate(VarSchedDate, interval 1 DAY);
			when "1 WEEK" then
				set VarSchedDate = adddate(VarSchedDate, interval 1 WEEK);
			when "2 WEEK" then
				set VarSchedDate = adddate(VarSchedDate, interval 2  WEEK);
			when "1 MONTH" then
				set VarSchedDate = adddate(VarSchedDate, interval 1 MONTH);
			when "2 MONTH" then
				set VarSchedDate = adddate(VarSchedDate, interval 2 MONTH);
			else
				set VarSchedDate = adddate(VarSchedDate, interval 1 Day);
		end case;

		set i = i + 1;
	end while;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcLedgerEntryDelete
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcLedgerEntryDelete`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcLedgerEntryDelete`(
	in VarEntryID int
)
BEGIN
	DELETE FROM `ledger` 
	WHERE `EntryID`= VarEntryID;

end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcModCustomer
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcModCustomer`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcModCustomer`(
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcOldImport
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcOldImport`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcOldImport`(
	IN VOfficeID	int
)
begin
	declare	VPlanNum	text;
	declare VDateExe	Date;
	declare VAgentIn	VarChar(3);
	declare VPymntAmnt  decimal(10,2);
	declare VFreq		varchar(5);
	declare VPrevBal	decimal(10,2);
	declare VAlphaPre	VarChar(5);
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
	declare VBegBal		Decimal(10,2);

	declare VLedgDate	date;
	declare VLedgDesc	text;
	declare VLedgDeb	decimal(10,2);
	declare VLedgCred	decimal(10,2);

	declare VDueDate	date;
	declare VAmntDue	decimal(10,2);
	
	declare VCmntDate	date;
	declare Vcomment	text;

	declare VBondID		integer;
	declare VFirstBondID	integer;
	declare VIsDef		integer;
	declare VComID		integer;
	declare VFreqID		integer;
	declare VExecD		date;

	/*set up the cursor*/
	declare b int;
	declare CurID cursor for select ID from `importold`;
	declare continue handler for not found set b = 1;
	open curID;
	
	set b = 0;

	importoldloop: while b =0 DO
		fetch curID into VID;

		SELECT
			`importold`.`agent`,
			STR_TO_DATE(`importold`.`execdate`,'%m/%d/%Y'),
			`importold`.`prevbal`,
			`importold`.`pymntamount`,
			`importold`.`pymntfreq`,

			STR_TO_DATE(`importold`.`ledgerdate`,'%m/%d/%Y'),
			`importold`.`ledgerdesc`,
			`importold`.`ledgdebit`,
			`importold`.`ledgcredit`,

			STR_TO_DATE(`importold`.`duedate`,'%m/%d/%Y'),
			`importold`.`amntdue`,

			STR_TO_DATE(`importold`.`commentdate`,'%m/%d/%Y'),
			`importold`.`comment`,

			`importold`.`firstname`,
			`importold`.`lastname`,
			`importold`.`add1`,
			`importold`.`add2`,
			`importold`.`city`,
			`importold`.`state`,
			`importold`.`zip`,
			`importold`.`phone`,

			`importold`.`prefix`,
			`importold`.`bondnum`,

			`importold`.`id`
		into
			VAgentIn	,
			VDateExe,	
			VPrevBal	,
			VPymntAmnt  ,
			VFreq		,

			VLedgDate	,
			VLedgDesc	,
			VLedgDeb	,
			VLedgCred   ,

			VDueDate,
			VAmntDue,

			VCmntDate,
			VComment,


			VIFirstName,
			VILastName	,	
			VIAddress1	,
			VIAddress2 ,
			VIState	,	
			VICity		,	
			VIZipcode 	,
			VIPhone	,	

			VAlphaPre	,
			VBondNum	,
			VBlDue		
		FROM `ppdb`.`importold`
			where `id` = VID;

		-- set the payment plan
		if VAgentIn != '' then

			-- decide what the frequency is
			case VFreq
				when 'U' then
					set VFreqID = 6; -- other
				when 'W' then
					set VFreqID = 2; -- weekly
				when 'M' then
					set VFreqID = 5; -- monthly
				when 'BW' then
					set VFreqID = 3; -- bi monthly
				else
					set VFreqID = 7; -- not set
			end case;

			-- select VPrevBal, VID;

			-- make sure the execution date is the same for all bonds on the plan by setting this
			set VExecD = VDateExe;
			
			set VAgentID = FnAgentIDFromIn(VAgentIn); /*find the Agent ID of the initials*/
			set	VPayPlanID = FnPayPlanAdd(VDateExe,VLedgDeb,VPymntAmnt,VFreqID,VDueDate,null,VAgentID,null,VPrevBal,null,null);
			set VIsDef = 1;  -- this tells the next customer to be a defendant
		end if;
		

		if VIFirstName != '' then
			call PrcPayPlanCustomerAdd(VPayPlanID, FnCustomerAdd(VIFirstName,VILastName,null,VIAddress1,VIAddress2,VICity,VIState,VIZipCode,VIPhone),VIsDef);
			set VIsDef = 0;
		end if;

		-- if there is a bond on this line, add it
		if VAlphaPre != '' then
			-- if the bond already exists  then add the existing bond to the payplan
			if EXISTS(	SELECT 1 
						FROM `bonds` 
						WHERE `bonds`.`FKBondPrefix` = VAlphaPre
							and `bonds`.`PowerNumber` = VBondNum) then

				set VBondID = (SELECT  `BondiD`
								FROM `bonds` 
								WHERE `bonds`.`FKBondPrefix` = VAlphaPre
									and `bonds`.`PowerNumber` = VBondNum);
			
				call PrcPayPlanBondAdd(VPayPlanID,VBondID);
		else -- if the bond doesn't exist add a new bond

			set VBondID = FnBondAdd(VAlphaPre,VBondNum,VAgentID,VOfficeID,VExecD,0);
			call PrcPayPlanBondAdd(VPayPlanID, VBondID);
		end if;

			if VAgentIn != '' then -- this allows me to know what the first bond is (which I'm putting all the ledger entries on
				set VFirstBondID = VBondID;
			end if;
		end if;

		-- add the ledger entry
		if VLedgDate != '' then
			if VLedgDeb > 0 then -- check if debit or credit
				call PrcAddLedgerEntry(VFirstBondID,VLedgDate,VLedgDeb, 'Debit',VLedgDesc);
			elseif VLedgCred > 0 then
				call PrcAddLedgerEntry(VFirstBondID,VLedgDate,VLedgCred, 'Credit',VLedgDesc);
			end if;
		end if;
		-- select  VPayPlanID, VID, VDueDate;

		-- add the schedules
		if VDueDate != '0000-00-00' then
			-- select VPayPlanID as 'Sched';
			call PrcPayScheduleAdd(null, VPayPlanID,VAmntDue,VDueDate,0);
		end if;

		-- add the comments
		if VComment != '' then
			if VCmntDate != '0000-00-00' then -- if there is a new date create a new comment
				-- select VCmntDate;
				call PrcPayPlanCommentAdd(VPayPlanID,VCmntDate,VAgentID,VComment);
			else  -- if there is no new date the you just add this comment to the end of the last comment
				set VComID = (SELECT max(`comments`.`CommentID`) -- get the last comment ID 
								FROM `ppdb`.`comments` as `comments`
								where `comments`.FKCommentPayPlanID = VPayPlanID);

				UPDATE `ppdb`.`comments` -- add to the last comment
				SET
				`Comment` = concat(`Comment`,'
',VComment)
				WHERE `CommentID` = VComID;
				-- select 'update';
			end if;
		end if;

		-- marked as processed
		UPDATE `ppdb`.`importold`
		SET
		`isproc` = 1
		WHERE `id` = VID;

		
	end while;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcPayPlanBondAdd
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcPayPlanBondAdd`;

DELIMITER $$
USE `ppdb`$$
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

-- -----------------------------------------------------
-- procedure PrcPayPlanMod
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcPayPlanMod`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcPayPlanMod`(	
	VarPayPlanID		INT,
	VarCreationDate		DATE,
	VarStartBal			DECIMAL(10,2),
	VarPaymentAmount	DECIMAL(10,2),
	VarFrequencyID		INT,
	VarStartDate		DATE,
	VarOthCond			text,
	VarAgentID			Int,
	VarScnLoc			VarChar(255),
	VarOldDebt			Decimal(10,2),
	VarIsFinanced		Boolean,
	VarIsBadDebt		Boolean
)
begin
	UPDATE `ppdb`.`payplans`
	SET
		`CreationDate` = VarCreationDate,
		`StartingBalance` = VarStartBal,
		`PaymentAmount` = VarPaymentAmount,
		`FKPayPlanFrequencyID` = VarFrequencyID,
		`StartDate` = VarStartDate,
		`OtherConditions` = VarOthCond,
		`FKPayPlanAgentID` =VarAgentID,
		`ScanLocation` = VarScnLoc,
		`IsFinanced` = VarIsFinanced,
		`IsBadDebt` = VarIsBadDebt,
		`OldDebt` = VarOldDebt
	WHERE `PayPlanID` = VarPayPlanID;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcPayScheduleAdd
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcPayScheduleAdd`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcPayScheduleAdd`(
	IN VarBondID 	INT,
	IN VarPayPlanID INT,
	IN VarAmount 	DECIMAL(10,2),
	IN VarDueDate	date,
	in VarIsAutoPay boolean
)
    COMMENT 'adds the Payment Schedule'
BEGIN
	INSERT INTO `PPDB`.`paymentschedules` 
	(
		`FKScheduleBondID`, 
		`FKSchedulePayPlanID`, 
		`Amount`, 
		`DueDate`,
		`IsAutoPay`
	) VALUES 
	(
		VarBondID, 
		VarPayPlanID, 
		VarAmount, 
		VarDueDate,
		VarIsAutoPay
	);

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcPayScheduleDelete
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcPayScheduleDelete`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcPayScheduleDelete`(
	IN Del int
)
begin
	DELETE FROM 
		`ppdb`.`paymentschedules` 
	WHERE `ScheduleID`= Del;

end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcScheduleAutoCCSwitch
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcScheduleAutoCCSwitch`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcScheduleAutoCCSwitch`(
	VarSchedID int
)
begin
	declare VarIsAuto boolean;

	SELECT `paymentschedules`.`IsAutoPay`
	into VarIsAuto
	FROM `ppdb`.`paymentschedules`
	where `ScheduleID`= VarSchedID;
		
	if VarIsAuto = 1 then
		set VarIsAuto = 0;
	else 
		set VarIsAuto = 1;
	end if;

	UPDATE `ppdb`.`paymentschedules` 
	SET `IsAutoPay`= VarIsAuto
	WHERE `ScheduleID`= VarSchedID;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcSetCustomerDefendant
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcSetCustomerDefendant`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcSetCustomerDefendant`(
	in VarPPID int,
	in VarCustID int
)
begin
	UPDATE `ppdb`.`payplans_has_customers`
	SET `Defendant` = 1
	WHERE `PayPlans_PayPlanID` = VarPPID AND `Customers_CustomerID` = VarCustID;

	UPDATE `ppdb`.`payplans_has_customers`
	SET	`Defendant` = 0
	WHERE `payplans_has_customers`.`PayPlans_PayPlanID` = VarPPID 
		AND `payplans_has_customers`.`Customers_CustomerID` != VarCustID;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PrcSetPayBegBal
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`PrcSetPayBegBal`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PrcSetPayBegBal`(
	VPayID	int,
	VBegBal	Decimal(10,2)
)
begin	
	Update `ppdb`.`payplans`
	Set `payplans`.`StartingBalance`  = VBegBal
	where `payplans`.`PayPlanID` = VPayID;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure prcsetcclistdate
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`prcsetcclistdate`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `prcsetcclistdate`(
	in vardate date
)
begin
	UPDATE `ppdb`.`ppdbsettings`
	SET
	`CCListDate` = vardate
	WHERE `ID` = 1;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure prcviewscheduleonplan
-- -----------------------------------------------------

USE `ppdb`;
DROP procedure IF EXISTS `ppdb`.`prcviewscheduleonplan`;

DELIMITER $$
USE `ppdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `prcviewscheduleonplan`(
	PayPlanID integer
)
begin

	SELECT  `paymentschedules`.`ScheduleID` as 'Schedule ID',
		`paymentschedules`.`FKSchedulePayPlanID` as 'Pay Plan ID',
		-- `paymentschedules`.`FKScheduleBondID` as 'Bond ID',
		-- concat(`bonds`.`FKBondPrefix`,' ',`bonds`.`PowerNumber`) as 'Bond',
		Date_Format(`paymentschedules`.`DueDate`,'%c/%d/%y') as 'Due Date',
		DATE_FORMAT(`paymentschedules`.`DueDate`, '%Y-%m-%d') as 'Order DDate',
		-- `paymentschedules`.`SuspendedDate` as 'Suspended Date',
		-- `paymentschedules`.`RecordDate` as 'Record Date',
		`paymentschedules`.`Amount` as 'Due',

		-- find the amount past due
		case 
			when (ifnull((	select sum(`DTD`.`Amount`) -- the sum of all that was due before now
					from `paymentschedules` as `DTD`
					where `DTD`.`FKSchedulePayPlanID` =`paymentschedules`.`FKSchedulePayPlanID`
						and `DTD`.`DueDate` < `paymentschedules`.`DueDate`
				),0) - ifnull((
					SELECT sum(Credit) -- the sum of all the payments made before now
					FROM ppdb.vwledgeronplan
					where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
						and `vwledgeronplan`.`Date` < `paymentschedules`.`DueDate` 
				),0)) > 0 
				then (ifnull((	select sum(`DTD`.`Amount`) -- the sum of all that was due before now
						from `paymentschedules` as `DTD`
						where `DTD`.`FKSchedulePayPlanID` =`paymentschedules`.`FKSchedulePayPlanID`
							and `DTD`.`DueDate` < `paymentschedules`.`DueDate`
					),0) - ifnull((
						SELECT sum(Credit) -- the sum of all the payments made before now
						FROM ppdb.vwledgeronplan
						where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
							and `vwledgeronplan`.`Date` < `paymentschedules`.`DueDate` 
					),0))
			else  null
		end as 'Past Due',

		case 
			when (ifnull((	select sum(`DTD`.`Amount`) -- the sum of all that was due before now
						from `paymentschedules` as `DTD`
						where `DTD`.`FKSchedulePayPlanID` =`paymentschedules`.`FKSchedulePayPlanID`
							and `DTD`.`DueDate` < `paymentschedules`.`DueDate`
					),0) - ifnull((
						SELECT sum(Credit) -- the sum of all the payments made before now
						FROM ppdb.vwledgeronplan
						where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
							and `vwledgeronplan`.`Date` < `paymentschedules`.`DueDate` 
					),0)) >= `paymentschedules`.`Amount` 
				then  'red'
			when (ifnull((	select sum(`DTD`.`Amount`) -- the sum of all that was due before now
						from `paymentschedules` as `DTD`
						where `DTD`.`FKSchedulePayPlanID` =`paymentschedules`.`FKSchedulePayPlanID`
							and `DTD`.`DueDate` < `paymentschedules`.`DueDate`
					),0) - ifnull((
						SELECT sum(Credit) -- the sum of all the payments made before now
						FROM ppdb.vwledgeronplan
						where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
							and `vwledgeronplan`.`Date` < `paymentschedules`.`DueDate` 
					),0)) > 0 then 'yellow'
			else 'green'
		end as 'Past Due CSS ID',




		(	-- adds up all credits made between the previous scheduled date and the current scheduled date
			SELECT sum(Credit) 
			FROM ppdb.vwledgeronplan
			where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
				and `vwledgeronplan`.`Date` <= `paymentschedules`.`DueDate`
				and `vwledgeronplan`.`Date` > (ifnull(  -- this selects the previouse due date, if there is none it selects the creation date
												(SELECT max(`PrevSched`.`DueDate`) -- the previouse due date
												from `paymentschedules` as `PrevSched`
												where `PrevSched`.`FKSchedulePayPlanID` = `paymentschedules`.`FKSchedulePayPlanID`
													and `PrevSched`.`DueDate` < `paymentschedules`.`DueDate`
												), DATE_SUB((SELECT `vwpayplansimple`.`Creation Date` -- the creation date
													FROM `vwpayplansimple`
													where `vwpayplansimple`.`ID`= `paymentschedules`.`FKSchedulePayPlanID`
												),INTERVAL 1 DAY))
											)
		)	 as 'Paid',
	-- select the sum of all payments due up to current date
	/*	(	select sum(`DTD`.`Amount`) -- do not need
			from `paymentschedules` as `DTD`
			where `DTD`.`FKSchedulePayPlanID` =`paymentschedules`.`FKSchedulePayPlanID`
				and `DTD`.`DueDate` <= `paymentschedules`.`DueDate`
		)	as 'Due To Date', */

	/*	(	SELECT sum(Credit) -- doesn't work
			FROM ppdb.vwledgeronplan
			where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
				and `vwledgeronplan`.`Date` <= `paymentschedules`.`DueDate` 
		)	as 'Paid To Date', */


		(ifnull((select sum(`Debit`) -- sum of all debit in the ledger
		from `vwledgeronplan`
		where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
			and `vwledgeronplan`.`Date` <= `paymentschedules`.`DueDate` ),0) 
		- ifnull((select sum(`Credit`) -- sum of all debit in the ledger
		from `vwledgeronplan`
		where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
			and `vwledgeronplan`.`Date` <= `paymentschedules`.`DueDate` ),0) )			
		as 'Balance',

		case `paymentschedules`.`IsAutoPay`
			when 1 then '[X]'
			when 0 then '[_]'
		end as 'Auto CC',
		case 
			when `paymentschedules`.`DueDate` < CURDATE() then
				'Past'
			when `paymentschedules`.`DueDate` = (select	`PPFMK`.`DueDate` -- the next date on the schedule
												from 	`paymentschedules` as `PPFMK`
												where 	`PPFMK`.`FKSchedulePayPlanID` =`paymentschedules`.`FKSchedulePayPlanID`
													and `PPFMK`.`DueDate` >= CURDATE()
												order by `PPFMK`.`DueDate`
												Limit 1) then 
				'Present'
			else 'Future' 
		end as 'PPF Mark',
		'delete' as 'delete'
	FROM `ppdb`.`paymentschedules`
	left join `ppdb`.`bonds`
		on `paymentschedules`.`FKScheduleBondID` = `bonds`.`BondiD`
	Where `paymentschedules`.`FKSchedulePayPlanID` = PayPlanID order by DATE_FORMAT(`paymentschedules`.`DueDate`, '%Y-%m-%d');

end$$

DELIMITER ;

-- -----------------------------------------------------
-- View `ppdb`.`vwagentlist`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwagentlist` ;
DROP TABLE IF EXISTS `ppdb`.`vwagentlist`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwagentlist` AS select `ppdb`.`agents`.`AgentID` AS `Agent ID`,concat(`ppdb`.`agents`.`LastName`,', ',`ppdb`.`agents`.`FirstName`) AS `Agent Name` from `ppdb`.`agents` order by concat(`ppdb`.`agents`.`LastName`,', ',`ppdb`.`agents`.`FirstName`);

-- -----------------------------------------------------
-- View `ppdb`.`vwbondonplan`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwbondonplan` ;
DROP TABLE IF EXISTS `ppdb`.`vwbondonplan`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwbondonplan` AS select `ppdb`.`bonds`.`BondiD` AS `Bond ID`,`ppdb`.`bonds_has_payplans`.`PayPlans_PayPlanID` AS `Pay Plan ID`,concat(`ppdb`.`bonds`.`FKBondPrefix`,' ',`ppdb`.`bonds`.`PowerNumber`) AS `Power Number`,`ppdb`.`bonds`.`FKBondAgentID` AS `Agent ID`,`ppdb`.`agents`.`Initials` AS `Agent`,`ppdb`.`bonds`.`FKBondOfficeID` AS `Office ID`,`ppdb`.`offices`.`OfficeName` AS `Office`,`ppdb`.`bonds`.`ExecutionDate` AS `ExecutionDate`,'Remove' AS `Remove` from (((`ppdb`.`bonds` join `ppdb`.`bonds_has_payplans` on((`ppdb`.`bonds_has_payplans`.`Bonds_BondiD` = `ppdb`.`bonds`.`BondiD`))) join `ppdb`.`agents` on((`ppdb`.`bonds`.`FKBondAgentID` = `ppdb`.`agents`.`AgentID`))) join `ppdb`.`offices` on((`ppdb`.`bonds`.`FKBondOfficeID` = `ppdb`.`offices`.`OfficeID`)));

-- -----------------------------------------------------
-- View `ppdb`.`vwbondquicklist`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwbondquicklist` ;
DROP TABLE IF EXISTS `ppdb`.`vwbondquicklist`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwbondquicklist` AS select `ppdb`.`bonds`.`BondiD` AS `Bond ID`,concat(`ppdb`.`bonds`.`FKBondPrefix`,' ',`ppdb`.`bonds`.`PowerNumber`) AS `Number` from `ppdb`.`bonds`;

-- -----------------------------------------------------
-- View `ppdb`.`vwbonds`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwbonds` ;
DROP TABLE IF EXISTS `ppdb`.`vwbonds`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwbonds` AS select `ppdb`.`bonds`.`BondiD` AS `Bond ID`,concat(`ppdb`.`bonds`.`FKBondPrefix`,' ',`ppdb`.`bonds`.`PowerNumber`) AS `Power Number`,`ppdb`.`bonds`.`FKBondAgentID` AS `Agent ID`,`ppdb`.`agents`.`Initials` AS `Agent`,`ppdb`.`bonds`.`FKBondOfficeID` AS `Office ID`,`ppdb`.`offices`.`OfficeName` AS `Office`,`ppdb`.`bonds`.`ExecutionDate` AS `ExecutionDate` from ((`ppdb`.`bonds` join `ppdb`.`agents` on((`ppdb`.`bonds`.`FKBondAgentID` = `ppdb`.`agents`.`AgentID`))) join `ppdb`.`offices` on((`ppdb`.`bonds`.`FKBondOfficeID` = `ppdb`.`offices`.`OfficeID`)));

-- -----------------------------------------------------
-- View `ppdb`.`vwccduelist`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwccduelist` ;
DROP TABLE IF EXISTS `ppdb`.`vwccduelist`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwccduelist` AS select `ppdb`.`payplans`.`PayPlanID` AS `PayPlanID`,concat(`ppdb`.`customers`.`LastName`,', ',`ppdb`.`customers`.`FirstName`) AS `Customer`,`ppdb`.`paymentschedules`.`Amount` AS `Amount`,`ppdb`.`paymentschedules`.`DueDate` AS `Due Date` from (((`ppdb`.`payplans` left join `ppdb`.`payplans_has_customers` on((`ppdb`.`payplans_has_customers`.`PayPlans_PayPlanID` = `ppdb`.`payplans`.`PayPlanID`))) left join `ppdb`.`customers` on((`ppdb`.`payplans_has_customers`.`Customers_CustomerID` = `ppdb`.`customers`.`CustomerID`))) left join `ppdb`.`paymentschedules` on((`ppdb`.`paymentschedules`.`FKSchedulePayPlanID` = `ppdb`.`payplans`.`PayPlanID`))) where ((`ppdb`.`paymentschedules`.`DueDate` = (select `ppdb`.`ppdbsettings`.`CCListDate` from `ppdb`.`ppdbsettings` where (`ppdb`.`ppdbsettings`.`ID` = 1))) and (`ppdb`.`paymentschedules`.`IsAutoPay` = 1));

-- -----------------------------------------------------
-- View `ppdb`.`vwcommentsonplan`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwcommentsonplan` ;
DROP TABLE IF EXISTS `ppdb`.`vwcommentsonplan`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwcommentsonplan` AS select `ppdb`.`comments`.`CommentID` AS `Comment ID`,`ppdb`.`comments`.`FKCommentPayPlanID` AS `Pay Plan ID`,`ppdb`.`comments`.`Agents_AgentID` AS `Agent ID`,date_format(`ppdb`.`comments`.`CommentDate`,'%c/%d/%y') AS `Date`,`ppdb`.`agents`.`Initials` AS `Agent`,`ppdb`.`comments`.`Comment` AS `Comment` from (`ppdb`.`comments` join `ppdb`.`agents` on((`ppdb`.`comments`.`Agents_AgentID` = `ppdb`.`agents`.`AgentID`)));

-- -----------------------------------------------------
-- View `ppdb`.`vwcondensedcomments`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwcondensedcomments` ;
DROP TABLE IF EXISTS `ppdb`.`vwcondensedcomments`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwcondensedcomments` AS select `ppdb`.`comments`.`CommentID` AS `CommentID`,concat('---',date_format(`ppdb`.`comments`.`CommentDate`,'%c/%d/%y'),' : ',`ppdb`.`agents`.`Initials`,'---\n',`ppdb`.`comments`.`Comment`) AS `Comment`,`ppdb`.`comments`.`FKCommentPayPlanID` AS `FKCommentPayPlanID`,`ppdb`.`comments`.`Agents_AgentID` AS `Agents_AgentID` from (`ppdb`.`comments` left join `ppdb`.`agents` on((`ppdb`.`comments`.`Agents_AgentID` = `ppdb`.`agents`.`AgentID`)));

-- -----------------------------------------------------
-- View `ppdb`.`vwcustomeraddlist`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwcustomeraddlist` ;
DROP TABLE IF EXISTS `ppdb`.`vwcustomeraddlist`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwcustomeraddlist` AS select `ppdb`.`customers`.`CustomerID` AS `CustomerID`,concat(`ppdb`.`customers`.`LastName`,', ',`ppdb`.`customers`.`FirstName`) AS `Name`,`ppdb`.`customers`.`DOB` AS `DOB`,'Cancel' AS `Cancel` from `ppdb`.`customers` where (concat(`ppdb`.`customers`.`LastName`,', ',`ppdb`.`customers`.`FirstName`) <> ', ') order by `Name`;

-- -----------------------------------------------------
-- View `ppdb`.`vwcustomerlist`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwcustomerlist` ;
DROP TABLE IF EXISTS `ppdb`.`vwcustomerlist`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwcustomerlist` AS select `ppdb`.`customers`.`CustomerID` AS `CustomerID`,concat(`ppdb`.`customers`.`LastName`,', ',`ppdb`.`customers`.`FirstName`) AS `Name`,`ppdb`.`customers`.`DOB` AS `DOB` from `ppdb`.`customers`;

-- -----------------------------------------------------
-- View `ppdb`.`vwcustomeronplan`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwcustomeronplan` ;
DROP TABLE IF EXISTS `ppdb`.`vwcustomeronplan`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwcustomeronplan` AS select `ppdb`.`payplans_has_customers`.`PayPlans_PayPlanID` AS `Pay Plan ID`,(case when (`ppdb`.`payplans_has_customers`.`Defendant` = 1) then 'X' end) AS `Def`,`ppdb`.`customers`.`CustomerID` AS `Customer ID`,`ppdb`.`customers`.`FirstName` AS `First Name`,`ppdb`.`customers`.`LastName` AS `Last Name`,`ppdb`.`customers`.`DOB` AS `D.O.B`,`ppdb`.`customers`.`Address1` AS `Address 1`,`ppdb`.`customers`.`Address2` AS `Address 2`,`ppdb`.`customers`.`City` AS `City`,`ppdb`.`customers`.`State` AS `State`,(case when ((`ppdb`.`customers`.`ZipCode` = 0) or (`ppdb`.`customers`.`ZipCode` = NULL)) then '' else `ppdb`.`customers`.`ZipCode` end) AS `Zip Code`,(case when ((`ppdb`.`customers`.`PhoneNumber` = 0) or (`ppdb`.`customers`.`PhoneNumber` = NULL)) then '' else concat('(',left(`ppdb`.`customers`.`PhoneNumber`,3),') ',substr(`ppdb`.`customers`.`PhoneNumber`,4,3),'-',substr(`ppdb`.`customers`.`PhoneNumber`,7,4)) end) AS `Phone`,'Remove' AS `Remove` from (`ppdb`.`customers` left join `ppdb`.`payplans_has_customers` on((`ppdb`.`customers`.`CustomerID` = `ppdb`.`payplans_has_customers`.`Customers_CustomerID`)));

-- -----------------------------------------------------
-- View `ppdb`.`vwcustomeronplanlist`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwcustomeronplanlist` ;
DROP TABLE IF EXISTS `ppdb`.`vwcustomeronplanlist`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwcustomeronplanlist` AS select `vwcustomeronplan`.`Customer ID` AS `Customer ID`,concat(`vwcustomeronplan`.`Last Name`,', ',`vwcustomeronplan`.`First Name`) AS `Customer Name`,`vwcustomeronplan`.`Pay Plan ID` AS `Pay Plan ID` from `ppdb`.`vwcustomeronplan`;

-- -----------------------------------------------------
-- View `ppdb`.`vwledger`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwledger` ;
DROP TABLE IF EXISTS `ppdb`.`vwledger`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwledger` AS select `ppdb`.`ledger`.`EntryID` AS `ID`,`ppdb`.`ledger`.`Date` AS `Date`,`ppdb`.`ledger`.`FKLedgerBondID` AS `Bond ID`,concat(`ppdb`.`bonds`.`FKBondPrefix`,' ',`ppdb`.`bonds`.`PowerNumber`) AS `Bond`,`ppdb`.`ledger`.`Description` AS `Description`,(case when isnull(`ppdb`.`ledger`.`Debit`) then '' else concat('$',`ppdb`.`ledger`.`Debit`) end) AS `Credit`,(case when isnull(`ppdb`.`ledger`.`Credit`) then '' else concat('$',`ppdb`.`ledger`.`Credit`) end) AS `Debit` from (`ppdb`.`ledger` left join `ppdb`.`bonds` on((`ppdb`.`ledger`.`FKLedgerBondID` = `ppdb`.`bonds`.`BondiD`)));

-- -----------------------------------------------------
-- View `ppdb`.`vwledgeronplan`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwledgeronplan` ;
DROP TABLE IF EXISTS `ppdb`.`vwledgeronplan`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwledgeronplan` AS select `ppdb`.`ledger`.`EntryID` AS `Entry ID`,`ppdb`.`ledger`.`FKLedgerBondID` AS `Bond ID`,`ppdb`.`bonds_has_payplans`.`PayPlans_PayPlanID` AS `Pay Plan ID`,`ppdb`.`ledger`.`Date` AS `Date`,concat(`ppdb`.`bonds`.`FKBondPrefix`,' ',`ppdb`.`bonds`.`PowerNumber`) AS `Bond Number`,`ppdb`.`ledger`.`Description` AS `Description`,`ppdb`.`ledger`.`Debit` AS `Debit`,`ppdb`.`ledger`.`Credit` AS `Credit`,`ppdb`.`ledger`.`IsFinanced` AS `Financed`,'Delete' AS `Delete` from ((`ppdb`.`ledger` join `ppdb`.`bonds` on((`ppdb`.`ledger`.`FKLedgerBondID` = `ppdb`.`bonds`.`BondiD`))) join `ppdb`.`bonds_has_payplans` on((`ppdb`.`bonds_has_payplans`.`Bonds_BondiD` = `ppdb`.`bonds`.`BondiD`))) order by `ppdb`.`ledger`.`Date`;

-- -----------------------------------------------------
-- View `ppdb`.`vwpayplanlist`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwpayplanlist` ;
DROP TABLE IF EXISTS `ppdb`.`vwpayplanlist`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwpayplanlist` AS select `ppdb`.`payplans`.`PayPlanID` AS `ID`,concat(`ppdb`.`customers`.`LastName`,', ',`ppdb`.`customers`.`FirstName`) AS `Defendant`,`ppdb`.`customers`.`Address1` AS `Def Address 1`,`ppdb`.`customers`.`Address2` AS `Def Address 2`,`ppdb`.`customers`.`City` AS `Def City`,`ppdb`.`customers`.`State` AS `Def State`,(case when ((`ppdb`.`customers`.`ZipCode` = 0) or (`ppdb`.`customers`.`ZipCode` = NULL)) then '' else `ppdb`.`customers`.`ZipCode` end) AS `Def Zip Code`,(case when ((`ppdb`.`customers`.`PhoneNumber` = 0) or (`ppdb`.`customers`.`PhoneNumber` = NULL)) then '' else concat('(',left(`ppdb`.`customers`.`PhoneNumber`,3),') ',substr(`ppdb`.`customers`.`PhoneNumber`,4,3),'-',substr(`ppdb`.`customers`.`PhoneNumber`,7,4)) end) AS `Def Phone`,concat(`i`.`LastName`,', ',`i`.`FirstName`) AS `Indemnitor`,`i`.`Address1` AS `Ind Address 1`,`i`.`Address2` AS `Ind Address 2`,`i`.`City` AS `Ind City`,`i`.`State` AS `Ind State`,(case when ((`i`.`ZipCode` = 0) or (`i`.`ZipCode` = NULL)) then '' else `i`.`ZipCode` end) AS `Ind Zip Code`,(case when ((`i`.`PhoneNumber` = 0) or (`i`.`PhoneNumber` = NULL)) then '' else concat('(',left(`i`.`PhoneNumber`,3),') ',substr(`i`.`PhoneNumber`,4,3),'-',substr(`i`.`PhoneNumber`,7,4)) end) AS `Ind Phone`,`ppdb`.`payplans`.`OldDebt` AS `Old Debt`,`ppdb`.`payplans`.`CreationDate` AS `Exec Date`,`ppdb`.`agents`.`AgentID` AS `Agent ID`,`ppdb`.`agents`.`Initials` AS `Agent`,(select max(`vwledgeronplan`.`Date`) from `ppdb`.`vwledgeronplan` where ((`vwledgeronplan`.`Credit` <> '') and (`vwledgeronplan`.`Pay Plan ID` = `ppdb`.`payplans`.`PayPlanID`))) AS `Date Last Paid`,`ppdb`.`frequency`.`Frequency` AS `Freq`,`ppdb`.`payplans`.`PaymentAmount` AS `Amount`,(select count(0) from `ppdb`.`vwledgeronplan` where ((`vwledgeronplan`.`Credit` <> '') and (`vwledgeronplan`.`Pay Plan ID` = `ppdb`.`payplans`.`PayPlanID`))) AS `# payments`,`ppdb`.`payplans`.`StartingBalance` AS `Start Bal`,(select format((sum(`vwledgeronplan`.`Debit`) - (case when isnull(sum(`vwledgeronplan`.`Credit`)) then '0' else sum(`vwledgeronplan`.`Credit`) end)),2) from `ppdb`.`vwledgeronplan` where (`vwledgeronplan`.`Pay Plan ID` = `ppdb`.`payplans`.`PayPlanID`)) AS `Balance`,(select `vwscheduleonplan`.`Past Due` from `ppdb`.`vwscheduleonplan` where ((`vwscheduleonplan`.`Pay Plan ID` = `ppdb`.`payplans`.`PayPlanID`) and (`vwscheduleonplan`.`PPF Mark` = 'Present'))) AS `Past Due`,(select `vwscheduleonplan`.`Past Due CSS ID` from `ppdb`.`vwscheduleonplan` where ((`vwscheduleonplan`.`Pay Plan ID` = `ppdb`.`payplans`.`PayPlanID`) and (`vwscheduleonplan`.`PPF Mark` = 'Present'))) AS `Past Due CSS ID`,`ppdb`.`payplans`.`StartDate` AS `Start Date`,(to_days(curdate()) - to_days(`ppdb`.`payplans`.`CreationDate`)) AS `Age`,(select group_concat(`vwcondensedcomments`.`Comment` separator ' 
') from `ppdb`.`vwcondensedcomments` where (`vwcondensedcomments`.`FKCommentPayPlanID` = `ppdb`.`payplans`.`PayPlanID`)) AS `Comments` from ((((((`ppdb`.`payplans` left join `ppdb`.`frequency` on((`ppdb`.`payplans`.`FKPayPlanFrequencyID` = `ppdb`.`frequency`.`FrequencyID`))) left join `ppdb`.`agents` on((`ppdb`.`payplans`.`FKPayPlanAgentID` = `ppdb`.`agents`.`AgentID`))) left join `ppdb`.`payplans_has_customers` on((`ppdb`.`payplans`.`PayPlanID` = `ppdb`.`payplans_has_customers`.`PayPlans_PayPlanID`))) left join `ppdb`.`customers` on((`ppdb`.`customers`.`CustomerID` = `ppdb`.`payplans_has_customers`.`Customers_CustomerID`))) left join `ppdb`.`payplans_has_customers` `pci` on((`ppdb`.`payplans`.`PayPlanID` = `pci`.`PayPlans_PayPlanID`))) left join `ppdb`.`customers` `i` on((`i`.`CustomerID` = `pci`.`Customers_CustomerID`))) where (case when ((select count(0) from `ppdb`.`payplans_has_customers` where (`ppdb`.`payplans_has_customers`.`PayPlans_PayPlanID` = `ppdb`.`payplans`.`PayPlanID`)) > 1) then ((`ppdb`.`payplans_has_customers`.`Defendant` = '1') and (`pci`.`Defendant` = '0')) else ((`ppdb`.`payplans_has_customers`.`Defendant` = '1') and (`pci`.`Defendant` = '1')) end);

-- -----------------------------------------------------
-- View `ppdb`.`vwpayplanlist90day`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwpayplanlist90day` ;
DROP TABLE IF EXISTS `ppdb`.`vwpayplanlist90day`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwpayplanlist90day` AS select `vwpayplanlist`.`ID` AS `ID`,`vwpayplanlist`.`Defendant` AS `Defendant`,`vwpayplanlist`.`Def Address 1` AS `Def Address 1`,`vwpayplanlist`.`Def Address 2` AS `Def Address 2`,`vwpayplanlist`.`Def City` AS `Def City`,`vwpayplanlist`.`Def State` AS `Def State`,`vwpayplanlist`.`Def Zip Code` AS `Def Zip Code`,`vwpayplanlist`.`Def Phone` AS `Def Phone`,`vwpayplanlist`.`Indemnitor` AS `Indemnitor`,`vwpayplanlist`.`Ind Address 1` AS `Ind Address 1`,`vwpayplanlist`.`Ind Address 2` AS `Ind Address 2`,`vwpayplanlist`.`Ind City` AS `Ind City`,`vwpayplanlist`.`Ind State` AS `Ind State`,`vwpayplanlist`.`Ind Zip Code` AS `Ind Zip Code`,`vwpayplanlist`.`Ind Phone` AS `Ind Phone`,`vwpayplanlist`.`Old Debt` AS `Old Debt`,`vwpayplanlist`.`Exec Date` AS `Exec Date`,`vwpayplanlist`.`Agent ID` AS `Agent ID`,`vwpayplanlist`.`Agent` AS `Agent`,`vwpayplanlist`.`Date Last Paid` AS `Date Last Paid`,`vwpayplanlist`.`Freq` AS `Freq`,`vwpayplanlist`.`Amount` AS `Amount`,`vwpayplanlist`.`# payments` AS `# payments`,`vwpayplanlist`.`Start Bal` AS `Start Bal`,`vwpayplanlist`.`Balance` AS `Balance`,`vwpayplanlist`.`Past Due` AS `Past Due`,`vwpayplanlist`.`Past Due CSS ID` AS `Past Due CSS ID`,`vwpayplanlist`.`Start Date` AS `Start Date`,`vwpayplanlist`.`Age` AS `Age`,`vwpayplanlist`.`Comments` AS `Comments` from `ppdb`.`vwpayplanlist` where ((to_days(curdate()) - to_days(`vwpayplanlist`.`Exec Date`)) <= 90);

-- -----------------------------------------------------
-- View `ppdb`.`vwpayplanlistnew`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwpayplanlistnew` ;
DROP TABLE IF EXISTS `ppdb`.`vwpayplanlistnew`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwpayplanlistnew` AS select `vwpayplanlist`.`ID` AS `ID`,`vwpayplanlist`.`Defendant` AS `Defendant`,`vwpayplanlist`.`Def Address 1` AS `Def Address 1`,`vwpayplanlist`.`Def Address 2` AS `Def Address 2`,`vwpayplanlist`.`Def City` AS `Def City`,`vwpayplanlist`.`Def State` AS `Def State`,`vwpayplanlist`.`Def Zip Code` AS `Def Zip Code`,`vwpayplanlist`.`Def Phone` AS `Def Phone`,`vwpayplanlist`.`Indemnitor` AS `Indemnitor`,`vwpayplanlist`.`Ind Address 1` AS `Ind Address 1`,`vwpayplanlist`.`Ind Address 2` AS `Ind Address 2`,`vwpayplanlist`.`Ind City` AS `Ind City`,`vwpayplanlist`.`Ind State` AS `Ind State`,`vwpayplanlist`.`Ind Zip Code` AS `Ind Zip Code`,`vwpayplanlist`.`Ind Phone` AS `Ind Phone`,`vwpayplanlist`.`Old Debt` AS `Old Debt`,`vwpayplanlist`.`Exec Date` AS `Exec Date`,`vwpayplanlist`.`Agent ID` AS `Agent ID`,`vwpayplanlist`.`Agent` AS `Agent`,`vwpayplanlist`.`Date Last Paid` AS `Date Last Paid`,`vwpayplanlist`.`Freq` AS `Freq`,`vwpayplanlist`.`Amount` AS `Amount`,`vwpayplanlist`.`# payments` AS `# payments`,`vwpayplanlist`.`Start Bal` AS `Start Bal`,`vwpayplanlist`.`Balance` AS `Balance`,`vwpayplanlist`.`Past Due` AS `Past Due`,`vwpayplanlist`.`Past Due CSS ID` AS `Past Due CSS ID`,`vwpayplanlist`.`Start Date` AS `Start Date`,`vwpayplanlist`.`Age` AS `Age`,`vwpayplanlist`.`Comments` AS `Comments` from `ppdb`.`vwpayplanlist` where (`vwpayplanlist`.`Freq` = 'Not Set') order by `vwpayplanlist`.`Exec Date` desc;

-- -----------------------------------------------------
-- View `ppdb`.`vwpayplansimple`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwpayplansimple` ;
DROP TABLE IF EXISTS `ppdb`.`vwpayplansimple`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwpayplansimple` AS select `ppdb`.`payplans`.`PayPlanID` AS `ID`,`ppdb`.`payplans`.`CreationDate` AS `Creation Date`,`ppdb`.`payplans`.`StartingBalance` AS `Start Bal`,`ppdb`.`payplans`.`PaymentAmount` AS `Pay Amount`,`ppdb`.`payplans`.`FKPayPlanFrequencyID` AS `Freq ID`,`ppdb`.`frequency`.`Frequency` AS `Freq`,`ppdb`.`payplans`.`StartDate` AS `Start Date`,`ppdb`.`payplans`.`OtherConditions` AS `Other Conditions`,`ppdb`.`payplans`.`FKPayPlanAgentID` AS `Agent ID`,`ppdb`.`agents`.`Initials` AS `Agent`,`ppdb`.`payplans`.`ScanLocation` AS `Scan Location`,`ppdb`.`payplans`.`OldDebt` AS `Old Debt`,`ppdb`.`payplans`.`IsFinanced` AS `Financed`,`ppdb`.`payplans`.`IsBadDebt` AS `Bad Debt`,(case when (`ppdb`.`payplans`.`ScanLocation` = NULL) then '' else 'scan' end) AS `Scan`,`ppdb`.`payplans`.`IsSuspended` AS `susp` from ((`ppdb`.`payplans` join `ppdb`.`frequency` on((`ppdb`.`payplans`.`FKPayPlanFrequencyID` = `ppdb`.`frequency`.`FrequencyID`))) join `ppdb`.`agents` on((`ppdb`.`payplans`.`FKPayPlanAgentID` = `ppdb`.`agents`.`AgentID`)));

-- -----------------------------------------------------
-- View `ppdb`.`vwplanoncustomer`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwplanoncustomer` ;
DROP TABLE IF EXISTS `ppdb`.`vwplanoncustomer`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwplanoncustomer` AS select `ppdb`.`customers`.`CustomerID` AS `CustID`,`ppdb`.`payplans`.`PayPlanID` AS `PayPlanID`,`ppdb`.`payplans`.`CreationDate` AS `Plan Date`,`ppdb`.`payplans`.`StartingBalance` AS `Starting Bal` from ((`ppdb`.`customers` left join `ppdb`.`payplans_has_customers` on((`ppdb`.`customers`.`CustomerID` = `ppdb`.`payplans_has_customers`.`Customers_CustomerID`))) left join `ppdb`.`payplans` on((`ppdb`.`payplans_has_customers`.`PayPlans_PayPlanID` = `ppdb`.`payplans`.`PayPlanID`)));

-- -----------------------------------------------------
-- View `ppdb`.`vwplansonbond`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwplansonbond` ;
DROP TABLE IF EXISTS `ppdb`.`vwplansonbond`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwplansonbond` AS select `ppdb`.`payplans`.`PayPlanID` AS `Pay Plan ID`,`ppdb`.`payplans`.`CreationDate` AS `Creation Date`,`ppdb`.`payplans`.`StartingBalance` AS `Start Bal`,`ppdb`.`bonds_has_payplans`.`Bonds_BondiD` AS `Bond ID` from (`ppdb`.`payplans` join `ppdb`.`bonds_has_payplans` on((`ppdb`.`payplans`.`PayPlanID` = `ppdb`.`bonds_has_payplans`.`PayPlans_PayPlanID`)));

-- -----------------------------------------------------
-- View `ppdb`.`vwppbondaddlist`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwppbondaddlist` ;
DROP TABLE IF EXISTS `ppdb`.`vwppbondaddlist`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwppbondaddlist` AS select `ppdb`.`bonds`.`BondiD` AS `Bond ID`,`ppdb`.`bonds_has_payplans`.`PayPlans_PayPlanID` AS `Pay Plan ID`,concat(`ppdb`.`bonds`.`FKBondPrefix`,' ',`ppdb`.`bonds`.`PowerNumber`) AS `Power Number`,`ppdb`.`bonds`.`FKBondAgentID` AS `Agent ID`,`ppdb`.`agents`.`Initials` AS `Agent`,`ppdb`.`bonds`.`FKBondOfficeID` AS `Office ID`,`ppdb`.`offices`.`OfficeName` AS `Office`,`ppdb`.`bonds`.`ExecutionDate` AS `ExecutionDate`,'Cancel' AS `Cancel` from (((`ppdb`.`bonds` join `ppdb`.`bonds_has_payplans` on((`ppdb`.`bonds_has_payplans`.`Bonds_BondiD` = `ppdb`.`bonds`.`BondiD`))) join `ppdb`.`agents` on((`ppdb`.`bonds`.`FKBondAgentID` = `ppdb`.`agents`.`AgentID`))) join `ppdb`.`offices` on((`ppdb`.`bonds`.`FKBondOfficeID` = `ppdb`.`offices`.`OfficeID`)));

-- -----------------------------------------------------
-- View `ppdb`.`vwprefixlist`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwprefixlist` ;
DROP TABLE IF EXISTS `ppdb`.`vwprefixlist`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwprefixlist` AS select `ppdb`.`powerprefixes`.`Prefix` AS `ID`,`ppdb`.`powerprefixes`.`Prefix` AS `Prefix` from `ppdb`.`powerprefixes`;

-- -----------------------------------------------------
-- View `ppdb`.`vwscheduleonplan`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ppdb`.`vwscheduleonplan` ;
DROP TABLE IF EXISTS `ppdb`.`vwscheduleonplan`;
USE `ppdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ppdb`.`vwscheduleonplan` AS select `ppdb`.`paymentschedules`.`ScheduleID` AS `Schedule ID`,`ppdb`.`paymentschedules`.`FKSchedulePayPlanID` AS `Pay Plan ID`,date_format(`ppdb`.`paymentschedules`.`DueDate`,'%c/%d/%y') AS `Due Date`,date_format(`ppdb`.`paymentschedules`.`DueDate`,'%Y-%m-%d') AS `Order DDate`,`ppdb`.`paymentschedules`.`Amount` AS `Due`,(case when ((ifnull((select sum(`dtd`.`Amount`) from `ppdb`.`paymentschedules` `dtd` where ((`dtd`.`FKSchedulePayPlanID` = `ppdb`.`paymentschedules`.`FKSchedulePayPlanID`) and (`dtd`.`DueDate` < `ppdb`.`paymentschedules`.`DueDate`))),0) - ifnull((select sum(`vwledgeronplan`.`Credit`) from `ppdb`.`vwledgeronplan` where ((`vwledgeronplan`.`Pay Plan ID` = `ppdb`.`paymentschedules`.`FKSchedulePayPlanID`) and (`vwledgeronplan`.`Date` < `ppdb`.`paymentschedules`.`DueDate`))),0)) > 0) then (ifnull((select sum(`dtd`.`Amount`) from `ppdb`.`paymentschedules` `dtd` where ((`dtd`.`FKSchedulePayPlanID` = `ppdb`.`paymentschedules`.`FKSchedulePayPlanID`) and (`dtd`.`DueDate` < `ppdb`.`paymentschedules`.`DueDate`))),0) - ifnull((select sum(`vwledgeronplan`.`Credit`) from `ppdb`.`vwledgeronplan` where ((`vwledgeronplan`.`Pay Plan ID` = `ppdb`.`paymentschedules`.`FKSchedulePayPlanID`) and (`vwledgeronplan`.`Date` < `ppdb`.`paymentschedules`.`DueDate`))),0)) else NULL end) AS `Past Due`,(case when ((ifnull((select sum(`dtd`.`Amount`) from `ppdb`.`paymentschedules` `dtd` where ((`dtd`.`FKSchedulePayPlanID` = `ppdb`.`paymentschedules`.`FKSchedulePayPlanID`) and (`dtd`.`DueDate` < `ppdb`.`paymentschedules`.`DueDate`))),0) - ifnull((select sum(`vwledgeronplan`.`Credit`) from `ppdb`.`vwledgeronplan` where ((`vwledgeronplan`.`Pay Plan ID` = `ppdb`.`paymentschedules`.`FKSchedulePayPlanID`) and (`vwledgeronplan`.`Date` < `ppdb`.`paymentschedules`.`DueDate`))),0)) >= `ppdb`.`paymentschedules`.`Amount`) then 'red' when ((ifnull((select sum(`dtd`.`Amount`) from `ppdb`.`paymentschedules` `dtd` where ((`dtd`.`FKSchedulePayPlanID` = `ppdb`.`paymentschedules`.`FKSchedulePayPlanID`) and (`dtd`.`DueDate` < `ppdb`.`paymentschedules`.`DueDate`))),0) - ifnull((select sum(`vwledgeronplan`.`Credit`) from `ppdb`.`vwledgeronplan` where ((`vwledgeronplan`.`Pay Plan ID` = `ppdb`.`paymentschedules`.`FKSchedulePayPlanID`) and (`vwledgeronplan`.`Date` < `ppdb`.`paymentschedules`.`DueDate`))),0)) > 0) then 'yellow' else 'green' end) AS `Past Due CSS ID`,(select sum(`vwledgeronplan`.`Credit`) from `ppdb`.`vwledgeronplan` where ((`vwledgeronplan`.`Pay Plan ID` = `ppdb`.`paymentschedules`.`FKSchedulePayPlanID`) and (`vwledgeronplan`.`Date` <= `ppdb`.`paymentschedules`.`DueDate`) and (`vwledgeronplan`.`Date` > ifnull((select max(`prevsched`.`DueDate`) from `ppdb`.`paymentschedules` `prevsched` where ((`prevsched`.`FKSchedulePayPlanID` = `ppdb`.`paymentschedules`.`FKSchedulePayPlanID`) and (`prevsched`.`DueDate` < `ppdb`.`paymentschedules`.`DueDate`))),((select `vwpayplansimple`.`Creation Date` from `ppdb`.`vwpayplansimple` where (`vwpayplansimple`.`ID` = `ppdb`.`paymentschedules`.`FKSchedulePayPlanID`)) - interval 1 day))))) AS `Paid`,(ifnull((select sum(`vwledgeronplan`.`Debit`) from `ppdb`.`vwledgeronplan` where ((`vwledgeronplan`.`Pay Plan ID` = `ppdb`.`paymentschedules`.`FKSchedulePayPlanID`) and (`vwledgeronplan`.`Date` <= `ppdb`.`paymentschedules`.`DueDate`))),0) - ifnull((select sum(`vwledgeronplan`.`Credit`) from `ppdb`.`vwledgeronplan` where ((`vwledgeronplan`.`Pay Plan ID` = `ppdb`.`paymentschedules`.`FKSchedulePayPlanID`) and (`vwledgeronplan`.`Date` <= `ppdb`.`paymentschedules`.`DueDate`))),0)) AS `Balance`,(case `ppdb`.`paymentschedules`.`IsAutoPay` when 1 then '[X]' when 0 then '[_]' end) AS `Auto CC`,(case when (`ppdb`.`paymentschedules`.`DueDate` < curdate()) then 'Past' when (`ppdb`.`paymentschedules`.`DueDate` = (select `ppfmk`.`DueDate` from `ppdb`.`paymentschedules` `ppfmk` where ((`ppfmk`.`FKSchedulePayPlanID` = `ppdb`.`paymentschedules`.`FKSchedulePayPlanID`) and (`ppfmk`.`DueDate` >= curdate())) order by `ppfmk`.`DueDate` limit 1)) then 'Present' else 'Future' end) AS `PPF Mark`,'delete' AS `delete` from (`ppdb`.`paymentschedules` left join `ppdb`.`bonds` on((`ppdb`.`paymentschedules`.`FKScheduleBondID` = `ppdb`.`bonds`.`BondiD`)));

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `ppdb`;

DELIMITER $$

USE `ppdb`$$
DROP TRIGGER IF EXISTS `ppdb`.`after_update_payplans` $$
USE `ppdb`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `ppdb`.`after_update_payplans`
AFTER UPDATE ON `ppdb`.`payplans`
FOR EACH ROW
begin
	declare VarPayPlanID int;
	set VarPayPlanID = NEW.`PayPlanID`;
	
	UPDATE `ppdb`.`ledger`
	inner join `ppdb`.`bonds`
		on FKLedgerBondID = `bonds`.`BondiD`
	inner join`ppdb`.`bonds_has_payplans`
		on `bonds_has_payplans`.`Bonds_BondiD` = `bonds`.`BondiD`
	SET
		`ledger`.`IsFinanced` = NEW.`IsFinanced`
	WHERE `bonds_has_payplans`.`PayPlans_PayPlanID` = VarPayPlanID;
end$$


USE `ppdb`$$
DROP TRIGGER IF EXISTS `ppdb`.`before_insert_bonds` $$
USE `ppdb`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `ppdb`.`before_insert_bonds`
BEFORE INSERT ON `ppdb`.`bonds`
FOR EACH ROW
begin
	if EXISTS(	SELECT 1 
				FROM `bonds` 
				WHERE `bonds`.`FKBondPrefix` = New.`FKBondPrefix`
					and `bonds`.`PowerNumber` = New.`PowerNumber`) then
		Signal sqlstate '45000'
			set message_text = 'You cannot create two of the same power number, add an existing power';
	end if;
end$$


DELIMITER ;
