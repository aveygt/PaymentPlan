use `ppdb`;

drop trigger if exists `after_update_payplans`;

Delimiter $$

Create Trigger `ppdb`.`after_update_payplans`
	after update on `ppdb`.`payplans` for each row
begin
	declare VarPayPlanID int;
	set VarPayPlanID = NEW.`PayPlanID`;
	
	UPDATE `ppdb`.`ledger`
	inner join `ppdb`.`bonds`
		on FKLedgerBondID = `bonds`.`BondiD`
	inner join`ppdb`.`bonds_has_payplans`
		on `bonds_has_payplans`.`Bonds_BondiD` = `bonds`.`BondiD`
	SET
		`ledger`.`IsFinanced` = NEW.`IsFinanced`
	WHERE `bonds_has_payplans`.`PayPlans_PayPlanID` = VarPayPlanID;
end$$