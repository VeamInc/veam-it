<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="https://itunesconnect.apple.com/" target="_blank">iTunes Connect</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [My Apps]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [<?php echo $app->getName() ?>]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+] button of [Build]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check uploaded build and click on the [Done] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save] of the page</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Submit for Review]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check [Yes] for [Export Compliance]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check [Yes] for [Does your app qualify for any of the exemptions provided in Category 5, Part 2 of the U.S. Export Administration Regulations?]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check [No] for [Content Rights]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check [Yes] for [Does this app use the Advertising Identifier (IDFA)?]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check [Serve advertisements within the app]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check [I, ___ ___, confirm that this app, and any third party that interfaces with this app...]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Submit]</td></tr>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?> and mark as done.</td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
