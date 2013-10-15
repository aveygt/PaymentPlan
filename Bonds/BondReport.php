

<?php
	$ID = $_GET['ID'];
	//echo "Bond ID: ".$ID;
	echo "<div class='PPReport' id='Everything'>";

	echo "<div id='lower'>";
	$BReport = new clsQueryTable;
	$BReport->SetTitle("Bonds");
	$BReportQuery = 'Select * from `ppdb`.`vwbonds` where `Bond ID` ='.$ID.';';
	$BReport->SetTable("`ppdb`.`vwbonds`",'',$BReportQuery);
	$BReport->Hidecol('Agent ID');
	$BReport->Hidecol('Office ID');
	$BReport->Hidecol('Bond ID');
	$BReport->ShowTable();
	unset($BReport);
	
	$LonB = new clsQueryTable;
	$LonB->SetTitle("Ledger");
	$LonB->SetTable("`ppdb`.`vwledger`","`Bond ID` = '".$ID."'");
	$LOPLink = $HomeURL.'?page=/Bonds/BondReport.php&ID='.$ID.'&Submit=get&Query=call%20PrcLedgerEntryDelete("###");&Confirm=Schedule%20Deleted#LedgerAnchor';
	$LonB->SetColumnLink('Delete',$LOPLink,'Entry ID');
	$LonB->Hidecol('Bond ID');
	$LonB->Hidecol('ID');
	$LonB->ShowTable();
				//the form to add a payment Ledger Entry
				$NLForm = new clsForm(
					'',
					"/PaymentPlans/Report.php&ID=".$ID,
					'call PrcAddLedgerEntry("**bond**","**date**","**amount**","**debcred**","**desc**");',
					'post',			
					'Add Entry',
					'Hide',
					'Ledger Entry Made'
				);
				$NLForm->DateIn("date","Date");
				echo "</br>";
				//define the query to get the bonds list
				$Query = 'SELECT 	`vwbondonplan`.`Bond ID`,
									`vwbondonplan`.`Power Number`
						FROM `ppdb`.`vwbondonplan`
						where `vwbondonplan`.`Pay Plan ID` = '.$ID.';';
				$NLForm->QueryDropDown('bond','Bond',$Query);
				echo "</br>";
				$NLForm->Currency('amount','Amount');
				echo"</br>";
				
					$NLRadioArr['Debit'] = 'Debit';
					$NLRadioArr['Credit'] = 'Credit';
				$NLForm->Radio('debcred','',$NLRadioArr, 'Credit');
				$NLForm->TextArea('desc','Description','40','1','Payment');
				echo "</br>";
				$NLForm->SubmitButton('Add Entry');
				unset($NLForm);
	unset($LonB);
	
	$PonB = new clsQueryTable;
	$PonB->SetTitle("Pay Plans");
	$PonBQuery = 'Select * from `ppdb`.`vwplansonbond` where `Bond ID` = "'.$ID.'";';
	$PonB->SetTable("`ppdb`.`vwplansonbond`",'',$PonBQuery);
	$PonBLin = $HomeURL.'?page=/PaymentPlans/Report.php&ID=###';
	$PonB->SetColumnLink('Creation Date',$PonBLin,'Pay Plan ID');
	$PonB->Hidecol('Bond ID');
	$PonB->Hidecol('Pay Plan ID');
	$PonB->Hidecol('ID');
	$PonB->ShowTable();
	unset($PonB);
	echo "</div>";
	echo "</div>";

?>
