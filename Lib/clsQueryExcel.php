<?php

	// this is a class that generates an excel spreadsheet based on a Query

class clsQueryExcel
{
	public	$Link;
	public	$TableData;
	public	$TableHeaders;
	private $HiddenCols = array();
	private $ExcelTitle;	
	
	//on construct connect to the database
	public function __construct()
	{
	}
	
	//on destruct close connection to the database
	public function __destruct()
	{
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
	
	public function SetTitle($NewTitle)
	{
		$this->ExcelTitle = $NewTitle;
	}
	
	//like SetTable but  using mysqli
	//it just takes a query  input
	public function SetTablei($Query)	
	{
		$this->TableData = GetQuery($Query);
		//print_r($this->TableData);
		$this->TableHeaders = GetQuery($Query);
	}
	
	public function GenBook()
	{
		$QBook = new PHPExcel();
		
		$QBook->getProperties()->setCreator("PP System")
							 ->setLastModifiedBy("PP System")
							 ->setTitle("PHPExcel Test Document");
		
		$QBook->setActiveSheetIndex(0)
			->setCellValue('A1','THIS IS A TEST');
		//when page is loaded it will ask where to download or whatever
		header('Content-Type: application/vnd.ms-excel');
		header('Content-Disposition: attachment;filename="your_name.xls"');
		header('Cache-Control: max-age=0');
		
		$writer = PHPExcel_IOFactory::createWriter($QBook, 'Excel2007');
		$writer->save('php://output');
	}
}


?>