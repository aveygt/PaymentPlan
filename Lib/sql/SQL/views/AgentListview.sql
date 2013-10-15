use ppdb;
drop view if exists `vwagentlist`;

CREATE VIEW `vwagentlist` AS

SELECT `agents`.`AgentID` as 'Agent ID',
    concat(`agents`.`LastName`,', ',`agents`.`FirstName`) as 'Agent Name'
FROM `ppdb`.`agents`
Order by concat(`agents`.`LastName`,', ',`agents`.`FirstName`) ;
