<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="https://itunesconnect.apple.com/" target="_blank">iTunes Connect</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [My Apps]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [<?php echo $app->getName() ?>]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [In-App Purchases]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Premium Content]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Edit] of [In-App Purchase Details]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Choose File] of [Screenshot for Review]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select the Comfirm Subscription Message Screenshot File that you have saved earlier and click on the [Choose] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Done] button</td></tr>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?> and mark as done.</td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
