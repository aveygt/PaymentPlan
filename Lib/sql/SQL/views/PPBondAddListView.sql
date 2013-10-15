use ppdb;
drop view if exists `vwppbondaddlist`;

CREATE VIEW `vwppbondaddlist` AS
	SELECT 
		`bonds`.`BondiD` as 'Bond ID',
		`bonds_has_payplans`.`PayPlans_PayPlanID` as 'Pay Plan ID',
		concat(`bonds`.`FKBondPrefix`,' ',`bonds`.`PowerNumber`) as 'Power Number',
		`bonds`.`FKBondAgentID` as 'Agent ID',
		`agents`.`Initials` as 'Agent',
		`bonds`.`FKBondOfficeID` as 'Office ID',
		`offices`.`OfficeName` as 'Office',
		`bonds`.`ExecutionDate`,
		'Cancel' as 'Cancel'
	FROM `ppdb`.`bonds`
	join `ppdb`.`bonds_has_payplans`
		on `bonds_has_payplans`.`Bonds_BondiD` = `bonds`.`BondiD`
	join `ppdb`.`agents`
		on `bonds`.`FKBondAgentID` = `agents`.`AgentID`
	join `ppdb`.`offices`
		on `bonds`.`FKBondOfficeID` = `offices`.`OfficeID`;