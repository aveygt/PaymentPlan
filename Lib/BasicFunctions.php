<?php
	//returns array with ID as key and value from the output of sql
	function GetQuery($Query){
		global $DBServer, $DBUserName, $DBPassword, $DBSchema;
		//echo 'getquery called<br />';
		
		$mysqli =  new mysqli($DBServer, $DBUserName, $DBPassword, $DBSchema);
		
		if (mysqli_connect_errno()) {
			echo 'connction failed<br />';
			exit('Connect failed: '. mysqli_connect_error());
		}
		//echo "</br><span class=' alert green''>".$Query."</span></br>";

		$Result = $mysqli->query($Query) or die($mysqli->error.__LINE__);
		
		$mysqli->close();
		
		return $Result;
	}	
?>
