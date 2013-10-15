<?php
	$ID = $_GET['ID'];
	$ABList = new clsQueryTable;
	$ABList->SetTitle("All Payment Plans");
	$ABList->SetTable("`ppdb`.`vwppbondaddlist`");
	$AddLink = $HomeURL.'?page=/PaymentPlans/Report.php&ID='.$ID.'&Submit=get&Query=call%20PrcPayPlanBondAdd("'.$ID.'","###");&Confirm=Customer%20Added';
	$ABList->SetColumnLink('Power Number',$AddLink,'Bond ID');
	$ABList->Hidecol('Agent ID');
	$ABList->Hidecol('Office ID');
	$ABList->Hidecol('Bond ID');
	$ABList->Hidecol('Pay Plan ID');
	$CancelLink = $HomeURL.'?page=/PaymentPlans/Report.php&ID='.$ID;
	$ABList->SetColumnLink('Cancel',$CancelLink,'Cancel');
	$ABList->ShowTable();
?>