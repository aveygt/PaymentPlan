<?php

	$Import = new clsForm(
	'', // the action can be blank
	'/PaymentPlans/ListNew.php', //the Page
	'ImportQuery', // the query
	'POST', //post or get
	'Import Sub Office Report', //title of form
	'Hide', //whether taged as hiden
	'Payment Plans Imported', //confirmation message
	'enctype="multipart/form-data"'  //other aspects of the form
	);
	$Import->FileUp('importfile','Import Report',$BaseDir.'\\Import\\');
	echo "</br>";
	$Import->SubmitButton('Import Report');
	unset($Import);
?>
