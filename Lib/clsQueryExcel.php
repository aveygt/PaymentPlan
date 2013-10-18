<?php

	// this is a class that generates an excel spreadsheet based on a Query

class clsQueryExcel
{
	public	$Link;
	public	$TableData;
	public	$SheetHeaders;
	private $HiddenCols = array();
	private $ExcelTitle;	
	public $BookObj;
	
	
	//on construct connect to the database
	public function __construct()
	{
		$this->BookObj = new PHPExcel();
	}
	
	//on destruct close connection to the database
	public function __destruct()
	{
	}
	
	//set a column to be hidden
	public function HideCol($NewHiddenCol){
		$this->HiddenCols[] = $NewHiddenCol;
		return $this;
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
	
	public function SetTitle($NewTitle)
	{
		$this->ExcelTitle = $NewTitle;
		return $this;
	}
	
	//like SetTable but  using mysqli
	//it just takes a query  input
	public function SetQuery($Query)	
	{
		$this->TableData = GetQuery($Query);
		//print_r($this->TableData);
		$this->SheetHeaders = GetQuery($Query);
		return $this;
	}
	
	public function CQEActiveSheet($Sheet){
		$this->BookObj->setActiveSheetIndex($Sheet);
		return $this;
	}
	
	public function CreateSheet($SheetName)
	{
		global $BaseDir;
		$QBook =& $this->BookObj;
		
		$Column = "A";
		$RowNum = 1;
		

		
		$QBook->getProperties()->setCreator("PP System")
							 ->setLastModifiedBy("PP System")
							 ->setTitle("PHPExcel Test Document");
		
		$QBook->setActiveSheetIndex(0);
		
		//put the title in the sheet
		if(isset($this->ExcelTitle)){
			$QBook->setActiveSheetIndex(0)
				->setCellValue('A'.$RowNum,$this->ExcelTitle);
			$RowNum++;
			//echo "THE TITLE IS SET";
		}
		
		//put the headers in
		$header = $this->SheetHeaders->fetch_assoc();

		foreach($header as $Key => $Record)
		{
			// check for hidden column
			if(!$this->isColHidden($Key)){
				$QBook->setActiveSheetIndex(0)
					->setCellValue($Column.$RowNum,$Key);
			
			// move to the next column	
			$Column++;
			}
		}
		
		//merge the title cells if there is a title
		if(isset($this->ExcelTitle)){
			$Column = chr(ord($Column) - 1); // rol the column back one
			$QBook->setActiveSheetIndex(0)
				->mergeCells("A1:".$Column."1");
		}
			
	
			
		
		//go through each row
		while ($row=$this->TableData->fetch_assoc())
		{
			$RowNum++;
			$ColNum = 0;
			//go through each column
			foreach($row as $Key => $Record)
			{
				
				//check for hidden column
				if(!$this->isColHidden($Key)){
					$QBook	->getActiveSheet()
							->setCellValueByColumnAndRow($ColNum, $RowNum, $Record);
					$ColNum++;
				}
			}
		}
	}
	
	public function SaveWorkBook($Location)
	{
		$writer = PHPExcel_IOFactory::createWriter($this->BookObj, 'Excel2007');
		$writer->save($Location);
	}
}


?>