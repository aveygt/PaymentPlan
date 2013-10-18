<div class="PayPlansList" id="ListOver90">
<?php 
		$PayPlanList = new clsQueryTable;
	$ListTitle = "All Collections Plans (Over 90 Days)";
	
	$Condition = 'and  DATEDIFF(CURDATE() , `payplans`.`CreationDate`) > 90 ';
	
	//set the location of the Excel Sheet
	$ExcelName = 'Over90.xlsx';
	
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
	$PayPlanList->Hidecol('Past Due CSS ID');
	$PayPlanList->SetColCellID('Past Due','Past Due CSS ID');
	$PayPlanList->SetColumnLink('Defendant',$HomeURL."?page=/PaymentPlans/Report.php&ID=###",'ID','Invisible');
	$PayPlanList->ShowTable();
	unset($PayPlanList);
	
	$PPExcel = new clsQueryExcel();
	$PPExcel->SetQuery($PPLQuery)
			->SetTitle($ListTitle)
			->Hidecol('ID')
			->Hidecol('Agent  ID')
			->Hidecol('Past Due CSS ID')
			->CreateSheet("Delinquent Plans");
		
		
	$PPExcel->CQEActiveSheet(0)	
			->SaveWorkBook($ExcelLocation);
		
	unset($PPExcel);
?> 
</div>