<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="https://itunesconnect.apple.com/" target="_blank">iTunes Connect</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [My Apps]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+] button and select [New iOS App]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $app->getStoreAppName() ?></strong>" for [Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong>English</strong>" for [Primary Language]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong><?php echo $app->getName() ?> - co.veam.veam<?php echo $app->getId() ?></strong>" for [Bundle ID]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>1.0</strong>" for [Version]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $app->getId() ?></strong>" for [SKU]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Create] button</td></tr>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?> and mark as done.</td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
