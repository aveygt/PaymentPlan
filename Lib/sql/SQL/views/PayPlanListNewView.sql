DROP VIEW IF EXISTS `ppdb`.`vwpayplanlistNew`;

CREATE VIEW `vwpayplanlistNew` AS

SELECT * FROM `ppdb`.`vwpayplanlist` 
Where `vwpayplanlist`.`Freq` = "Not Set"
order by `Exec Date` Desc;