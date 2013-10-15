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
  `Agents_AgentID` INT NULL,
  PRIMARY KEY (`CommentID`, `FKCommentPayPlanID`),
  INDEX `FKCommentPayPlanID_idx` (`FKCommentPayPlanID` ASC),
  INDEX `fk_Comments_Agents1_idx` (`Agents_AgentID` ASC),
  CONSTRAINT `FKCommentPayPlanID`
    FOREIGN KEY (`FKCommentPayPlanID`)
    REFERENCES `PPDB`.`PayPlans` (`PayPlanID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Comments_Agents1`
    FOREIGN KEY (`Agents_AgentID`)
    REFERENCES `PPDB`.`Agents` (`AgentID`)
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


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
