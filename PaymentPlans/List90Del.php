<div class="PayPlansList" id="List90Del">
<?php 

	$PayPlanList = new clsQueryTable;
	$ListTitle = "Delinquent Plans Under 90 Days";
	
	$Condition = 'and  DATEDIFF(CURDATE() , `payplans`.`CreationDate`) <= 90 and ifnull((	select sum(`DTD`.`Amount`) /* the sum of all that was due before now*/
		from `paymentschedules` as `DTD`
		where `DTD`.`FKSchedulePayPlanID` =`payplans`.`PayPlanID`
			and `DTD`.`DueDate` < CurDate()
	),0) - ifnull((
		SELECT sum(Credit) /* the sum of all the payments made before now*/
		FROM ppdb.vwledgeronplan
		where `vwledgeronplan`.`Pay Plan ID` = `payplans`.`PayPlanID`
			and `vwledgeronplan`.`Date` <=CURDATE()
	),0) > 0';
	
	//set the location of the Excel Sheet
	$ExcelName = '90Delinquent.xlsx';
	
		// catch the agent ID
	if (isset($_GET['agent'])){
		$replace = $Condition." and `agents`.`AgentID` = ".$_GET['agent'];
		
		//figure out the agent name
		$Agent = GetQuery("SELECT concat(`agents`.`LastName`,', ',`agents`.`FirstName`) as 'name', `Initials` as 'IN' FROM `ppdb`.`agents` where AgentID = ".$_GET['agent'].";");
		$AgentName = $Agent->fetch_assoc();
		$ListTitle = $ListTitle." : ".$AgentName['name'];
		
		//set the name of the excel sheet
		$ExcelName = $AgentName['IN'].$ExcelName;
	} else {
		$replace = $Condition;
	}
	
	$ExcelLocation = $BaseDir.'\ExcelWorkBooks\\'.$ExcelName;
	$ExcelUrl = $HomeURL.'/ExcelWorkBooks/'.$ExcelName;
	
	echo "</br><a href='".$ExcelUrl."'> Download excel Workbook</a>";	
	
	$PayPlanList->SetTitle($ListTitle);
	$PPLQuery= str_replace('where###',$replace,file_get_contents($BaseDir.'\PaymentPlans\Queries\PaymentPlanList.sql'));
	
	$PayPlanList->SetTablei($PPLQuery);
	$PayPlanList->Hidecol('Agent ID');
	$PayPlanList->Hidecol('Def Address 1');
	$PayPlanList->Hidecol('Def Address 2');
	$PayPlanList->Hidecol('Def City');
	$PayPlanList->Hidecol('Def State');
	$PayPlanList->Hidecol('Def Zip Code');
	$PayPlanList->Hidecol('Ind Address 1');
	$PayPlanList->Hidecol('Ind Address 2');
	$PayPlanList->Hidecol('Ind City');
	$PayPlanList->Hidecol('Ind State');
	$PayPlanList->Hidecol('Past Due CSS ID');
	$PayPlanList->SetColCellID('Past Due','Past Due CSS ID');
	$PayPlanList->Hidecol('Ind Zip Code');	
	$PayPlanList->SetColumnLink('Defendant',$HomeURL."?page=/PaymentPlans/Report.php&ID=###",'ID','Invisible');
	$PayPlanList->ShowTable();
	unset($PayPlanList);
	
	$PPExcel = new clsQueryExcel();
	$PPExcel->SetQuery($PPLQuery)
			->SetTitle($ListTitle)
			->Hidecol('ID')
			->Hidecol('Agent  ID')
			->Hidecol('Def Address 1')
			->Hidecol('Def Address 2')
			->Hidecol('Def City')
			->Hidecol('Def State')
			->Hidecol('Def Zip Code')
			->Hidecol('Ind Address 1')
			->Hidecol('Ind Address 2')
			->Hidecol('Ind City')
			->Hidecol('Ind State')
			->Hidecol('Past Due CSS ID')
			->Hidecol('Ind Zip Code')
			->CreateSheet("Delinquent Plans");
		
		
	$PPExcel->SetActiveSheetIndex(0)	
			->SaveWorkBook($ExcelLocation);
		
	unset($PPExcel);
?> 

</div>