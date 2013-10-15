use ppdb;
drop view if exists `vwbondquicklist`;

CREATE VIEW `vwbondquicklist` AS

SELECT `bonds`.`BondiD` as 'Bond ID',
    concat(`bonds`.`FKBondPrefix`, ' ',`bonds`.`PowerNumber`) as 'Number'
FROM `ppdb`.`bonds`;
