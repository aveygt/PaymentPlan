<?php

		$PonPForm = new clsForm(
			'',
			"/PaymentPlans/ListNew.php",
			'call PrcPayPlanCustomerAdd(`FnPayPlanAdd`("**createdate**",null,null,7,null,null,"**agent**",null,null,null,null),FnCustomerAdd("New","Customer",null,null,null,null,null,null,null),1);',
			'POST',
			'Add New Payment Plan',
			'Hide',
			'Payment Plan Added'
		);
		$PonPForm->DateIn("createdate","Creation Date");
		echo "</br>";/*
		$PonPForm->Currency("startbal","Start Balance","Balance when plan created");
		echo "</br>";
		$PonPForm->Currency("payment","Payment Amount","Amount paid in each installment");
		echo "</br>";
		$PonPForm->QueryDropDown('freq','Frequency',"SELECT `frequency`.`FrequencyID` as 'ID', `frequency`.`Frequency` as 'Frequency' FROM `ppdb`.`frequency`;", "Frequency");
		echo "</br>";
		$PonPForm->Currency("olddebt","Old Debt","Any Old Debt not included in the payplan");
		echo "</br>";*/
		$PonPForm->QueryDropDown('agent','Agent','SELECT * FROM ppdb.vwagentlist;', "Agent");
		echo "</br>";/*
		$PonPForm->DateIn("startdate","Start Date");
		echo "</br>";
		$PonPForm->CheckBox('Financed','1','Fincanced');
		echo "</br>";
		$PonPForm->TextArea('othConditions','Other Conditions','40','5');
		echo"</br>";*/
		$PonPForm->SubmitButton('Create New PayPlan');
		echo "</br>";
		unset($PonPForm);
?>