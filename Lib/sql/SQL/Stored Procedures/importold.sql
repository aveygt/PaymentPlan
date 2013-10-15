use ppdb;
DROP PROCEDURE if exists `ppdb`.`PrcOldImport`;


DELIMITER $$
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
			case when `importold`.`execdate` != '' then
				STR_TO_DATE(`importold`.`execdate`,'%m/%d/%Y')
			else
				'0000-00-00'
			end,
			`importold`.`prevbal`,
			`importold`.`pymntamount`,
			`importold`.`pymntfreq`,
			
			case when `importold`.`ledgerdate` != '' then
				STR_TO_DATE(`importold`.`ledgerdate`,'%m/%d/%Y')
			else
				'0000-00-00'
			end,
			`importold`.`ledgerdesc`,
			`importold`.`ledgdebit`,
			`importold`.`ledgcredit`,

			case when `importold`.`duedate` != '' then
				STR_TO_DATE(`importold`.`duedate`,'%m/%d/%Y')
			else
				'0000-00-00'
			end,
			`importold`.`amntdue`,

			case when `importold`.`commentdate` != '' then
				STR_TO_DATE(`importold`.`commentdate`,'%m/%d/%Y')
			else
				'0000-00-00'
			end,
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