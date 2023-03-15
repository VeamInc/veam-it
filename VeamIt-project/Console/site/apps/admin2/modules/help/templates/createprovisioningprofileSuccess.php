<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="http://developer.apple.com/devcenter/ios/index.action" target="_blank">iOS Dev Center</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Certificates, Identifires & Profiles] on the right of the page</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Provisioning Profiles]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [iOS App Development] and click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong><?php echo sprintf("co.veam.veam%s",$app->getId()) ?></strong>" for the [App ID]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [___(iOS App Development)] and click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select the devices you wish to include in this provisioning profile and click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $app->getId() ?> Dev Profile</strong>" for [Profile Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Generate] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Download] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Double-click on the file "<strong><?php echo $app->getId() ?>_Dev_Profile.mobileprovision</strong>" to install it in the XCode application</td></tr>

				<tr><td>-</td><td>The same process above applies when generating the distribution profile</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="http://developer.apple.com/devcenter/ios/index.action" target="_blank">iOS Dev Center</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Certificates, Identifires & Profiles] on the right of the page</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Provisioning Profiles]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [App Store] and click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong><?php echo sprintf("co.veam.veam%s",$app->getId()) ?></strong>" for the [App ID]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [___(iOS Distribution)] and click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $app->getId() ?> Distribution Profile</strong>" for [Profile Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Generate] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Download] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Double-click on the file "<strong><?php echo $app->getId() ?>_Distribution_Profile.mobileprovision</strong>" to install it in the XCode application</td></tr>

				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?> and mark as done.</td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
