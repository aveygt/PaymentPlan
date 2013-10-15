DROP VIEW IF EXISTS `ppdb`.`vwccduelist`;

CREATE VIEW `vwccduelist` AS

SELECT 
	`payplans`.`PayPlanID`,
	concat(`customers`.`LastName`, ', ',`customers`.`FirstName`) as 'Customer',
	`paymentschedules`.`Amount` as 'Amount',
	`paymentschedules`.`DueDate` as 'Due Date'
FROM `ppdb`.`payplans`
left join `ppdb`.`payplans_has_customers`
	on `payplans_has_customers`.`PayPlans_PayPlanID` = `payplans`.`PayPlanID`
left join `ppdb`.`customers`
	on `payplans_has_customers`.`Customers_CustomerID` = `customers`.`CustomerID`

left join `ppdb`.`paymentschedules`
	on `paymentschedules`.`FKSchedulePayPlanID` = `payplans`.`PayPlanID`

where `paymentschedules`.`DueDate` = (select `ppdbsettings`.`CCListDate` from `ppdb`.`ppdbsettings` where `ppdbsettings`.`ID` = 1)
	and `paymentschedules`.`IsAutoPay` = 1;