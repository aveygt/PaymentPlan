<?php

class clsUL
{
	public function __construct($class = 'clsUL'){
		echo "<ul class='".$class."'>";
	}
	
	public function __destruct(){
		echo "</ul>";
	}
	
	public function CreateListFromQuery($Query,$Contents){
		//run query
		$QList = GetQuery($Query);
		
		//go add a list for each row returned
		while ($row = $QList->fetch_assoc()){
			$Output = $Contents;
			foreach($row as $key => $record){
				$Output = str_replace("**".$key."**", $record,$Output);
				//echo "<pre>".$Output."</pre>";
			}
			echo "<li>".$Output."</li>";
		}
	}





}

?>