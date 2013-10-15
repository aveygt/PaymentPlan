<?php

//this is a class to make forms
//the first parameter is always the name of the element
//the second is always the title
class clsForm
{
	public $Action = 'noaction';
	public $Method ='post';
	
	
	/*
		$Action = the begining part of the URL
		$page = the page to be sent to
		$Query = the query to be executed with ##inputname## where the respective input needs to go. 
		$Method = post or get (currently only get works)
		$Title = the title of the Form.
		$Visible = Decides whether the form is a click to unhide form(the actual animation is done in css)
			if 'Show' then It defaults visible and click title to close
			if 'Hide' then It defaults Hidden and click title to open
			anything else is visible and can't be hidden
		$Confirmation = the confirmation message once data sent
		$OtherAtt = any other attributes needed in the form
	*/
	public function __construct($Action,$page,$Query,$Method,$Title = '',$Visible = '',$Confirmation = null ,$OtherAtt = ''){
		$Action = $Action.'?page='.$page.'&Submit=post&Query='.$Query;
		
		if (isset($Confirmation)){
			$Action=$Action."&Confirm=".$Confirmation;
		}
		
		IF ($Visible != 'Show' && $Visible != 'Hide'){
			$Visible = '';
			echo 'bad clsform visible input';
		}
		
		$Title = $Title;
		echo "<div Class='InputForm Object' id='".$Visible."'>";
		echo "<div class = 'Header id='FormTitle'>".$Title."</div>";
		echo "<div Class = 'Body'>";
		echo "<Form action='".$Action."' method='".$Method."'   ".$OtherAtt.">";
	}
	
	public function __destruct()
	{		
		echo "</form>";
		echo "</div>";
		echo "</div>";
	}
	
	//date input
	public function DateIn($Name, $Label, $Default = null){
	
		if (!isset($Default)){
			$Default = date('Y-m-d');
		}
		echo "<span class='Date InputField' id='".$Name."'>";
		echo "<label for='".$Name."'>".$Label." </label>"; 
		echo "<input type='date' name ='".$Name."' value='".$Default."' />";
		echo "</span>";
	}
	
	
	
	//this creates a drop down menu based off a 2 column query
	public function QueryDropDown($Name,$label,$Query,$Hover= null, $Default = null){
		//run the query and get the results
		$TableData = GetQuery($Query);
		
		echo "<span class='DropMenu InputField' id='".$Name."'>";
		echo"<label for='".$Name."'>".$label." </label>";
		
		echo '<select text="'.$Hover.'" name="'.$Name.'">';
		//go through the data and write to the drop menu
		//while ($row=mysql_fetch_array($TableData)){
		while ($row = $TableData->fetch_array()){
			if ($row[0] === $Default){
				echo '<option selected ="selected" value="'.$row[0].'">'.$row[1].'</option>';
			} else {
				echo '<option value="'.$row[0].'">'.$row[1].'</option>';
			}
		}
		echo '</select>';
		echo "</span>";
	}
	
	public function TextArea($Name,$label = '', $col ='40', $rows = '5',$default = ''){
		echo "<span class='TextAreaIn InputField' id='".$Name."'>";
		echo "<label for='".$Name."'>".$label."</label></br>";		
		echo '<textarea cols="'.$col.'" rows="'.$rows.'" name="'.$Name.'">'.$default.'</textarea>';
		echo "</label>";
		echo "</span>";
	}
	
	public function Currency($Name, $Label, $Hover = null, $Default = null){
		if (!isset($Hover)) {
			$Hover = $Name;
		}
		echo "<span class='Currency InputField' id='".$Name."' title='".$Hover."'>";
		echo "<label for='".$Name."' title='".$Hover."'>".$Label." </label>"; 
		echo "<input type='number' title='".$Hover."' name='".$Name."' value='".$Default."'>";
		echo "</span>";
	}
	
	//pass array with the key as value and record as label
	//$Pos is either side or over and states wether the radios are on top of each other or side by side
	//checked is the value that is default checked
	public function Radio($Name, $Label, $ArrButtons, $Default=null, $Pos = 'Over', $Hover = null){
		if (!isset($Hover)) {
			$Hover = $Name;
		}
		echo "<span class='Radio InputField' id='".$Name."' title='".$Hover."'>";
		echo "<label for='".$Name."' title='".$Hover."'>".$Label." </label>"; 
		foreach ($ArrButtons as $Value => $Text) {
			$Checked = ' ';
			if ($Default === $Value) {
				$Checked = "Checked";
			}
		
			echo " <input type='radio' name='".$Name."'  title='".$Hover."' value='".$Value."' ".$Checked."> ".$Text;
			switch ($Pos) {
				case "Over":
					echo "<br />";
				case "Side":
			}
		}
		echo "</span>";
	}
	
	//adds a file download button
	//
	public function FileUp($Name, $Label,$Location){
		//adds to  an array that is sent when submitted so the catcher knows what the names of the FILES are
		echo "<input type='hidden' name='File[".$Name."]' Value=".$Location.">";
		
		//the actual input
		echo '<label for="'.$Name.'">'.$Label.'</label>';
		echo '<input type="file" name="'.$Name.'" id="'.$Name.'">';
	}
	
	//text field
	public function TextField($Name, $Label,$Default=null){
		echo "<span class='TextFieldIn InputField' id='".$Name."'>";
		echo "<label for='".$Name."'>".$Label.": </label>";		
		echo '<input type = "text" name = "'.$Name.'" value = "'.$Default.'">';
		echo "</label>";
		echo "</span>";
	}
	
	//the submit button
	public function SubmitButton($value = 'submit'){
		echo "<span class='SubmitButton'>";
		echo "<input type='submit' value='".$value."'>";
		echo "</span>";
	}
	
	
	/*
		$Name is the name of the checkbox
		$Value is the Value passed if checked
		$Label is the label
	*/
	public function CheckBox($Name, $Value, $Label,$Default=null){
			
		switch ($Default) {
			case 0:
			case null:
			case 'unchecked':
			case '':
				$Default = null;
				break;
			case 1:
			case 'checked':
			case 'X':
			case 'x':
				$Default = 'checked';
		}
		
		echo "<span class='CheckBox'>";
		echo "<Input type='checkbox' name='".$Name."' value='".$Value."' ".$Default." >".$Label;
		echo "</span>";
	}
	
}
?>
