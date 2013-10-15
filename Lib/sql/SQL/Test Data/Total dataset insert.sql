DELETE FROM `ppdb`.`customers`;
DELETE FROM `ppdb`.`PhoneNumbers`;
DELETE FROM `ppdb`.`Addresses`;
DELETE FROM `ppdb`.`bonds`;
DELETE FROM `ppdb`.`ledger`;

ALTER TABLE `ppdb`.`customers` AUTO_INCREMENT = 1 ;
ALTER TABLE `ppdb`.`PhoneNumbers` AUTO_INCREMENT = 1 ;
ALTER TABLE `ppdb`.`Addresses` AUTO_INCREMENT = 1 ;



INSERT INTO `ppdb`.`customers` (`CustomerID`,`FirstName`, `LastName`, `DOB`) 
VALUES 
	('1','Grant', 'Avey', '1985-6-08'),
	('2','Delissa','Huff', '1975-7-20');

INSERT INTO `ppdb`.`PhoneNumbers` (PhoneNumberID,FKPhoneCustomerID,PhoneNumber,Extension,Description,RecordDate)
VALUES
	('1','1','5746431235',null,'1','2013-01-01 00:00:00'),
	('2','2','1231234567',null,'1','2013-01-01 00:00:00');

INSERT INTO `ppdb`.`Addresses` (AddressID,FKAddressCustomerID,Line1,Line2,City,FKAddressStateID,ZipCode,RecordDate)
VALUES
	('1','1','3015 Herbert LN','','Orlando','9','32805','2012-01-01 00:00:00'),
	('2','2','3910 south john young park way','','Orlando','9','32806','2013-03-03 00:00:00');

INSERT INTO `ppdb`.`bonds` (BondID,PowerNumber,FKBondPrefixID,FKBondAgentID,FKBondOfficeID,ExecutionDate)
VALUES
	('1','5588832','1','5','1','2013-8-17'),
	('2','5588833','1','5','1','2013-8-17'),
	('3','5588834','1','5','1','2013-8-17');

INSERT INTO `ppdb`.`ledger`
(`EntryID`,`FKLedgerBondID`,`date`,`Debit`,`Credit`,`Description`)
VALUES
	('1','1','2013-8-17','500.42','','Bond Posted for $5,000'),
	('2','2','2013-8-17','100.08','','Bond Posted for $500'),
	('3','3','2013-8-17','200.17','','Bond Posted for $2000');

INSERT INTO `ppdb`.`payplans`
(`PayPlanID`,
`CreationDate`,
`FKPayPlanFrequencyID`,
`PaymentAmount`,
`StartDate`,
`StartingBalance`,
`ScanLocation`,
`FKPayPlanAgentID`)
VALUES
('1','2013-8-17','2','100.00','2013-8-28','800.67','//sbs2008/Scans/Grant-Avey-13-8-17','5');


