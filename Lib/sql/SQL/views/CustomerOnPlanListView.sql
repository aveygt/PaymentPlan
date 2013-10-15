use ppdb;
drop view if exists `vwCustomerOnPlanList`;

CREATE VIEW `vwCustomerOnPlanList` AS

SELECT 
	`vwcustomeronplan`.`Customer ID` as 'Customer ID',
	concat(`vwcustomeronplan`.`Last Name`,', ',`vwcustomeronplan`.`First Name`) as 'Customer Name',
	`vwcustomeronplan`.`Pay Plan ID`
FROM `ppdb`.`vwcustomeronplan`;
