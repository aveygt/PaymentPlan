DROP VIEW IF EXISTS `ppdb`.`vwpayplanlist90Day`;

CREATE VIEW `vwpayplanlist90Day` AS

SELECT * FROM `ppdb`.`vwpayplanlist` Where DATEDIFF(CURDATE(), `vwpayplanlist`.`Exec Date`) <= 90;