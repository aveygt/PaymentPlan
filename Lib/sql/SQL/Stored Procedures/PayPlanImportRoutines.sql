use ppdb;
DROP PROCEDURE if exists `ppdb`.`PrcPayPlanImport`;

DELIMITER $$
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
