DROP VIEW IF EXISTS `ppdb`.`vwpayplanlistColl`;

CREATE VIEW `vwpayplanlistColl` AS

SELECT * FROM `ppdb`.`vwpayplanlist` Where `vwpayplanlist`.`Age` > 90;