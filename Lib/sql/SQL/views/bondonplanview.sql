use ppdb;
drop view if exists `vwbondonplan`;


CREATE VIEW `vwbondonplan` AS
    select 
        `bonds`.`BondiD` AS `Bond ID`,
        `bonds_has_payplans`.`PayPlans_PayPlanID` AS `Pay Plan ID`,
        concat(`bonds`.`FKBondPrefix`,
                ' ',
                `bonds`.`PowerNumber`) AS `Power Number`,
        `bonds`.`FKBondAgentID` AS `Agent ID`,
        `agents`.`Initials` AS `Agent`,
        `bonds`.`FKBondOfficeID` AS `Office ID`,
        `offices`.`OfficeName` AS `Office`,
        `bonds`.`ExecutionDate` AS `ExecutionDate`,
        'Remove' AS `Remove`
    from `bonds`
        join `bonds_has_payplans` ON `bonds_has_payplans`.`Bonds_BondiD` = `bonds`.`BondiD`
        join `agents` ON `bonds`.`FKBondAgentID` = `agents`.`AgentID`
        join `offices` ON `bonds`.`FKBondOfficeID` = `offices`.`OfficeID`;
