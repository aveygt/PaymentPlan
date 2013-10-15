<nav>
	<ul>
		<li><a href="#">Payment Plans</a>
			<ul>
				<li><a href='#'>All Plans</a>
					<?php
						$AllPlans = new clsUL();
							echo "<li><a  href='".$HomeURL."?page=/PaymentPlans/List.php'>All Plans</a></li>";
							$APQuery = 'SELECT * FROM ppdb.vwagentlist;';
							$APURL = "<a href='".$HomeURL."?page=/PaymentPlans/List.php&agent=**Agent ID**'>**Agent Name**</a>";
							$AllPlans->CreateListFromQuery($APQuery, $APURL);
						unset($AllPlans);
					?>
				</li>
				<li><a href='#'>90 Day</a>
					<?php
						$AllPlans = new clsUL();
							echo "<li><a href='".$HomeURL."?page=/PaymentPlans/List90.php'>All 90 Day</a></li>";
							$APQuery = 'SELECT * FROM ppdb.vwagentlist;';
							$APURL = "<a href='".$HomeURL."?page=/PaymentPlans/List90.php&agent=**Agent ID**'>**Agent Name**</a>";
							$AllPlans->CreateListFromQuery($APQuery, $APURL);
						unset($AllPlans);
					?>
				</li>
				<li><a href='#'>90 Day Delinquent</a>
					<?php
						$AllPlans = new clsUL();
							echo "<li><a  href='".$HomeURL."?page=/PaymentPlans/List90Del.php'>All Delinquent</a></li>";
							$APQuery = 'SELECT * FROM ppdb.vwagentlist;';
							$APURL = "<a href='".$HomeURL."?page=/PaymentPlans/List90Del.php&agent=**Agent ID**'>**Agent Name**</a>";
							$AllPlans->CreateListFromQuery($APQuery, $APURL);
						unset($AllPlans);
					?>
				</li>
				<li><a href='#'>Collections</a>
					<?php
						$AllPlans = new clsUL();
							echo "<li><a  href='".$HomeURL."?page=/PaymentPlans/ListColl.php'>All Collections</a></li>";
							$APQuery = 'SELECT * FROM ppdb.vwagentlist;';
							$APURL = "<a href='".$HomeURL."?page=/PaymentPlans/ListColl.php&agent=**Agent ID**'>**Agent Name**</a>";
							$AllPlans->CreateListFromQuery($APQuery, $APURL);
						unset($AllPlans);
					?>
				</li>
				<li><a href='<?php echo $HomeURL."?page=/PaymentPlans/DailyCCList.php"; ?>'>Daily CC Charge List</a></li>
			</ul>
		</li>
		<li><a href="#">New Plans</a>
			<ul>
				<li><a href='<?php echo $HomeURL."?page=/PaymentPlans/CreateNewPlan.php"; ?>'>New Plan</a></li>
				<li><a href='<?php echo $HomeURL."?page=/PaymentPlans/ImportPlansFromSubOff.php"; ?>'>Import Plans From File</a></li>
				<?php
					echo "<li><a href='".$HomeURL."?page=/PaymentPlans/ListNew.php'>Edit New Plans</a></li>";
				?>
			</ul>
		</li>
		<li><a href='#'>Lists</a>
			<ul>
				<li><a href='<?php echo $HomeURL.'?page=/Bonds/BondList.php'; ?>' >Bond List</a></li>
				<li><a href='<?php echo $HomeURL.'?page=/Customers/List.php'; ?>' >Customer List</a></li>
			</ul>
		</li>
	</ul>
</nav>