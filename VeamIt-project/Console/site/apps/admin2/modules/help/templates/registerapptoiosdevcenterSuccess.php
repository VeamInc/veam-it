<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="http://developer.apple.com/devcenter/ios/index.action" target="_blank">iOS Dev Center</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Certificates, Identifires & Profiles] on the right of the page</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Identifiers]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $app->getName() ?></strong>" for the [App ID Description]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [Explicit App ID]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo sprintf("co.veam.veam%s",$app->getId()) ?></strong>" for the [Bundle ID]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [In-App Purchase] and the [Push Notifications] of the [App Services]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Submit] button</td></tr>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?> and mark as done.</td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
