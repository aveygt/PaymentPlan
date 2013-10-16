
<?php
	$ID = $_GET['ID'];
	
	echo "<h1>Viewing PayPlan ID:".$ID."</h1>";
	
	echo "<div class='PPReport' id='Everything'>";

		echo "<div id='top'>";
			echo "<div id='topleft'>";
				//Payment Plan info
				$PlanOnPlan = new clsQueryTable;
				$PlanOnPlan->SetTitle("Payment Plan ");
				$PlanOnPlan->SetTable("`ppdb`.`vwpayplansimple`","`ID` = '".$ID."'");
				$PlanOnPlan->SetColumnLink('Scan',$HomeURL."PPScans/###",'Scan Location','Invisible',"'popup','width=500,height=600,resizable=yes,directories=no,toolbar=no,location=no,menubar=no,status=no,left=0,top=0'");
				$PlanOnPlan->Hidecol('Freq ID');
				$PlanOnPlan->Hidecol('Agent ID');
				$PlanOnPlan->Hidecol('ID');
				$PlanOnPlan->Hidecol('Scan Location');
				$PlanOnPlan->Hidecol('susp');
				$PlanOnPlan->ShowTable();
				
					$PonPResults = GetQuery("SELECT * FROM ppdb.vwpayplansimple where `ID` = '".$ID."';");
					$PonPDefaults = $PonPResults->fetch_assoc();
					$PonPForm = new clsForm(
						'',
						"/PaymentPlans/Report.php&ID=".$ID,
						'call PrcPayPlanMod("'.$ID.'","**createdate**","**startbal**","**payment**","**freq**","**startdate**","**othConditions**","**agent**","'.$PonPDefaults['Scan Location'].'","**olddebt**","**Financed**","**BadDebt**");',
						'POST',
						'Modify Payment Plan',
						'Hide',
						'Payment Plan Updated'
					);
					$PonPForm->DateIn("createdate","Creation Date",$PonPDefaults['Creation Date']);
					echo "</br>";
					$PonPForm->Currency("startbal","Start Balance","Balance when plan created",$PonPDefaults['Start Bal']);
					echo "</br>";
					$PonPForm->Currency("payment","Payment Amount","Amount paid in each installment",$PonPDefaults['Pay Amount']);
					echo "</br>";
					$PonPForm->Currency("olddebt","Old Debt","Any Old Debt not included in the payplan",$PonPDefaults['Old Debt']);
					echo "</br>";
					$PonPForm->QueryDropDown('agent','Agent','SELECT * FROM ppdb.vwagentlist;', "Agent", $PonPDefaults['Agent ID']);
					echo "</br>";
					$PonPForm->DateIn("startdate","Start Date",$PonPDefaults['Start Date']);
					echo "</br>";
					$PonPForm->QueryDropDown('freq','Frequency',"SELECT `frequency`.`FrequencyID` as 'ID', `frequency`.`Frequency` as 'Frequency' FROM `ppdb`.`frequency`;", "Frequency", $PonPDefaults['Freq ID']);
					echo "</br>";
					$PonPForm->CheckBox('Financed','1','Fincanced',$PonPDefaults['Financed']);
					echo "</br>";
					$PonPForm->CheckBox('BadDebt','1','Bad Debt',$PonPDefaults['Bad Debt']);
					echo "</br>";
					$PonPForm->TextArea('othConditions','Other Conditions','40','5',$PonPDefaults['Other Conditions']);
					echo"</br>";
					$PonPForm->SubmitButton('Submit Changes');
					unset($PonPForm);

					//the form to upload the scan
					$PonPScanForm = new clsForm(
						'',
						"/PaymentPlans/Report.php&ID=".$ID,
						'call PrcPayPlanMod("'.$ID.'","'.$PonPDefaults['Creation Date'].'","'.$PonPDefaults['Start Bal'].'","'.$PonPDefaults['Pay Amount'].'","'.$PonPDefaults['Freq ID'].'","'.$PonPDefaults['Start Date'].'","'.$PonPDefaults['Other Conditions'].'","'.$PonPDefaults['Agent ID'].'","**scan'.$ID.'**","'.$PonPDefaults['Financed'].'","'.$PonPDefaults['Bad Debt'].'","'.$PonPDefaults["Old Debt"].'");',
						'POST',
						'',
						'Hide',
						'Scan Uploaded',
						'enctype="multipart/form-data"'
					);
					$PonPScanForm->FileUp('scan'.$ID,'Payment Plan Scan',$BaseDir.'\\PPScans\\');
					echo "</br>";
					$PonPScanForm->SubmitButton('Upload Scan');
					unset($PonPScanForm);
					
				unset($PlanOnPlan);
				echo "<br />";

				//Customers on Plan
				$CustOnPlan = new clsQueryTable;
				$CustOnPlan->SetTitle("Customers");
				$CustOnPlan->SetTable("`ppdb`.`vwcustomeronplan`","`Pay Plan ID` = '".$ID."'");
				$CustOnPlan->SetColumnLink('First Name',$HomeURL."?page=/Customers/Report.php&ID=###",'Customer ID','Invisible');
				$RmvLink = $HomeURL.'?page=/PaymentPlans/Report.php&ID='.$ID."&Submit=get&Query=call%20PrcPayPlanCustomerDelete('".$ID."','###');&Confirm=Schedule%20Deleted#ScheduleAnchor";
				$CustOnPlan->SetColumnLink('Remove',$RmvLink,'Customer ID','Invisible');
				$CustOnPlan->Hidecol('Pay Plan ID');
				$CustOnPlan->ShowTable();
				
					$CustOnPlanForm = new clsForm(
					'',
					"/PaymentPlans/Report.php&ID=".$ID,
					'call PrcPayPlanCustomerAdd('.$ID.',FnCustomerAdd("New","Customer",null,null,null,null,null,null,null),0);', //the quiery to be run
					'POST',			//what method to send to server
					'Change Customer', //title of form
					'Hide', //ithe tag of the form
					'Ledger Entry Made' //the confirmation message
					);
					$CustOnPlanForm->SubmitButton('Add New Customer');
					unset($CustOnPlanForm);
					
					$CustDefForm = new clsForm(
					'',
					"/PaymentPlans/Report.php&ID=".$ID,
					'call PrcSetCustomerDefendant('.$ID.',**customer**)',
					'POST',			
					'',
					'Hide',
					'Ledger Entry Made'
					);
					$CDFQuery = 'SELECT * FROM ppdb.vwCustomerOnPlanList where `Pay Plan ID` = '.$ID.';';
					$CustDefForm->QueryDropDown('customer','Customer',$CDFQuery, "Agent", $PonPDefaults['Agent ID']);
					$CustDefForm->SubmitButton('Set Defendant');
					unset($CustDefForm);
					
					$AddExCust = new clsForm(
					'',
					"/Customers/AddCustomerList.php&ID=".$ID,
					'',
					'POST',			
					'',
					'Hide',
					''
					);
					$AddExCust->SubmitButton('Add Existing Customer');
					unset($AddExCust);
				
				unset($CustOnPlan);
			echo "</div>";
			
			echo "<div id='topright'>";
				//the bonds
				$BondOnPlan = new clsQueryTable;
				$BondOnPlan->SetTitle("Bonds");
				$BondOnPlan->SetTable("`ppdb`.`vwbondonplan`","`Pay Plan ID` = '".$ID."'");
				$BOPUrl = $HomeURL.'?page=/PaymentPlans/Report.php&ID='.$ID."&Submit=get&Query=call%20PrcPayPlanBondDelete('".$ID."','###');&Confirm=Schedule%20Deleted";
				$BondOnPlan->SetColumnLink('Remove',$BOPUrl,'Bond ID');
				$BondOnPlan->Hidecol('Pay Plan ID');
				$BondOnPlan->Hidecol('Bond ID');
				$BondOnPlan->Hidecol('Agent ID');
				$BondOnPlan->Hidecol('Office ID');
				$BondOnPlan->ShowTable();
				
					$AddExCust = new clsForm(
					'',
					"/Bonds/PPBondAddList.php&ID=".$ID,
					'',
					'POST',			
					'Add Bond',
					'Hide',
					''
					);
					$AddExCust->SubmitButton('Add Existing Bond');
					unset($AddExCust);
				
				$BOP = new clsForm(
					'',
					"/PaymentPlans/Report.php&ID=".$ID,
					'call PrcPayPlanBondAdd('.$ID.',FnBondAdd("**prefix**","**number**","**agent**","**office**","**execution**","**begbal**"));',
					'post',			
					'',
					'Hide',
					'New Bond Created and Added'
				);
				$Query = 'SELECT * FROM ppdb.vwprefixlist;';
				$BOP->QueryDropDown('prefix','Power',$Query);
				$BOP->TextField('number','');
				echo "</br>";
				$BOP->DateIn("execution","Exec Date");
				echo "</br>";
				$BOP->QueryDropDown('agent','Agent','SELECT * FROM ppdb.vwagentlist;', "Agent", $PonPDefaults['Agent ID']);
				echo "</br>";
					$BOPRadioArr['1'] = 'Orlando';
					$BOPRadioArr['2'] = 'Brevard';
				$BOP->Radio('office','Office: </br>',$BOPRadioArr, 1,'Side');
				echo "</br>";
				$BOP->Currency('begbal','Beginning Balance');
				echo"</br>";
				$BOP->SubmitButton('Add New Bond');
				unset($BOP);
				
				
				
				
				unset($BondOnPlan);
			echo "</div>";
		echo "</div>";
		
		echo "<div id='lower'>";
		echo "<a name='LedgerAnchor'>";
			//ledger on plan with included form
			$LedgerOnPlan = new clsQueryTable;
			$LedgerOnPlan->SetTitle("Ledger");
			$LedgerOnPlan->SetTable("`ppdb`.`vwledgeronplan`","`Pay Plan ID` = '".$ID."'");
			$LOPLink = $HomeURL.'?page=/PaymentPlans/Report.php&ID='.$ID."&Submit=get&Query=call%20PrcLedgerEntryDelete('###');&Confirm=Schedule%20Deleted#LedgerAnchor";
			$LedgerOnPlan->SetColumnLink('Delete',$LOPLink,'Entry ID');
			$LedgerOnPlan->Hidecol('Pay Plan ID');
			$LedgerOnPlan->Hidecol('Bond ID');
			$LedgerOnPlan->Hidecol('Entry ID');
			$LedgerOnPlan->Hidecol('Financed');
			$LedgerOnPlan->ShowTable();
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
			unset($LedgerOnPlan);
			echo "</a>";
			
			
			//payment schedule table and form
			echo "<a name='ScheduleAnchor'>";
			$PaymentSchedule = new clsQueryTable;
			$PaymentSchedule->SetTitle("Payment Schedule");
			$PaySchedQuery= str_replace('###',$ID,file_get_contents($BaseDir.'\PaymentPlans\Queries\ScheduleOnPlan.sql'));
			//echo $PaySchedQuery;
			$PaymentSchedule->SetTablei($PaySchedQuery);
			$PSLink = $HomeURL."?page=/PaymentPlans/Report.php&ID=".$ID."&Submit=get&Query=call%20PrcPayScheduleDelete('###');&Confirm=Schedule%20Deleted#ScheduleAnchor";
			$PaymentSchedule->SetColumnLink('delete',$PSLink,'Schedule ID','Invisible');
			//$PSLink =$HomeURL.'?page=/PaymentPlans/Report.php&ID='.$ID.'&Submit=get&Query=call%20PrcScheduleAutoCCSwitch("###");&Confirm=Schedule%20AutoCC%20Set#ScheduleAnchor';
			//$PaymentSchedule->SetColumnLink('Auto CC',$PSLink,'Schedule ID');
			$PaymentSchedule->Hidecol('Order DDate');
			$PaymentSchedule->Hidecol('Pay Plan ID');
			$PaymentSchedule->Hidecol('Bond ID');
			$PaymentSchedule->Hidecol('Schedule ID');
			$PaymentSchedule->Hidecol('Record Date');
			$PaymentSchedule->Hidecol('Suspended Date');
			$PaymentSchedule->Hidecol('Bond');
			$PaymentSchedule->Hidecol('Due To Date');
			$PaymentSchedule->Hidecol('Paid To Date');
			$PaymentSchedule->Hidecol('Past Due CSS ID');
			$PaymentSchedule->Hidecol('PPF Mark');
			$PaymentSchedule->SetColCellID('Past Due','Past Due CSS ID');
			$PaymentSchedule->SetRowID('PPF Mark');
			$PaymentSchedule->ShowTable();
				//the form to add a payment schedule
				$NLForm = new clsForm(
					'',
					"/PaymentPlans/Report.php&ID=".$ID,
					'call PrcPayScheduleAdd(null,"'.$ID.'","**amount**","**duedate**","**AutoCC**");',
					'post',			
					'Add New Schedule',
					'Hide'
				);
				$NLForm->DateIn("duedate","Due Date");
				echo "</br>";
				//define the query to get the bonds list
				$Query = 'SELECT 	`vwbondonplan`.`Bond ID`,
									`vwbondonplan`.`Power Number`
						FROM `ppdb`.`vwbondonplan`
						where `vwbondonplan`.`Pay Plan ID` = '.$ID.';';
				//$NLForm->QueryDropDown('bond','Bond',$Query);
				//echo "</br>";
				$NLForm->Currency('amount','Amount');
				echo "</br>";
				$NLForm->CheckBox('AutoCC','1','Auto CC');
				echo "</br>";
				$NLForm->SubmitButton('Add Schedule');
				unset($NLForm);
				
				//auto generate schedule
				$APSForm = new clsForm(
					'',
					"/PaymentPlans/Report.php&ID=".$ID,
					'call PrcAutoSchedule('.$ID.',"**AutoCC**");',
					'post',			
					'',
					'Hide'
				);
				$APSForm->CheckBox('AutoCC','1','Auto CC');
				echo "</br>";
				$APSForm->SubmitButton('Auto Generate Schedules');
				unset($APSForm);			
			unset($PaymentSchedule);
			echo "</a>";
			
			//comment table and its form
			$CommentsOnPlan = new clsQueryTable;
			$CommentsOnPlan->SetTitle("Comments");
			$CommentsOnPlan->SetTable("`ppdb`.`vwcommentsonplan`","`Pay Plan ID` = '".$ID."'");
			$CommentsOnPlan->Hidecol('Pay Plan ID');
			$CommentsOnPlan->Hidecol('Comment ID');
			$CommentsOnPlan->Hidecol('Agent ID');	
			$CommentsOnPlan->ShowTable();
				//set the form
				$NCForm = new clsForm(
					'',
					"/PaymentPlans/Report.php&ID=".$ID,
					'call PrcPayPlanCommentAdd("'.$ID.'","**date**","**agent**","**comment**");',
					'post',
					'Add New Comment',
					'Hide'
				);
				$NCForm->DateIn("date","Date");
				echo "</br>";
				$NCForm->QueryDropDown('agent','Agent','SELECT * FROM ppdb.vwagentlist;');
				echo "</br>";
				$NCForm->TextArea('comment','Comment');
				echo "</br>";
				$NCForm->SubmitButton('Add Comment');
				unset($NCForm);
			unset($CommentsOnPlan);
		echo "</div>";
	echo "</div>";
?>
