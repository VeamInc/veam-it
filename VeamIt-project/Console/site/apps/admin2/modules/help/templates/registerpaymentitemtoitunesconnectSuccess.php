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
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Create New]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Select] of [Auto-Renewable Subscription]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>Premium Content</strong>" for [Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Add Duration] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong>1 Month</strong>" for [Duration]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>co.veam.veam<?php echo $app->getId() ?>.subscription0.1m</strong>" for [Product ID]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong><?php echo $priceTier ?></strong>" for [Price Tier] to set <?php echo $priceString ?></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Add Language] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong>English</strong>" for [Language]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>Premium Content</strong>" for [Display Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $app->getName() ?> - Premium Content</strong>" for [Description]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>Premium Content</strong>" for [Publication Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>http://veam.co/top/guideline</strong>" for [English] and click on the [Save] button</td></tr>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?> and mark as done.</td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
