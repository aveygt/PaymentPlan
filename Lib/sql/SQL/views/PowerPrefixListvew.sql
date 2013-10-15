DROP VIEW IF EXISTS `ppdb`.`vwprefixlist`;

CREATE VIEW `vwprefixlist` AS
SELECT `powerprefixes`.`Prefix` as 'ID',
    `powerprefixes`.`Prefix` as 'Prefix'
FROM `ppdb`.`powerprefixes`;
