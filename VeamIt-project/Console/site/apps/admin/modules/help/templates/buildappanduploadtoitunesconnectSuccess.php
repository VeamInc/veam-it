<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Change screen to the XCode project</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Confirm iOS device has been connected to the Mac</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Product] and select the [Archive]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Submit to App Store...]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select the appropriate team and click [Chose]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Remove check mark for [Include app symbols...] and click on the [Submit]</td></tr>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?> and mark as done.</td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
