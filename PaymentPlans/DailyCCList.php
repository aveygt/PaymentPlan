<h1>CCLIST </h1>

<?php

	$CCQuery = 'call prcsetcclistdate("**date**");';
	//echo $CCQuery;
				$CCList = new clsForm(
					'', // action
					'/PaymentPlans/DailyCCList.php', // ?page=
					$CCQuery, //the quiery to be run
					'POST',			//what method to send to server
					'Set Date', //title of form
					'Hide', //ithe tag of the form
					'Date Changed' //the confirmation message
					);
					$CCList->DateIn('date','Date',date("Y-m-d"));
					echo "</br>";
					$CCList->SubmitButton('Change Date');
					
	$PayPlanList = new clsQueryTable;
	$PayPlanList->SetTitle("CC Due List");
	$PayPlanList->SetTable("`ppdb`.`vwccduelist`");
	$PayPlanList->hidecol('PayPlanID');
	$PayPlanList->SetColumnLink('Customer',$HomeURL."?page=/PaymentPlans/Report.php&ID=###",'PayPlanID','Invisible');
	$PayPlanList->ShowTable();
	unset($PayPlanList);
	
	unset($CCList);
?>