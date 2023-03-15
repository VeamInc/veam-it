<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<form action="/admin.php/app/registeradmob" target="_blank">
		<input type="hidden" name="a" value="<?php echo $app->getId() ?>">
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="https://apps.admob.com/" target="_blank">AdMob</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+Monetize new app] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Add your app manually]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $app->getName() ?></strong>" for [App Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong>iOS</strong>" for [Platform]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Add app]</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Native]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "Big" for size</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>forum_native</strong>" for [Ad unit name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter ad unit ID : <input type="text" name="ios_forum_native" style="background-color:#EEF"></td></tr>

				<tr><td>-</td><td>The same process above applies when generating the android app</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Home] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+Monetize new app] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Add your app manually]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $app->getName() ?></strong>" for [App Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong>Android</strong>" for [Platform]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Add app]</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Native]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "Big" for size</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>forum_native</strong>" for [Ad unit name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter ad unit ID : <input type="text" name="android_forum_native" style="background-color:#EEF"></td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Click on this button <input type="submit" value="submit"></td></tr>

				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?></td></tr>
			</tbody>
		</table>
		</form>
	</div>
</div>
<!-- end: Right Content -->
