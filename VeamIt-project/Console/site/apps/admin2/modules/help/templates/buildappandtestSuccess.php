<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Connect iOS device to your Mac</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Launch the Finder application in your Mac</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Double-click on the [veam<?php echo $app->getId() ?>/veam<?php echo $app->getId() ?>.xcodeproj] in the Veam install directory</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Product] and select the [Destination] -> [iOS device name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Product] and select the [Clean]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Product] and select the [Run]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Tap on the App Premium Section</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Tap on [Tap to subscribe US$x.99 per/month]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter the test user password and tap on [OK]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Take the screenshot of the [Comfirm Subscription] Message Screen</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Continue to test the sections(Premium,YouTube,Forum,Links,etc.)</td></tr>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?> and mark as done.</td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
