<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="https://apps.twitter.com/" target="_blank">Twitter Apps</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Create New App]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $app->getName() ?></strong>" for [Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $app->getStoreAppName() ?></strong>" for [Description]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>http://veam.co/</strong>" for [Website]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [Yes, I agree] of [Developer Agreement]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Create your Twitter application]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Keys and Access Tokens]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Register Consumer Key/Secret to the <?php echo AdminTools::link_to("register page", "app/entertwitterapp", array("target"=>"_blank","query_string"=>sprintf("a=%d",$app->getId()))) ; ?></td></tr>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?></td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
