<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="http://www.kiip.me/" target="_blank">Kiip</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong>iOS</strong>" for [Your App Platform]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $app->getName() ?></strong>" for [Your App Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Create Application]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong><?php echo $app->getCategory() ?></strong>" for [App Genre]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Upload the screenshot image file downloaded from <?php echo AdminTools::link_to("here", $app->getScreenShot1(), array("target"=>"_blank")) ; ?></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Upload the icon image file downloaded from <?php echo AdminTools::link_to("here", $smallIconUrl, array("target"=>"_blank")) ; ?></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Integrate the SDK]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Add Moments]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Add New Moment]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>3 Pictures</strong>" for [Here's a reward for...]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $app->getId() ?></strong>" for [Moment Identifier]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Change [Do you have any virtual currency?] to "<strong>NOPE</strong>"</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Submit App]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Submit App]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [APP SETTINGS]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Register Kiip App Key/Secret to the <?php echo AdminTools::link_to("register page", "app/enterkiipapp", array("target"=>"_blank","query_string"=>sprintf("a=%d",$app->getId()))) ; ?></td></tr>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?></td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
