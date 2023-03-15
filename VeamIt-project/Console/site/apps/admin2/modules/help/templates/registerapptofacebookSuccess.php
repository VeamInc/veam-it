<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="https://developers.facebook.com/" target="_blank">Facebook Developers</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [My Apps]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Add a New App]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [iOS]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $app->getName() ?></strong>" for [Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Create New Facebook App ID] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong><?php echo $app->getCategory() ?></strong>" for [Category]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Create App ID] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [My Apps]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [<?php echo $app->getName() ?>]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Settings]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter your email address for [Contact Email]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+Add Platform]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [iOS]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>co.veam.veam<?php echo $app->getId() ?></strong>" for [Bundle ID]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Change [Single Sign On] to "<strong>YES</strong>"</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Change [Automatically Log App Events for In-App Purchases on iOS] to "<strong>NO</strong>"</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save Changes]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [App Details]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>http://veam.co/top/guideline</strong>" for [Privacy Policy URL]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>http://veam.co/top/termsofservice31000000</strong>" for [Terms of Service URL]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>support@veam.co</strong>" for [User Support Email]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>http://veam.co/</strong>" for [User Support URL]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save Changes]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Status & Review]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Change [Do you want to make this app and all its live features available to the general public?] to "<strong>YES</strong>"</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Confirm]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Dashboard]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Remenber App ID</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Register the App ID to the <?php echo AdminTools::link_to("register page", "app/enterfacebookappid", array("target"=>"_blank","query_string"=>sprintf("a=%d",$app->getId()))) ; ?></td></tr>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?></td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
