DROP VIEW IF EXISTS `ppdb`.`vwpayplanlist90DayDel`;

CREATE VIEW `vwpayplanlist90DayDel` AS

SELECT * FROM `ppdb`.`vwpayplanlist` Where `vwpayplanlist`.`Age` <= 90;