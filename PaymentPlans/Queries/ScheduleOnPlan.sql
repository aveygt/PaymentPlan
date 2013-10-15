		SELECT  `paymentschedules`.`ScheduleID` as 'Schedule ID',
		`paymentschedules`.`FKSchedulePayPlanID` as 'Pay Plan ID',
		/* `paymentschedules`.`FKScheduleBondID` as 'Bond ID',*/
		/* concat(`bonds`.`FKBondPrefix`,' ',`bonds`.`PowerNumber`) as 'Bond',*/
		Date_Format(`paymentschedules`.`DueDate`,'%c/%d/%y') as 'Due Date',
		DATE_FORMAT(`paymentschedules`.`DueDate`, '%Y-%m-%d') as 'Order DDate',
		/* `paymentschedules`.`SuspendedDate` as 'Suspended Date',*/
		/* `paymentschedules`.`RecordDate` as 'Record Date',*/
		`paymentschedules`.`Amount` as 'Due',

		/* find the amount past due*/
		case 
			when (ifnull((	select sum(`DTD`.`Amount`) /* the sum of all that was due before now*/
					from `paymentschedules` as `DTD`
					where `DTD`.`FKSchedulePayPlanID` =`paymentschedules`.`FKSchedulePayPlanID`
						and `DTD`.`DueDate` < `paymentschedules`.`DueDate`
				),0) - ifnull((
					SELECT sum(Credit) /* the sum of all the payments made before now*/
					FROM ppdb.vwledgeronplan
					where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
						and `vwledgeronplan`.`Date` < `paymentschedules`.`DueDate` 
				),0)) > 0 
				then (ifnull((	select sum(`DTD`.`Amount`) /* the sum of all that was due before now*/
						from `paymentschedules` as `DTD`
						where `DTD`.`FKSchedulePayPlanID` =`paymentschedules`.`FKSchedulePayPlanID`
							and `DTD`.`DueDate` < `paymentschedules`.`DueDate`
					),0) - ifnull((
						SELECT sum(Credit) /* the sum of all the payments made before now*/
						FROM ppdb.vwledgeronplan
						where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
							and `vwledgeronplan`.`Date` < `paymentschedules`.`DueDate` 
					),0))
			else  null
		end as 'Past Due',

		case 
			when (ifnull((	select sum(`DTD`.`Amount`) /* the sum of all that was due before now*/
						from `paymentschedules` as `DTD`
						where `DTD`.`FKSchedulePayPlanID` =`paymentschedules`.`FKSchedulePayPlanID`
							and `DTD`.`DueDate` < `paymentschedules`.`DueDate`
					),0) - ifnull((
						SELECT sum(Credit) /* the sum of all the payments made before now*/
						FROM ppdb.vwledgeronplan
						where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
							and `vwledgeronplan`.`Date` < `paymentschedules`.`DueDate` 
					),0)) >= `paymentschedules`.`Amount` 
				then  'red'
			when (ifnull((	select sum(`DTD`.`Amount`) /* the sum of all that was due before now*/
						from `paymentschedules` as `DTD`
						where `DTD`.`FKSchedulePayPlanID` =`paymentschedules`.`FKSchedulePayPlanID`
							and `DTD`.`DueDate` < `paymentschedules`.`DueDate`
					),0) - ifnull((
						SELECT sum(Credit) /* the sum of all the payments made before now*/
						FROM ppdb.vwledgeronplan
						where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
							and `vwledgeronplan`.`Date` < `paymentschedules`.`DueDate` 
					),0)) > 0 then 'yellow'
			else 'green'
		end as 'Past Due CSS ID',




		(/*-- adds up all credits made between the previous scheduled date and the current scheduled date*/
			SELECT sum(Credit) 
			FROM ppdb.vwledgeronplan
			where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
				and `vwledgeronplan`.`Date` <= `paymentschedules`.`DueDate`
				and `vwledgeronplan`.`Date` > (ifnull(  /* this selects the previouse due date, if there is none it selects the creation date*/
												(SELECT max(`PrevSched`.`DueDate`) /* the previouse due date*/
												from `paymentschedules` as `PrevSched`
												where `PrevSched`.`FKSchedulePayPlanID` = `paymentschedules`.`FKSchedulePayPlanID`
													and `PrevSched`.`DueDate` < `paymentschedules`.`DueDate`
												), DATE_SUB((SELECT `vwpayplansimple`.`Creation Date` /* the creation date*/
													FROM `vwpayplansimple`
													where `vwpayplansimple`.`ID`= `paymentschedules`.`FKSchedulePayPlanID`
												),INTERVAL 1 DAY))
											)
		)	 as 'Paid',
	/* select the sum of all payments due up to current date*/
	/*	(	select sum(`DTD`.`Amount`) -- do not need
			from `paymentschedules` as `DTD`
			where `DTD`.`FKSchedulePayPlanID` =`paymentschedules`.`FKSchedulePayPlanID`
				and `DTD`.`DueDate` <= `paymentschedules`.`DueDate`
		)	as 'Due To Date', */

	/*	(	SELECT sum(Credit) -- doesn't work
			FROM ppdb.vwledgeronplan
			where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
				and `vwledgeronplan`.`Date` <= `paymentschedules`.`DueDate` 
		)	as 'Paid To Date', */


		(ifnull((select sum(`Debit`) /*sum of all debit in the ledger*/
		from `vwledgeronplan`
		where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
			and `vwledgeronplan`.`Date` <= `paymentschedules`.`DueDate` ),0) 
		- ifnull((select sum(`Credit`) /* sum of all debit in the ledger*/
		from `vwledgeronplan`
		where `vwledgeronplan`.`Pay Plan ID` = `paymentschedules`.`FKSchedulePayPlanID`
			and `vwledgeronplan`.`Date` <= `paymentschedules`.`DueDate` ),0) )			
		as 'Balance',

		case `paymentschedules`.`IsAutoPay`
			when 1 then '[X]'
			when 0 then '[_]'
		end as 'Auto CC',
		case 
			when `paymentschedules`.`DueDate` < CURDATE() then
				'Past'
			when `paymentschedules`.`DueDate` = (select	`PPFMK`.`DueDate` /* the next date on the schedule*/
												from 	`paymentschedules` as `PPFMK`
												where 	`PPFMK`.`FKSchedulePayPlanID` =`paymentschedules`.`FKSchedulePayPlanID`
													and `PPFMK`.`DueDate` >= CURDATE()
												order by `PPFMK`.`DueDate`
												Limit 1) then 
				'Present'
			else 'Future' 
		end as 'PPF Mark',
		'delete' as 'delete'
	FROM `ppdb`.`paymentschedules`
	left join `ppdb`.`bonds`
		on `paymentschedules`.`FKScheduleBondID` = `bonds`.`BondiD`
	Where `paymentschedules`.`FKSchedulePayPlanID` = ### order by DATE_FORMAT(`paymentschedules`.`DueDate`, '%Y-%m-%d');