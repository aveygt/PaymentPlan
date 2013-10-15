SELECT 
	`payplans`.`PayPlanID` as 'ID',
	/* defendant*/
	concat(`customers`.`LastName`,', ',`customers`.`FirstName`) as 'Defendant',
	`customers`.`Address1` 	as 'Def Address 1',
	`customers`.`Address2` 	as 'Def Address 2',
	`customers`.`City` 		as 'Def City',
	`customers`.`State`		as 'Def State',
	case when `customers`.`ZipCode` = 0 or `customers`.`ZipCode` = null
		then ''
		else `customers`.`ZipCode` 
	End as 'Def Zip Code',
	case when `customers`.`PhoneNumber` = 0 or `customers`.`PhoneNumber` = null
		then ''
		else concat('(',left(`customers`.`PhoneNumber`,3),') ',substring(`customers`.`PhoneNumber`,4,3),'-',substring(`customers`.`PhoneNumber`,7,4))
	End as 'Def Phone',
	/* Indemnitor*/
	concat(I.LastName,', ',I.FirstName) as 'Indemnitor',
	`I`.`Address1` 	as 'Ind Address 1',
	`I`.`Address2` 	as 'Ind Address 2',
	`I`.`City` 		as 'Ind City',
	`I`.`State` 	as 'Ind State',
	case when `I`.`ZipCode` = 0 or `I`.`ZipCode` = null
		then ''
		else `I`.`ZipCode` 
	End as 'Ind Zip Code',
	case when `I`.`PhoneNumber` = 0 or `I`.`PhoneNumber` = null
		then ''
		else concat('(',left(`I`.`PhoneNumber`,3),') ',substring(`I`.`PhoneNumber`,4,3),'-',substring(`I`.`PhoneNumber`,7,4))
	End as 'Ind Phone',
	/* payplan info*/
	`payplans`.`OldDebt`			as 'Old Debt',
    `payplans`.`CreationDate` 		as 'Exec Date',
	`agents`.`AgentID`				as 'Agent ID',
    `agents`.`Initials` 			as 'Agent',
	(
		SELECT max(`vwledgeronplan`.`Date`) 
		FROM ppdb.vwledgeronplan 
		where `vwledgeronplan`.`Credit` != '' 
			and `vwledgeronplan`.`Pay Plan ID` = `payplans`.`PayPlanID`
	)								as 'Date Last Paid',
    `frequency`.`Frequency` 		as 'Freq',
    `payplans`.`PaymentAmount`	 	as 'Amount',
	(
		SELECT count(*) 
		FROM ppdb.vwledgeronplan
		where `vwledgeronplan`.`Credit` != '' 
			and `vwledgeronplan`.`Pay Plan ID` = `payplans`.`PayPlanID`

	)								as '# payments',
    `payplans`.`StartingBalance` 	as 'Start Bal',
	(
		/* use the case to handle if the value is null */
		SELECT (Format(SUM(`vwledgeronplan`.`Debit`) - (case when sum(`vwledgeronplan`.`Credit`) is null 
													then '0' 
													else sum(`vwledgeronplan`.`Credit`)
												end),2))
		FROM ppdb.vwledgeronplan
		where `vwledgeronplan`.`Pay Plan ID` = `payplans`.`PayPlanID`
	)								as 'Balance',

	 case when (select @VarPastDue := (ifnull((	select sum(`DTD`.`Amount`) /* the sum of all that was due before now*/
		from `paymentschedules` as `DTD`
		where `DTD`.`FKSchedulePayPlanID` =`payplans`.`PayPlanID`
			and `DTD`.`DueDate` < CurDate()
	),0) - ifnull((
		SELECT sum(Credit) /* the sum of all the payments made before now*/
		FROM ppdb.vwledgeronplan
		where `vwledgeronplan`.`Pay Plan ID` = `payplans`.`PayPlanID`
			and `vwledgeronplan`.`Date` <=CURDATE()
	),0))) <= 0 then
		null 
	else @VarPastDue end as  'Past Due',
	
	case
		when @VarPastDue >= `payplans`.`PaymentAmount` then
			'red'
		when @VarPastDue > 0 then
			'yellow'
		else
			'green'
		end as 'Past Due CSS ID',


		
    `payplans`.`StartDate`			as 'Start Date',
	DATEDIFF(CURDATE(), `payplans`.`CreationDate` ) as 'Age',

	/*list all comments*/
	(select group_concat(`vwcondensedcomments`.`Comment` SEPARATOR ' 
') 
	from `vwcondensedcomments` 
	where `FKCommentPayPlanID`	= 	`payplans`.`PayPlanID`)			as 'Comments'
FROM `ppdb`.`payplans`

/* Joining for the frequency and agents*/
left join `ppdb`.`frequency`
	on `payplans`.`FKPayPlanFrequencyID` = `frequency`.`FrequencyID`
left join `ppdb`.`agents`
	on `payplans`.`FKPayPlanAgentID` = `agents`.`AgentID`

/* joining for the Defendant*/
left join `ppdb`.`payplans_has_customers`
	on `payplans`.`PayPlanID` = `payplans_has_customers`.`PayPlans_PayPlanID`
left join `ppdb`.`customers`
	on `customers`.`CustomerID` = `payplans_has_customers`.`Customers_CustomerID`

/* joinging for the Indemnitor*/
Left join `ppdb`.`payplans_has_customers` PCI
	on `payplans`.`PayPlanID` = `PCI`.`PayPlans_PayPlanID`
left join `ppdb`.`customers` I
	on `I`.`CustomerID` = `PCI`.`Customers_CustomerID`
	

where 
/* make sure that it doesn't show payplans multiple times for each customer, only the first customer*/
	case 
		when 
			(Select count(*)
			from `ppdb`.`payplans_has_customers`
			where `payplans_has_customers`.`PayPlans_PayPlanID` = `payplans`.`PayPlanID`) > 1
		then
			`payplans_has_customers`.`Defendant` = '1' and
		 	`PCI`.`Defendant` = '0'
		else
			`payplans_has_customers`.`Defendant` = '1' and
			`PCI`.`Defendant` = '1'
		end
where### ;

