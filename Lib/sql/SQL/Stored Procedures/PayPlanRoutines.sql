use ppdb;
SET GLOBAL log_bin_trust_function_creators = 1;
DROP function if exists `ppdb`.`FnPayPlanAdd`;
DROP PROCEDURE if exists `ppdb`.`PrcPayPlanCommentAdd`;
DROP PROCEDURE if exists `ppdb`.`PrcPayPlanBondAdd`;
drop procedure if exists `ppdb`.`PrcPayPlanBondDelete`;
DROP PROCEDURE if exists `ppdb`.`PrcPayPlanCustomerAdd`;
Drop procedure if exists `ppdb`.`PrcPayPlanCustomerDelete`;
DROP PROCEDURE if exists `ppdb`.`PrcPayScheduleAdd`;
Drop procedure if exists `ppdb`.`PrcSetPayBegBal`;
Drop procedure if exists `ppdb`.`PrcPayPlanMod`;
Drop procedure if exists `ppdb`.`PrcPayScheduleDelete`;
Drop procedure if exists `ppdb`.`PrcAutoSchedule`;
Drop procedure if exists `ppdb`.`PrcScheduleAutoCCSwitch`;
Drop procedure if exists `ppdb`.`PrcSetCustomerDefendant`;


-- --------------------------------------------------------------------------------`PrcPayPlanMod`
-- PayPlanRoutines Group Routines
-- --------------------------------------------------------------------------------
DELIMITER $$

create procedure `PrcSetCustomerDefendant`
(
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

CREATE function `FnPayPlanAdd` 
(
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
)
returns int
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

CREATE PROCEDURE `PrcPayPlanCommentAdd`
(
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

CREATE PROCEDURE `PrcPayPlanBondDelete` 
(
	IN VPayPlanID int,
	IN VBondID int
)
BEGIN
	DELETE FROM `ppdb`.`bonds_has_payplans` 
	WHERE `Bonds_BondiD`= VBondID
	and`PayPlans_PayPlanID`= VPayPlanID;

	-- select 'bond plan added' as 'bond plan';
END$$




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

-- to delete the relationship between payplan and customer
create procedure `PrcPayPlanCustomerDelete`
(
	IN VarPayPlanID		INT,
	in VarCustomerID	INT
)
begin
	DELETE FROM `ppdb`.`payplans_has_customers` 
		WHERE `PayPlans_PayPlanID`= VarPayPlanID 
		and `Customers_CustomerID`=	VarCustomerID;
end$$

CREATE PROCEDURE `PrcPayScheduleAdd` 
(
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

CREATE PROCEDURE `PrcPayScheduleDelete`
(
	IN Del int
)
begin
	DELETE FROM 
		`ppdb`.`paymentschedules` 
	WHERE `ScheduleID`= Del;

end$$

create procedure `PrcAutoSchedule`
(
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

create procedure `PrcScheduleAutoCCSwitch`
(
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

CREATE PROCEDURE `PrcSetPayBegBal`
(
	VPayID	int,
	VBegBal	Decimal(10,2)
)
begin	
	Update `ppdb`.`payplans`
	Set `payplans`.`StartingBalance`  = VBegBal
	where `payplans`.`PayPlanID` = VPayID;
END$$

CREATE PROCEDURE `PrcPayPlanMod`
(	
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
	