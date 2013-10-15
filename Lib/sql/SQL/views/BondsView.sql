use ppdb;
drop view if exists `vwbonds`;


CREATE VIEW `vwbonds` AS
    select 
        `bonds`.`BondiD` AS `Bond ID`,
        concat(`bonds`.`FKBondPrefix`,
                ' ',
                `bonds`.`PowerNumber`) AS `Power Number`,
        `bonds`.`FKBondAgentID` AS `Agent ID`,
        `agents`.`Initials` AS `Agent`,
        `bonds`.`FKBondOfficeID` AS `Office ID`,
        `offices`.`OfficeName` AS `Office`,
        `bonds`.`ExecutionDate` AS `ExecutionDate`
    from `bonds`
        join `agents` ON `bonds`.`FKBondAgentID` = `agents`.`AgentID`
        join `offices` ON `bonds`.`FKBondOfficeID` = `offices`.`OfficeID`;