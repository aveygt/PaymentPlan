use ppdb;
DROP PROCEDURE if exists `ppdb`.`prcfixstatecity`;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `prcfixstatecity`(
)
begin
-- this is to fix the stupid mistake I made
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
			`importold`.`firstname`,
			`importold`.`lastname`,
			`importold`.`add1`,
			`importold`.`add2`,
			`importold`.`city`,
			`importold`.`state`,
			`importold`.`zip`,
			`importold`.`phone`
		into
			VIFirstName,
			VILastName	,	
			VIAddress1	,
			VIAddress2 ,
			VICity		,	
			VIState,
			VIZipcode 	,
			VIPhone		
		FROM `ppdb`.`importold`
			where `id` = VID;

		

	UPDATE `ppdb`.`customers`
	SET
		`City` = VICity,
		`State` = VIState
	WHERE 
		`FirstName` = VIFirstName and
		`LastName` = VILastName and
		`Address1` = VIAddress1 and
		`Address2` = VIAddress2 and
		`ZipCode` = VIZipcode and
		`PhoneNumber` = VIPhone;
	
	end while;
end$$