<h1>Viewing Customer ID:


<?php
	$ID = $_GET['ID'];
	echo $ID;
?>
</h1>
<div class='CustReport' id = 'Everything'>
<div id="top">
<?php
		$CustResults = GetQuery("SELECT * FROM ppdb.customers where `CustomerID` = '".$ID."';");
		$CustVal = $CustResults->fetch_assoc();
		$CustForm = new clsForm(
							'',
							"/Customers/Report.php&ID=".$ID,
							'call PrcModCustomer('.$ID.',"**FirstName**","**LastName**","**DOB**","**Address1**","**Address2**","**City**","**State**","**ZipCode**","**Phone**");',
							'POST',
							$CustVal['LastName'].', '.$CustVal['FirstName'],
							'Hide',
							'Changes Applied'
						);
			$CustForm->TextField('FirstName','First Name',$CustVal['FirstName']);
				echo "</br>";
			$CustForm->TextField('LastName','Last Name',$CustVal['LastName']);
				echo "</br>";
			$CustForm->DateIn('DOB','D.O.B.',$CustVal['DOB']);
				echo "</br>";
			$CustForm->TextField('Address1','Address Line 1',$CustVal['Address1']);
				echo "</br>";
			$CustForm->TextField('Address2','Address Line 2',$CustVal['Address2']);
				echo "</br>";
			$CustForm->TextField('City','City',$CustVal['City']);
				echo "</br>";
			$CustForm->TextField('State','State',$CustVal['State']);
				echo "</br>";
			$CustForm->TextField('ZipCode','Zip Code',$CustVal['ZipCode']);
				echo "</br>";
			$CustForm->TextField('Phone','Phone Number',$CustVal['PhoneNumber']);
				echo "</br>";
				
			$CustForm->SubmitButton('Submit Changes');
		unset($CustForm);
		
		$PlanOnCust = new clsQueryTable;
		$PlanOnCust->SetTitle("Payment Plan ");
		$PlanOnCust->SetTable("`ppdb`.`vwplanoncustomer`","`CustID` = '".$ID."'");
		$PlanOnCust->SetColumnLink('Plan Date',$HomeURL."?page=/PaymentPlans/Report.php&ID=###",'PayPlanID','Invisible');
		$PlanOnCust->Hidecol('CustID');
		$PlanOnCust->ShowTable();
		unset($PlanOnCust);
		


?>
</div>
</div>