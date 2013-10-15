DROP VIEW IF EXISTS `ppdb`.`vwcustomerlist`;

CREATE VIEW `vwcustomerlist` AS

SELECT `customers`.`CustomerID`,
    concat(`customers`.`LastName`, ', ', `customers`.`FirstName`) as 'Name',
    `customers`.`DOB` as 'DOB'
FROM `ppdb`.`customers`;
