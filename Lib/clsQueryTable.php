<?php
// this is a class to deal with the payplan  database

class clsquerytable
{
	public	$Link;
	public	$TableData;
	public	$TableHeaders;
	private $HiddenCols = array();
	private $TableTitle;
	private $ArrLinkCol = array();
	private $ArrColCellID = array();
	private $ArrRowID = array();
	
	
	//on construct connect to the database
	public function __construct()
	{

	}
	
	//on destruct close connection to the database
	public function __destruct()
	{
		echo "</div>";
		echo "</div>";
	}
	
	//set a column to be hidden
	public function HideCol($NewHiddenCol){
		$this->HiddenCols[] = $NewHiddenCol;
	}
	
	//this checks if the column given is set for hidden in the $HiddenCol array
	Private function isColHidden($ValCheck)
	{
		$Hidden = false;
		foreach ($this->HiddenCols as $col){
			if ($col == $ValCheck){
				$Hidden = true;
			}
		}
		Return $Hidden;
	}
	
		//figures out if the column is a link 
		// returns the row number of the array if it is
		//returns null if it isn't
	private function IsColLink($col){
		$result = null;
		foreach ($this->ArrLinkCol as $Key => $Row){
			if ($Row['LinkCol'] == $col){
				$result = $Key;
			}
		}
		
		return $result;
	}
	
		//figures out if the column should have an ID 
		// returns the row number of the array if it is
		//returns null if it isn't
	private function IsColID($col){
		$result = null;
		foreach ($this->ArrColCellID as $Key => $Row){
			if ($Row['ColSet'] == $col){
				$result = $Key;
			}
		}
		
		return $result;
	}
	
	public function SetTitle($NewTitle)
	{
		$this->TableTitle = $NewTitle;
	}
	
	//set the table and queries the info
	//gets both the data and headers
	public function SetTable($Table,$Where = null,$InQuery=null)
	{
		if ($Where == null){
			$Query = "SELECT * FROM ".$Table.";";
		}else{
			$Query = "SELECT * FROM ".$Table." Where ".$Where.";";
		}
		
		if(isset($InQuery)){
			$Query=$InQuery;
		}
		
		//echo "<span class=' alert green''>".$Query."</span></br>";
		$this->TableData = GetQuery($Query);
		$this->TableHeaders = GetQuery($Query);
	}
	
	//like SetTable but  using mysqli
	//it just takes a query  input
	public function SetTablei($Query)	
	{
		$this->TableData = GetQuery($Query);
		//print_r($this->TableData);
		$this->TableHeaders = GetQuery($Query);
	}
	
	/*
	$NewRowLink = the row the link will show up in
	$NewURL = the $URL the link will send you see next variable for how string is parced
	$NewLinkRowVar = the value in the row set by this variable replaces '###' in the above string
	$NewLrvVisible = if you want the LinkRowVar column to be visible set this to 'visible' otherwise set it to 'Invisible';
	$popup = if this is not = 'no' then its a jscript pupup with conditions set by the value of $popup
	*/
	public function SetColumnLink($NewRowLink, $NewUrl, $NewLinkRowVar,$NewLrvVisible = "Visible", $popup = "no")
	{

		if ($NewLrvVisible == 'Invisible'){
			$this->HideCol($NewLinkRowVar);		
		}
		
		if ($popup == 'no'){
			$NewUrl = 'href = "'.$NewUrl.'"'; // normal link
		} else {
			$NewUrl = 'href = "'.$NewUrl.'"  onclick="window.open('."'".$NewUrl."',".$popup.'); return false"'; //jscript link
		}
		
		//set the index to the next number 
		$Index = count($this->ArrLinkCol) + 1;
		$this->ArrLinkCol[$Index]	 = 	array( 	"LinkCol" => $NewRowLink,
														"LinkUrl" => $NewUrl,
														"LinkRowVar" => $NewLinkRowVar);
	}		
	
	/*
		sets a cell to have and ID based on what is in the other cell
		$NewColSet = the column whose cells will have their ID set
		$IDCol = the column whose values will be the ID
	*/
	public function SetColCellID($NewColSet, $IDCol)
	{
		//set the index to the next number 
		$Index = count($this->ArrColCellID) + 1;
		$this->ArrColCellID[$Index]	 = 	array( 	"ColSet" => $NewColSet,
														"IDCol" => $IDCol,);
	}

	/* 
		this sets each rows to have an ID based on what the value is in the given column
	*/
	public function SetRowID($NewRow)
	{
		array_push($this->ArrRowID, $NewRow);
	}
	
	
	public function ShowTable()
	{
		
		echo "<div class = 'container Object QueryTable' id='".$this->TableTitle."'>";
		echo "<div class = 'QueryTable Object' id='".$this->TableTitle."'>";
		if (isset($this->TableTitle)){
			echo "<div class = 'Header id='TableTitle'>".$this->TableTitle."</div>";
		}
		echo "<div class = 'Body'>";
		
		if ($this->TableData->num_rows > 0){
			echo "<table border = '1'>";

			//loop through to put the headers in
			echo "<thead><tr>";
			$header = $this->TableHeaders->fetch_assoc();
			foreach ($header as $Key => $Record)
			{
				//check to see if this col needs to be invisible
				if ($this->isColHidden($Key) == false){
					echo "<th>";
					echo $Key;
					echo "</th>";
				}
			}
			echo "</tr></thead>";

			//loop through to put the data body in
			//every loop makes a row 
			while ($row=$this->TableData->fetch_assoc())
			{
				echo "<tr ID='";
				
					foreach($this->ArrRowID as $RowID){
						echo $row[$RowID];
					}
					echo "' >";
					//every  loop through this adds a column to the row
					foreach ($row as $key => $Record){
						//check to see if this col needs to be invisible
						if ($this->isColHidden($key) == false)
						{
							echo "<td class='".$key."' ";
							//check if this col has an ID
							$ColCellIDIndx = $this->IsColID($key);
							if (!$ColCellIDIndx == null){
								$IDCol =  $this->ArrColCellID[$ColCellIDIndx]['IDCol'];
								echo " ID='".$row[$IDCol]."' ";
							}
							echo ">";
							
							//check if this Col is a link
							$ColLinkIndx = $this->IsColLink($key);
							if (!$ColLinkIndx == null){
								echo "<a ".str_replace('###',$row[$this->ArrLinkCol[$ColLinkIndx]['LinkRowVar']],$this->ArrLinkCol[$ColLinkIndx]['LinkUrl']).">";
								echo $Record;
								echo "</a>";
							}else{
								echo $Record;
							}
							echo "</td>";
						}
					}
				echo"</tr>";
			}
			echo "</table>";
		} else {
			echo "<h3>No Records available</h3>";
		}
		echo "</div>";
	}
}
