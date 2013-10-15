use ppdb;
Drop view if exists `ppdb`.`vwledger`;

CREATE VIEW `vwledger` AS

SELECT `ledger`.`EntryID` as 'ID',
    `ledger`.`Date`,
    `ledger`.`FKLedgerBondID` as 'Bond ID',
	concat(`bonds`.`FKBondPrefix`,' ',`bonds`.`PowerNumber`) as Bond,
	`ledger`.`Description`,
	case when `ledger`.`Debit` is null
		then ''
		else concat('$',`ledger`.`Debit`)
	end as 'Credit',
	case when `ledger`.`Credit` is null
		then ''
		else concat('$',`ledger`.`Credit`)
	end as 'Debit'
FROM `ppdb`.`ledger`
left join `ppdb`.`bonds`
	on `ledger`.`FKLedgerBondID` = `bonds`.`BondiD`;
