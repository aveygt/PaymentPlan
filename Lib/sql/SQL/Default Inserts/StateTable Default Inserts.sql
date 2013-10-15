-- -----------------------------------------------------
-- Data for table `PPDB`.`States`
-- -----------------------------------------------------
START TRANSACTION;
USE `PPDB`;


INSERT INTO `PPDB`.`Agents` (`AgentID`,`FirstName`, `LastName`,`Initials`) 
VALUES 
	('1','Russel Bruce','Moncrief','RBM'),
	('2','Heather','West','HW'),
	('3','Nate','West','NW'),
	('4','Jennifer','Schumate','JS'),
	('5','Kyle','Jameson','KJ'),
	('6','Robert','Reeves','RWR'),
	('7','Melissa','King','MLK'),
	('8','Ashley','Kinser','AK'),
	('9','Kristine','Woldanski','KW'),
	('10','Victor','Grifith','VNG'),
	('11','Juan','Quinones','JQ'),
	('12','Nichole','Maldonado','NJ'),
	('13','Emily','ZUnknown','EC'),
	('14','ZUnknown','ZUnknown','CD');

INSERT INTO `PPDB`.`Offices` (`OfficeID`,`OfficeName` ,`OfficeAbbreviation`)
VALUES
	('1','Orlando','MBB'),
	('2','Brevard','BMBB');

INSERT INTO `PPDB`.`PowerPrefixes` (`Prefix`,`PowerLimit`)
VALUES
	('A50','0.00'),
	('BB','6000'),
	('AB','11000'),
	('AC','25000'),
	('AD','50000'),
	('AF','100000'),
	('AG','250000'),
	('TRAN','0.00');

INSERT INTO `PPDB`.`Frequency` (`FrequencyID`,`Frequency`,`Description`)
VALUES
	('0','No Plan','0 DAY'),
	('1','Daily','1 DAY'),
	('2','Weekly','1 WEEK'),
	('3','Bi-Weekly','2 WEEK'),
	('4','Monthly','1 MONTH'),
	('5','Bi-Monthly','2 MONTH'),
	('6','Other','0 DAY'),
	('7','Not Set','0 DAY');

commit;
