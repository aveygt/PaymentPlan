SET GLOBAL log_bin_trust_function_creators = 1;
drop function if exists Fnbondadd;
drop function if exists FnCheckForBond;
drop procedure if exists PrcAddLedgerEntry;
drop procedure if exists PrcLedgerEntryDelete;

-- --------------------------------------------------------------------------------
-- BondProcedures Group Routines
-- --------------------------------------------------------------------------------
DELIMITER $$

create procedure `PrcLedgerEntryDelete`
(
	in VarEntryID int
)
BEGIN
	DELETE FROM `ledger` 
	WHERE `EntryID`= VarEntryID;

end$$


CREATE Function `FnBondAdd` 
(
	VarPrefix 		Varchar(5),
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

create function FnCheckForBond
(
	VPrefix  varchar(5),
	VNumber  VarChar(10)
)
returns boolean
begin	
	return exists(select 1 from bonds where FKBondPrefix = vPrefix and PowerNumber = VNumber);
end$$

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
END $$