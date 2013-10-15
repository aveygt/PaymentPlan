
use ppdb;
Drop view if exists `ppdb`.`vwledgeronplan`;

CREATE VIEW `vwledgeronplan` AS

SELECT `ledger`.`EntryID` as 'Entry ID',
    `ledger`.`FKLedgerBondID` as 'Bond ID',
	`bonds_has_payplans`.`PayPlans_PayPlanID` as 'Pay Plan ID',
	`ledger`.`Date`,
	concat(`bonds`.`FKBondPrefix`,' ',`bonds`.`PowerNumber`) as 'Bond Number',
	`ledger`.`Description`,
	`ledger`.`Debit` as 'Debit',
	`ledger`.`Credit` as 'Credit',
	`ledger`.`IsFinanced` as 'Financed',
	'Delete' as 'Delete'
FROM `ppdb`.`ledger`
inner join `ppdb`.`bonds`
	on FKLedgerBondID = `bonds`.`BondiD`
inner join`ppdb`.`bonds_has_payplans`
	on `bonds_has_payplans`.`Bonds_BondiD` = `bonds`.`BondiD`
order by
	`ledger`.`Date` Asc;