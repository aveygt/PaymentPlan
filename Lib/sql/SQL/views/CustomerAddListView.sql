DROP VIEW IF EXISTS `ppdb`.`vwcustomeraddlist`;

CREATE VIEW `vwcustomeraddlist` AS

SELECT `customers`.`CustomerID`,
    concat(`customers`.`LastName`, ', ', `customers`.`FirstName`) as 'Name',
    `customers`.`DOB`,
	'Cancel' as 'Cancel'
FROM `ppdb`.`customers`
where concat(`customers`.`LastName`, ', ', `customers`.`FirstName`) != ', '
order by `Name`;
