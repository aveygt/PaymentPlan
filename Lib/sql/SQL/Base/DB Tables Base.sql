DROP TABLE IF EXISTS BondsPayPlans;
DROP TABLE IF EXISTS CustomersPayPlans;
DROP TABLE IF EXISTS Addresses;
DROP TABLE IF EXISTS PhoneNumbers;
DROP TABLE IF EXISTS States;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS ScheduledPayments;
DROP TABLE IF EXISTS Bonds;
DROP TABLE IF EXISTS Comments;
DROP TABLE IF EXISTS PayPlans;
DROP TABLE IF EXISTS PaymentFrequencies;
DROP TABLE IF EXISTS Agents;
DROP TABLE IF EXISTS Offices;
DROP TABLE IF EXISTS PowerPrefixes;




CREATE TABLE Customers (
	CustomerID Integer GENERATED BY DEFAULT AS Identity(START WITH 0) NOT NULL PRIMARY KEY,
	FirstName VarChar(25) NOT NULL,
	LastName VarChar(25),
	DOB DATE
);

CREATE TABLE States (
	StateID integer generated by default as identity(start with 0) not null primary key,
	StateInitial varchar(2) not null,
	State varchar(25)
);

CREATE TABLE Addresses (
	AddressID Integer Generated by default as identity(start with 0) not null primary key,
	CustomerID integer not null,
	Line1 varchar(40),
	Line2 varchar(40),
	City varchar(25),
	StateID integer,
	ZipCode varchar(15),
	RecordDate timestamp default current_timestamp not null,
	
	----CONSTRAINTS-----
	CONSTRAINT AddressesFKinStates FOREIGN KEY(StateID) REFERENCES States (StateID),
	CONSTRAINT AddressesFKinCustomers FOREIGN KEY(CustomerID) REFERENCES Customers (CustomerID)
);

CREATE TABLE PhoneNumbers (
	PhoneNumberID integer generated by default as identity(start with 0) not null primary key,
	CustomerID integer,		--Foreign Key: Customers
	PhoneNumber varchar(10),
	Extention varchar(10),
	Description varchar(10),
	RecordDate timestamp default current_timestamp not null,
	
	-----CONSTRAINTS-------
	CONSTRAINT PhoneNumbersFKinCustomers FOREIGN KEY(CustomerID) REFERENCES Customers (CustomerID)
);

CREATE TABLE PaymentFrequencies (
	FrequencyID integer generated by default as identity(start with 0) not null primary key,
	Frequency varchar(15) not null,
	Description varchar(255)
);

CREATE TABLE Agents (
	AgentID integer GENERATED BY DEFAULT AS IDENTITY(START WITH 1) NOT NULL PRIMARY KEY,
	FirstName VarChar(25),
	LastName VarChar(25),
	Initials VarChar(3)
);

CREATE TABLE PayPlans (
	PayPlanID INTEGER GENERATED BY DEFAULT AS IDENTITY(START WITH 0) NOT NULL PRIMARY KEY,
	CreationDate  DATE NOT NULL,
	FrequencyID integer,		--Foriegn Key: PaymentFrequencies
	PaymentAmount DECIMAL(10,2),
	StartDate DATE,
	StartingBalance DECIMAL(10,2) NOT NULL,
	ScanLocation varchar(255),
	AgentID integer NOT NULL,	--Foriegn Key: Agents
	RecordDate timestamp default current_timestamp not null,
	
	-----CONSTRAINTS-----
	CONSTRAINT PayPlansFKinPaymentFrequencies FOREIGN KEY(FrequencyID) REFERENCES PaymentFrequencies (FrequencyID),
	CONSTRAINT PayPlansFKinAgents FOREIGN KEY(AgentID) REFERENCES Agents (AgentID)
);

CREATE TABLE Comments (
	CommentID INTEGER GENERATED BY DEFAULT AS IDENTITY(START with 0) NOT NULL PRIMARY KEY,
	RecordDate timestamp default current_timestamp not null,
	PayPlanID integer,			--Foriegn Key: PayPlans
	
	----CONSTRAINTS----
	CONSTRAINT CommentsFKinPayPlans FOREIGN KEY(PayPlanID) REFERENCES PayPlans (PayPlanID)
);

CREATE TABLE Offices (
	OfficeID integer GENERATED BY DEFAULT AS IDENTITY(START WITH 1) NOT NULL PRIMARY KEY,
	OfficeName VarChar(25),
	OfficeAbbreviation VarChar(4)
);

CREATE TABLE PowerPrefixes (
	PrefixID integer GENERATED BY DEFAULT AS IDENTITY(START WITH 0) NOT NULL PRIMARY KEY,
	Prefix VarChar(2) NOT NULL,
	PowerLimit DECIMAL(10,2) NOT NULL
);

CREATE TABLE Bonds (
	BondID Integer GENERATED BY DEFAULT AS IDENTITY(START WITH 0) NOT NULL PRIMARY KEY,
	PrefixID integer NOT NULL,	--Forieng Key: PowerPrefixes
	AgentID integer NOT NULL, 	--Foriegn Key: Agents
	OfficeID integer NOT NULL, 	--FOriegn Key: Offices
	ExecutionDate Date NOT NULL,
	
	----CONSTRAINTS----
	CONSTRAINT BondsFKinPowerPrefixes FOREIGN KEY(PrefixID) REFERENCES PowerPrefixes (PrefixID),
	CONSTRAINT BondsFKinAgents FOREIGN KEY(AgentID) REFERENCES Agents (AgentID),
	CONSTRAINT BondsFkinOffices FOREIGN KEY(OfficeID) REFERENCES Offices (OfficeID)
);

CREATE TABLE ScheduledPayments (
	ScheduledPaymentID INTEGER GENERATED BY DEFAULT AS IDENTITY(START WITH 0) NOT NULL PRIMARY KEY,
	BondID Integer, 				--Foriegn Key: Bonds
	PayPlanID Integer,			--Foriegn Key: PayPlans
	Amount Decimal(10,2) not null,
	DueDate Date NOT NULL,
	IsSuspended Boolean default '0',
	RecordDate timestamp default current_timestamp not null,
	
	-----CONSTRAINTS-----
	CONSTRAINT ScheduledPaymentsFKinBonds FOREIGN KEY(BondID) REFERENCES Bonds (BondID),
	CONSTRAINT ScheduledPaymentsFKinPayPlans FOREIGN KEY(PayPlanID) REFERENCES PayPlans (PayPlanID)
);

CREATE TABLE BondsPayPlans (
	BondID Integer NOT NULL,				--Foriegn Key: Bonds
	PayPlanID Integer NOT NULL,			--Foriegn Key: PayPlans)
	
	----CONSTRAINTS----
	CONSTRAINT BondsPayPayPlansPK PRIMARY KEY (BondID, PayPlanID),
	CONSTRAINT BondsPayPlansFKinBonds FOREIGN KEY(BondID) REFERENCES Bonds (BondID),
	CONSTRAINT BondsPayPlansFKinPayPlans FOREIGN KEY(PayPlanID) REFERENCES PayPlans (PayPlanID)
);

CREATE TABLE CustomersPayPlans (
	CustomerID Integer NOT NULL,			--Foriegn Key: Customers
	PayPlanID Integer NOT NULL,			--Foriegn Key: PayPlans)
	IsDefendant Boolean default '1',
	
	----CONSTRAINTS----
	CONSTRAINT CustomersPayPlansPK PRIMARY KEY (CustomerID, PayPlanID),
	CONSTRAINT CustomersPayPlansFKinBonds FOREIGN KEY(CustomerID) REFERENCES Customers (CustomerID),
	CONSTRAINT CustomersPayPlansFKinPayPlans FOREIGN KEY(PayPlanID) REFERENCES PayPlans (PayPlanID)
);