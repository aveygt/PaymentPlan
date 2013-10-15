use ppdb;
Drop View If Exists `vwcustomeronplan`;

CREATE VIEW `vwcustomeronplan` AS
SELECT 
	`payplans_has_customers`.`PayPlans_PayPlanID` as 'Pay Plan ID',
	case when `payplans_has_customers`.`Defendant` = 1
		then 'X'
	End as 'Def',
	`customers`.`CustomerID` as 'Customer ID',
    `customers`.`FirstName` as 'First Name',
    `customers`.`LastName` as 'Last Name',
    `customers`.`DOB` as 'D.O.B',
    `customers`.`Address1` as 'Address 1',
    `customers`.`Address2` as 'Address 2',
    `customers`.`City` as 'City',
    `customers`.`State` as 'State',
	case when `customers`.`ZipCode` = 0 or `customers`.`ZipCode` = null
		then ''
		else `customers`.`ZipCode` 
	End as 'Zip Code',
	case when `customers`.`PhoneNumber` = 0 or `customers`.`PhoneNumber` = null
		then ''
		else concat('(',left(`customers`.`PhoneNumber`,3),') ',substring(`customers`.`PhoneNumber`,4,3),'-',substring(`customers`.`PhoneNumber`,7,4))
	End as 'Phone',
	'Remove'
FROM `ppdb`.`customers`
left join `ppdb`.`payplans_has_customers`
	on `customers`.`CustomerID` = `payplans_has_customers`.`Customers_CustomerID`;