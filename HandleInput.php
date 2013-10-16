<?php
//check if there was a submision
//
if (isset($_GET['Submit'])){
	$InputCont = 'go' ;	
	
	//if you are sending a file you will need to send a get variable named File
	//		this variable will need to be set to the name of the File sent.
	//
	if (isset($_POST['File'])) {	
		$FilesInHand = $_POST['File'];
		//handles error if there is an error it tells the rest of file to stop and outputs an error
		foreach ($FilesInHand as $Name => $Location){
		
			//check for errors
			if ($_FILES[$Name] ["error"] > 0)
			{
				echo "<span class='alert red' >";
					echo "Error: ".$_FILES[$Name];
				echo "</span>";
				$InputCont = 'stop';
			} else {
				//echo "SUCCESS!!!</br>";
			
				//tget the extension
				$Path_Parts = pathinfo($_FILES[$Name]["name"]);
				$ext = $Path_Parts['extension'];
				
				$InputCont = 'go';				
				
				//save the file
				move_uploaded_file($_FILES[$Name]["tmp_name"],$Location.$Name.'.'.$ext);
				$_POST[$Name] = $Name.'.'.$ext;
			}			
		}
		//uset the  array so the next part doesn't give any errors
		unset($_POST['File']);
	}
	
	//if told to go continue calculating
	if ($InputCont == 'go'){
			$Query = $_GET['Query'];
			//echo $Query;
			if ($Query=='ImportQuery'){
				$Query = "
	delete from loadednewplans;
	
	LOAD DATA LOCAL INFILE 'C:\\\wamp\\\www\\\PaymentPlan\\\Import\\\importfile.csv' INTO TABLE ppdb.loadednewplans 	
	FIELDS TERMINATED BY ',' 	
	ENCLOSED BY '".'"'."' 	
	ignore 1 lines	
	(CLastName,CFirstName,Caddress1,Caddress2,CCity,CState,CZipCode,CPhone,@VarDateExe,Alpha_pre,Power,Bl_due,Agent,ILastName,IFirstName,IAddress1,IAddress2,ICity,IState,IZipCode,IPhone)	
	set DateExe = STR_TO_DATE(@VarDateExe,'%m/%d/%Y');";	

				GetQuery($Query);
				$Query = "call prcpayplanimport('1');";	
			}
			
				if($Query <> null){
				foreach ($_POST  as $Key => $Value)
				{
					//echo '</br>';
					//echo $Key.' = '.$Value;
					$Query = str_replace('**'.$Key.'**',$Value, $Query);
					//echo '</br>'.$Query;
				}	
				

				echo "<span class='alert green' >".$Query."</span>";

				GetQuery($Query);

				
				//if it was passed a confirmation message it shows that, otherwise it does a standard one
				echo "<span class='alert green' >";
				if (isset($_GET['Confirm'])){
					echo $_GET['Confirm'];
				} else {
				
					echo 'Query "'.$Query.'" executed';
				}
				echo "</span>";
			}
	}




	
}
?>