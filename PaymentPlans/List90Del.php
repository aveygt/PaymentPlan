<div class="PayPlansList" id="List90Del">
<?php 
	echo "</br><a href='".$HomeURL."/ExcelWorkBooks/List90Del.xls'> download the excel sheet</a>";

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
	
	$PPExcel = new clsQueryExcel();
	$PPExcel->GenBook();
	unset($PPExcel);
?> 

</div>