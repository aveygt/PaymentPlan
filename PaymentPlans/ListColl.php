<?php 
		$PayPlanList = new clsQueryTable;
	$ListTitle = "All Collections Plans (Over 90 Days)";
	
	$Condition = 'and  DATEDIFF(CURDATE() , `payplans`.`CreationDate`) > 90 ';
	
		// catch the agent ID
	if (isset($_GET['agent'])){
		$replace = $Condition." and `agents`.`AgentID` = ".$_GET['agent'];
		
		$Agent = GetQuery("SELECT concat(`agents`.`LastName`,', ',`agents`.`FirstName`) as 'name' FROM `ppdb`.`agents` where AgentID = ".$_GET['agent'].";");
		$AgentName = $Agent->fetch_assoc();
		$PayPlanList->SetTitle($ListTitle." : ".$AgentName['name']);
	} else {
		$replace = $Condition;
		
		$PayPlanList->SetTitle($ListTitle);
	}
	
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
?> 