use ppdb;
drop view if exists `vwplansonbond`;


CREATE VIEW `vwplansonbond` AS
SELECT `payplans`.`PayPlanID` as 'Pay Plan ID',
    `payplans`.`CreationDate` as 'Creation Date',
    `payplans`.`StartingBalance` as 'Start Bal',
	`bonds_has_payplans`.`Bonds_BondiD` as 'Bond ID'
FROM `ppdb`.`payplans`
join `ppdb`.`bonds_has_payplans`
	on  `payplans`.`PayPlanID` = `bonds_has_payplans`.`PayPlans_PayPlanID`;
		