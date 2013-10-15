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
	delete FROM ppdb.importold;

	/*load the cvs file into table loadednewplans*/
	LOAD DATA LOCAL INFILE 'C:\\wamp\\www\\PaymentPlan\\Import\\importsheet.csv' INTO TABLE ppdb.importold 
	FIELDS TERMINATED BY ',' 
	ENCLOSED BY '"' 
	ignore 1 lines
	(plannum,agent,execdate,prevbal,pymntamount,pymntfreq,ledgerdate,ledgerdesc,ledgdebit,ledgcredit,duedate,amntdue,commentdate,comment,lastname,firstname,add1,add2,city,state,zip,phone,prefix,bondnum);

	call PrcOldImport(1);
