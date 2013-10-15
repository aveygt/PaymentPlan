SELECT `payplans`.`PayPlanID` as 'ID',
    `payplans`.`CreationDate` as 'Creation Date',
    `payplans`.`StartingBalance` as ' Start Bal',
    `payplans`.`PaymentAmount` as 'Payment amount',
    `frequency`.`Frequency` as 'Freq',
    `payplans`.`StartDate`,
    `agents`.`Initials` as 'Agent'
FROM `ppdb`.`payplans`
left join `ppdb`.`frequency`
	on `payplans`.`FKPayPlanFrequencyID` = `frequency`.`FrequencyID`
left join `ppdb`.`agents`
	on `payplans`.`FKPayPlanAgentID` = `agents`.`AgentID`;
