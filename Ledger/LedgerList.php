<?php

	$LedgerEntry = new clsForm;
	
	$LedgerEntry->ShowForm();
	unset($LedgerEntry);
	

	$LedgerList = new clsQueryTable;

	$LedgerList->SetTable("`ppdb`.`vwledger`");
	$LedgerList->ShowTable();
	unset($LedgerList);
?>