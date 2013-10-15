	use ppdb;
	delete from bonds_has_payplans;
	delete from loadednewplans;
	delete from paymentschedules;
	delete from comments;
	delete from payplans_has_customers;	
	delete from customers;
	delete from loadednewplans;
	delete from payplans;
	delete from ledger;
	delete from bonds;

	/*load the cvs file into table loadednewplans*/
	LOAD DATA LOCAL INFILE 'C:\\wamp\\www\\PaymentPlan\\Import\\importfile.csv' INTO TABLE ppdb.loadednewplans 
	FIELDS TERMINATED BY ',' 
	ENCLOSED BY '"' 
	ignore 1 lines
	(CLastName,CFirstName,Caddress1,Caddress2,CCity,CState,CZipCode,CPhone,@VarDateExe,Alpha_pre,Power,Bl_due,Agent,ILastName,IFirstName,IAddress1,IAddress2,ICity,IState,IZipCode,IPhone)
	set DateExe = STR_TO_DATE(@VarDateExe,'%m/%d/%Y');

	call prcpayplanimport('1');