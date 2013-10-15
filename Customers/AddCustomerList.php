<?php
	$ID = $_GET['ID'];
	$ACList = new clsQueryTable;
	$ACList->SetTitle("All Payment Plans");
	$ACList->SetTable("`ppdb`.`vwcustomeraddlist`");
	$AddLink = $HomeURL.'?page=/PaymentPlans/Report.php&ID='.$ID.'&Submit=get&Query=call%20PrcPayPlanCustomerAdd("'.$ID.'","###",0);&Confirm=Customer%20Added#ScheduleAnchor';
	$ACList->SetColumnLink('Name',$AddLink,'CustomerID');
	$ACList->Hidecol('CustomerID');
	$CancelLink = $HomeURL.'?page=/PaymentPlans/Report.php&ID='.$ID;
	$ACList->SetColumnLink('Cancel',$CancelLink,'Cancel');
	$ACList->ShowTable();
?>