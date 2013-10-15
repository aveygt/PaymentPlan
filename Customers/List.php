<?php
	$CList = new clsQueryTable;
	$CList->SetTitle("Customers");
	$CListQuery= 'Select * from `ppdb`.`vwcustomerlist` order by `Name`';
	$CList->SetTable("`ppdb`.`vwcustomerlist`",'',$CListQuery);
	$AddLink = $HomeURL.'?page=/Customers/Report.php&ID=###';
	$CList->SetColumnLink('Name',$AddLink,'CustomerID');
	$CList->Hidecol('CustomerID');
	$CList->ShowTable();
?>