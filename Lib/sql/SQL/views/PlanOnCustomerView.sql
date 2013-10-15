use ppdb;
drop view if exists `vwplanoncustomer`;

create view `vwplanoncustomer` as
SELECT `customers`.`CustomerID` as 'CustID',
	`payplans`.`PayPlanID` as 'PayPlanID',
	`payplans`.`CreationDate` as 'Plan Date',
	`payplans`.`StartingBalance` as 'Starting Bal'
FROM `ppdb`.`customers`
left join `ppdb`.`payplans_has_customers`
	on `customers`.`CustomerID` = `payplans_has_customers`.`Customers_CustomerID`
left join `ppdb`.`payplans`
	on `payplans_has_customers`.`PayPlans_PayPlanID` = `payplans`.`PayPlanID`;
