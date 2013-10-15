<html>
<head>
	<link rel="stylesheet" type="text/css" href="./CSS/PPNavStyle.css">
	<link rel="stylesheet" type="text/css" href="./CSS/PPQueryTableStyles.css">
	<link rel="stylesheet" type="text/css" href="./CSS/PPStyles.css">
	<link rel="stylesheet" type="text/css" href="./CSS/PPReport.css">
	<link rel="stylesheet" type="text/css" href="./CSS/PPList.css">
	<title>Payment Plans</title>
	

</head>
<body>




<?php 
	$HomeURL = "http://localhost/PaymentPlan/";
	$DBSchema = 'ppdb';
	$DBServer = 'localhost';
	$DBUserName = 'root';
	$DBPassword = 'R3db3@rd';
	$BaseDir = "C:\wamp\www\PaymentPlan";
	

	include '/Lib/BasicFunctions.php';
	include '/Lib/clsQueryTable.php';
	include '/Lib/clsForm.php';
	include '/Lib/clsUL.php';
	include 'HandleInput.php';
	
	include 'menu.php';
	
	
?>


<div class = 'Body'>
<?php 
	



	//check if the page variable is directing us somewhere
	if (isset($_GET['page'])) {
		$page = $_GET['page'];
	} else {
		$page = 'home.php';
	}
	
	include $page;
?> 
</div>

</body>
</html>
