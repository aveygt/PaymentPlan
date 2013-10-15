DROP VIEW IF EXISTS `ppdb`.`vwpayplansimple`;

CREATE VIEW `vwpayplansimple` AS

SELECT `payplans`.`PayPlanID` as 'ID',
    `payplans`.`CreationDate` as 'Creation Date',
    `payplans`.`StartingBalance` as 'Start Bal',
    `payplans`.`PaymentAmount` as 'Pay Amount',
    `payplans`.`FKPayPlanFrequencyID` as 'Freq ID',
	`frequency`.`Frequency` as 'Freq',
    `payplans`.`StartDate` as 'Start Date',
    `payplans`.`OtherConditions` as 'Other Conditions',
    `payplans`.`FKPayPlanAgentID` as 'Agent ID',
	`agents`.`Initials` as 'Agent',
    `payplans`.`ScanLocation` as 'Scan Location',
	`payplans`.`OldDebt` as 'Old Debt',
	`payplans`.`IsFinanced`  as 'Financed',
	`payplans`.`IsBadDebt`	as 'Bad Debt',
	case when `payplans`.`ScanLocation` = null
		then ''
		else 'scan'
	End as 'Scan',
    `payplans`.`IsSuspended` as 'susp'
FROM `ppdb`.`payplans`
join `ppdb`.`frequency`
	on `payplans`.`FKPayPlanFrequencyID` = `frequency`.`FrequencyID`
join `ppdb`.`agents`
	on `payplans`.`FKPayPlanAgentID` = `agents`.`AgentID`;