

<?php
	$BList = new clsQueryTable;
	$BList->SetTitle("Bonds");
	$BListQuery = 'Select * from `ppdb`.`vwbonds` order by `Power Number`;';
	$BList->SetTable("`ppdb`.`vwbonds`",'',$BListQuery);
	$AddLink = $HomeURL."?page=/Bonds/BondReport.php&ID=###";
	$BList->SetColumnLink('Power Number',$AddLink,'Bond ID');
	$BList->Hidecol('Bond ID');
	$BList->Hidecol('Office ID');
	$BList->Hidecol('Agent ID');
	$BList->ShowTable();
?>
